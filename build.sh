#!/usr/bin/env bash
# exit on errors
set -o errexit

bundle install

bundle exec rake assets:precompile

bundle exec rake assets:clean

bundle exec rake db:migrate

bundle exec honeybadger deploy --environment=production
