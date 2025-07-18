CREATE TABLE Passengers (
        Passenger_ID VARCHAR2(5) PRIMARY KEY,
        Name VARCHAR2(100),
        Email VARCHAR2(100),
      Phone NUMBER UNIQUE
   )

CREATE TABLE Flights (
       Flight_ID VARCHAR2(5) PRIMARY KEY,
       Origin VARCHAR2(50),
       Destination VARCHAR2(50),
       Available_Seats NUMBER
   )

CREATE TABLE Bookings (
       Booking_ID VARCHAR2(5) PRIMARY KEY,
       Passenger_ID VARCHAR2(5),
       Flight_ID VARCHAR2(5),
       Booking_Date DATE,
       Seat_Number NUMBER,
       FOREIGN KEY (Passenger_ID) REFERENCES Passengers(Passenger_ID),
       FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID)
   )

 INSERT INTO Passengers VALUES ('P01', 'Ali Khan', 'khanali@hotmail.com', '0711234567');
 INSERT INTO Passengers VALUES ('P02', 'Thisara Perera', 'thisaraperar@yahoo.com', '0721234567');
 INSERT INTO Passengers VALUES ('P03', 'San Jeevan', 'sanjeevan@gmail.com', '0761234567');
 INSERT INTO Passengers VALUES ('P04', 'Faslan Raheem', 'faslanraheem@hotmail.com', '0741234567');
 INSERT INTO Passengers VALUES ('P05', 'kumara Silva', 'kumara123@gmail..com', '0751234567');

 INSERT INTO Flights VALUES ('F101', 'Colombo', 'Dubai', 99);
 INSERT INTO Flights VALUES ('F102', 'Colombo', 'London',  149);
 INSERT INTO Flights VALUES ('F103', 'Colombo', 'Delhi',119);
 INSERT INTO Flights VALUES ('F104', 'Colombo', 'Singapore',  129);
 INSERT INTO Flights VALUES ('F105', 'Colombo', 'Bangkok', 109);

INSERT INTO Bookings VALUES ('B1001', 'P01', 'F101', SYSDATE, 12);
INSERT INTO Bookings VALUES ('B1002', 'P02', 'F102', SYSDATE, 14);
INSERT INTO Bookings VALUES ('B1003', 'P03', 'F103', SYSDATE, 16);
INSERT INTO Bookings VALUES ('B1004', 'P04', 'F104', SYSDATE, 30);
INSERT INTO Bookings VALUES ('B1005', 'P05', 'F105', SYSDATE, 46);



