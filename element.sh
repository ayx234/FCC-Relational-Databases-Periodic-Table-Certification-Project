#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

ELEMENT() {
  if [[ -z "$1" ]]
  then
    echo Please provide an element as an argument.
  fi
}

ELEMENT "$1"