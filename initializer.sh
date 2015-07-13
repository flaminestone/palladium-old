#!/usr/bin/env bash
service postgresql start
rake db:migrate
rake init:configure