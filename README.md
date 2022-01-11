# GREP

This alias (and the functions which support it) tries to emulate the `grep` command from *NIX systems, in that it will search your buffer for all the lines which match a pattern and display them on the screen for you.

It will autodetect how many lines can fit on your main window and paginate the results for you accordingly. This was created after someone asked me if Mudlet could do something like TinTin++'s [grep](https://tintin.mudhalla.net/manual/grep.php) command in the #help channel on the Mudlet discord. It seemed like a good idea, so I threw something together.

## Things to keep in mind

The output of the `grep` alias adds to the buffer, so future uses of grep (including changing pages) will include the already printed pages at the end. This means for browsing the end of the output you should really use `-1` for the page to print from the get go, IE `grep Bob -1` to show the most recent page of lines with Bob on.

## The future?

I think it might be a slightly cleaner experience to have the alias assemble the output, and then display it in a Miniconsole with the wrapping turned off and the horizontal scroll bar turned on. This way the output you're paging through isn't changing because you're paging through it. But I wanted to go ahead and get this out the door.

## Alias

* `grep <regex pattern to search for> <optional page of the results to display>`
  * This alias will search the main console buffer for all lines which match the pattern provided. It reads the buffer after it has been word wrapped, which means that it evaluates each line as it appears separately, rather than how it came in from the game originally.
  * examples:
    * `grep \d+ gold coins`
      * searches the buffer for any line with a number of gold coins on it and prints the outcome.
    * `grep (?i)goblin 2`
      * searches the buffer for goblin, ignoring case sensitivity (will match goblin or GoBLin), and print page 2 if there's more than 1 page.

## Functions

I use the `[=[things and stuff]=]` alternate method of string delineation for two reasons

* Using `"things and stuff"` means you have to escape every `\` in your regex
* This text is included in the package's config.lua, which uses the form without the `=` sign between the brackets, and if I use that it breaks the package.

### `GREP.getLines([win,]pattern)`

  `pattern` is the regular expression you want to search the main buffer for
  
  returns a table with all of the matching lines in it, one entry per line
  
```lua
  GREP.getLines([=[\d+ gold coins]=])
```

returns

```txt
{
  "There are 32 gold coins on the floor here",
  "There are 72 gold coins on the floor here",
  "The table has 1928 gold coins upon it",
}
```

### `GREP.grep(pattern, pg)`

Prints out the lines matching the `pattern` to the main window, starting at `pg`. If `pg` is left off, then it defaults to 1. see getPage above for more on the page numbering.

```lua
GREP.grep([=[\d+ gold coins]=])
```

```txt
(grep): total hits: 5   Pg:1/1
`echo There are 32 gold coins on the floor here
There are 32 gold coins on the floor here
`echo There are 72 gold coins on the floor here
There are 72 gold coins on the floor here
`echo The table has 1928 gold coins upon it
(grep):No more pages
```
