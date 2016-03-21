#!/bin/bash

rake spec

gem build master_api_key.gemspec
gem install ./master_api_key-0.0.0.gem

cd examples/rails-api-authenticator

rails generate master_api_key:active_record
rake db:migrate

rake spec
