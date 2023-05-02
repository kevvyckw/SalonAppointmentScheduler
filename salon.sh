#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#Display list of services
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
if [[ $1 ]]
then echo -e "\n$1"
fi
  echo "Welcome to My Salon, how can I help you?"
  SERVICE_ID_1=$($PSQL "SELECT service_id FROM services WHERE name = 'cut'")
  SERVICE_ID_1_FORMATTED=$(echo $SERVICE_ID_1 | sed 's/^ *//')
  SERVICE_ID_2=$($PSQL "SELECT service_id FROM services WHERE name = 'color'")
  SERVICE_ID_2_FORMATTED=$(echo $SERVICE_ID_2 | sed 's/^ *//')
  SERVICE_ID_3=$($PSQL "SELECT service_id FROM services WHERE name = 'perm'")
  SERVICE_ID_3_FORMATTED=$(echo $SERVICE_ID_3 | sed 's/^ *//')
  SERVICE_ID_4=$($PSQL "SELECT service_id FROM services WHERE name = 'style'")
  SERVICE_ID_4_FORMATTED=$(echo $SERVICE_ID_4 | sed 's/^ *//')
  SERVICE_ID_5=$($PSQL "SELECT service_id FROM services WHERE name = 'trim'")
  SERVICE_ID_5_FORMATTED=$(echo $SERVICE_ID_5 | sed 's/^ *//')
  echo -e "\n$SERVICE_ID_1_FORMATTED) cut"
  echo "$SERVICE_ID_2_FORMATTED) color"
  echo "$SERVICE_ID_3_FORMATTED) perm"
  echo "$SERVICE_ID_4_FORMATTED) style"
  echo "$SERVICE_ID_5_FORMATTED) trim"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ *//')
  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU ;;
    2) SERVICE_MENU ;;
    3) SERVICE_MENU ;;
    4) SERVICE_MENU ;;
    5) SERVICE_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE_MENU(){
#get customer's phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

#check if customer exists in customers table
CUSTOMER_EXISTS=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#if customer does not exist, get customer name
if [[ -z $CUSTOMER_EXISTS ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  #insert customer into customers table
  NEW_CUSTOMER_INPUT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
fi

#get customer's preferred time for service
echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME?"
read SERVICE_TIME

#input data into appointments table
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
NEW_APPOINTMENT_INPUT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 

#if succesfully booked a time slot
echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT(){
echo -e "\nThank you for stopping in.\n"

}

MAIN_MENU
