SELECT *
FROM PortfolioProject..CovidDeathsCSV
ORDER BY 3,4;


--SELECT *
--FROM PortfolioProject..CovidVaccinationsCSV
--ORDER BY 3,4;

--Just the datas

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeathsCSV
ORDER BY 1,2;

-- Shows Percentage of Deaths per cases

SELECT location, date, total_cases, total_deaths,
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Death_percentage
FROM PortfolioProject..CovidDeathsCSV
WHERE location like '%Brazil%' AND continent is not NULL
ORDER BY 1,2;

-- Shows Percentage of Population with Covid

SELECT location, date, population, total_cases, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS Cases_percentage
FROM PortfolioProject..CovidDeathsCSV
WHERE location like '%Brazil%' AND continent is not NULL
ORDER BY 1,2;

-- Shows Percentage of the most infected Countries with Covid

SELECT location, population, MAX(total_cases) AS Most_infected_country,
(CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS Most_infectadedcases_percentage
FROM PortfolioProject..CovidDeathsCSV
--WHERE location like '%Brazil%' AND continent is not NULL
GROUP BY location , population
ORDER BY Most_infectadedcases_percentage DESC;

--Countries with most Deaths
SELECT location,  sum(CAST(new_deaths AS int)) as Total_deaths_percountries
FROM PortfolioProject..CovidDeathsCSV
--WHERE location like '%Brazil%' 
where continent!=''
GROUP BY location
ORDER BY Total_deaths_percountries DESC;

--Continents with most Deaths
SELECT location,  sum(CAST(new_deaths AS int)) as Total_deaths_percontinents
FROM PortfolioProject..CovidDeathsCSV
--WHERE location like '%Brazil%' 
WHERE continent=''
GROUP BY location
ORDER BY Total_deaths_percontinents DESC;

-- Globally Numbers od Deaths
SELECT SUM(cast(new_cases as INT)) as total_cases, 
SUM(CAST(new_deaths as int)) total_deaths, 
SUM(CONVERT(float, new_deaths))/NULLIF(SUM(CONVERT(float, new_cases)),0) *100 AS Death_percentage
FROM PortfolioProject..CovidDeathsCSV
WHERE continent=''
--GROUP BY date
ORDER BY 1,2;


--Percentage of the population vaccinated
WITH PopulationvsVaccination (Continent, Location, Date, Population, New_vaccinations, Rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
--,(Rolling_people_vaccinated/population)*100
FROM PortfolioProject..CovidDeathsCSV dea
JOIN PortfolioProject..CovidVaccinationsCSV vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent !=''
--ORDER BY 2,3
)
SELECT *, (Rolling_people_vaccinated/NULLIF(population,0))*100 AS percetange_population_vaccinated
FROM PopulationvsVaccination

--TEMP TABLE

DROP TABLE IF exists #PercetangePopulationVaccinated
CREATE TABLE #PercetangePopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population FLOAT,
New_vaccination FLOAT,
Rolling_people_vaccinated FLOAT
)

INSERT INTO #PercetangePopulationVaccinated(continent, location,date, population,new_vaccination,Rolling_people_vaccinated)
SELECT dea.continent, dea.location, dea.date, CONVERT(float, dea.population), CONVERT(float,vac.new_vaccinations),
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
--,(Rolling_people_vaccinated/population)*100
FROM PortfolioProject..CovidDeathsCSV dea
JOIN PortfolioProject..CovidVaccinationsCSV vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent !=''
--ORDER BY 2,3
SELECT *, (Rolling_people_vaccinated/NULLIF(population,0))*100 AS percetange_population_vaccinated
FROM #PercetangePopulationVaccinated

-- Creating VIEW for later visualization

CREATE VIEW PercetangePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, CONVERT(float, dea.population) AS population, CONVERT(float,vac.new_vaccinations) AS new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
--,(Rolling_people_vaccinated/population)*100
FROM PortfolioProject..CovidDeathsCSV dea
JOIN PortfolioProject..CovidVaccinationsCSV vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent !=''
--ORDER BY 2,3

SELECT *
FROM PercetangePopulationVaccinated