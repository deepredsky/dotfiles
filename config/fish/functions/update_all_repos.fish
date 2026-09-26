function update_all_repos -d "Pull the default branch in every immediate subdirectory"
  for d in */
    set -l repo (string trim -r -c / -- $d)
    echo "Updating $repo"

    pushd $repo
    set -l branch (git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace 'origin/' '')
    if test -z "$branch"
      echo "Could not determine default branch for $repo"
    else if git pull origin $branch --ff
      echo done
    else
      echo "Failed to update repo in $repo"
    end
    popd
  end
end
