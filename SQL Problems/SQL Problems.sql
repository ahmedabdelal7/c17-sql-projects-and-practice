
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

--Make-Count(Vehicles)-avg(Engine_CC)-Year

select Make , Count(ID) as NumberOfVehicles, Avg(Engine_CC) AvgEngine_CC, Max(Year) as NewestYear
from Makes m join VehicleDetails vd
on m.MakeID = vd.MakeID
group by m.Make
having Count(ID) > 500
order by NumberOfVehicles DESC

