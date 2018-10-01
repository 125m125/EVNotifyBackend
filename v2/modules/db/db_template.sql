-- accounts table structure
CREATE TABLE IF NOT EXISTS `accounts` (
    `akey` VARCHAR(6) NOT NULL PRIMARY KEY,
    `pw_hash` VARCHAR(255) NOT NULL,
    `lastactivity` INT(10) DEFAULT 0,
    `token` VARCHAR(20) NOT NULL UNIQUE
);

-- settings table structure
CREATE TABLE IF NOT EXISTS `settings` (
    `user` VARCHAR(6) NOT NULL,
    `akey` VARCHAR(6) NOT NULL,
    `email` VARCHAR(100) DEFAULT NULL,
    `telegram` INT(100) DEFAULT 0,
    `summary` TINYINT(1) DEFAULT 0,
    `soc` INT(3) DEFAULT 70,
    `lng` VARCHAR(20) DEFAULT 'en',
    `push` TINYINT(1) DEFAULT 0,
    `car` VARCHAR(100) DEFAULT NULL,
    `consumption` FLOAT(99, 2) DEFAULT 13,
    `device` VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (`user`),
    FOREIGN KEY (`akey`) REFERENCES `accounts`(`akey`)
);

-- sync table structure
CREATE TABLE IF NOT EXISTS `sync` (
    `user` VARCHAR(6) NOT NULL,
    `akey` VARCHAR(6) NOT NULL,
    `soc_display` FLOAT DEFAULT 0,
    `soc_bms` FLOAT DEFAULT 0,
    `soh` FLOAT DEFAULT 0,
    `charging` TINYINT(1) DEFAULT 0,
    `rapid_charge_port` TINYINT(1) DEFAULT 0,
    `normal_charge_port` TINYINT(1) DEFAULT 0,
    `aux_battery_voltage` FLOAT DEFAULT 0,
    `dc_battery_voltage` FLOAT DEFAULT 0,
    `dc_battery_current` FLOAT DEFAULT 0,
    `dc_battery_power` FLOAT DEFAULT 0,
    `latitude` DECIMAL(10, 8) DEFAULT NULL,
    `longitude` DECIMAL(11, 8) DEFAULT NULL,
    `gps_speed` FLOAT DEFAULT 0,
    `last_soc` INT(13) DEFAULT 0,
    `last_extended` INT(13) DEFAULT 0,
    `last_notification` INT(13) DEFAULT 0,
    `last_location` INT(13) DEFAULT 0,
    PRIMARY KEY (`user`),
    FOREIGN KEY (`akey`) REFERENCES `accounts`(`akey`)
);

-- statistics table structure
CREATE TABLE IF NOT EXISTS `statistics` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `akey` VARCHAR(6) NOT NULL,
    `soc_display` FLOAT DEFAULT NULL,
    `soc_bms` FLOAT DEFAULT NULL,
    `soh` FLOAT DEFAULT NULL,
    `charging` TINYINT(1) DEFAULT NULL,
    `rapid_charge_port` TINYINT(1) DEFAULT NULL,
    `normal_charge_port` TINYINT(1) DEFAULT NULL,
    `aux_battery_voltage` FLOAT DEFAULT NULL,
    `dc_battery_voltage` FLOAT DEFAULT NULL,
    `dc_battery_current` FLOAT DEFAULT NULL,
    `dc_battery_power` FLOAT DEFAULT NULL,
    `latitude` DECIMAL(10, 8) DEFAULT NULL,
    `longitude` DECIMAL(11, 8) DEFAULT NULL,
    `gps_speed` FLOAT DEFAULT NULL,
    `timestamp` INT(13) DEFAULT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`akey`) REFERENCES `accounts`(`akey`)
);

-- debug table structure
CREATE TABLE IF NOT EXISTS `debug` (
    `id` int NOT NULL AUTO_INCREMENT,
    `akey` VARCHAR(6) NOT NULL,
    `data` MEDIUMTEXT DEFAULT NULL,
    `timestamp` int(10) DEFAULT 0,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`akey`) REFERENCES `accounts`(`akey`)
);

-- login table structure for web interface
CREATE TABLE IF NOT EXISTS `login` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `mail` VARCHAR(100) NOT NULL,
    `pw_hash` VARCHAR(255) NOT NULL,
    `last_login` INT(10) DEFAULT 0,
    PRIMARY KEY (`id`)
);

-- devices table structure for web interface
CREATE TABLE IF NOT EXISTS `devices` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user` INT NOT NULL,
    `akey` VARCHAR(6) NOT NULL UNIQUE,
    `alias` VARCHAR(255) DEFAULT NULL,
    `token` VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user`) REFERENCES `login`(`id`),
    FOREIGN KEY (`akey`) REFERENCES `accounts`(`akey`)
);