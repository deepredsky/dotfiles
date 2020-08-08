#!/bin/bash

bin=/usr/local/bin/notmuch

function notmuch {
  echo $1
  while [ 1 -gt 0 ]; do
    # result=`$bin $1 2>&1`
    result=`$bin $1`
    regex="already locked"

    if [[ $result =~ $regex ]]; then
      echo "Xapian DB busy.  Retrying in 2 seconds"
    else
      if [ -n "$result" ]; then
        echo $result
      else
        echo "wtf"
      fi
      return
    fi

    sleep 2
  done
}

function tag_new { notmuch "tag $1 tag:inbox and ($2)"; }
function archive { notmuch "tag -unread -inbox +archive --  date:'1month..today' not tag:starred and $1"; }
function blacklist { tag_new "-inbox -unread +delete" $1; }

notmuch new

# blacklist "from:xxx at example.com or from yyy at example.com"

archive "from:*twitch.tv"
archive "from:*yammer.com"
archive "from:*facebookmail.com"
archive "from:notifications@github.com"
archive "from:notifications@pivotaltracker.com"
archive "from:notifications@harvestapp.com"
archive "from:*@stackshare.io"
archive "from:info@500px.com"
archive "from:info@meetup.com"
archive "from:no-reply@dtdg.co"
archive "from:alert@dtdg.co"
archive "from:notify@twitter.com"
archive "from:no-reply@karnovgroup.com"
archive "from:info@twitter.com"
archive "from:noreply@glassdoor.com"
archive "subject:Zeteo Nyheter*"
archive "subject:Sygic Travel*"
archive "from:*@newrelic.com"

## pro
#tag_new "+friend +mathieu" "mathieu or ejm2106 or emily at example.com"
#tag_new "+friend +balktick" "balktick"

## open community services
#tag_new "+ocs" "open community services or opencommunityservices"

## okos
#tag_new "+okos" "jim and glaser and not LinkedIn"
#tag_new "+okos" "joshlevy.ny at example.com"
#tag_new "+okos" "enright at example.com"

## book liberator
#tag_new "+bklib" "wnf at example.com or bkrpr"

## joomla
#tag_new "+osm" "from:waring or to:waring"
#tag_new "+osm" "from:dave.huelsmann at example.com or to:dave.huelsmann at example.com"
#tag_new "+osm" "james.vasile at example.com"
#tag_new "+osm" "joomla"

##lists
#tag_new "+list +notmuch" "to:notmuchmail.org or notmuch"
#tag_new "+list +stumpwm" "to:stumpwm-devel at nongnu.org or stumpwm"
#tag_new "+list +bklib" "to:bklib at googlegroups.com"

### Catchalls for sflc, hv, etc.
#tag_new "+sflc" "not tag:list and not tag:friend and softwarefreedom.org and not tag:osm"
#tag_new "+sflc" "to:firm at example.com"
#tag_new "+hv" "hackervisions.org and not tag:list and not tag:friend"
#tag_new "+gmail" "(to:jvasile at example.com or from:jvasile at example.com) and not tag:list and not tag:friend"

### Mark mine unread
#tag_new "-unread" "from:james at example.com"
#tag_new "-unread" "from:vasile at example.com"
#tag_new "-unread" "from:james.vasile at example.com"

### Remove inbox tag
#tag_new "-inbox" "tag:sflc or tag:hv or tag:list or tag:osm or tag:okos or tag:friend or tag:bklib"
