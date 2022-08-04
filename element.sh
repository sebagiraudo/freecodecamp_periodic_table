#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check if it's a word:
  if [[ $1 =~ [^a-zA-Z] ]]
  then
    # input es numero atomica
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    TYPE=$($PSQL "SELECT type FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1")
    MASS=$($PSQL "SELECT atomic_mass FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE atomic_number=$1")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    if [[ -z $ATOMIC_NUMBER ]] 
    then
      # $1 es nombre
      NAME=$1
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
      TYPE=$($PSQL "SELECT type FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
      MASS=$($PSQL "SELECT atomic_mass FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE name='$1'")
    else
      # $1 es simbolo
      SYMBOL=$1
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
      TYPE=$($PSQL "SELECT type FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
      MASS=$($PSQL "SELECT atomic_mass FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) WHERE symbol='$1'")
    fi
  fi

  NAME=$(echo $NAME | sed 's/ //g')
  ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/ //g')
  TYPE=$(echo $TYPE | sed 's/ //g')
  SYMBOL=$(echo $SYMBOL | sed 's/ //g')
  MASS=$(echo $MASS | sed 's/ //g')
  MELTING_POINT=$(echo $MELTING_POINT | sed 's/ //g')
  BOILING_POINT=$(echo $BOILING_POINT | sed 's/ //g')


  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. Hydrogen has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi






