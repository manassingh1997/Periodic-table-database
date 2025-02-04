#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
else
    ELEMENT="$1"

    # Check if the input is a number (atomic number) or not
    if [[ "$ELEMENT" =~ ^[0-9]+$ ]]; then
        # If it's a number, query by atomic number
        ELEMENT_DATA=$($PSQL "SELECT elements.atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = 1;")
        
    else
        # Otherwise, query by symbol or name (assuming case-insensitive search for symbol and name)
        ELEMENT_DATA=$($PSQL "SELECT elements.atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE symbol ILIKE '$ELEMENT' OR name ILIKE '$ELEMENT';")
    fi

    # Output the result
    if [[  -z $ELEMENT_DATA ]]
    then
        echo I could not find that element in the database.
    else
        IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $ELEMENT_DATA
        
        # Format the output
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
fi

# Get the argument passed to the script


