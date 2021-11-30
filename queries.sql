/*Queries that provide answers to the questions from all projects.*/

/* Find all animals whose name ends in "mon". */

SELECT * FROM animals WHERE name LIKE '%mon';

/* List the name of all animals born between 2016 and 2019. */

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' and '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts. */

SELECT name FROM animals WHERE neutered = 'true' AND escape_attempts < 3;

/* List date of birth of all animals named either "Agumon" or "Pikachu". */

SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

/* List name and escape attempts of animals that weigh more than 10.5kg */

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/* Find all animals that are neutered. */

SELECT * FROM animals WHERE neutered = 'true';

/* Find all animals not named Gabumon. */

SELECT * FROM animals WHERE name != 'Gabumon';

/* Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */

SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/* TRANSACTION FOR UPDATING SPECIES */ 

START TRANSACTION;

UPDATE animals SET species = 'unspecified';

ROLLBACK;

/* TRANSACTION FOR SETTING TO DIGIMON OR POKEMON */

START TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species = '';

COMMIT;

/* TRANSACTION TO DELETE ALL RECORDS */

START TRANSACTION;

DELETE FROM animals;

ROLLBACK;

/* TRANSACTION TO DELETE BY BORN DATE */

START TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT SP1;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK TO SP1;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE SIGN(weight_kg) = -1;

COMMIT;

/* How many animals are there? */

SELECT COUNT(*) AS total_animals FROM animals;

/* How many animals have never tried to escape? */

SELECT COUNT(*) AS never_escaped_animals FROM animals WHERE escape_attempts = 0;

/* What is the average weight of animals? */

SELECT AVG(weight_kg) AS average_weight FROM animals;

/* Who escapes the most, neutered or not neutered animals? */

SELECT name FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals);

/* What is the minimum and maximum weight of each type of animal? */

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */

SELECT species, AVG(escape_attempts) FROM ANIMALS WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
