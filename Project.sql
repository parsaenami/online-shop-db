-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 21, 2019 at 04:22 AM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_temp_3`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_delivery` (IN `ID` CHAR(5), IN `VendorID` CHAR(5), IN `FirstName` VARCHAR(10), IN `LastName` VARCHAR(10), IN `Phone` CHAR(11), IN `Status` VARCHAR(10), IN `Credit` VARCHAR(100))  BEGIN
    INSERT INTO delivery
VALUES(
    ID,
    VendorID,
    NULL,
    FirstName,
    LastName,
    Phone,
    `Status`,
    Credit
) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_operator` (IN `ID` CHAR(5), IN `VendorID` CHAR(5), IN `FirstName` VARCHAR(10), IN `LastName` VARCHAR(10))  BEGIN
    INSERT INTO operator
VALUES(
    ID,
    VendorID,
    FirstName,
    LastName
) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_orders` (IN `ID` CHAR(5), IN `VendorID` CHAR(5), IN `RegCustomerID` CHAR(5), IN `UnregCustomerID` CHAR(5), IN `CreatedAt` VARCHAR(10))  BEGIN
	IF VendorID IN (SELECT vendor.ID FROM vendor WHERE 1) AND 
    (RegCustomerID IN (SELECT registered_customer.ID FROM registered_customer WHERE 1) OR UnregCustomerID IN (SELECT unregistered_customer.ID FROM unregistered_customer WHERE 1))
    THEN
    INSERT INTO orders
VALUES(
    ID,
    VendorID,
    RegCustomerID,
    UnregCustomerID,
    NULL,
    NULL,
    CreatedAt,
    NULL
) ;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_product` (IN `ID` CHAR(5), IN `VendorID` CHAR(5), IN `Title` VARCHAR(10), IN `Price` VARCHAR(10), IN `Discount` VARCHAR(10), IN `Amount` INT(11))  BEGIN
    INSERT INTO product
VALUES(
    ID,
    VendorID,
    Title,
    Price,
    Discount
) ;
CALL
    add_product_to_vendor(VendorID, ID, Amount);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_product_to_orders` (IN `OrderID` CHAR(5), IN `ProductID` CHAR(5), IN `Amount` INT(11))  BEGIN
IF ProductID IN (SELECT product.ID FROM product WHERE 1) AND OrderID IN (SELECT orders.ID FROM orders WHERE 1) THEN
    INSERT INTO orderproduct
VALUES(OrderID, ProductID, Amount) ;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_product_to_vendor` (IN `VendorID` CHAR(5), IN `ProductID` CHAR(5), IN `Amount` INT(11))  BEGIN
IF VendorID IN (SELECT vendor.ID FROM vendor WHERE 1) AND productID IN (SELECT product.ID FROM product WHERE 1) THEN
    INSERT INTO vendorproduct
VALUES(VendorID, ProductID, Amount) ;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_registered_customer` (IN `ID` CHAR(5), IN `Password` VARCHAR(10), IN `Email` VARCHAR(30), IN `FirstName` VARCHAR(10), IN `LastName` VARCHAR(10), IN `PostalCode` CHAR(11), IN `Sex` VARCHAR(6), IN `Credit` VARCHAR(100), IN `Address` VARCHAR(1000), IN `Phone` CHAR(11))  BEGIN
    INSERT INTO registered_customer
VALUES(
    ID,
    MD5(`Password`),
    Email,
    FirstName,
    LastName,
    PostalCode,
    Sex,
    Credit
) ;
INSERT INTO customer_phone
VALUES(ID, Phone) ;
INSERT INTO customer_address
VALUES(ID, Address) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_support` (IN `ID` CHAR(5), IN `VendorID` CHAR(5), IN `FirstName` VARCHAR(10), IN `LastName` VARCHAR(10), IN `Phone` CHAR(11), IN `Address` VARCHAR(1000))  BEGIN
    INSERT INTO support
VALUES(
    ID,
    VendorID,
    FirstName,
    LastName,
    Phone,
    Address
) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_unregistered_customer` (IN `ID` CHAR(5), IN `FirstName` VARCHAR(10), IN `LastName` VARCHAR(10), IN `Address` VARCHAR(1000), IN `Phone` CHAR(11))  BEGIN
    INSERT INTO unregistered_customer
VALUES(
    ID,
    FirstName,
    LastName,
    Address,
    Phone
) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_vendor` (IN `ID` CHAR(5), IN `Title` VARCHAR(10), IN `City` VARCHAR(10), IN `Address` VARCHAR(1000), IN `Phone` CHAR(11), IN `Manager` VARCHAR(10), IN `OpenAt` CHAR(5), IN `CloseAt` CHAR(5))  BEGIN
    INSERT INTO vendor
VALUES(
    ID,
    Title,
    City,
    Address,
    Phone,
    Manager,
    OpenAt,
    CloseAt
) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_submit` (IN `OrderID` CHAR(5), IN `inPaymentType` VARCHAR(10), IN `inDeliveryAddress` VARCHAR(1000))  BEGIN
    UPDATE
        orders
    SET
    	PaymentType = inPaymentType, DeliveryAddress = inDeliveryAddress
    WHERE
        ID = OrderID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_customer` (IN `inID` CHAR(5), IN `WhoAmI` CHAR(5), IN `inPassword` VARCHAR(10), IN `inEmail` VARCHAR(30), IN `inFirstName` VARCHAR(10), IN `inLastName` VARCHAR(10), IN `inPostalCode` CHAR(11), IN `inSex` VARCHAR(6), IN `inCredit` VARCHAR(100), IN `newPassword` VARCHAR(10), IN `inAddress` VARCHAR(1000), IN `inPhone` CHAR(11))  BEGIN
IF WhoAmI = inID THEN
    
    IF inFirstName IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            FirstName = inFirstName
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inLastName IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            LastName = inLastName
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inPostalCode IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            PostalCode = inPostalCode
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inSex IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            Sex = inSex
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inCredit IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            Credit = Credit + inCredit
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF newPassword IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            `Password` = MD5(newPassword)
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inEmail IS NOT NULL THEN
        UPDATE
            registered_customer
        SET
            Email = inEmail
        WHERE
        	ID = inID AND `Password` = MD5(inPassword);
    END IF;
    IF inAddress IS NOT NULL THEN
        IF inAddress NOT IN (SELECT customer_address.Address FROM customer_address WHERE 1) THEN
            INSERT INTO 
                customer_address 
            VALUES (
                inID,
                inAddress
            );
        END IF;
    END IF;
    IF (inPhone IS NOT NULL AND inPhone NOT IN (SELECT customer_phone.Phone FROM customer_phone WHERE 1)) THEN
    INSERT INTO 
    	customer_phone
    VALUES (
        inID,
        inPhone
    );
    END IF;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

CREATE TABLE `customer_address` (
  `CustomerID` char(5) NOT NULL,
  `Address` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_address`
--

INSERT INTO `customer_address` (`CustomerID`, `Address`) VALUES
('10000', 'abc'),
('20000', 'bbb'),
('10002', 'add1');

-- --------------------------------------------------------

--
-- Table structure for table `customer_phone`
--

CREATE TABLE `customer_phone` (
  `CustomerID` char(5) NOT NULL,
  `Phone` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_phone`
--

INSERT INTO `customer_phone` (`CustomerID`, `Phone`) VALUES
('10000', '66666666666'),
('10002', '912');

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `ID` char(5) NOT NULL,
  `VendorID` char(5) NOT NULL,
  `OrderID` char(5) NOT NULL,
  `FirstName` varchar(10) DEFAULT NULL,
  `LastName` varchar(10) DEFAULT NULL,
  `Phone` char(11) DEFAULT NULL,
  `Status` varchar(10) DEFAULT NULL,
  `Credit` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`ID`, `VendorID`, `OrderID`, `FirstName`, `LastName`, `Phone`, `Status`, `Credit`) VALUES
('50000', '20000', '', 'c', 'cc', '54554', 'free', '17.6'),
('60000', '20001', '', 'a', 'aa', '54554', 'free', '2116.25');

--
-- Triggers `delivery`
--
DELIMITER $$
CREATE TRIGGER `delivery_logger` AFTER UPDATE ON `delivery` FOR EACH ROW IF (NEW.`status` != OLD.`status` ) THEN
INSERT INTO delivery_log
VALUES(
    old.ID,
    old.OrderID,
    old.`Status`,
    NEW.`Status`,
    NOW());
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_log`
--

CREATE TABLE `delivery_log` (
  `DeliveryID` char(5) DEFAULT NULL,
  `OrderID` char(5) NOT NULL,
  `OldStatus` varchar(10) DEFAULT NULL,
  `NewStatus` varchar(10) DEFAULT NULL,
  `Times` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `delivery_log`
--

INSERT INTO `delivery_log` (`DeliveryID`, `OrderID`, `OldStatus`, `NewStatus`, `Times`) VALUES
('50000', '', 'free', 'busy', '19:12:59'),
('50000', '40000', 'busy', 'free', '19:15:38'),
('50000', '', 'free', 'busy', '19:20:15'),
('50000', '40000', 'busy', 'free', '19:49:21'),
('50000', '', 'free', 'busy', '23:53:22'),
('50000', '50000', 'busy', 'free', '23:58:14'),
('50000', '', 'free', 'busy', '00:03:15'),
('50000', '50000', 'busy', 'free', '00:03:24'),
('50000', '', 'free', 'busy', '00:12:37'),
('50000', '50000', 'busy', 'free', '00:30:04'),
('50000', '', 'free', 'busy', '00:44:40'),
('50000', '10001', 'busy', 'free', '00:45:00'),
('50000', '', 'free', 'freee', '02:37:43'),
('50000', '', 'freee', 'free\\', '02:42:31'),
('50000', '', 'free\\', 'free', '02:42:35'),
('60000', '', 'free', 'busy', '03:15:06'),
('60000', '10002', 'busy', 'free', '03:19:37'),
('60000', '', 'free', 'busy', '05:39:14'),
('60000', '40062', 'busy', 'free', '05:40:53');

-- --------------------------------------------------------

--
-- Table structure for table `operator`
--

CREATE TABLE `operator` (
  `ID` char(5) NOT NULL,
  `VendorID` char(5) NOT NULL,
  `FirstName` varchar(10) DEFAULT NULL,
  `LastName` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `orderproduct`
--

CREATE TABLE `orderproduct` (
  `OrderID` char(5) NOT NULL,
  `ProductID` char(5) NOT NULL,
  `Amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orderproduct`
--

INSERT INTO `orderproduct` (`OrderID`, `ProductID`, `Amount`) VALUES
('40000', '30000', 5),
('40000', '40000', 3),
('40000', '50000', 4),
('50000', '40000', 3),
('50000', '50000', 4),
('10001', '40000', 5),
('10002', '40000', 5),
('10002', '50000', 10),
('1003', '40000', 3),
('40002', '30002', 200),
('40062', '30002', 200);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `ID` char(5) NOT NULL,
  `VendorID` char(5) NOT NULL,
  `RegCustomerID` char(5) DEFAULT NULL,
  `UnregCustomerID` char(5) DEFAULT NULL,
  `Status` varchar(10) DEFAULT NULL,
  `PaymentType` varchar(10) DEFAULT NULL,
  `CreatedAt` int(5) DEFAULT NULL,
  `DeliveryAddress` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`ID`, `VendorID`, `RegCustomerID`, `UnregCustomerID`, `Status`, `PaymentType`, `CreatedAt`, `DeliveryAddress`) VALUES
('10001', '20000', NULL, '11111', 'completed', 'dargah', 11, 'a'),
('10002', '30000', NULL, '11111', 'completed', 'dargah', 11, 'a'),
('10003', '30000', NULL, '11111', 'denied', 'dargah', 23, 'a'),
('40000', '20000', '10000', NULL, 'completed', 'credit', 9, 'abc'),
('40002', '20001', '10002', NULL, 'denied', 'credit', 12, 'add1'),
('40062', '20001', '10002', NULL, 'completed', 'credit', 12, 'add1'),
('50000', '20000', '20000', NULL, 'completed', 'credit', 9, 'bbb');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `before_update_order` BEFORE UPDATE ON `orders` FOR EACH ROW IF (NEW.`status` IS NULL) THEN
  IF (NEW.regcustomerID IS NOT NULL AND (SELECT B.V FROM (SELECT COUNT(T.Address) as V FROM customer_address as T WHERE (T.Address = NEW.DeliveryAddress AND T.CustomerID = NEW.RegCustomerID)) AS B WHERE 1) = 0) THEN
      SET NEW.`status` = 'denied';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
  ELSEIF (SELECT COUNT(O.Amount) FROM vendorproduct as V, orderproduct as O
    WHERE (V.VendorID = NEW.VendorID AND V.ProductID = O.ProductID AND       V.Amount < O.Amount) > 0) THEN
      SET NEW.`status` = 'denied';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
  ELSEIF ((SELECT COUNT(D.ID) FROM delivery as D WHERE
           (D.VendorID = CONVERT(NEW.VENDORid, CHAr) AND D.Status='free')) = 0) THEN
        SET NEW.`status` = 'denied';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
    ELSEIF (NEW.regcustomerID IS NOT NULL AND NEW.PaymentType = 'credit' AND (SELECT COUNT(R.ID) FROM         registered_customer as R WHERE(R.ID = NEW.RegCustomerID AND R.Credit <   (SELECT SUM(P.Price * ((100 - P.Discount)/100) * O.Amount) FROM product AS P, orderproduct AS O     WHERE (O.OrderID = NEW.ID AND P.ID = O.ProductID) GROUP BY O.OrderID))))    THEN
        SET NEW.`status` = 'denied';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
    ELSEIF ((SELECT COUNT(V.ID) FROM vendor as V WHERE((V.ID = CONVERT(NEW.VendorID, char))  AND NEW.CreatedAt > V.OpenAt AND NEW.CreatedAt < V.CloseAt)) = 0) THEN
        SET NEW.`status` = 'denied';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
    ELSE
        SET NEW.`status` = 'confirmed';
        INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
        UPDATE delivery
        SET ``.`Status` = 'busy', ``.`orderID` = NEW.ID
        WHERE ID = (SELECT D.ID FROM (SELECT * FROM delivery) as D WHERE
           (D.VendorID = CONVERT(NEW.VendorID, char) AND D.Status = 'free') LIMIT 1);
           UPDATE vendorproduct
           SET Amount = Amount - (SELECT O.Amount FROM `orderproduct` as O WHERE (O.OrderID = NEW.ID AND vendorproduct.productID = O.ProductID))
           WHERE (vendorproduct.`VendorID` = CONVERT(NEW.VendorID, char) AND (SELECT COUNT(O.OrderID) FROM `orderproduct` as O WHERE (O.OrderID = NEW.ID AND O.ProductID = vendorproduct.`ProductID`)) > 0);
           SET NEW.`Status` = 'sent';
           INSERT INTO order_log VALUES(old.ID, 'confirmed', NEW.`Status`, NOW());
           
  END IF;

ELSEIF (NEW.`status` = 'completed') THEN
  UPDATE delivery
        SET `Status` = 'free', `orderID` = NULL, `Credit` = ``.`Credit` + ((SELECT SUM(P.Price * ((100 - P.Discount)/100) * O.Amount) FROM product AS P, orderproduct AS O     WHERE (O.OrderID = CONVERT(NEW.ID, char) AND P.ID = O.ProductID) GROUP BY O.OrderID) * 0.05)
        WHERE orderID = NEW.ID;
  IF (NEW.paymentType = 'credit') THEN
          UPDATE registered_customer
          SET ``.`Credit` = ``.`Credit` - ((SELECT SUM(P.Price * ((100 - P.Discount)/100) * O.Amount) FROM product AS P, (SELECT * FROM orderproduct) AS O     WHERE (O.OrderID = NEW.ID AND         P.ID = O.ProductID) GROUP BY O.OrderID))
                  WHERE (ID = NEW.RegCustomerID);
     End IF;
     INSERT INTO order_log VALUES(old.ID, old.`Status`, NEW.`Status`, NOW());
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `order_logger` AFTER INSERT ON `orders` FOR EACH ROW INSERT INTO order_log
VALUES(
    new.ID,
    null,
    NEW.`Status`,
    NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_log`
--

CREATE TABLE `order_log` (
  `OrderID` char(5) DEFAULT NULL,
  `OldStatus` varchar(10) DEFAULT NULL,
  `NewStatus` varchar(10) DEFAULT NULL,
  `Times` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_log`
--

INSERT INTO `order_log` (`OrderID`, `OldStatus`, `NewStatus`, `Times`) VALUES
('40000', 'completed', 'confirmed', '19:12:59'),
('40000', 'confirmed', 'sent', '19:12:59'),
('40000', 'sent', 'completed', '19:15:38'),
('40000', 'completed', 'confirmed', '19:20:15'),
('40000', 'confirmed', 'sent', '19:20:15'),
('40000', 'sent', 'completed', '19:49:21'),
('50000', NULL, NULL, '23:05:01'),
('50000', NULL, 'denied', '23:05:10'),
('50000', 'denied', 'denied', '23:06:54'),
('50000', 'denied', 'denied', '23:08:25'),
('50000', 'denied', 'denied', '23:13:32'),
('50000', 'denied', 'denied', '23:18:03'),
('1', 'denied', 'denied', '23:19:24'),
('50000', 'denied', 'confirmed', '23:53:22'),
('50000', 'confirmed', 'sent', '23:53:22'),
('50000', 'sent', 'completed', '23:58:14'),
('50000', 'completed', 'confirmed', '00:03:15'),
('50000', 'confirmed', 'sent', '00:03:15'),
('50000', 'sent', 'completed', '00:03:24'),
('50000', 'completed', 'denied', '00:03:51'),
('50000', 'denied', 'denied', '00:05:24'),
('50000', 'denied', 'confirmed', '00:12:37'),
('50000', 'confirmed', 'sent', '00:12:37'),
('40000', 'completed', 'completed', '00:28:20'),
('40000', 'completed', 'completed', '00:29:14'),
('50000', 'sent', 'completed', '00:30:04'),
('10001', NULL, NULL, '00:36:47'),
('10001', NULL, 'denied', '00:38:27'),
('1', 'denied', 'denied', '00:42:21'),
('10001', 'denied', 'confirmed', '00:44:40'),
('10001', 'confirmed', 'sent', '00:44:40'),
('10001', 'sent', 'completed', '00:45:00'),
('10002', NULL, NULL, '02:07:28'),
('10002', NULL, 'denied', '02:08:40'),
('10002', 'denied', 'denied', '02:12:37'),
('10002', 'denied', 'denied', '02:13:29'),
('3', 'denied', 'denied', '02:14:46'),
('30000', 'denied', 'denied', '02:18:21'),
('30000', 'denied', 'denied', '02:21:13'),
('30000', 'denied', 'denied', '02:24:36'),
('30000', 'denied', 'denied', '02:27:12'),
('30000', 'denied', 'denied', '02:29:59'),
('30000', 'denied', 'denied', '02:35:39'),
('30000', 'denied', 'denied', '02:38:31'),
('5', 'denied', 'denied', '02:40:45'),
('5', 'denied', 'denied', '02:43:33'),
('5', 'denied', 'denied', '02:45:38'),
('5', 'denied', 'denied', '02:53:16'),
('11', 'denied', 'denied', '02:54:59'),
('5', 'denied', 'denied', '02:58:15'),
('5', 'denied', 'denied', '03:01:05'),
('5', 'denied', 'denied', '03:04:20'),
('5', 'denied', 'denied', '03:05:45'),
('5', 'denied', 'denied', '03:07:41'),
('5', 'denied', 'denied', '03:08:58'),
('5', 'denied', 'denied', '03:11:14'),
('10002', 'denied', 'confirmed', '03:15:06'),
('10002', 'confirmed', 'sent', '03:15:06'),
('10002', 'sent', 'completed', '03:19:37'),
('10004', NULL, 'completed', '03:21:23'),
('10003', NULL, NULL, '03:22:17'),
('10003', NULL, 'denied', '03:22:54'),
('40002', NULL, NULL, '05:20:16'),
('40002', NULL, 'denied', '05:22:32'),
('40062', NULL, NULL, '05:39:14'),
('40062', NULL, 'confirmed', '05:39:14'),
('40062', 'confirmed', 'sent', '05:39:14'),
('40062', 'sent', 'completed', '05:40:53');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `ID` char(5) NOT NULL,
  `VendorID` char(5) NOT NULL,
  `Title` varchar(10) DEFAULT NULL,
  `Price` int(10) DEFAULT NULL,
  `Discount` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ID`, `VendorID`, `Title`, `Price`, `Discount`) VALUES
('30000', '20000', 'x', 10, '0'),
('30001', '20000', 'y', 20, '0'),
('30002', '20001', 'chiz', 234, '10'),
('30003', '20000', 'w', 15, '0'),
('30004', '20000', 'ww', 20, '0'),
('30005', '20000', 'www', 25, '10'),
('40000', '20000', 'zz', 5, '0'),
('50000', '20000', 'qq', 20, '10');

-- --------------------------------------------------------

--
-- Table structure for table `registered_customer`
--

CREATE TABLE `registered_customer` (
  `ID` char(5) NOT NULL,
  `Password` varchar(100) DEFAULT NULL,
  `Email` varchar(30) DEFAULT NULL,
  `FirstName` varchar(10) DEFAULT NULL,
  `LastName` varchar(10) DEFAULT NULL,
  `PostalCode` char(11) DEFAULT NULL,
  `Sex` varchar(6) DEFAULT NULL,
  `Credit` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `registered_customer`
--

INSERT INTO `registered_customer` (`ID`, `Password`, `Email`, `FirstName`, `LastName`, `PostalCode`, `Sex`, `Credit`) VALUES
('10000', '81dc9bdb52d04dc20036dbd8313ed055', 'p@outlook.com', 'a', 'aa', '2714', 'female', '871'),
('10002', 'b59c67bf196a4758191e42f76670ceba', 'q@y.com', 'ali', 'mali', '123123', 'male', '57880'),
('20000', '827ccb0eea8a706c4c34a16891f84e7b', 'a.@g.com', 'aaa', 'bbb', '123', 'male', '9913');

-- --------------------------------------------------------

--
-- Table structure for table `support`
--

CREATE TABLE `support` (
  `ID` char(5) NOT NULL,
  `VendorID` char(5) NOT NULL,
  `FirstName` varchar(10) DEFAULT NULL,
  `LastName` varchar(10) DEFAULT NULL,
  `Phone` char(11) DEFAULT NULL,
  `Address` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `unregistered_customer`
--

CREATE TABLE `unregistered_customer` (
  `ID` char(5) NOT NULL,
  `FirstName` varchar(10) DEFAULT NULL,
  `LastName` varchar(10) DEFAULT NULL,
  `Address` varchar(1000) DEFAULT NULL,
  `Phone` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `unregistered_customer`
--

INSERT INTO `unregistered_customer` (`ID`, `FirstName`, `LastName`, `Address`, `Phone`) VALUES
('11111', 'a', 'a', 'a', '03121234567');

-- --------------------------------------------------------

--
-- Table structure for table `vendor`
--

CREATE TABLE `vendor` (
  `ID` char(5) NOT NULL,
  `Title` varchar(10) DEFAULT NULL,
  `City` varchar(10) DEFAULT NULL,
  `Address` varchar(1000) DEFAULT NULL,
  `Phone` char(11) DEFAULT NULL,
  `Manager` varchar(10) NOT NULL,
  `OpenAt` int(5) NOT NULL,
  `CloseAt` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vendor`
--

INSERT INTO `vendor` (`ID`, `Title`, `City`, `Address`, `Phone`, `Manager`, `OpenAt`, `CloseAt`) VALUES
('20000', 'abrisham', 'tehran', 'cdf', '88888888888', 'mamad', 7, 22),
('20001', 'vendishop', 'yazd', 'add3', '914', 'vendizade', 6, 23),
('30000', 'abrisham2', 'tehran', 'cdf', '88888888888', 'mamad', 8, 15);

-- --------------------------------------------------------

--
-- Table structure for table `vendorproduct`
--

CREATE TABLE `vendorproduct` (
  `VendorID` char(5) NOT NULL,
  `ProductID` char(5) NOT NULL,
  `Amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vendorproduct`
--

INSERT INTO `vendorproduct` (`VendorID`, `ProductID`, `Amount`) VALUES
('20000', '30000', 85),
('20000', '40000', 52),
('20000', '50000', 56),
('30000', '40000', 15),
('30000', '50000', 40),
('20001', '30002', 250),
('20000', '30003', 40),
('20000', '30004', 30),
('20000', '30005', 35);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD KEY `CustomerID` (`CustomerID`);

--
-- Indexes for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD KEY `CustomerID` (`CustomerID`);

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `VendorID` (`VendorID`);

--
-- Indexes for table `operator`
--
ALTER TABLE `operator`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `VendorID` (`VendorID`);

--
-- Indexes for table `orderproduct`
--
ALTER TABLE `orderproduct`
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `orders_ibfk_3` (`VendorID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `VendorID` (`VendorID`);

--
-- Indexes for table `registered_customer`
--
ALTER TABLE `registered_customer`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `support`
--
ALTER TABLE `support`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `VendorID` (`VendorID`);

--
-- Indexes for table `unregistered_customer`
--
ALTER TABLE `unregistered_customer`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vendorproduct`
--
ALTER TABLE `vendorproduct`
  ADD KEY `VendorID` (`VendorID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD CONSTRAINT `customer_address_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `registered_customer` (`ID`);

--
-- Constraints for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD CONSTRAINT `customer_phone_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `registered_customer` (`ID`);

--
-- Constraints for table `operator`
--
ALTER TABLE `operator`
  ADD CONSTRAINT `operator_ibfk_1` FOREIGN KEY (`VendorID`) REFERENCES `vendor` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
