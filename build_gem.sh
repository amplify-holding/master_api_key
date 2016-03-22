#!/bin/bash

GEM_VERSION=$(<master_api_key.gemversion)
FORCE_UPDATE=false

yellow=`tput setaf 3`
reset=`tput sgr0`

usage() {
  if [ -n "${1}" ]; then 
    EXIT_VAL=1
    echo "${yellow}" "Error: ${1} ${reset}"
  else
    EXIT_VAL=0
  fi
  cat <<EOT
  
  Usage build_gem.sh -u -h

  -u Updates all gems including the master_api_key gem
  
  The command will run unit tests against the gem, build and install the gem locally,
  and run the integration tests in the rails-api-authenticator example app. If you
  update this gem's version file, you'll need to run the command with -u
EOT
exit ${EXIT_VAL}
}

while getopts ":hu" OPT
do
  case ${OPT} in
    h) 
      usage 
      ;;
    u) 
      FORCE_UPDATE=true
      ;;
   \?)
      usage "Invalid option -$OPTARG"
      ;;
    :)
      usage "Missing option argument for -$OPTARG" >&2
      ;;
  esac
done

echo "Updating gem and running unit tests"

if [ ${FORCE_UPDATE} == true ]; then
  bundle update
else
  bundle install
fi

rake spec

echo "Building and Installing gem"
gem build master_api_key.gemspec
gem install ./master_api_key-$GEM_VERSION.gem

cd examples/rails-api-authenticator

echo "Updating dependent gems for example app"

if [ ${FORCE_UPDATE} == true ]; then
  bundle update
else
  bundle install
  bundle update master_api_key --local
fi

echo "Generating api key scaffolding and running migrations"

rails generate master_api_key:active_record
rake db:migrate

echo "Running integration tests"

rake spec
