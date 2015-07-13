#!/usr/bin/env bash
service postgresql start
rake db:migrate
rake rake init:configure