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

/* What animals belong to Melody Pond? */

SELECT name FROM owners O JOIN animals A ON O.id = A.owner_id WHERE O.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */

SELECT A.name FROM animals A JOIN species S ON A.species_id = S.id WHERE S.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */

SELECT full_name, A.name FROM owners O FULL JOIN animals A ON O.id = A.owner_id;

/* How many animals are there per species? */

SELECT S.name, COUNT(species_id) FROM species S JOIN animals A ON S.id = A.species_id GROUP BY S.name;

/* List all Digimon owned by Jennifer Orwell. */

SELECT A.name FROM owners O JOIN animals A ON O.id = A.owner_id JOIN species S ON S.id = A.species_id WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';

/* List all animals owned by Dean Winchester that haven't tried to escape. */

SELECT name FROM animals A JOIN owners O ON O.id = A.owner_id WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;

/* Who owns the most animals? */

SELECT full_name, COUNT (*) as number_of_animals FROM owners O JOIN animals A ON A.owner_id = O.id GROUP BY full_name ORDER BY 2 DESC LIMIT 1;

/* Who was the last animal seen by William Tatcher? */

SELECT A.name, MAX(date_of_visit) AS last_visit_date FROM animals A JOIN visits V ON A.id = V.animal_id WHERE V.vet_id = 1 GROUP BY A.name ORDER BY 2 DESC LIMIT 1;

/* How many different animals did Stephanie Mendez see? */

SELECT count(animal_id) AS animals_seen FROM visits WHERE vet_id = 3;

/* List all vets and their specialties, including vets with no specialties. */

SELECT V.name, S.specie_id FROM vets V FULL JOIN specializations S ON V.id = S.vet_id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */

SELECT A.name FROM animals A JOIN visits V ON A.id = V.animal_id WHERE V.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */

SELECT A.name, COUNT(animal_id) AS visit_times FROM visits V JOIN animals A ON A.id = V.animal_id GROUP BY A.name ORDER BY 2 DESC LIMIT 1;

/* Who was Maisy Smith's first visit? */

SELECT A.name, MIN(V.date_of_visit) AS first_visit FROM visits V JOIN animals A ON A.id = V.animal_id WHERE V.vet_id = 2 GROUP BY A.name LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit. */

SELECT A.*, VT.*, date_of_visit FROM visits V JOIN animals A ON V.animal_id = A.id JOIN vets VT ON VT.id = V.vet_id WHERE V.date_of_visit = (SELECT MAX(date_of_visit) FROM visits);

/* How many visits were with a vet that did not specialize in that animal's species? */

SELECT COUNT(*) AS total FROM animals A JOIN visits V ON A.id = V.animal_id JOIN specializations S ON S.vet_id = V.vet_id WHERE A.species_id != S.specie_id;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */

select A.name, count(*) AS times_she_gets from visits V JOIN animals A ON V.animal_id = A.id where V.vet_id = 2 GROUP BY A.name ORDER BY 2 DESC LIMIT 1;

