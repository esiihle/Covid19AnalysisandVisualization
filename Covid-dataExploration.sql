-- Initial data exploration - let's see what we're working with
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 3,4;

-- Starting with the core data fields I need for analysis
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;

-- Death rate analysis - calculating the likelihood of dying if infected
-- This shows me how deadly COVID is in different countries
SELECT Location, 
       date, 
       total_cases,
       total_deaths, 
       (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
  AND continent is not null 
ORDER BY 1,2;

-- Population infection rate - what percentage of each country got infected
-- This helps me understand how widespread the virus was
SELECT Location, 
       date, 
       Population, 
       total_cases,  
       (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Finding countries with highest infection rates relative to their population
-- Using MAX to get the peak infection count for each country
SELECT Location, 
       Population, 
       MAX(total_cases) as HighestInfectionCount,  
       MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Countries with highest absolute death counts
-- Converting to int because the data might be stored as varchar
SELECT Location, 
       MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Continental breakdown - aggregating death counts by continent
-- This gives me a broader geographical perspective
SELECT continent, 
       MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global summary statistics - the big picture numbers
-- Calculating overall death rate across all countries
SELECT SUM(new_cases) as total_cases, 
       SUM(CAST(new_deaths as int)) as total_deaths, 
       SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;

-- Vaccination rollout analysis - tracking cumulative vaccinations
-- Using window function to calculate running total of vaccinations per country
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (
           PARTITION BY dea.Location 
           ORDER BY dea.location, dea.Date
       ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3;

-- Using CTE to calculate vaccination percentage
-- I need this because I can't directly reference the window function result
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
    SELECT dea.continent, 
           dea.location, 
           dea.date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(CONVERT(int,vac.new_vaccinations)) OVER (
               PARTITION BY dea.Location 
               ORDER BY dea.location, dea.Date
           ) as RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent is not null
)
-- Now I can calculate what percentage of population has been vaccinated
SELECT *, 
       (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
FROM PopvsVac;

-- Alternative approach using temporary table
-- Sometimes temp tables perform better than CTEs for complex calculations
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);

-- Populating the temp table with the same vaccination data
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (
           PARTITION BY dea.Location 
           ORDER BY dea.location, dea.Date
       ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

-- Now I can query the temp table and add my percentage calculation
SELECT *, 
       (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
FROM #PercentPopulationVaccinated;

-- Creating a view for future use in visualizations
-- Views are great for storing complex queries that I'll use repeatedly
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (
           PARTITION BY dea.Location 
           ORDER BY dea.location, dea.Date
       ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null;