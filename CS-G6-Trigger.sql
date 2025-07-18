CREATE OR REPLACE TRIGGER trigg_prevent_manual_duplicate_booking
BEFORE INSERT ON Bookings
FOR EACH ROW
DECLARE
  manual_duplicate_booking EXCEPTION;
  PRAGMA EXCEPTION_INIT(manual_duplicate_booking,-20500); 
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM Bookings
  WHERE Flight_ID = :NEW.Flight_ID
    AND Seat_Number = :NEW.Seat_Number;
  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error: Seat ' || :NEW.Seat_Number || ' is already booked for Flight ' || :NEW.Flight_ID);
  END IF;
EXCEPTION
	WHEN manual_duplicate_booking THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
