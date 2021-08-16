ALTER TABLE owned_vehicles
ADD garage_id varchar(32) NOT NULL DEFAULT 'A';

ALTER TABLE owned_vehicles
ADD impound int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD stored int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD `type` varchar(32) NOT NULL DEFAULT 'car';

ALTER TABLE owned_vehicles
ADD `job` varchar(32) NOT NULL;

ALTER TABLE owned_vehicles
ADD park_coord LONGTEXT NULL DEFAULT '[]';

ALTER TABLE owned_vehicles
ADD isparked int(1) NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `private_garage` (
	`identifier` VARCHAR(64) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    `vehicles` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	`garage` VARCHAR(64) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`inventory` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;