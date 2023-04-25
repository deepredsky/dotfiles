#!/bin/bash

bin=/opt/homebrew/bin/notmuch

function notmuch {
  echo $1
  while [ 1 -gt 0 ]; do
    result=`$bin $1`
    regex="already locked"

    if [[ $result =~ $regex ]]; then
      echo "Xapian DB busy.  Retrying in 2 seconds"
    else
      if [ -n "$result" ]; then
        echo $result
      fi
      return
    fi

    sleep 2
  done
}

function tag_new { notmuch "tag $1 tag:inbox and ($2)"; }
function archive { notmuch "tag -unread -inbox +archive --  date:'1month..today' not tag:starred and $1"; }
function delete { tag_new "-inbox -unread +delete" $1; }

notmuch new

archive_list="$HOME/.email-archive.txt"
while IFS= read line
do
  archive "$line"
done <"$archive_list"

delete_list="$HOME/.email-delete.txt"
while IFS= read line
do
  delete "$line"
done <"$delete_list"
