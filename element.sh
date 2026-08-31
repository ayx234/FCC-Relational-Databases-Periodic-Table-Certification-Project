#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT() {
  if [[ -z "$1" ]]
  # if no argument provided
  then
    echo Please provide an element as an argument.
  elif [[ "$1" =~ ^[0-9]+$ ]]
  # if number provided as argument
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    # if atomic_number exists
    if [[ ! -z "$ATOMIC_NUMBER" ]]
    then
      PRINT_ELEMENT_INFO $ATOMIC_NUMBER
    fi
  elif [[ $1 =~ ^[A-Za-z]+$ ]]
  # if text provided as argument
  then
    if [[ ${#1} -le 2 ]]
    # if text <= 2 characters
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
      if [[ ! -z "$ATOMIC_NUMBER" ]]
      # if atomic number exists
      then
        PRINT_ELEMENT_INFO $ATOMIC_NUMBER
      fi
    else
    # if text > 2 chars
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
      if [[ ! -z "$ATOMIC_NUMBER" ]]
      # if atomic number exists
      then
        PRINT_ELEMENT_INFO $ATOMIC_NUMBER
      fi
    fi
  fi
}

PRINT_ELEMENT_INFO(){
  ATOMIC_NUMBER=$1
  NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")"
  SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")"
  TYPE="$($PSQL "SELECT types.type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")"
  MASS=$($PSQL "SELECT atomic_mass from properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

ELEMENT "$1"