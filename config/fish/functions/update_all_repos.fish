function update_all_repos
  for d in (ls)
    echo "Updating $d"

    fish -c "
      cd $d; and git pull origin master --ff;

      if test $status -eq 0
        echo \"done\"
      else
        echo \"Failed to update repo in $d\"
      end
    "
  end
end

