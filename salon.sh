#! /bin/bash

service_name1=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM services WHERE service_id = 1")
service_name2=$(psql --username=freecodecamp --dbname=salon -t -A -c  "SELECT name FROM services WHERE service_id = 2")
service_name3=$(psql --username=freecodecamp --dbname=salon -t -A -c  "SELECT name FROM services WHERE service_id = 3")
service_Iden1=$(psql --username=freecodecamp --dbname=salon -t -A -c  "SELECT service_id FROM services WHERE service_id = 1")
service_Iden2=$(psql --username=freecodecamp --dbname=salon -t -A -c  "SELECT service_id FROM services WHERE service_id = 2")
service_Iden3=$(psql --username=freecodecamp --dbname=salon -t -A -c  "SELECT service_id FROM services WHERE service_id = 3")

echo -e "Welcome to My Salon, how can I help you?"
echo -e "$service_Iden1) $service_name1"
echo -e "$service_Iden2) $service_name2"
echo -e "$service_Iden3) $service_name3"


read SERVICE_ID_SELECTED

service_check=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

while [[ -z $service_check ]]
do
  echo "I could not find that service. What would you like today?."
  echo -e "$service_Iden1) $service_name1"
  echo -e "$service_Iden2) $service_name2"
  echo -e "$service_Iden3) $service_name3"
  read SERVICE_ID_SELECTED
  service_check=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done

echo -e "What's your phone number?"
read CUSTOMER_PHONE

customer_check=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $customer_check ]]
then

  service_name=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  echo -e "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  echo "What time would you like your $service_name, $CUSTOMER_NAME?"
  read SERVICE_TIME

  insert_customer=$(psql --username=freecodecamp --dbname=salon -t -A -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  customer_number=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  insert_appointment=$(psql --username=freecodecamp --dbname=salon -t -A -c "INSERT INTO appointments(customer_id, service_id, time) VALUES('$customer_number','$SERVICE_ID_SELECTED','$SERVICE_TIME')")


  echo -e "I have put you down for a $service_name at $SERVICE_TIME, $CUSTOMER_NAME."

else

  service_name=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  customer_namey=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  echo -e "What time would you like your $service_name, $customer_namey?"
  read SERVICE_TIME
  customer_number=$(psql --username=freecodecamp --dbname=salon -t -A -c "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  insert_appointment=$(psql --username=freecodecamp --dbname=salon -t -A -c "INSERT INTO appointments(customer_id, service_id, time) VALUES('$customer_number','$SERVICE_ID_SELECTED','$SERVICE_TIME')")


  echo -e "I have put you down for a $service_name at $SERVICE_TIME, $customer_namey."

fi