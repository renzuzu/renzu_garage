ALTER TABLE owned_vehicles
ADD garage_id varchar(32) NOT NULL DEFAULT 'A';

ALTER TABLE owned_vehicles
ADD impound int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD stored int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD park_coord LONGTEXT NULL DEFAULT '[]';
ALTER TABLE owned_vehicles
ADD isparked int(1) NULL DEFAULT 0;