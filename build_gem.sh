#!/bin/bash

GEM_VERSION=$(<master_api_key.gemversion)

echo "Updating gem and running unit tests"
bundle update
rake spec

echo "Building and Installing gem"
gem build master_api_key.gemspec
gem install ./master_api_key-$GEM_VERSION.gem

cd examples/rails-api-authenticator

echo "Updating dependent gems for example app"

bundle update

echo "Generating api key scaffolding and running migrations"

rails generate master_api_key:active_record
rake db:migrate

echo "Running integration tests"

rake spec
