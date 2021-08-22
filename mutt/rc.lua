function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end

if file_exists('/tmp/light-theme') then
  mutt.call('source', '~/.mutt/mutt-colors-solarized/mutt-colors-solarized-light-16.muttrc')
else
  mutt.call('source', '~/.mutt/mutt-colors-solarized/mutt-colors-solarized-dark-16.muttrc')
end
