#!/usr/bin/env bash
service postgresql start
rake db:migrate
rake init:configure
bundle exec unicorn -c config/unicorn.rb -D
service nginx restart
