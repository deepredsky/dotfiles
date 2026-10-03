function fish_user_key_bindings
  if functions -q fzf_configure_bindings
    fzf_configure_bindings --history=  # leave ctrl-r to atuin
  else if functions -q fzf_key_bindings
    fzf_key_bindings
  end
  # here, not config.fish: setting fish_key_bindings erases binds made there
  bind ctrl-r _atuin_search
  bind -M insert ctrl-r _atuin_search
end
