CREATE TABLE `patients` (
	`firstName` VARCHAR(255) NOT NULL,
	`lastName` VARCHAR(255) NOT NULL,
	`dob` VARCHAR(255) NOT NULL,
	`allergies` text NOT NULL,
	`injuries` text NOT NULL,
	PRIMARY KEY (`firstName`, `lastName`)
);
