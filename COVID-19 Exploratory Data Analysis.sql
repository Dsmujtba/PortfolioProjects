-- SELECT *
-- FROM CovidVaccinations
-- ORDER BY 3, 4;

SELECT *
FROM CovidDeaths 
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- select the data that we will be using 

SELECT Location, date, total_tests, new_cases, total_deaths, population 
FROM CovidDeaths
ORDER BY 1, 2;

-- Looking at the total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100
FROM CovidDeaths
WHERE location LIKE '%Africa%'
ORDER BY 1,2;

-- Looking at the total case vs the population
-- Shows what percentage of popualtion got Covid

SELECT location, date, total_cases, population, (total_cases  / population)*100  
FROM CovidDeaths
WHERE location LIKE '%Africa%'
ORDER BY 1, 2;

-- Looking at countries Infestion Rates compered to population

SELECT location, Cast(population AS INT), MAX(CAST(total_cases AS INT)), MAX((Cast(total_cases AS INT)/ CAST(population AS INT)))*100 AS pop_per_infect
FROM CovidDeaths
GROUP BY location, population 
ORDER BY pop_per_infect DESC;

-- What country has the highest number of total case and total deaths

SELECT location, total_cases, total_deaths
FROM CovidDeaths
ORDER BY 2, 3;

-- Showing Countries with Highest Death count per Popualtion
SELECT location, MAX(CAST(total_deaths as INT)) As total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing Countries with Highest Death count per Popualtion
SELECT location, MAX(CAST(total_deaths as int)) As total_death_count
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;


-- GLOBAL NUMBERS

SELECT
	continent,
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) AS total_deaths,
	SUM(new_deaths) / SUM(new_cases) * 100  
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY 1,2;


-- Looking at total popualtion vs vaccinations

SELECT 
	cd.continent, 
	cd.location, 
	cd.population,
	cd.date, 
	cv.new_vaccinations
FROM CovidVaccinations cv INNER JOIN CovidDeaths cd 
	ON cv.location=cd.location 
	AND cv.date=cd.date
WHERE cd.population IS NOT NULL	
ORDER BY 2, 4;


-- USE CTE 

WITH PopvsVac (continent, location, population, date, new_vaccinations, rolling)
AS
(
SELECT 
	cd.continent, 
	cd.location, 
	cd.population,
	cd.date, 
	cv.new_vaccinations,
	SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling
FROM CovidVaccinations cv INNER JOIN CovidDeaths cd 
	ON cv.location=cd.location 
	AND cv.date=cd.date
-- WHERE cd.population IS NOT NULL
-- ORDER BY 2, 4
)


-- Creating View To Store Data for Later Visualisation


CREATE VIEW PercentPopulationVaccinated AS
SELECT 
	cd.continent, 
	cd.location, 
	cd.population,
	cd.date, 
	cv.new_vaccinations,
	SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling
FROM CovidVaccinations cv INNER JOIN CovidDeaths cd 
	ON cv.location=cd.location 
	AND cv.date=cd.date
WHERE cd.population IS NOT NULL
-- ORDER BY 2, 4


-- Creating View for Percentage of death within each continent

CREATE VIEW PercentDeath AS 
SELECT
	continent,
	SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) AS total_deaths,
	SUM(new_deaths) / SUM(new_cases) * 100  
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY 1,2;



