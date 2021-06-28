/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


-- Fix data types for CovidDeaths Table
Alter Table PortfolioProject..CovidDeaths
Alter Column total_deaths float;

Alter Table PortfolioProject..CovidDeaths
Alter Column total_cases float;

Alter Table PortfolioProject..CovidDeaths
Alter Column new_deaths float;

Alter Table PortfolioProject..CovidDeaths
Alter Column total_deaths_per_million float;

Alter Table PortfolioProject..CovidDeaths
Alter Column new_deaths_per_million float;

Alter Table PortfolioProject..CovidDeaths
Alter Column reproduction_rate float;

Alter Table PortfolioProject..CovidDeaths
Alter Column icu_patients float;

Alter Table PortfolioProject..CovidDeaths
Alter Column icu_patients_per_million float;

Alter Table PortfolioProject..CovidDeaths
Alter Column hosp_patients float;

Alter Table PortfolioProject..CovidDeaths
Alter Column hosp_patients_per_million float;

Alter Table PortfolioProject..CovidDeaths
Alter Column weekly_icu_admissions float;

Alter Table PortfolioProject..CovidDeaths
Alter Column weekly_icu_admissions_per_million float;

Alter Table PortfolioProject..CovidDeaths
Alter Column weekly_hosp_admissions float;

Alter Table PortfolioProject..CovidDeaths
Alter Column weekly_hosp_admissions_per_million float;


-- Fix data types for CovidVax Table
Alter Table PortfolioProject..CovidVax
Alter Column new_tests float;

Alter Table PortfolioProject..CovidVax
Alter Column total_tests float;

Alter Table PortfolioProject..CovidVax
Alter Column total_tests_per_thousand float;

Alter Table PortfolioProject..CovidVax
Alter Column new_tests_per_thousand float;

Alter Table PortfolioProject..CovidVax
Alter Column new_tests_smoothed float;

Alter Table PortfolioProject..CovidVax
Alter Column new_tests_smoothed_per_thousand float;

Alter Table PortfolioProject..CovidVax
Alter Column positive_rate float;

Alter Table PortfolioProject..CovidVax
Alter Column tests_per_case float;

Alter Table PortfolioProject..CovidVax
Alter Column total_vaccinations float;

Alter Table PortfolioProject..CovidVax
Alter Column people_vaccinated float;

Alter Table PortfolioProject..CovidVax
Alter Column people_fully_vaccinated float;

Alter Table PortfolioProject..CovidVax
Alter Column new_vaccinations float;

Alter Table PortfolioProject..CovidVax
Alter Column new_vaccinations_smoothed float;

Alter Table PortfolioProject..CovidVax
Alter Column total_vaccinations_per_hundred float;

Alter Table PortfolioProject..CovidVax
Alter Column people_vaccinated_per_hundred float;

Alter Table PortfolioProject..CovidVax
Alter Column people_fully_vaccinated_per_hundred float;

Alter Table PortfolioProject..CovidVax
Alter Column new_vaccinations_smoothed_per_million float;

Alter Table PortfolioProject..CovidVax
Alter Column extreme_poverty float;

Alter Table PortfolioProject..CovidVax
Alter Column female_smokers float;

Alter Table PortfolioProject..CovidVax
Alter Column male_smokers float;

Alter Table PortfolioProject..CovidVax
Alter Column excess_mortality float;


-- Total Cases vs Total Deaths
-- Roughly shows likelihood of dying if contract covid in US

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;


-- By Country Total Cases vs Population
-- what percent of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;


-- Countries with highest infection rate compared to population

Select location, population, Max(total_cases)as MaxInfectionCount, Max(total_cases/population)*100 as MaxInfectionPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
Order by MaxInfectionPercent desc;


-- Countries with highest death count

Select location, Max(total_deaths) as MaxTotalDeaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by MaxTotalDeaths desc;


-- cases vs hospital patients

Select location, date, total_cases, hosp_patients, (hosp_patients/total_cases)*100 as HospPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;


-- cases vs icu patients

Select location, date, total_cases, icu_patients, (icu_patients/total_cases)*100 as IcuPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;


-- hopital patients and age by country

Select dea.location, Max(dea.hosp_patients) as MaxHospitalization, Max(vax.aged_65_older) as avg_aged_65_older, Max(vax.aged_70_older) as avg_aged_70_older, Max(vax.life_expectancy) as avg_life_expectancy
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- icu patients and age by country

Select dea.location, Max(dea.icu_patients) as MaxIcu, Max(vax.aged_65_older) as avg_aged_65_older, Max(vax.aged_70_older) as avg_aged_70_older, Max(vax.life_expectancy) as avg_life_expectancy
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- deaths patients and age by country

Select dea.location, Max(dea.total_deaths) as TotalDeaths, Max(vax.aged_65_older) as avg_aged_65_older, Max(vax.aged_70_older) as avg_aged_70_older, Max(vax.life_expectancy) as avg_life_expectancy
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- hopital patients and population_dentsity by country

Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Max(dea.population) as population, Max(vax.population_density) as population_density
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- icu patients and population_dentsity by country

Select dea.location, Max(dea.icu_patients) as MaxIcu, Max(dea.population) as population, Max(vax.population_density) as population_density
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- deaths patients and population_dentsity by country

Select dea.location, Max(dea.total_deaths) as TotalDeaths, Max(dea.population) as population, Max(vax.population_density) as population_density
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;



-- hopital patients and wealth by country

Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Avg(vax.gdp_per_capita) as avgGDP, Avg(vax.human_development_index) as avgDevelopment
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- icu patients and wealth by country

Select dea.location, Max(dea.icu_patients) as MaxIcu, Avg(vax.gdp_per_capita) as avgGDPC, Avg(vax.human_development_index) as avgDevelopment
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- deaths patients and wealth by country

Select dea.location, Max(dea.total_deaths) as TotalDeaths, Avg(vax.gdp_per_capita) as avgGDPC, Avg(vax.human_development_index) as avgDevelopment
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- hopital patients and health factors by country

Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Max(vax.cardiovasc_death_rate) as cardiovasc_death_rate, Max(vax.diabetes_prevalence) as diabetes_prevalance, Max(vax.female_smokers) as female_smokers, Max(vax.male_smokers) as male_smokers
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- icu patients and health factors by country

Select dea.location, Max(dea.icu_patients) as MaxIcu, Max(vax.cardiovasc_death_rate) as cardiovasc_death_rate, Max(vax.diabetes_prevalence) as diabetes_prevalance, Max(vax.female_smokers) as female_smokers, Max(vax.male_smokers) as male_smokers
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- deaths patients and health factors by country

Select dea.location, Max(dea.total_deaths) as TotalDeaths, Max(vax.cardiovasc_death_rate) as cardiovasc_death_rate, Max(vax.diabetes_prevalence) as diabetes_prevalance, Max(vax.female_smokers) as female_smokers, Max(vax.male_smokers) as male_smokers
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- hospital beds vs deaths

Select dea.location, Max(dea.total_deaths) as TotalDeaths, Max(vax.hospital_beds_per_thousand) as hospital_beds_per_thousand
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- cases vs tests

Select dea.location, Max(dea.total_cases), Max(vax.total_tests)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;

Select dea.location, Max(dea.total_cases_per_million)/1000 as cases_per_thousand, Max(vax.total_tests_per_thousand) as tests_per_thousand
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location
Order by 2 desc;


-- cases vs vacinations
Select dea.location, dea.date, dea.new_cases, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Order by 1,2;


-- deaths vs vacinations

Select dea.location, dea.date, dea.new_deaths, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Order by 1,2;


-- hospital patients vs vaccinations

Select dea.location, dea.date, dea.weekly_hosp_admissions, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Order by 1,2;


-- icu patients vs vaccinations

Select dea.location, dea.date, dea.weekly_icu_admissions, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Order by 1,2;



-- By Continent Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where continent is null
Order by 1,2;


-- By Continent Total Cases vs Population

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercent
From PortfolioProject..CovidDeaths
Where continent is null
Order by 1,2;


-- Continents with highest infection rate compared to population

Select location, population, Max(total_cases)as MaxInfectionCount, Max(total_cases/population)*100 as MaxInfectionPercent
From PortfolioProject..CovidDeaths
where continent is null
Group by location, population
Order by MaxInfectionPercent desc;


-- Continents with the highest death count

Select location, Max(total_deaths) as MaxTotalDeaths
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
order by MaxTotalDeaths desc;


-- Global Numbers cases vs deaths by day

Select date, Sum(new_cases) as GlobalCases, Sum(new_deaths) as GlobalDeaths, (Sum(new_deaths)/Sum(new_cases))*100 as GlobalDeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2;


-- Global cases vs deaths total

Select Sum(new_cases) as GlobalCases, Sum(new_deaths) as GlobalDeaths, (Sum(new_deaths)/Sum(new_cases))*100 as GlobalDeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2;


-- Total Population vs Vaccination
-- cte

With PopvsVax (continent, location, date, population, new_vaccinations, RollingVaxCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
Sum(vax.new_vaccinations) Over (Partition by dea.location Order by dea.location, dea.date) as RollingVaxCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
	and dea.date = vax.date
Where dea.continent is not null
)

Select *, (RollingVaxCount/population)*100
From PopvsVax
Order by 2, 3;


-- Total Population vs Vaccinations
-- temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population float,
new_vaccinations float,
RollingVaxCount float
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
Sum(vax.new_vaccinations) Over (Partition by dea.location Order by dea.location, dea.date) as RollingVaxCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
	and dea.date = vax.date
Where dea.continent is not null

Select *, (RollingVaxCount/population)*100
From #PercentPopulationVaccinated
Order by 2, 3;




-- create views for visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
Sum(vax.new_vaccinations) Over (Partition by dea.location Order by dea.location, dea.date) as RollingVaxCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
	and dea.date = vax.date
Where dea.continent is not null;

Select *
From PercentPopulationVaccinated;

Create View GlobalCasesAndDeaths as
Select date, Sum(new_cases) as GlobalCases, Sum(new_deaths) as GlobalDeaths, (Sum(new_deaths)/Sum(new_cases))*100 as GlobalDeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date;

Select *
From GlobalCasesAndDeaths;


Create View DeathAsPercentOfCases as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null;

Select *
From DeathAsPercentOfCases;


Create View InfectionPercentOfPop as
Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercent
From PortfolioProject..CovidDeaths
Where continent is not null;

Select *
From InfectionPercentOfPop;


Create View MaxInfectionPercent as
Select location, population, Max(total_cases)as MaxInfectionCount, Max(total_cases/population)*100 as MaxInfectionPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population;

Select *
From MaxInfectionPercent;


Create View DeathsByCountry as
Select location, Max(total_deaths) as MaxTotalDeaths
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location;

Select *
From DeathsByCountry;


Create View PercentOfInfectedHospitalized as
Select location, date, total_cases, hosp_patients, (hosp_patients/total_cases)*100 as HospPercent, icu_patients, (icu_patients/total_cases)*100 as IcuPercent
From PortfolioProject..CovidDeaths
Where continent is not null;

Select *
From PercentOfInfectedHospitalized;


Create View AgeEffect as
Select dea.location, Max(dea.hosp_patients) as MaxHospitalization, Max(dea.icu_patients) as MaxIcu, Max(dea.total_deaths) as TotalDeaths, Max(vax.aged_65_older) as avg_aged_65_older, Max(vax.aged_70_older) as avg_aged_70_older, Max(vax.life_expectancy) as avg_life_expectancy
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location;

Select *
From AgeEffect;


Create View PopEffect as
Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Max(dea.icu_patients) as MaxIcu, Max(dea.total_deaths) as TotalDeaths, Max(dea.population) as population, Max(vax.population_density) as population_density
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location;

Select *
From PopEffect;


Create View WealthEffect as
Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Max(dea.icu_patients) as MaxIcu, Max(dea.total_deaths) as TotalDeaths, Avg(vax.gdp_per_capita) as avgGDP, Avg(vax.human_development_index) as avgDevelopment
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location;

Select *
From WealthEffect;


Create View HealthEffect as
Select dea.location, Max(dea.hosp_patients) as MaxHospitalizations, Max(dea.icu_patients) as MaxIcu, Max(dea.total_deaths) as TotalDeaths, Max(vax.cardiovasc_death_rate) as cardiovasc_death_rate, Max(vax.diabetes_prevalence) as diabetes_prevalance, Max(vax.female_smokers) as female_smokers, Max(vax.male_smokers) as male_smokers
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location;

Select *
From HealthEffect;


Create View BedsAndDeaths as
Select dea.location, Max(dea.total_deaths) as TotalDeaths, Max(vax.hospital_beds_per_thousand) as hospital_beds_per_thousand
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null
Group by dea.location;

Select *
From BedsAndDeaths;


Create View VaxEffect as
Select dea.location, dea.date, dea.new_cases, dea.new_deaths, dea.weekly_hosp_admissions, dea.weekly_icu_admissions, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVax vax
	On dea.location = vax.location
Where dea.continent is not null;

Select *
From VaxEffect;


Create View ContinentalCases as
Select location, date, population, total_cases, (total_cases/population)*100 as InfectionPercent, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where continent is null;

Select *
From ContinentalCasesAndDeaths;


Create View ContinentalInfectionRate as
Select location, population, Max(total_cases)as MaxInfectionCount, Max(total_cases/population)*100 as MaxInfectionPercent
From PortfolioProject..CovidDeaths
where continent is null
Group by location, population;

Select *
From ContinentalInfectionRate;


Create View ContinentalDeathCount as
Select location, Max(total_deaths) as MaxTotalDeaths
From PortfolioProject..CovidDeaths
Where continent is null
Group by location;

Select *
From ContinentalDeathCount;