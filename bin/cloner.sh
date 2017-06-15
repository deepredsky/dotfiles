#!/bin/sh

set -e

echo $1

curl -u deepredsky:$GITHUB_PR_TOKEN -s https://api.github.com/orgs/$1/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'
