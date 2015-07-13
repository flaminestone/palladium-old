#!/usr/bin/env bash
service postgresql start
rake db:migrate
rake init:configure
bundle exec unicorn -c config/unicorn.rb -D
sudo service nginx restart
