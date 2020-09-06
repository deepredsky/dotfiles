if os.getenv('ITERM_PROFILE') == 'Light' then
  mutt.call('source', '~/.mutt/mutt-colors-solarized/mutt-colors-solarized-light-16.muttrc')
else
  mutt.call('source', '~/.mutt/mutt-colors-solarized/mutt-colors-solarized-dark-256.muttrc')
end
