local pattern, pg = matches[2], 1
if matches[3] then
  pg = tonumber(matches[3]:trim())
end
GREP.grep(matches[2], matches[3])