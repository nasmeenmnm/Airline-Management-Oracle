# Airline-Management-Oracle

# Airline Management System 
## Business Scenario
An airline Management system is designed handle flight bookings and manage passengers data. Passenger can register, view available flights according to their origin and destination,book seats, cancel booking and see available seats in a flights.
Key stakeholders are passengers (the people who book flights), Flight administration(Who register new flights and passenger to system), System(Enforces validation rules via triggers).
Administrators can register a new flight by providing a unique flight ID, origin, destination, and total available seats. The system prevents inserting duplicate flight IDs using exception handling.New passengers can register by submitting their details (name, email, phone). The system ensures that duplicate IDs are not accepted and basic information is properly recorded.

### Passengers can book a specific seat on a flight. The system:

•	Validates if the passenger exists.

•	Validates if the seat number is within flight capacity.

•	Checks whether the seat is already booked using both procedural logic and a database trigger.

•	Inserts the booking and automatically decreases the available seat count.

•	A passenger is allowed to book multiple seats from a flight or different flight, but each one seat booking will be stored as new booking( Drawback)


Passengers may cancel their bookings. The system removes the booking record and Increases the available seat count in the flight.Passengers can view flights that are available between two cities. Only flights with remaining seats are shown using a cursor-based procedure.For a specific flight, the system returns the list of unbooked seat numbers by comparing the full capacity against the already booked seat numbers.A PL/SQL trigger prevents manual seat overbooking, even if someone tries to insert directly into the Bookings table.

#### Component of Package
The pkg_airline package is designed to manage flight and passenger operations in the Airline Management System. It contains procedures and functions that handle the core tasks such as registering flights and passengers, booking and canceling seats, and retrieving available flights or seats.
Public Procedures

##### proc_register_flight
•	The proc_register_flight procedure allows administrators to register new flights 

•	Parameters: flight_ID, origin, destination, and number of available seats. 

•	It ensures that duplicate flight entries are avoided and commits the changes to the database.



##### proc_register_passenger
•	The proc_register_passenger procedure registers a new passenger 
•	Parameters: Passenger_ID, name, email, and phone number. 
•	It handles duplication errors and stores the data securely in the Passengers table.

##### proc_book_seat
•	The proc_book_seat procedure books a specific seat for a passenger on a given flight.
 
•	Parameters: Booking_Id, Passenger_id, Flight_id, Seat_number

•	Before inserting the booking, it checks whether the passenger exists and whether the requested seat is valid and available. 

•	It uses a private function (func_validate_seat_availability) to ensure the seat number is within the valid range and not already booked.
 
•	If the booking is successful, it updates the Bookings table and decreases the available seat count for the flight in flight table.

##### proc_cancel_booking
•	The proc_cancel_booking procedure allows users to cancel an existing booking
 
•	Parameters: Booking_ID. 

•	It validates whether the booking exists, deletes the record from the Bookings table

•	Updates the Flights table to increase the available seats.


Public Functions
##### func_show_available_flights
•	The function func_show_available_flights returns a list of available flights from a given origin to a destination as a string.

•	Parameters: Origin, Destination

•	It uses a cursor and a record type to loop through the available flights and format the output.

•	If there is a no flights from given origin to destination it will return a message 'No available flights found for the given origin and destination' as a string

##### func_get_available_seat_numbers
•	The function func_get_available_seat_numbers returns a list of unbooked seat numbers for a specific flight as a comma-separated string.

•	Parameters: Flight_id

•	It uses a cursor to fetch all booked seats and compares them against the total capacity to determine which seats are still free.

•	If there is no data found in cursor it will exit.

•	It also use REGEXP to store the available seats in comma separated format.

•	Also It use RTRIM to remove the comma which will be added to last


Private Functions
##### func_get_flight_details
•	This will return the whole flight details.

•	Parameters:Flight_id

•	If Flight is not found,It will return a Exception

##### func_validate_seat_availability
•	It uses to validate a seat number.

•	Parameters:Flight_id, Seat_number

•	This first check if the given seat number is in the range of given flights available seat count.

•	Then it will check that given seat number is already booked using a count variable.

Together, these components provide a complete and modular backend for managing airline bookings, ensuring data accuracy and enforcing business rules through built-in validations and exception handling.

## Trigger
•	The trigger trg_prevent_manual_duplicate_booking is designed to ensure that no two bookings can be made for the same seat on the same flight. 

•	Even though the seat availability is checked inside the PL/SQL package procedures, this trigger adds an extra layer of protection by preventing direct manual inserts into the Bookings table that bypass the package logic. 

•	It fires automatically before a new row is inserted and checks whether the seat number is already booked for that flight. 

•	If the seat is already taken, it raises an error using RAISE_APPLICATION_ERROR, stopping the insert and preserving data integrity.
 
•	This trigger enforces an essential business rule: each seat on a flight must be unique to one passenger, and it ensures consistency and reliability in the airline booking system.

## IMAGES<img width="1023" height="221" alt="available seats" src="https://github.com/user-attachments/assets/6df538c2-d609-4792-b4c4-172decd7f260" />
<img width="1101" height="245" alt="Trigger1" src="https://github.com/user-attachments/assets/0141644f-9139-4d95-b057-7c67e749c42e" />
<img width="1116" height="140" alt="Trigger" src="https://github.com/user-attachments/assets/b3edcdf1-6987-4b6b-a4c3-9d93e44121f0" />
<img width="1046" height="338" alt="Proc_register_passenger" src="https://github.com/user-attachments/assets/3a3edc62-f800-480c-9cc1-77cac344686b" />
<img width="1153" height="321" alt="Proc_register_flights3" src="https://github.com/user-attachments/assets/f0dc8eed-f666-47cd-ad30-79dbb9ca50cd" />
<img width="877" height="730" alt="Proc_register_flights2" src="https://github.com/user-attachments/assets/efc82ccf-ed96-4021-898c-d48bda3af37d" />
<img width="1157" height="557" alt="Proc_register_flights" src="https://github.com/user-attachments/assets/84f9b3b9-d0a4-46e2-b11f-49e734a8f837" />
<img width="940" height="223" alt="fubc_show_flights" src="https://github.com/user-attachments/assets/66d0494b-3d26-4584-8e9e-f3a4bfc0d2a3" />
<img width="921" height="127" alt="cancel_booking1" src="https://github.com/user-attachments/assets/ad29891d-5d91-48f1-9ffa-3db922dc9bcb" />
<img width="942" height="445" alt="cancel_booking" src="https://github.com/user-attachments/assets/5d665b8c-99cb-4ffb-981d-8c327cdf019f" />
<img width="1018" height="340" alt="book_seat3" src="https://github.com/user-attachments/assets/91857474-fe15-4b8b-b2ae-701e36cae284" />
<img width="1016" height="370" alt="book_seat2" src="https://github.com/user-attachments/assets/7e663424-c1dd-4171-ab4a-14073a42e33f" />
<img width="1052" height="885" alt="book_seat1" src="https://github.com/user-attachments/assets/e7bd4020-88b2-448d-95a0-3c146214716e" />
<img width="938" height="191" alt="available seats1" src="https://github.com/user-attachments/assets/b2513c9a-0eed-46d1-8058-8963f595e282" />

