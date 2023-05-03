--View Data
Select *
From [owid-covid-data_29062022]

--DATA CLEANING
--Convert data type
---With Modify option in Object Explorer (Microsoft SQL Server)

--Find Duplicates
---Using Having statement
SELECT date, location, COUNT(*)
FROM [owid-covid-data_29062022]
GROUP BY date, location
--HAVING COUNT(*) > 1
Order By date

--Or also we can use CTE
With RowNumCTE AS (
Select *, 
		ROW_NUMBER() Over (
		Partition By Date,
					 Location
					 Order By 
						Date
						) row_num
From [owid-covid-data_29062022]
)

Select *
From RowNumCTE
Where row_num > 1

--DATA EXPLORATION
Select *
From [owid-covid-data_29062022]
Where location = 'indonesia'
Order By date desc

--DATA IN INDONESIA
--Date from 2021 to 2022
Select *
From [owid-covid-data_29062022]
Where (date >= '2021-01-01' AND date <= '2022-12-31') and location = 'indonesia'
Order By date

--New cases
Select date, new_cases
From [owid-covid-data_29062022]
Where (date >= '2021-01-01' AND date <= '2022-12-31') and location = 'indonesia'
Order By date

--Vaccination Percentage
Select date, (people_fully_vaccinated/population) * 100 as Vaccination_Percentage
From [owid-covid-data_29062022]
Where (date >= '2021-01-01' AND date <= '2022-12-31') and location = 'indonesia'

--Shows only date with vaccination record
With VacPrcntCTE as (
Select date, (people_fully_vaccinated/population) * 100 as Vaccination_Percentage
From [owid-covid-data_29062022]
Where (date >= '2021-01-01' AND date <= '2022-12-31') and location = 'indonesia'
)

Select *
From VacPrcntCTE
Where Vaccination_Percentage <> 0

--Global Vaccination Percentage
Select location, MAX(people_fully_vaccinated)/MAX(population) * 100 as Latest_Vaccination_Percentage
From [owid-covid-data_29062022]
Where continent = 'asia' and population <> 0
Group By location
Order By Latest_Vaccination_Percentage
