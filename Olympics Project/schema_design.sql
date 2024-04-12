-- creating the database
CREATE DATABASE IF NOT EXISTS olympic_db;
-- use the database
USE olympic_db;

-- creating tables' schemas
CREATE TABLE IF NOT EXISTS athlete_events
(
	id INT,
    name VARCHAR(50),
    sex ENUM('M','F'),
    age VARCHAR(10),
    height VARCHAR(10),
    weight VARCHAR(10),
    team VARCHAR(50),
    noc VARCHAR(10),
    games VARCHAR(100),
    year INT,
    season VARCHAR(100),
    city VARCHAR(50),
    sport VARCHAR(100),
    event TEXT,
    medal VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS noc_regions
(
	noc VARCHAR(10),
    region VARCHAR(100),
    notes TEXT
);