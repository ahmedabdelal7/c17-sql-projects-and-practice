
--------------------------------------------------------------
--	Restore Database
--------------------------------------------------------------

--Q1
use master;
use CarData;
restore database VehicleMakesDB
from disk = 'E:\Course-17\SQL Problems\car-database\VehicleMakesDB.bak';

--Q2
use VehicleMakesDB
EXEC sp_changedbowner 'sa';


--------------------------------------------------------------
--	Exersieses From ChatGPT Easy to Hard
--------------------------------------------------------------

--Display all vehicles with their display name and year.
select ID ,Vehicle_Display_Name as [Vehicle Name], Year  from VehicleDetails

--Write a query to display all fuel types from the database.
select FuelTypeID, FuelTypeName from FuelTypes

--Write a query to display all makes sorted alphabetically.
select MakeID, Make from Makes order by Make ASC

--Write a query to display vehicles manufactured after 2020.
select ID, Vehicle_Display_Name as [Vehicle Name], Year from VehicleDetails
where Year > 2020;

--Write a query to display vehicles with 4 doors.
select ID, Vehicle_Display_Name as [Vehicle Name], NumDoors from VehicleDetails
where NumDoors = 4;

--Write a query to display vehicles with Engine_CC greater than 2000.
select ID, Vehicle_Display_Name, Engine_CC from VehicleDetails
where Engine_CC > 2000;

--Write a query to display vehicles with 6 cylinders.
select ID, Vehicle_Display_Name, Engine_Cylinders from VehicleDetails
where Engine_Cylinders = 6;

--Write a query to display vehicles manufactured between 2018 and 2022.
select ID, Vehicle_Display_Name, Year from VehicleDetails
where Year between 2018 and 2022;

--Write a query to display vehicles sorted by newest year first.
select ID, Vehicle_Display_Name AS Name , Year from VehicleDetails
order by Year DESC, Name;

--Write a query to display GAS vehicles only.
select ID, Vehicle_Display_Name,FuelTypeName from VehicleDetails vd
inner join FuelTypes ft ON ft.FuelTypeID = vd.FuelTypeID
where ft.FuelTypeName = 'GAS';

--Write a query to display: Vehicle_Display_Name, Make ,ModelName
select ID, Vehicle_Display_Name, Make , ModelName
from VehicleDetails vd join Makes m 
ON vd.MakeID = m.MakeID join MakeModels mm
ON mm.ModelID = vd.ModelID;

--Write a query to display vehicle name, fuel type, and drive type
select Vehicle_Display_Name as [Vehicle Name], FuelTypeName, DriveTypeName
from VehicleDetails vd join FuelTypes ft on vd.FuelTypeID = ft.FuelTypeID 
join DriveTypes dt on dt.DriveTypeID = vd.DriveTypeID ;

--Write a query to display vehicle name and body type
select Vehicle_Display_Name as [Vehicle Name], BodyName as [Body Type]
from VehicleDetails vd join Bodies b 
on vd.BodyID = b.BodyID


--Write a query to display all models belonging to Toyota
select ModelName , Make from MakeModels mm
join Makes m on mm.MakeID = m.MakeID
where Make = 'Toyota'

--Write a query to display all submodels belonging to BMW
SELECT SubModelName, Make
FROM SubModels sm INNER JOIN
MakeModels mm ON sm.ModelID = mm.ModelID INNER JOIN
Makes m ON mm.MakeID = m.MakeID
where m.Make = 'BMW';

--Write a query to count vehicles for each make
select m.Make, Count(vd.ID) as VehiclesCount 
from Makes m inner join VehicleDetails vd
on m.MakeID = vd.MakeID
group by m.Make

--Write a query to calculate the average Engine_CC for each fuel type.
select FuelTypeName, AVG(Engine_CC) as Average_Engine_CC
from FuelTypes ft join VehicleDetails vd
on ft.FuelTypeID = vd.FuelTypeID
where Engine_CC is not null
group by ft.FuelTypeName

--Write a query to display the largest Engine_CC in the database.
select Max(Engine_CC) as [Largest Engine CC] from VehicleDetails

--Write a query to count vehicles for each manufacturing year
select Year, count (*) as vehiclesCount from VehicleDetails
group by  Year 
order by Year DESC;

--Write a query to display fuel types having more than 100 vehicles
select * from(
select FuelTypeName, count(ID) as VehiclesCount from FuelTypes ft
join VehicleDetails vd 
on ft.FuelTypeID = vd.FuelTypeID
group by ft.FuelTypeName
)t1 
where t1.VehiclesCount > 100


select FuelTypeName, count(ID) as VehiclesCount 
from FuelTypes ft join VehicleDetails vd 
on ft.FuelTypeID = vd.FuelTypeID
group by ft.FuelTypeName
having count(ID) >100

--Write a query to display each make with the number of models it has
select Make , Count(ModelID) as NumOfModels
from Makes m join  MakeModels mm 
on m.MakeID = mm.MakeID
group by m.Make
order by NumOfModels DESC

--Display each make with the number of vehicles, average Engine_CC,newest manufacturing year,
--and only include makes having more than 500 vehicles, sorted by vehicle count descending.

select Make , Count(ID) as NumberOfVehicles, Avg(Engine_CC) AvgEngine_CC, Max(Year) as NewestYear
from Makes m join VehicleDetails vd
on m.MakeID = vd.MakeID
group by m.Make
having Count(ID) > 500
order by NumberOfVehicles DESC

--------------------------------------------------------------
--	SQL Problems PA
--------------------------------------------------------------

-- Problem 1: Create Master View
create view VehicleMasterDetails as
select 
	ID,
	m.MakeID, Make,
	mm.ModelID,  ModelName,
	sm.SubModelID, SubModelName,
	b.BodyID, BodyName,
	Vehicle_Display_Name, Year,
	dt.DriveTypeID, DriveTypeName,
	Engine,Engine_CC,Engine_Liter_Display,Engine_Cylinders,
	ft.FuelTypeID, FuelTypeName,
	NumDoors
from VehicleDetails vd left join Makes m
on vd.MakeID = m.MakeID
inner join  MakeModels mm
on vd.ModelID = mm.ModelID
inner join SubModels sm
on vd.SubModelID = sm.SubModelID
inner join Bodies b
on vd.BodyID = b.BodyID
inner join DriveTypes dt
on vd.DriveTypeID = dt.DriveTypeID
inner join FuelTypes ft
on vd.FuelTypeID = ft.FuelTypeID;

select * from VehicleMasterDetails;

-- Problem 2: Get all vehicles made between 1950 and 2000

select * from VehicleDetails
where Year between 1950 and 2000;


--Problem 3 : Get number vehicles made between 1950 and 2000

select count(*) as VehiclesCount from VehicleDetails
where year between 1950 and 2000;

--Problem 4 : Get number vehicles made between 1950 and 2000 per make and order them by Number Of Vehicles Descending

select m.Make , count(*) as NumOfVehicles from Makes m 
inner join VehicleDetails vd on m.MakeID = vd.MakeID
where year between 1950 and 2000
group by m.Make
order by NumOfVehicles DESC;

--Problem 5 : Get All Makes that have manufactured more than 12000 Vehicles in years 1950 to 2000

select m.Make, count(*) as NumOfVehicles from Makes m
inner join VehicleDetails vd on vd.MakeID = m.MakeID
where  year between 1950 and 2000
group by m.Make
having count(*) > 12000 ;

--Without Having
select * from 
(
	select m.Make, count(*) as NumOfVehicles from Makes m
	inner join VehicleDetails vd on vd.MakeID = m.MakeID
	where  year between 1950 and 2000
	group by m.Make
)R1
where R1.NumOfVehicles > 12000;


--Problem 6: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside

select m.Make , count(*) as NumOfVehicles, TotalVehicles =  (select  count(*) from VehicleDetails)
from Makes m 
inner join VehicleDetails vd on m.MakeID = vd.MakeID
where year between 1950 and 2000   
group by m.Make
order by NumOfVehicles DESC


-- Problem 7: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it, then calculate it's percentage

select *, CAST(R1.NumOfVehicles as float )/ CAST( R1.TotalVehicles as float ) as Perc from 
(

		select 
			m.Make , count(*) as NumOfVehicles, TotalVehicles = (select count(*) from VehicleDetails)
		from Makes m 
		inner join VehicleDetails vd on m.MakeID = vd.MakeID
		where year between 1950 and 2000   
		group by m.Make

)R1
order by NumOfVehicles DESC


--Problem 8: Get Make, FuelTypeName and Number of Vehicles per FuelType per Make

SELECT Make, FuelTypeName, count(*) as TotalVehicles
FROM     VehicleDetails INNER JOIN
                  FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID INNER JOIN
                  Makes ON VehicleDetails.MakeID = Makes.MakeID

group by Make, FuelTypeName
order by Make

--Problem 9: Get all vehicles that runs with GAS

select * from VehicleDetails 
inner join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypes.FuelTypeName = N'GAS'

--Problem 10: Get all Makes that runs with GAS

select distinct Makes.Make, FuelTypes.FuelTypeName 
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
inner join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypeName = N'GAS'

--  Problem 11: Get Total Makes that runs with GAS

select count(*) as TotalMakesRunOnGas from 
(
	select distinct Makes.Make, FuelTypes.FuelTypeName 
	from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
	inner join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
	where FuelTypeName = N'GAS'
)R1

-- Method-2
select count(distinct Makes.Make)  TotalMakesRunOnGas
	from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
	inner join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
	where FuelTypeName = N'GAS'


--Problem 12: Count Vehicles by make and order them by NumberOfVehicles from high to low.

select Makes.Make, NumOfVehicles = count(*)
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make
order by NumOfVehicles DESC


--Problem 13: Get all Makes/Count Of Vehicles that manufactures more than 20K Vehicles
select Makes.Make, NumOfVehicles = count(*)
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make having count(*) > 20000
order by NumOfVehicles DESC

--Problem 14: Get all Makes with make starts with 'B'

select Make from Makes
where Make Like 'B%'

--Problem 15: Get all Makes with make ends with 'W

select Make from Makes
where Make Like '%W'

--Problem 16: Get all Makes that manufactures DriveTypeName = FWD

select distinct Makes.Make , DriveTypes.DriveTypeName 
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
inner join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
where  DriveTypes.DriveTypeName = N'FWD' 

--Problem 17: Get total Makes that Mantufactures DriveTypeName=FWD

select count(*) as MakeWithFWD from 
(
	select distinct Makes.Make , DriveTypes.DriveTypeName 
	from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
	inner join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
	where  DriveTypes.DriveTypeName = N'FWD' 
)R1

-- Method-2

select count(distinct Make) as MakeWithFWD  
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
inner join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
where  DriveTypes.DriveTypeName = N'FWD' 


--Problem 18: Get total vehicles per DriveTypeName Per Make and order them per make asc then per total Desc

select m.Make, dt.DriveTypeName, count(*) as TotalVehicles
from DriveTypes dt inner join VehicleDetails vd on dt.DriveTypeID = vd.DriveTypeID 
inner join Makes m on vd.MakeID = m.MakeID
group by m.Make, dt.DriveTypeName
order by m.Make, TotalVehicles DESC;


--Problem 19: Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000

select m.Make, dt.DriveTypeName, count(*) as TotalVehicles
from DriveTypes dt inner join VehicleDetails vd on dt.DriveTypeID = vd.DriveTypeID 
inner join Makes m on vd.MakeID = m.MakeID
group by m.Make, dt.DriveTypeName
having Count(*) > 10000
order by m.Make ASC, TotalVehicles DESC;


--Problem 20: Get all Vehicles that number of doors is not specified

select * from VehicleDetails
where NumDoors is null


--Problem 21: Get Total Vehicles that number of doors is not specified

select count(*) TotalWithNoSpecifiedDoors  from VehicleDetails
where NumDoors is NULL; 


--Problem 22: Get percentage of vehicles that has no doors specified

select 
(
	Cast((select count(*) TotalWithNoSpecifiedDoors  from VehicleDetails where NumDoors is NULL) as float)
	/
	Cast((select count(*) from VehicleDetails as TotalVehicles )as float)

) as PercOfNoSpecifiedDoors


--Problem 23: Get MakeID , Make, SubModelName for all vehicles that have SubModelName 'Elite'

select distinct VehicleDetails.MakeID, Makes.Make, SubModels.SubModelName 
from  VehicleDetails inner join Makes on Makes.MakeID = VehicleDetails.MakeID
inner join SubModels on VehicleDetails.SubModelID = SubModels.SubModelID
where SubModelName ='Elite'

--Problem 24: Get all vehicles that have Engines > 3 Liters and have only 2 doors

select * from VehicleDetails
where Engine_Liter_Display > 3 and NumDoors = 2

--Problem 25: Get make and vehicles that the engine contains 'OHV' and have Cylinders = 4

select  Makes.Make, VehicleDetails.* 
from VehicleDetails inner join Makes on VehicleDetails.MakeID = Makes.MakeID
where (VehicleDetails.Engine Like N'%OHV%') and (VehicleDetails.Engine_Cylinders = 4)


-- Problem 26: Get all vehicles that their body is 'Sport Utility' and Year > 2020

select Bodies.BodyName ,VehicleDetails.* 
from VehicleDetails inner join Bodies on VehicleDetails.BodyID = Bodies.BodyID
where Bodies.BodyName = 'Sport Utility' AND Year > 2020

--Problem 27: Get all vehicles that their Body is 'Coupe' or 'Hatchback' or 'Sedan'

select Bodies.BodyName ,VehicleDetails.* 
from VehicleDetails inner join Bodies on VehicleDetails.BodyID = Bodies.BodyID
where Bodies.BodyName IN ('Coupe','Hatchback','Sedan')

--Problem 28: Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' 
--and manufactured in year 2008 or 2020 or 2021

select Bodies.BodyName ,VehicleDetails.* 
from VehicleDetails inner join Bodies on VehicleDetails.BodyID = Bodies.BodyID
where Bodies.BodyName IN ('Coupe','Hatchback','Sedan') 
	AND Year IN (2008,2020,2021)


--Problem 29: Return found=1 if there is any vehicle made in year 1950

select found=
CASE
when exists(select * from VehicleDetails where year = 1950)  then 1
ELSE 0
END


--Doctor Method
select found = 1
where 
exists(
		select * from VehicleDetails where year = 1950
)


--Problem 30: Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words,
--and if door is null display 'Not Set'

select Vehicle_Display_Name, NumDoors, 
	Case
		when NumDoors = 1 then 'One Door'
		when NumDoors = 2 then 'Tow Doors'
		when NumDoors = 3 then 'Three Doors'
		when NumDoors = 4 then 'Four Doors'
		when NumDoors = 5 then 'Five Doors'
		when NumDoors = 6 then 'Six Doors'
		when NumDoors = 8 then 'Eight Doors'
		Else 'NotSet'
	End as DoorsDescription
from VehicleDetails;


select distinct NumDoors
from VehicleDetails
order by NumDoors ;

--Problem 31: Get all Vehicle_Display_Name, year and add extra column to calculate the age of the car 
--then sort the results by age desc.

select Vehicle_Display_Name, Year, Age = Year(getDate()) - Year

from VehicleDetails

--Problem 32: Get all Vehicle_Display_Name, year, Age for vehicles that their age between 15 and 25 years old

select * from 
(
select Vehicle_Display_Name, Year, Age = Year(getDate()) - Year
from VehicleDetails
)R1
where R1.Age between 15 and 25

--Problem 33: Get Minimum Engine CC , Maximum Engine CC , and Average Engine CC of all Vehicles

select 
	Min(Engine_CC) as MinimumEnging_CC,
	Max(Engine_CC) as MaximumEnging_CC,
	Avg(Engine_CC) as AverageEnging_CC
from VehicleDetails

--Problem 34: Get all vehicles that have the minimum Engine_CC

select * from VehicleDetails
where Engine_CC = (select Min(Engine_CC)  from VehicleDetails )







































































































































