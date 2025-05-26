CREATE DATABASE conservation_db;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name TEXT NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status TEXT   -- Endangered  || Vulnerable
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES rangers(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location TEXT NOT NULL,
    notes TEXT DEFAULT NULL
);

-- Insert data into rangers table
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');



-- Check the inserted data
SELECT * FROM rangers;


-- Insert data into species table
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Check the inserted data
SELECT * FROM species;

-- Insert data into sightings table
INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes)
VALUES
  (1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
  (2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
  (3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
  (4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Check the inserted data
SELECT * FROM sightings;

-- Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (ranger_id, name, region) VALUES
(4, 'Derek Fox', 'Coastal Plains');

-- Check the inserted data
SELECT * FROM rangers;


-- Count unique species ever sighted.
SELECT count(DISTINCT(species_id)) as "unique_species_count"
    FROM sightings;

-- Find all sightings where the location includes "Pass".
SELECT * 
    FROM sightings
    WHERE location ILIKE '%Pass%';

SELECT 
  r.name AS name,
  COUNT(s.sighting_id) AS total_sightings
FROM 
  rangers r
JOIN 
  sightings s ON r.ranger_id = s.ranger_id
GROUP BY 
  r.name
ORDER BY 
  r.name;

-- find the species that not  sightings
SELECT 
  sp.common_name
FROM 
  species sp
LEFT JOIN 
  sightings s ON sp.species_id = s.species_id
WHERE 
  s.sighting_id IS NULL;

-- Find the most recent sighting of each species
SELECT *
FROM sightings
ORDER BY sighting_time DESC
LIMIT 2;

-- Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET status = 'Historic'
WHERE discovery_year < 1800;

-- Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT DISTINCT ranger_id FROM sightings
);

