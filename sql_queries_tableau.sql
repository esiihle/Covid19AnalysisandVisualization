-- Global COVID statistics
SELECT SUM(new_cases) as total_cases, 
       SUM(CAST(new_deaths as int)) as total_deaths, 
       SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;

-- Death counts by continent/region
SELECT location, 
       SUM(CAST(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null 
  AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Infection rates by country
SELECT Location, 
       Population, 
       MAX(total_cases) as HighestInfectionCount,  
       MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Infection rates by country and date
SELECT Location, 
       Population,
       date, 
       MAX(total_cases) as HighestInfectionCount,  
       MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;

-- Vaccination progress by location and date
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population,
       MAX(vac.total_vaccinations) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null 
GROUP BY dea.continent, dea.location, dea.date, dea.population
ORDER BY 1,2,3;

-- Daily COVID data by location
SELECT Location, 
       date, 
       population, 
       total_cases, 
       total_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;

-- Rolling vaccination percentage calculation using CTE
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
SELECT *, 
       (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
FROM PopvsVac;