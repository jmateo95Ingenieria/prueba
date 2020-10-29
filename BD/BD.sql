
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema BANK_SYSTEM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BANK_SYSTEM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BANK_SYSTEM` DEFAULT CHARACTER SET latin1 ;
USE `BANK_SYSTEM` ;

-- -----------------------------------------------------
-- Table `BANK_SYSTEM`.`USER_ACCOUNT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BANK_SYSTEM`.`USER_ACCOUNT` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `userName` VARCHAR(20) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pin` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `userName_UNIQUE` (`userName` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 300035
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `BANK_SYSTEM`.`BANK_ACCOUNT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BANK_SYSTEM`.`BANK_ACCOUNT` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `idUserAccount` INT(11) NOT NULL,
  `accountType` ENUM('BASIC', 'PREMIUM', 'PLUS') NOT NULL DEFAULT 'BASIC',
  `role` ENUM('CLIENT', 'ADMIN') NOT NULL DEFAULT 'CLIENT',
  `stateAccount` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  `balance` DOUBLE NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `fk_BANK_ACCOUNT_ID_USER_ON_USER_ACCOUNT_idx` (`idUserAccount` ASC),
  CONSTRAINT `fk_BANK_ACCOUNT_ID_USER_ON_USER_ACCOUNT`
    FOREIGN KEY (`idUserAccount`)
    REFERENCES `BANK_SYSTEM`.`USER_ACCOUNT` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 100017
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `BANK_SYSTEM`.`BANK_MOVEMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BANK_SYSTEM`.`BANK_MOVEMENT` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `idBankAccount` INT(11) NOT NULL,
  `dateMovement` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `movementType` ENUM('ACCREDITATION', 'RETIREMENT') NOT NULL,
  `amount` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_BANK_MOVEMENT_ID_BANK_ON_BANK_ACCOUNT_idx` (`idBankAccount` ASC),
  CONSTRAINT `fk_BANK_MOVEMENT_ID_BANK_ON_BANK_ACCOUNT`
    FOREIGN KEY (`idBankAccount`)
    REFERENCES `BANK_SYSTEM`.`BANK_ACCOUNT` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 100015
DEFAULT CHARACTER SET = latin1;

USE `BANK_SYSTEM` ;

-- -----------------------------------------------------
-- function ADD_BANK_MOVEMENT
-- -----------------------------------------------------

DELIMITER $$
USE `BANK_SYSTEM`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ADD_BANK_MOVEMENT`(idBankAccount INT, movementType VARCHAR(20), amount DOUBLE) RETURNS int(11)
BEGIN

DECLARE result_movement INT DEFAULT 0;
DECLARE actual_amount DOUBLE;

IF movementType = 'RETIREMENT' THEN
SELECT BANK_ACCOUNT.balance
INTO actual_amount
FROM BANK_ACCOUNT
WHERE BANK_ACCOUNT.id = idBankAccount;
IF actual_amount < amount THEN
RETURN result_movement;
END IF;
END IF;

INSERT INTO BANK_MOVEMENT(idBankAccount,movementType,amount)
VALUES (idBankAccount,movementType,amount);

SET result_movement = 1;
RETURN result_movement;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function AUTO_CREATE_USER_ACCOUNT
-- -----------------------------------------------------

DELIMITER $$
USE `BANK_SYSTEM`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `AUTO_CREATE_USER_ACCOUNT`(name_user VARCHAR(30), userName_user VARCHAR(20), pin_user INT) RETURNS int(11)
BEGIN

DECLARE last_insert INT;

INSERT INTO USER_ACCOUNT (name,userName,pin)
VALUES (name_user, userName_user, pin_user);

SELECT LAST_INSERT_ID()
INTO last_insert;

RETURN last_insert;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function DEFAULT_CREATE_BANK_ACCOUNT
-- -----------------------------------------------------

DELIMITER $$
USE `BANK_SYSTEM`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `DEFAULT_CREATE_BANK_ACCOUNT`(idUserAccount INT, accountType VARCHAR(10), role VARCHAR(10)) RETURNS int(11)
BEGIN

DECLARE last_insert INT;

INSERT INTO BANK_ACCOUNT(idUserAccount,accountType,role)
VALUES (idUserAccount,accountType,role);

SELECT LAST_INSERT_ID()
INTO last_insert;

RETURN last_insert;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `BANK_SYSTEM`;

DELIMITER $$
USE `BANK_SYSTEM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `BANK_SYSTEM`.`ACTION_AFTER_BANK_MOVEMENT`
AFTER INSERT ON `BANK_SYSTEM`.`BANK_MOVEMENT`
FOR EACH ROW
BEGIN
DECLARE total_balance DOUBLE;
DECLARE new_balance DOUBLE;

SELECT BANK_ACCOUNT.balance
INTO total_balance
FROM BANK_ACCOUNT
WHERE BANK_ACCOUNT.id = NEW.idBankAccount;

IF NEW.movementType = 'ACCREDITATION' THEN
SET new_balance = total_balance + NEW.amount;
UPDATE BANK_ACCOUNT
SET balance = new_balance
WHERE BANK_ACCOUNT.id = NEW.idBankAccount;
ELSEIF NEW.movementType = 'RETIREMENT' THEN
SET new_balance = total_balance - NEW.amount;
UPDATE BANK_ACCOUNT
SET balance = new_balance
WHERE BANK_ACCOUNT.id = NEW.idBankAccount;
END IF;

END$$


DELIMITER ;

  
SELECT AUTO_CREATE_USER_ACCOUNT('Werner Lopez','wernerLZ','123456789');
SELECT AUTO_CREATE_USER_ACCOUNT('Usuario 1','user1','123456789');
SELECT AUTO_CREATE_USER_ACCOUNT('Usuario 2','user2','123456789');
SELECT AUTO_CREATE_USER_ACCOUNT('Usuario 3','user3','123456789');
SELECT AUTO_CREATE_USER_ACCOUNT('Usuario 4','user4','123456789');
SELECT DEFAULT_CREATE_BANK_ACCOUNT('300001','PREMIUM','CLIENT');
SELECT DEFAULT_CREATE_BANK_ACCOUNT('300001','PREMIUM','ADMIN');
SELECT DEFAULT_CREATE_BANK_ACCOUNT('300002','PREMIUM','ADMIN');
SELECT DEFAULT_CREATE_BANK_ACCOUNT('300002','PREMIUM','CLIENT');
SELECT ADD_BANK_MOVEMENT('100002','ACCREDITATION','300');
SELECT ADD_BANK_MOVEMENT('100002','ACCREDITATION','50');
SELECT ADD_BANK_MOVEMENT('100002','ACCREDITATION','30');
SELECT ADD_BANK_MOVEMENT('100001','ACCREDITATION','300');
SELECT ADD_BANK_MOVEMENT('100001','ACCREDITATION','10');