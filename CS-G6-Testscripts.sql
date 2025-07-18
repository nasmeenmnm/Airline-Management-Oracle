----------------------------------
--Testing proc_register_flight
DECLARE
       v_flight_id  Flights.Flight_id%TYPE:=&flight_id;
               v_origin  Flights.origin%TYPE:=&origin;
               v_destination  Flights.destination%TYPE:=&destination;
               v_available_seats  Flights.available_seats%TYPE:=&available_seats;
    BEGIN
       pkg_airline.proc_register_flight(v_flight_id,v_origin,v_destination,v_available_seats);
   END;
----------------------------------
--Testing proc_register_passenger

DECLARE
                       v_passenger_id Passengers.Passenger_id%TYPE:=&passenger_id;
                       v_name Passengers.name%TYPE:=&name;
                       v_email Passengers.email%TYPE:=&email;
                       v_phone Passengers.phone%TYPE:=&phone;
        BEGIN
           pkg_airline.proc_register_passenger(v_passenger_id,v_name,v_email,v_phone);
      END;
----------------------------------
--Testing proc_book_seat

DECLARE
		v_booking_id Bookings.booking_id%TYPE:=&booking_id;
    		v_passenger_id Passengers.Passenger_id%TYPE:=&passenger_id;
    		v_flight_id Flights.Flight_id%TYPE:=&flight_id;
    		v_seat_number Bookings.seat_number%TYPE:=&seat_number;
BEGIN
		pkg_airline.proc_book_seat(v_booking_id,v_passenger_id,v_flight_id,v_seat_number);
END;
----------------------------------
--Testing cancel_booking
DECLARE
		v_booking_id Bookings.booking_id%TYPE:=&booking_id;
BEGIN
		pkg_airline.proc_cancel_booking(v_booking_id);
END;

----------------------------------
--Testing fung_show_available_flights

DECLARE
		v_origin Flights.origin%TYPE:=&origin;
		v_destination Flights.destination%TYPE:=&destination;
		v_output VARCHAR2(32767);
BEGIN
		v_output:=pkg_airline.func_show_available_flights(v_origin,v_destination);
		DBMS_OUTPUT.PUT_LINE(v_output);
END;
----------------------------------
--Testing fung_get_available_seats
DECLARE
		v_flight_id Flights.Flight_id%TYPE:=&flight_id;
		v_available_seats VARCHAR2(32767);
BEGIN
		v_available_seats:=pkg_airline.func_get_available_seat_numbers(v_flight_id);
		DBMS_OUTPUT.PUT_LINE(v_available_seats);
END;

----------------------------------------
--Testing Triggers
-- This should work if seat 88 on flight F101 is not booked
INSERT INTO Bookings (Booking_ID, Passenger_ID, Flight_ID, Booking_Date, Seat_Number)
VALUES ('B9998', 'P02', 'F101', SYSDATE, 88);
-- This should fail if seat 12 on flight F101 is already booked
INSERT INTO Bookings (Booking_ID, Passenger_ID, Flight_ID, Booking_Date, Seat_Number)
VALUES ('B9999', 'P02', 'F101', SYSDATE, 12);

