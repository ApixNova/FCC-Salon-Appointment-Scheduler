#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\nWelcome to my Salon!\nHow can I help you with?\n"

MAIN_MENU() {
  echo "$($PSQL "SELECT * FROM services")" | sed 's/|/) /'
  read SERVICE_ID_SELECTED
  #if not found
  
  if [[ -z $($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED") ]]
  then
    echo "Please select a valid option"
    MAIN_MENU
  else
    echo "What is your phone number?"
    read CUSTOMER_PHONE
    #if not found

    if [[ -z $($PSQL "SELECT phone from customers WHERE phone='$CUSTOMER_PHONE'") ]]
    then
      #create new customer

      echo "What is your name?"
      read CUSTOMER_NAME
      $($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    # create appointment:

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    $($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
