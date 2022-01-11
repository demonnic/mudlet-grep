GREP = GREP or {}

function GREP.getLines(win, pattern)
  if not pattern then
    pattern = win
    win = "main"
  end
  local lines = getLines(win, 0, getLineCount(win))
  local r = rex.new(pattern)
  local hits = {}
  for _, line in ipairs(lines) do
    if r:match(line) then
      hits[#hits+1] = line
    end
  end
  return hits
end

function GREP.grep(pattern, pg)
  pg = tonumber(pg) or 1
  local header = "<ansiCyan><b>(<white>grep<ansiCyan>)<r>:"
  local hits = GREP.getLines("main", pattern)
  local total = #hits
  if total == 0 then
    cecho(f"\n{header} no matches for {pattern} found\n")
    return
  end
  local borderTop = getBorderTop()
  local borderBottom = getBorderBottom()
  local borderMargin = borderTop + borderBottom
  local _, height = getMainWindowSize()
  height = height - borderMargin
  local _, fheight = calcFontSize("main")
  local perPage = math.floor(height / fheight) - 6 -- the 6 is for the header and footer in use by the printout
  local pages = math.ceil(total / perPage)
  if pg < 0 then
    pg = 1 + pages + pg
  end
  if pg < 1 then
    pg = 1
  end
  if pg > pages then
    pg = pages
  end
  cecho(f "\n{header} total hits: {total}   Pg:{pg}/{pages}     {perPage} lines/pg\n")
  local start = 1 + ((pg - 1) * perPage)
  for i = start, start + perPage do
    local txt = hits[i]
    if txt then
      echo(txt .. "\n")
    end
  end
  if pages == 1 then
    cecho(header .. "No more pages\n")
    return
  end
  cecho(header .. "   ")
  if pg > 1 then
    echoLink("<<", function()
      GREP.grep(pattern, 1)
    end, "First page", true)
    echo("|")
    echoLink("<", function()
      GREP.grep(pattern, pg - 1)
    end, "Previous Pg", true)
  else
    echo "    "
  end
  echo(f"{pg}/{pages}")
  if pg < pages then
    echoLink(">", function()
      GREP.grep(pattern, pg + 1)
    end, "Next Page", true)
    echo("|")
    echoLink(">>", function()
      GREP.grep(pattern, -1)
    end, "Last page", true)
  end
  echo("\n")
end