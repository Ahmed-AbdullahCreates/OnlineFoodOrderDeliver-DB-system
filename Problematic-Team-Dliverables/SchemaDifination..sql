CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    UserName NVARCHAR(100) NOT NULL UNIQUE, -- No username duplicates
    PasswordHash CHAR(64) NOT NULL, -- Store hashed password
    City NVARCHAR(100) NOT NULL,
    Street NVARCHAR(100) NOT NULL,
    Apartment NVARCHAR(50),
    Email NVARCHAR(255) NOT NULL UNIQUE, -- No email duplicates
    CONSTRAINT CK_Email CHECK (Email LIKE '%_@__%.__%'),--! Email format validation
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    LastLoginTime DATETIME,
    AccountStatus NVARCHAR(20) DEFAULT 'Active' 
        CHECK (AccountStatus IN ('Active', 'Suspended', 'Blocked'))
);

CREATE TABLE UserPhones (
    PhoneNumber NVARCHAR(15) NOT NULL, 
    UserID INT NOT NULL,
    PRIMARY KEY (PhoneNumber, UserID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT CK_UserPhone CHECK (PhoneNumber LIKE '+%[0-9]%' AND LEN(PhoneNumber) >= 10)
);

CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Street NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1,
    Rating DECIMAL(3,2) NOT NULL CHECK (Rating BETWEEN 0 AND 5)
);

CREATE TABLE RestaurantPhones (
    PhoneNumber NVARCHAR(15) NOT NULL,
    RestaurantID INT NOT NULL,
    PRIMARY KEY (PhoneNumber, RestaurantID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE,
    CONSTRAINT CK_RestaurantPhone CHECK (PhoneNumber LIKE '+%[0-9]%' AND LEN(PhoneNumber) >= 10)
);

CREATE TABLE CuisineTypes (
    CuisineType NVARCHAR(50) NOT NULL,
    RestaurantID INT NOT NULL,
    Description NVARCHAR(500),
    PRIMARY KEY (CuisineType, RestaurantID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE
);

CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY IDENTITY(1,1),
    ItemName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500), 
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    RestaurantID INT NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,
    PreparationTime INT, -- in minutes
    IsVegetarian BIT DEFAULT 0,
    IsSpicy BIT DEFAULT 0,
    AllergensInfo NVARCHAR(500),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE 
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderStatus NVARCHAR(50) NOT NULL CHECK (OrderStatus IN ('Pending', 'Completed', 'Cancelled')),
    TotalPrice DECIMAL(10,2) NOT NULL CHECK (TotalPrice >= 0),
    OrderTime DATETIME NOT NULL DEFAULT GETDATE(),
    UserID INT NOT NULL,
    SpecialInstructions NVARCHAR(500) DEFAULT 'No special instructions', -- Default value
    CancellationReason NVARCHAR(200) DEFAULT 'N/A', -- Default value
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (OrderID, MenuItemID), -- Surrogate key
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    PaymentMethod NVARCHAR(50) NOT NULL CHECK (PaymentMethod IN ('Cash', 'Online')),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentTimestamp DATETIME NOT NULL DEFAULT GETDATE(), -- Combined date and time
    OrderID INT NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Processing', 'Completed', 'Failed', 'Refunded')),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE Deliveries (
    DeliveryID INT PRIMARY KEY IDENTITY(1,1),
    DeliveryAddress NVARCHAR(200) NOT NULL,
    DeliveryStatus NVARCHAR(50) NOT NULL CHECK (DeliveryStatus IN ('Pending', 'In Transit', 'Delivered')),
    DeliveryTime DATETIME NULL, -- Allow NULL initially
    OrderID INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    Rating DECIMAL(3,2) NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments NVARCHAR(500), -- Limited to 500 characters
    FeedbackTime DATETIME NOT NULL DEFAULT GETDATE(),
    OrderID INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);



--insert data 

INSERT INTO Users (UserName, Password, City, Street, Apartment, Role)
VALUES 
('Ahmed Mohamed', 'ahmed123', 'Cairo', 'Giza', 'Apartment 101', 'Customer'),
('Sara Ali', 'sara456', 'Alexandria', 'Mansoura Street', 'Apartment 202', 'Manager'),
('Mohamed Hassan', 'mohamed789', 'Mansoura', 'El Geish Street', 'Apartment 303', 'Admin'),
('Noor Abdullah', 'nour1234', 'Hurghada', 'El Sakala Square', 'Apartment 404', 'Customer'),
('Mariam Mostafa', 'mariam5678', 'Aswan', 'Corniche Street', 'Apartment 505', 'Admin');


INSERT INTO UserPhones (PhoneNumber, UserID)
VALUES 
    ('01012345678', 1),
    ('01234567890', 2),
    ('01198765432', 3);



INSERT INTO Restaurants (Name, City, Street)
VALUES 
('cario Restaurant', 'Cairo', 'Nile Street'),
('Nile Restaurant', 'Alexandria', 'March 30 Street'),
('Vista Restaurant', 'Hurghada', 'El Sakala Square'),
('Zaytouna Restaurant', 'Aswan', 'Corniche Street');


INSERT INTO RestaurantPhones (PhoneNumber, RestaurantID)
VALUES 
    ('0223456789', 1),
    ('0234567890', 2),
    ('0323456789', 3);




INSERT INTO CuisineTypes (CuisineType, RestaurantID)
VALUES 
    ('Egyptian', 1),
    ('Italian', 2),
    ('Seafood', 3);




INSERT INTO MenuItems (ItemName, Description, Price, RestaurantID)
VALUES 
('Lamb Tagine', 'Grilled lamb with potatoes', 120.00, 1),
('Koshary', 'Rice with lentils and fava beans', 40.00, 2),
('Chicken Shawarma', 'Grilled chicken with special marinade', 65.00, 3),
('Foul and Falafel', 'Foul beans and falafel with tahini salad', 35.00, 4);



INSERT INTO Orders (OrderStatus, TotalPrice, UserID)
VALUES 
    ('Pending', 45.00, 1),
    ('Completed', 30.00, 2),
    ('Cancelled', 0.00, 3);


INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity)
VALUES 
    (1, 1, 2),
    (2, 2, 1),
    (3, 3, 3);


	INSERT INTO Payments (PaymentMethod, Amount, OrderID)
VALUES 
    ('Cash', 45.00, 1),
    ('Card', 30.00, 2),
    ('Online', 0.00, 3);



INSERT INTO Deliveries (DeliveryAddress, DeliveryStatus, DeliveryTime, OrderID)
VALUES 
    ('123 Cairo Road, Cairo', 'Delivered', GETDATE(), 1),
    ('456 Giza Avenue, Giza', 'In Transit', GETDATE(), 2),
    ('789 Alexandria Street, Alexandria', 'Pending', GETDATE(), 3);



INSERT INTO Feedback (Rating, Comments, OrderID)
VALUES 
    (5, 'Excellent service!', 1),
    (4, 'Good food, but delivery was delayed.', 2),
    (3, 'Average experience.', 3);



--update data

UPDATE Users
SET Password = 'ah123321', Street = 'Mohammed Mahmoud Street', Apartment = 'Flat 10'
WHERE UserID = 1;


UPDATE UserPhones
SET PhoneNumber = '01098765432'
WHERE UserID = 2;


UPDATE Restaurants
SET Street = 'Dokki Street'
WHERE RestaurantID = 1;


UPDATE RestaurantPhones
SET PhoneNumber = '0229876543'
WHERE RestaurantID = 2;


UPDATE MenuItems
SET Price = 14.00
WHERE MenuItemID = 3;


UPDATE Orders
SET OrderStatus = 'Completed', TotalPrice = 50.00
WHERE OrderID = 2;


UPDATE OrderDetails
SET Quantity = 4
WHERE OrderID = 3 AND MenuItemID = 3;


UPDATE Payments
SET Amount = 60.00
WHERE PaymentID = 2;


UPDATE Deliveries
SET DeliveryStatus = 'Delivered'
WHERE DeliveryID = 1;


UPDATE Feedback
SET Rating = 4, Comments = 'Good experience, but room for improvement.'
WHERE FeedbackID = 3;




--delete data
DELETE FROM Users WHERE UserID = 3;


DELETE FROM UserPhones WHERE UserID = 1;


DELETE FROM Restaurants WHERE RestaurantID = 2;


DELETE FROM RestaurantPhones WHERE RestaurantID = 3;


DELETE FROM MenuItems WHERE MenuItemID = 2;


DELETE FROM Orders WHERE OrderID = 4;


DELETE FROM OrderDetails WHERE OrderID = 1 AND MenuItemID = 1;


DELETE FROM Payments WHERE PaymentID = 3;


DELETE FROM Deliveries WHERE DeliveryID = 2;


DELETE FROM Feedback WHERE FeedbackID = 1;





-- View for Users
CREATE VIEW View_Users AS
SELECT UserID, UserName, Password, City, Street, Apartment, Role
FROM Users;

-- View for User Phones
CREATE VIEW View_UserPhones AS
SELECT PhoneID, PhoneNumber, UserID
FROM UserPhones;

-- View for Restaurants
CREATE VIEW View_Restaurants AS
SELECT RestaurantID, Name, City, Street
FROM Restaurants;

-- View for Restaurant Phones
CREATE VIEW View_RestaurantPhones AS
SELECT PhoneID, PhoneNumber, RestaurantID
FROM RestaurantPhones;

-- View for Cuisine Types
CREATE VIEW View_CuisineTypes AS
SELECT CuisineID, CuisineType, RestaurantID
FROM CuisineTypes;

-- View for Menu Items
CREATE VIEW View_MenuItems AS
SELECT MenuItemID, ItemName, Description, Price, RestaurantID
FROM MenuItems;

-- View for Orders
CREATE VIEW View_Orders AS
SELECT OrderID, OrderStatus, TotalPrice, UserID
FROM Orders;

-- View for Order Details
CREATE VIEW View_OrderDetails AS
SELECT DetailID, OrderID, MenuItemID, Quantity
FROM OrderDetails;

-- View for Payments
CREATE VIEW View_Payments AS
SELECT PaymentID, PaymentMethod, Amount, OrderID
FROM Payments;

-- View for Deliveries
CREATE VIEW View_Deliveries AS
SELECT DeliveryID, DeliveryAddress, DeliveryStatus, DeliveryTime, OrderID
FROM Deliveries;

-- View for Feedback
CREATE VIEW View_Feedback AS
SELECT FeedbackID, Rating, Comments, OrderID
FROM Feedback;


