-- Create Database
CREATE DATABASE RaceDay;
GO
USE RaceDay;
GO

-- 1. CREATE TABLES WITH CONSTRAINTS
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    UserRole VARCHAR(20) NOT NULL DEFAULT 'Participant' -- Roles: Organiser or Participant
);
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Description VARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(50) NOT NULL, -- e.g., '5km Walk', '42km Marathon'
    DistanceKm DECIMAL(5,2) NOT NULL,
    EntryFee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    UNIQUE (ParticipantID, CategoryID) -- Prevents entering the same category twice
);
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE, -- 1:1 relationship with Enrolment
    FinishTime TIME NOT NULL,
    OverallPosition INT,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID)
);

-- 2. SEED DATA

-- Insert 2 Organisers and 2 Participants
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, UserRole)
VALUES 
('Alice', 'Smith', 'alice.organiser@raceday.co.za', 'hashedpassword123', 'Organiser'),
('Bob', 'Jones', 'bob.organiser@raceday.co.za', 'hashedpassword123', 'Organiser'),
('Charlie', 'Daniels', 'charlie.runner@gmail.com', 'hashedpassword123', 'Participant'),
('Diana', 'Prince', 'diana.cyclist@gmail.com', 'hashedpassword123', 'Participant');
-- Insert 3 Events
INSERT INTO Events (OrganiserID, EventName, EventDate, Location, Description)
VALUES 
(1, 'Soweto Marathon', '2026-11-01 05:30:00', 'Soweto, Johannesburg', 'The Peoples Race.'),
(1, 'Cape Town Cycle Tour', '2027-03-14 06:00:00', 'Cape Town', 'The biggest timed bike race in the world.'),
(2, 'Parkrun Botanical Gardens', '2026-09-12 08:00:00', 'Pretoria', 'Weekly community 5k.');
-- Insert Categories for each event
INSERT INTO Categories (EventID, CategoryName, DistanceKm, EntryFee)
VALUES 
(1, 'Full Marathon', 42.2, 350.00),
(1, 'Half Marathon', 21.1, 250.00),
(2, 'Main Cycle Route', 109.0, 600.00),
(3, '5km Walk/Run', 5.0, 0.00);
-- Insert Sample Enrolments
INSERT INTO Enrolments (ParticipantID, CategoryID)
VALUES 
(3, 1), -- Charlie enters Soweto Full Marathon
(3, 4), -- Charlie enters Parkrun
(4, 3), -- Diana enters CT Cycle Tour
(4, 2); -- Diana enters Soweto Half Marathon
-- Insert Sample Results 
INSERT INTO Results (EnrolmentID, FinishTime, OverallPosition)
VALUES 
(1, '03:45:12', 145), -- Charlie's Full Marathon Result
(2, '00:22:15', 5);   -- Charlie's Parkrun Result

USE master;
GO
DROP DATABASE RaceDay;
GO
