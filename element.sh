#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    FOUND_ELEMENT="$($PSQL "SELECT * FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE elements.atomic_number = $1;")"
  else
    FOUND_ELEMENT="$($PSQL "SELECT * FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE elements.symbol = '$1' or elements.name = '$1';")"
  fi
  if [[ $FOUND_ELEMENT ]]
  then
    echo $FOUND_ELEMENT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi
