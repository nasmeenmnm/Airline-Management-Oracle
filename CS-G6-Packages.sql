CREATE OR REPLACE PACKAGE pkg_airline IS
	PROCEDURE proc_register_flight(
    		p_flight_id IN Flights.Flight_id%TYPE,
    		p_origin IN Flights.origin%TYPE,
    		p_destination IN Flights.destination%TYPE,
    		p_available_seats IN Flights.available_seats%TYPE
  	);
	PROCEDURE proc_register_passenger(
    		p_passenger_id IN Passengers.Passenger_id%TYPE,
    		p_name IN Passengers.name%TYPE,
    		p_email IN Passengers.email%TYPE,
    		p_phone IN Passengers.phone%TYPE
  	);
	PROCEDURE proc_book_seat(
		p_booking_id IN Bookings.booking_id%TYPE,
    		p_passenger_id IN Passengers.Passenger_id%YPE,
    		p_flight_id IN Flights.Flight_id%TYPE,
    		p_seat_number IN Bookings.seat_number%TYPE
  	);
	PROCEDURE proc_cancel_booking(
    		p_booking_id IN Bookings.booking_id%TYPE
  	);
	FUNCTION func_show_available_flights(p_origin IN Flights.origin%TYPE,p_destination IN Flights.destination%TYPE) RETURN VARCHAR2;
	FUNCTION func_get_available_seat_numbers(p_flight_id IN Flights.Flight_id%TYPE) RETURN VARCHAR2;
END pkg_airline;




CREATE OR REPLACE PACKAGE BODY pkg_airline IS
	 -- Private function
	FUNCTION func_get_flight_details(p_flight_id IN Flights.Flight_id%TYPE) RETURN Flights%ROWTYPE IS
		v_flight_id Flights.Flight_id%TYPE:=p_flight_id;
		v_flight_details Flights%ROWTYPE;
	BEGIN
		SELECT *  INTO v_flight_details FROM Flights WHERE flight_id = v_flight_id;
		RETURN v_flight_details;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('Flight ID ' || v_flight_id || ' not found.');
      			RETURN NULL;
	END func_get_flight_details;
	 -- Private function
	FUNCTION func_validate_seat_availability(p_flight_id IN Flights.Flight_id%TYPE,p_seat_number IN Bookings.seat_number%TYPE) RETURN BOOLEAN IS
		v_flight_id Flights.Flight_id%TYPE:=p_flight_id;
		v_seat_number Bookings.seat_number%TYPE:=p_seat_number;
		v_flight_details Flights%ROWTYPE;
		v_booked_count NUMBER;
	BEGIN
		v_flight_details := func_get_flight_details(p_flight_id);
		IF v_seat_number > v_flight_details.available_seats OR v_seat_number<1 THEN
			RETURN FALSE;
		END IF;
		SELECT count(*) INTO v_booked_count FROM Bookings WHERE flight_id=v_flight_id AND seat_number=v_seat_number;
		RETURN v_booked_count=0;
	END func_validate_seat_availability;
	PROCEDURE proc_register_flight(
    		p_flight_id IN Flights.Flight_id%TYPE,
    		p_origin IN Flights.origin%TYPE,
    		p_destination IN Flights.destination%TYPE,
    		p_available_seats IN Flights.available_seats%TYPE
  	) IS
		v_flight_id Flights.Flight_id%TYPE:=p_flight_id;
    		v_origin Flights.origin%TYPE:=p_origin;
    		v_destination Flights.destination%TYPE:=p_destination;
    		v_available_seats Flights.available_seats%TYPE:=p_available_seats;
  	BEGIN
    	INSERT INTO Flights (flight_id, origin, destination, available_seats) VALUES (v_flight_id, v_origin, v_destination, v_available_seats);
    	COMMIT;
  	EXCEPTION
    		WHEN DUP_VAL_ON_INDEX THEN
        		DBMS_OUTPUT.PUT_LINE('Flight ID ' || v_flight_id || ' already exists.');
    		WHEN OTHERS THEN
        		DBMS_OUTPUT.PUT_LINE('Error registering flight: ' || SQLERRM);
  	END proc_register_flight;
	PROCEDURE proc_register_passenger(
    		p_passenger_id IN Passengers.Passenger_id%TYPE,
    		p_name IN Passengers.name%TYPE,
    		p_email IN Passengers.email%TYPE,
    		p_phone IN Passengers.phone%TYPE
  	) IS
		v_passenger_id Passengers.Passenger_id%TYPE:=p_passenger_id;
    		v_name Passengers.name%TYPE:=p_name;
    		v_email Passengers.email%TYPE:=p_email;
    		v_phone Passengers.phone%TYPE:=p_phone;
  	BEGIN
    		INSERT INTO Passengers (passenger_id, name, email, phone) VALUES (v_passenger_id, v_name, v_email, v_phone);
    	COMMIT;
  	EXCEPTION
    	WHEN DUP_VAL_ON_INDEX THEN
      		DBMS_OUTPUT.PUT_LINE('Passenger ID ' || p_passenger_id || ' already exists.');
    	WHEN OTHERS THEN
       		DBMS_OUTPUT.PUT_LINE('Error registering passenger: ' || SQLERRM);
  END proc_register_passenger;
	PROCEDURE proc_book_seat(
    		p_booking_id IN Bookings.booking_id%TYPE,
    		p_passenger_id IN Passengers.Passenger_id%TYPE,
    		p_flight_id IN Flights.Flight_id%TYPE,
    		p_seat_number IN Bookings.seat_number%TYPE
	) IS
		v_booking_id Bookings.booking_id%TYPE:=p_booking_id;
    		v_passenger_id Passengers.Passenger_id%TYPE:=p_passenger_id;
    		v_flight_id Flights.Flight_id%TYPE:=p_flight_id;
    		v_seat_number Bookings.seat_number%TYPE:=p_seat_number;
    		v_passenger_count NUMBER; 
		passenger_doesnot_exist EXCEPTION;
		seat_number_not_available EXCEPTION;
	BEGIN
    		SELECT count(*)
    		INTO   v_passenger_count
    		FROM   Passengers
    		WHERE  passenger_id = v_passenger_id;
    		IF v_passenger_count = 0 THEN
        		RAISE passenger_doesnot_exist;
   		 END IF;
    		IF NOT func_validate_seat_availability(v_flight_id, v_seat_number) THEN
        		RAISE seat_number_not_available;
    		END IF;
    		INSERT INTO Bookings (booking_id, passenger_id, flight_id, booking_date, seat_number) VALUES (v_booking_id, v_passenger_id, v_flight_id, SYSDATE, v_seat_number);
    		UPDATE Flights SET available_seats = available_seats - 1 WHERE flight_id = v_flight_id;
    		COMMIT;
		EXCEPTION
			WHEN seat_number_not_available THEN
				DBMS_OUTPUT.PUT_LINE('Seat ' || v_seat_number || ' is not available on Flight ' || p_flight_id);
			WHEN passenger_doesnot_exist THEN
				DBMS_OUTPUT.PUT_LINE('Passenger ID ' || v_passenger_id || ' does not exist.');
    			WHEN OTHERS THEN
        			DBMS_OUTPUT.PUT_LINE('Error booking seat: ' || SQLERRM);
	END proc_book_seat;
	PROCEDURE proc_cancel_booking(
    		p_booking_id IN Bookings.booking_id%TYPE
  	) IS
		v_booking_id Bookings.booking_id%TYPE:=p_booking_id;
    		v_booking_record Bookings%ROWTYPE;
		v_booking_count NUMBER;
		booking_id_not_exist EXCEPTION;
  	BEGIN
     		SELECT count(*) INTO   v_booking_count FROM   Bookings WHERE  booking_id = v_booking_id;
    		IF v_booking_count = 0 THEN
        		RAISE booking_id_not_exist;
    		END IF;
    	SELECT * INTO v_booking_record FROM Bookings WHERE booking_id = v_booking_id;
    	DELETE FROM Bookings WHERE booking_id = v_booking_id;
    	UPDATE Flights SET available_seats = available_seats + 1 WHERE flight_id = v_booking_record.flight_id;
    	COMMIT;
	EXCEPTION
	WHEN booking_id_not_exist THEN
		DBMS_OUTPUT.PUT_LINE('Booking ID ' || v_booking_id || ' does not exist.');
    	WHEN OTHERS THEN
        	DBMS_OUTPUT.PUT_LINE('Error cancelling booking: ' || SQLERRM);
	END proc_cancel_booking;
	 FUNCTION func_show_available_flights(p_origin IN Flights.origin%TYPE,p_destination IN Flights.destination%TYPE) RETURN VARCHAR2 IS
        	v_result VARCHAR2(32767);
        	CURSOR cur_flights IS
            		SELECT flight_id, origin, destination, available_seats FROM Flights WHERE origin = p_origin AND destination = p_destination AND available_seats > 0;
        	TYPE FlightRecTyp IS RECORD(
            		flight_id VARCHAR2(10),
            		origin VARCHAR2(50),
            		destination VARCHAR2(50),
            		available_seats NUMBER
        	);
        	flight_rec FlightRecTyp;
		v_origin Flights.origin%TYPE:=p_origin;
		v_destination Flights.destination%TYPE:=p_destination;
    	BEGIN
        	v_result := '';
        	OPEN cur_flights;
        	LOOP
            		FETCH cur_flights INTO flight_rec;
            		EXIT WHEN cur_flights%NOTFOUND;
            		v_result := v_result ||
                        	'Flight ID: ' || flight_rec.flight_id ||
                        	', Origin: ' || flight_rec.origin ||
                        	', Destination: ' || flight_rec.destination ||
                        	', Available Seats: ' || flight_rec.available_seats || CHR(10);
        	END LOOP;
        	CLOSE cur_flights;
        	IF v_result = '' THEN
             		v_result := 'No available flights found for the given origin and destination.';
        	END IF;
        	RETURN v_result;
    	EXCEPTION
        	WHEN OTHERS THEN
            		DBMS_OUTPUT.PUT_LINE('Error showing available flights: ' || SQLERRM);
    	END func_show_available_flights;
	FUNCTION func_get_available_seat_numbers(p_flight_id IN Flights.Flight_id%TYPE) RETURN VARCHAR2 IS
        	v_available_seats NUMBER;
        	CURSOR cur_booked_seats(p_flight_id_param VARCHAR2) IS
            		SELECT seat_number FROM Bookings WHERE flight_id = p_flight_id_param ORDER BY seat_number;
        	TYPE n_tab_seat_numbers IS TABLE OF NUMBER;
        	v_seat_number NUMBER;
        	v_available_seats_list VARCHAR2(32767) := '';
        	i NUMBER;
        	v_flight_details Flights%ROWTYPE;
		v_flight_id Flights.Flight_id%TYPE:=p_flight_id;
    	BEGIN
        	v_flight_details := func_get_flight_details(v_flight_id);
        	v_available_seats := v_flight_details.available_seats;
        	OPEN cur_booked_seats(v_flight_id);
        	LOOP
            		FETCH cur_booked_seats INTO v_seat_number;
            		EXIT WHEN cur_booked_seats%NOTFOUND;
            		FOR i IN 1..v_flight_details.available_seats LOOP
                 		IF i = v_seat_number THEN  
                    		CONTINUE;
                 		END IF;
                 	IF NOT REGEXP_LIKE(',' || v_available_seats_list || ',', ',' || i || ',') THEN
                    	v_available_seats_list := v_available_seats_list || i || ',';
                	END IF;
            		END LOOP;
        	END LOOP;
        	CLOSE cur_booked_seats;
        	IF LENGTH(v_available_seats_list) > 0 THEN
            		v_available_seats_list := RTRIM(v_available_seats_list, ',');
        	END IF;
       		RETURN v_available_seats_list;
    	EXCEPTION
        	WHEN OTHERS THEN
            		DBMS_OUTPUT.PUT_LINE('Error getting available seat numbers: ' || SQLERRM);
    	END func_get_available_seat_numbers;
END pkg_airline;
/






	
		



	
		
