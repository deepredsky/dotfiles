function fish_user_key_bindings
  if functions -q fzf_configure_bindings
    fzf_configure_bindings
  else if functions -q fzf_key_bindings
    fzf_key_bindings
  end
end
