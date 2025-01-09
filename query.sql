
--FINAL
-- Create the Database
CREATE DATABASE travel_manager;
USE travel_manager;

-- Create the Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL
);

-- Create the Destinations Table
CREATE TABLE Destinations (
    DestinationID INT AUTO_INCREMENT PRIMARY KEY,
    LocationName VARCHAR(100) NOT NULL,
    PricePerPersonPerDay DECIMAL(10, 2) NOT NULL, -- Price per day per person
    Description TEXT,
    Transportation VARCHAR(50)
);

-- Create the Transportation Table
CREATE TABLE Transportation (
    TransportID INT AUTO_INCREMENT PRIMARY KEY,
    DestinationID INT NOT NULL,
    TransportMode VARCHAR(50) NOT NULL, -- Example: "Flight", "Bus", "Train"
    Cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- Create the Bookings Table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    DestinationID INT NOT NULL,
    NumberOfPeople INT NOT NULL CHECK (NumberOfPeople > 0),
    TripStartDate DATE NOT NULL,
    TripEndDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TransportID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE, 
    FOREIGN KEY (TransportID) REFERENCES Transportation(TransportID) ON DELETE CASCADE
);

-- Create the Payments Table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentAmount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

-- Create the Trigger for Calculating TotalCost
DELIMITER $$

CREATE TRIGGER CalculateTotalCost
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE pricePerDay DECIMAL(10, 2);
    DECLARE transportCost DECIMAL(10, 2);
    DECLARE days INT;

    -- Fetch the PricePerPersonPerDay from the Destinations table
    SELECT PricePerPersonPerDay 
    INTO pricePerDay
    FROM Destinations
    WHERE DestinationID = NEW.DestinationID;

    -- Fetch the Transportation Cost from the Transportation table
    SELECT Cost
    INTO transportCost
    FROM Transportation
    WHERE TransportID = NEW.TransportID;

    -- Calculate the number of days
    SET days = DATEDIFF(NEW.TripEndDate, NEW.TripStartDate) + 1;

    -- Calculate the TotalCost (PricePerPersonPerDay * NumberOfPeople * days + Transportation Cost)
    SET NEW.TotalCost = (pricePerDay * NEW.NumberOfPeople * days) + transportCost;
END $$

DELIMITER ;

-- Insert Data into Users Table
INSERT INTO Users (UserName, Email, PhoneNumber, PasswordHash)
VALUES 
('Rohit Sharma', 'rohit.sharma@example.com', '9876543210', 'hash12345'),
('Ananya Gupta', 'ananya.gupta@example.com', '9123456780', 'hash54321'),
('Aman Verma', 'aman.verma@example.com', '9988776655', 'hash56789');

-- Insert Data into Destinations Table
INSERT INTO Destinations (LocationName, PricePerPersonPerDay, Description, Transportation)
VALUES 
('Goa', 5000.00, 'A vibrant beach destination with nightlife and water sports.', 'Flight'),
('Manali', 4000.00, 'A serene hill station with stunning snow-capped mountains.', 'Bus'),
('Kerala', 6000.00, 'Known as Gods own country, famous for backwaters and lush greenery.', 'Train'),
('Jaipur', 3000.00, 'The Pink City, famous for palaces and historical monuments.', 'Bus'),
('Kashmir', 8000.00, 'Paradise on Earth, known for its breathtaking valleys.', 'Flight'),
('Ladakh', 7000.00, 'Adventure destination with high-altitude deserts and monasteries.', 'Flight'),
('Rishikesh', 2000.00, 'Known for spiritual retreats and river rafting.', 'Bus'),
('Andaman', 10000.00, 'Exotic islands with crystal-clear beaches and scuba diving.', 'Flight'),
('Mumbai', 4000.00, 'The financial capital of India with vibrant urban life.', 'Train'),
('Ooty', 5000.00, 'A peaceful hill station with tea plantations and cool weather.', 'Bus');

-- Insert Data into Transportation Table
INSERT INTO Transportation (DestinationID, TransportMode, Cost)
VALUES 
(1, 'Flight', 5000.00),
(1, 'Train', 2000.00),
(1, 'Bus', 1500.00),
(2, 'Bus', 2000.00),
(2, 'Cab', 5000.00),
(2, 'Train', 1800.00),
(3, 'Train', 2500.00),
(3, 'Flight', 6000.00),
(3, 'Bus', 2000.00),
(4, 'Bus', 1500.00),
(4, 'Train', 1200.00),
(4, 'Cab', 3000.00),
(5, 'Flight', 8000.00),
(5, 'Train', 5000.00),
(5, 'Bus', 4500.00),
(6, 'Flight', 7000.00),
(6, 'Bike', 5000.00),
(6, 'Bus', 3000.00),
(7, 'Bus', 1200.00),
(7, 'Cab', 3500.00),
(7, 'Train', 1000.00),
(8, 'Flight', 12000.00),
(8, 'Ship', 8000.00),
(8, 'Helicopter', 20000.00),
(9, 'Train', 1500.00),
(9, 'Bus', 1200.00),
(9, 'Flight', 4000.00),
(10, 'Bus', 1800.00),
(10, 'Train', 2500.00),
(10, 'Cab', 3500.00);

-- Insert Data into Bookings Table
INSERT INTO Bookings (UserID, DestinationID, NumberOfPeople, TripStartDate, TripEndDate, TotalCost, TransportID)
VALUES 
(1, 1, 2, '2024-01-01', '2024-01-05', 0.00, 1),  -- Rohit to Goa for 5 days
(2, 5, 1, '2024-02-10', '2024-02-15', 0.00, 13), -- Ananya to Kashmir for 6 days
(3, 8, 3, '2024-03-01', '2024-03-07', 0.00, 23); -- Aman to Andaman for 7 days

-- Insert Data into Payments Table
INSERT INTO Payments (BookingID, PaymentAmount, PaymentMethod)
VALUES 
(1, 40000.00, 'Credit Card'),
(2, 48000.00, 'UPI'),
(3, 240000.00, 'Net Banking');

