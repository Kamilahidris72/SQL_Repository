SElect location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM CovidDeaths$
WHERE continent is not Null
ORDER by location,date

--CHECKING THE RATIO OF TOTAL DEATH VS TOTAL CASES--
--to check the %death  in Nigeria --
SElect location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 AS Percentage_Death
FROM CovidDeaths$
WHERE location='Nigeria' AND continent is not Null
ORDER by location,date 


--to check the totalcase  vs the population of the country
SELECT location, date, total_cases,Population,(total_cases/Population)*100 AS Popualtion_Percentage_with_Covid
FROM CovidDeaths$ 
WHERE location='Nigeria' AND continent is not Null
ORDER by location,date 

--Countries with the Highest infection rate--
SELECT location,population, Max(total_cases)as Highest_cases,(MAX (total_cases)/population)*100 as Population_percentage_with_Covid
FRom CovidDeaths$
WHERE continent is not NULL
GROUP BY location,population
Order BY Highest_cases  desc

--Countries with Highest Death Rate--
SELECT location,population, Max(CAST(total_deaths AS INT))as Highest_deaths,(MAX(CAST(total_deaths AS int))/population)*100 as Population_percentage_with_Covid
FRom CovidDeaths$
WHERE continent is not NULL
GROUP BY location,population
Order BY Highest_deaths desc

select*FRom CovidDeaths$
--WHERE continent is not NULL
ORDER BY continent,location, total_cases


--Highest death for each continent--
SELECT location, Max (cast(total_deaths as int))AS Highest_Death
FROM CovidDeaths$
WHERE continent is  NULL
GROUP BY location
ORDER BY location

--global number of case and death--
SELECT SUM(new_cases ) as global_cases, SUM(CAST(new_deaths AS iNT)) as global_deaths, (SUM(CAST(new_deaths AS iNT)))/SUM(new_cases)*100 as GLobal_death_rate
FROM CovidDeaths$

--CovidVaccination--
SELECT *
 FROM CovidDeaths$ inner join CovidVaccinations$
 ON CovidDeaths$.location=CovidVaccinations$.location AND CovidDeaths$.date=CovidVaccinations$.date

 --Relevant Data--
 SELECT CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations
 FROM CovidDeaths$ inner join CovidVaccinations$
 ON CovidDeaths$.location=CovidVaccinations$.location AND CovidDeaths$.date=CovidVaccinations$.date
 WHERE CovidDeaths$.continent is not NULL
 ORder by CovidDeaths$.location,CovidDeaths$.date 

 --ROLLING SUM UP OF NEW VACCINATIONS--
SELECT CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(cast(CovidVaccinations$.new_vaccinations as int))over(partition by CovidDeaths$.location order by CovidDeaths$.date) as RollUp_Vaccination
FROM CovidDeaths$ inner join CovidVaccinations$
ON CovidDeaths$.location=CovidVaccinations$.location AND CovidDeaths$.date=CovidVaccinations$.date
 WHERE CovidDeaths$.continent is not NULL AND CovidVaccinations$.new_vaccinations is not Null
 ORder by CovidDeaths$.location,CovidDeaths$.date

 --CREATING A #TEMPTABLE TO CALCULTATE THE RATIO OF ROLLUP_VACCINATION:POPULATION %--
 drop table if exists #TEMPTABLE CREATE TABLE #TEMPTABLE
 (continent varchar (50),location varchar(50), New_date  DATE, population Numeric,new_vaccination Numeric,RollUp_Vaccinaton Numeric)

INSERT INTO #TEMPTABLE
SELECT CovidDeaths$.continent,CovidDeaths$.location,CovidDeaths$.date,CovidDeaths$.population,CovidVaccinations$.new_vaccinations,
SUM(cast(CovidVaccinations$.new_vaccinations as int))over(partition by CovidDeaths$.location order by CovidDeaths$.date) as RollUp_Vaccination
FROM CovidDeaths$ inner join CovidVaccinations$
ON CovidDeaths$.location=CovidVaccinations$.location AND CovidDeaths$.date=CovidVaccinations$.date
WHERE CovidDeaths$.continent is not NULL AND CovidVaccinations$.new_vaccinations is not Null
ORder by CovidDeaths$.location,CovidDeaths$.date

  












