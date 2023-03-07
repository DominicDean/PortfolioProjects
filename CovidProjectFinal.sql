 --Covid Project--

 -- Data Exploration

SELECT *
FROM CovidProject. . CovidDeaths
WHERE continent is not NULL
Order by 3,4

SELECT *
FROM CovidProject. . CovidVaccinations
Order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you catch Covid

SELECT location, continent, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS DeathPercentage
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
Order by 1,2

select MAX(total_cases) as TotalCases, MAX(total_deaths) as TotalDeaths
From CovidProject. .CovidDeaths

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, total_cases, population, (total_cases/population) *100 AS CasePercentage
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
Order by 1,2

-- Lookin at countries with highest Infection Rate compared to Population

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Showing the spread of new cases over time across countries

SELECT location,date, new_cases
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL 
ORDER BY 1,2

-- Showing countries with highest Death Count 

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing countries with highest Death Count per Population

SELECT location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population)) *100 AS PercentPopulationDeath
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
GROUP BY location, population
Order by PercentPopulationDeath DESC

-- Showing countries with Highest Death Count

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
GROUP BY location, population
Order by TotalDeathCount DESC

-- Showing Highest Death Count per Continent 
SELECT continent, SUM(new_deaths) as TotalDeathCount
FROM CovidProject. .CovidDeaths
WHERE continent is not null	 
GROUP BY continent
Order by TotalDeathCount DESC

-- Showing total Case Mortality World

Select location, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject. .CovidDeaths
Where continent is not null
GROUP by location
order by 1,2

-- Showing total Case Mortality World over Time 

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject. .CovidDeaths
Where continent is not null
GROUP by date
order by 1,2


-- Showing total tests per Country 

SELECT MAX(total_tests) as TotalTests, location
FROM CovidProject. .CovidVaccinations
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalTests DESC

-- Showing total tests per Population per Country 

SELECT dea.location, MAX(total_tests)/dea.population as TestPercentage
FROM CovidProject. .CovidVaccinations as vac
	Join CovidProject. .CovidDeaths as dea
	ON dea.location = vac.location
WHERE dea.continent  is not NULL
GROUP BY dea.location, dea.population
ORDER BY TestPercentage DESC




-- Total Population vs Vaccination
With PopvsVac(continent, Location, Date, Population, new_vaccinations, RollingCountVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location Order by dea.location, dea.date) as RollingCountVaccinated
FROM CovidProject. .CovidDeaths AS dea
Join CovidProject. .CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
-- ORDER BY 2,3
)
Select*, (RollingCountVaccinated/Population)*100
From PopvsVac



-- Creating View to store data for later visualizations

-- Percent Population that is Vaccinated

Create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location Order by dea.location, dea.date) as RollingCountVaccinated
FROM CovidProject. .CovidDeaths AS dea
Join CovidProject. .CovidVaccinations AS vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
-- ORDER BY 2,3


-- Case Percentage by Population per Country

Create view PercentCasePopulation as 
SELECT location, date, total_cases, population, (total_cases/population) *100 AS CasePercentage
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
--Order by 1,2

-- Death Percentage Covid per Country

Create view PercentDeathPopulation as
SELECT location, continent, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS DeathPercentage
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
-- Order by 6 DESC

-- Covid Deaths per Country 

Create view DeathsPerCountry as
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
GROUP BY location
-- ORDER BY TotalDeathCount DESC

-- Covid Deaths per Country by over Population

Create view DeathsPopulationCountry as
SELECT location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population)) *100 AS PercentPopulationDeath
FROM CovidProject. .CovidDeaths
WHERE continent is not NULL
GROUP BY location, population
--Order by PercentPopulationDeath DESC


-- Covid Deaths per Continent 

Create view DeathsPerContinent as
SELECT continent, SUM(new_deaths) as TotalDeathCount
FROM CovidProject. .CovidDeaths
WHERE continent is not null	 
GROUP BY continent
-- Order by TotalDeathCount DESC


-- Total Case Mortality World over Time 

Create view CaseMortalityOverTimeWorld as
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject. .CovidDeaths
Where continent is not null
GROUP by date
-- order by 1,2

-- Total Case Mortality World

Create view CaseMortalityWorld as
Select location, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidProject. .CovidDeaths
Where continent is not null
GROUP by location
-- order by 1,2


-- Total tests per Country

Create view TestCountry as
SELECT MAX(total_tests) as TotalTests, location
FROM CovidProject. .CovidVaccinations
WHERE continent is not NULL
GROUP BY location
-- ORDER BY TotalTests DESC


-- Total tests per Population per Country 

Create view TestsPopulationCountry as
SELECT dea.location, MAX(total_tests)/dea.population as TestPercentage
FROM CovidProject. .CovidVaccinations as vac
	Join CovidProject. .CovidDeaths as dea
	ON dea.location = vac.location
WHERE dea.continent  is not NULL
GROUP BY dea.location, dea.population
-- ORDER BY TestPercentage DESC