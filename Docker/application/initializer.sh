#!/usr/bin/env bash
cd palladium/
rake db:create
rake db:migrate
rake init:configure
bundle exec unicorn -c config/unicorn.rb -D
service nginx restart
