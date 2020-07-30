#!/bin/sh

set -e

echo $1

curl -u deepredsky:$GITHUB_PR_TOKEN -s "https://api.github.com/orgs/$1/repos?page=2&per_page=300" | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'
