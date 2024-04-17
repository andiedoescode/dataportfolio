-- In SQL Server Management Studio (SSMS), a comment in the query window is preceded by two dashes (--). All comments appear in green
-- and are not run when real SQL code is executed.  Comments are way to communicated valuable information between analysts writing and 
-- runn the queries.

/** large block of comment can be preceded by a forward-slash and two asterisks and then ended by two asterisks and a back-slash 
	
	To begin selecting data, first use the database that you wish to pull data from.  Execute the command below to use the 
	'Medical' database, where all of our data are located.

	highlight the command with your mouse and click "Execute"

**/

-- GETTING STARTED

	use medical

-- You can use the Object Explorer to the left to list the tables under the Medical database.
-- to begin pulling some data, highlight and execute the command below.  It will return every row in the Doctors table of the Medical database.
-- select * can be used if you do not know the specific column names to select.  Highlight the code below and Execute.

	select * from doctors

-- EXERCISE - Try this for Patients, Facilities, Diagnoses
SELECT *
FROM Patients
SELECT *
FROM Facilities
SELECT *
FROM Diagnoses

-- to limit the number of rows returned, highlight and execute the code below

-- SELECT TOP

	select top 10 * from doctors

-- EXERCISE - Try this for Encounters, Medications, Diagnoses
SELECT TOP 10 *
FROM Encounters
SELECT TOP 10 *
FROM Medications
SELECT TOP 10 *
FROM Diagnoses

-- to select specific data by column name, list the column names (exactly) the select line.  They are NOT case sensitive.  Try the code below
-- by selecting it and clicking Execute

	select lastname, firstname from doctors

-- EXERCISE - select PatientID, LastName, DOB from Patients, Get Lastname and Specialty from the Doctors table.
SELECT PatientID, LastName, DOB
FROM Patients
SELECT LastName, Specialty
FROM Doctors

-- the code below will CONCTENATE (put together) the last and first names into a single column and will rename that column (for output purposes only)
-- 'Doctor Name'

-- RENAMING COLUMNS FOR OUTPUT

	select lastname+', '+firstname 'Doctor Name'
	from doctors

-- EXERCISE - Pull Diagnosis Code and Description from the Diagnoses table and name the Description column "Disease Name"
SELECT Description+' ('+CAST(DiagnosisID AS varchar)+')' 'Disease Name'
FROM Diagnoses

-- the code below will put those doctor names in order alphabetically starting with the beginning of the alphabet

-- SORTING

	select lastname+', '+firstname 'Doctor Name'
	from doctors
	order by lastname+', '+firstname

-- and the code below will put them in reverse alphabetical order.  Try it.

	select lastname+', '+firstname 'Doctor Name'
	from doctors
	order by lastname+', '+firstname DESC

-- EXERCISE - modify the code above to include doctor Specialty and sort by that column the doctor name
SELECT lastname+', '+firstname 'Doctor Name', Specialty
FROM doctors
ORDER BY Specialty

-- WHERE CLAUSE

-- to limit the data returned by some criterion or criteria, use a WHERE clause.  The code below will return doctors whose last name is Dalton.

	select lastname, firstname
	from doctors
	where lastname = 'Dalton'

-- Modify the code above to find doctors with last name "Gates"
SELECT lastname, firstname
FROM doctors
WHERE lastname = 'Gates'

-- we can specify multiple criteria.  With the method below, the lastname must EXACTLY match what is in the single quotes.  Try it.

	select lastname, firstname
	from doctors
	where lastname in ('Dalton', 'Hood')

-- EXERCISE - modify the code above to include doctors named "Collins" as well
SELECT lastname, firstname
FROM doctors
WHERE lastname IN ('Dalton', 'Hood', 'Collins')

-- If we forget to close a quote or a parenthese, we will get an error.

	select lastname, firstname
	from doctors
	where lastname in ('Dalton', 'Hood'  -- NOTE:  You will need to fix this problem in order not to see red squigglies in the rest of this code

-- JOINS

-- to get data from multiple tables pulled together, we must join the tables.  We usually join the tables on the PRIMARY KEY (the column identifying
-- unique values in that table) of one table to the FOREIGN KEY	value of the other.  These are the same values.  When primary key values appear in other
-- tables, they are called FOREIGN KEYS.  The code below joins the ENCOUNTERS table with the PATIENTS table, because we want to pull information from 
-- both tables together into one report.  We know that the PRIMARY KEY in the Patients table is PATIENTID and that value appears in the Encounters 
-- table as a FOREIGN KEY with the same name.  To return rows in common between the two tables, user an INNER JOIN.  This will only return rows where 
-- the PRIMARY and FOREIGN key values match between the two tables. 

-- we are also going to give each of our tables a nickname, so it is easier to refer to them in the query.  We will call Encounters "e" and Patients "p"
-- here we are pulling the concatenated patient name from the Patients table and the date of their encounters from the Encounters table, joined on
-- the column common to both, PATIENTID.  For an INNER JOIN such as this (note, using the word "JOIN" alone automatically makes it an INNER JOIN)
-- the order of the tables listed does not matter.  Select and execute the code below.

	select p.Lastname+', '+p.firstname 'Patient Name', e.date 'Encounter Date'
	from encounters e
	join patients p on e.patientid=p.patientid

-- EXERCISE - Add an inner join to the query above to the doctors table (the column in common is "doctorID") and include doctor last and first name in the 
-- selection
SELECT p.Lastname+', '+p.firstname 'Patient Name', e.date 'Encounter Date', d.LastName+', '+d.FirstName 'Provider'
FROM encounters e
	JOIN patients p ON e.patientid=p.patientid
	JOIN doctors d ON e.doctorid = d.doctorid

-- to put the data in order by patient name and by most recent encounter first, we will sort by both, making the date DESC

	select p.Lastname+', '+p.firstname 'Patient Name', e.date 'Encounter Date'
	from encounters e
	join patients p on e.patientid=p.patientid
	order by p.lastname+', '+p.firstname, e.date DESC

-- OUTER JOIN

-- to return all rows in the first table listed and only the matching rows in the second, use an OUTER JOIN.  In this case it is a LEFT JOIN
-- because the table listed first (which is on the left if you drew a picture) is the table we want all rows from, and table second
-- will only show the rows where that PATIENTID appears in the Encounters table

	select p.lastname, e.date
	from patients p 
	LEFT JOIN encounters e on p.patientid=e.patientid

-- EXERCISE - If I wanted to pull all doctors (lastname, firstname) and any encounter dates they have, and include all doctors even if they don't 
-- have encounters, how would I do it?
SELECT d.LastName+', '+d.FirstName 'Provider', e.Date 'Visit Date'
FROM Doctors d
	LEFT JOIN Encounters e ON e.DoctorID = d.DoctorID

-- in the Encounters table, a single date will appear multiple times, because there are many encounters in a single day.  To return each date in the
-- encounters table only one time, use DISTINCT.

	select distinct date
	from encounters

-- EXERCISE - How would I get a unique list of PatientIDs from the Encounters Table?
SELECT DISTINCT PatientID
FROM Patients

--WILDCARDS and COMPARISON

-- You can use a wildcard such as '%' in your WHERE CLAUSE to represent multiple items.  In the query below, we will see only patients whose
-- last name starts with A, regardless of what follows.

	select *
	from patients
	where lastname like 'a%'

-- EXERCISE - Modify the code above to pull all patients whose last name ends in "s" regardless of what precedes it
SELECT *
FROM patients
WHERE lastname like '%s'

-- You can also use comparison operators in your where clause.  They include things like 'BETWEEN', '<', '>', etc.  Highlight and execute the code below
-- to see encounters after 1/1/2020

	select * 
	from encounters
	where date>'2020-01-01'

-- How would I pull every column from the encocunters table for dates prior to 1/1/2019?
SELECT *
FROM Encounters
WHERE DATE < '2019-01-01'

-- and to see encounters in the last month of 2021, try this one

	select * 
	from encounters
	where date between '2021-12-01' and '2021-12-31' -- It is inclusive, so it will include the start and end dates

-- FUNCTIONS

-- You can use built-in FUNCTIONS to return and/or manipulate values.  The code below returns today's date, regardless of when you run it.

	select getdate() 'The Date Today'

-- And this code allows us to calculate someone's birthday in years as of the day the code was run.  It uses the DATADIFF function.

	select lastname, firstname, DOB, datediff(year, DOB, getdate()) 'Age in years'
	from patients

-- EXERCISE - modify the query above to add the Encounters table and get dates of encounters for all patients who were seen between 1/1/2022 and 3/1/2022
SELECT  lastname, firstname, DOB, datediff(year, DOB, getdate()) 'Age in years', e.Date 'Visit Date'
FROM Patients p
JOIN Encounters e ON e.PatientID = p.PatientID
WHERE e.Date BETWEEN '2022-01-01' AND '2022-03-01'
ORDER BY e.Date, datediff(year, DOB, getdate())

-- CASE STATEMENTS

-- A CASE STATEMENT allows us to organize or group data into categories or to otherwise transform it.  Highlight the code below and execute it to see.

	select lastname, firstname, DOB, datediff(year, dob, getdate()) 'Age in years',
	case when datediff(year, dob, getdate())<10 then 'Under 10 years of age'
		 when datediff(year, dob, getdate()) between 11 and 19 then '11 - 19 years old'
		 else 'Over 19' end 'Age Range'
	from patients

-- EXERCISE - modify the query above to include age range 20 - 29, 30 - 39 and 40 - 49 and make the last one Over 50
SELECT lastname, firstname, DOB, DATEDIFF(year, DOB, GETDATE()) 'Age in years',
		CASE WHEN DATEDIFF(year, DOB, GETDATE())<10 THEN 'Under 10 years of age'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 11 and 19 then '11 - 19 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 20 and 29 then '20 - 29 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 30 and 39 then '30 - 39 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 40 and 49 then '40 - 49 years old'
				ELSE 'Over 50' END 'Age Range'
FROM patients

-- AGGREGATION AND GROUPING

-- we can aggregate data in our output.  We can count it, add it, average it.  When we are aggregating across some other data point, we must GROUP BY 
-- that data point.  Here we will count all the visits.

	select count(encounterid) 'Total Number of Visits'
	from encounters

-- Here we will count all the visits by year

	select year(date) 'Year', count(encounterid) 'Total Number of Visits'
	from encounters
	group by year(date)

-- EXERCISE - modify the query above to add the facilityname and also group by it
SELECT YEAR(e.date) 'Year', f.Name 'Facility', COUNT(e.encounterid) 'Total Number of Visits'
FROM encounters e
JOIN Facilities f ON e.FacilityID = f.FacilityID
GROUP BY YEAR(date), f.Name

-- If we use a CASE STATEMENT and wish to group by it, we must include it in the GROUP BY statement

	select case when datediff(year, p.dob, getdate())<10 then 'Under 10 years of age'
		 when datediff(year, p.dob, getdate()) between 11 and 19 then '11 - 19 years old'
		 else 'Over 19' end 'Age Range', count(e.encounterid) 'Visits'
	from encounters e
	join patients p on e.patientid=p.patientid
	group by case when datediff(year, p.dob, getdate())<10 then 'Under 10 years of age'
		 when datediff(year, p.dob, getdate()) between 11 and 19 then '11 - 19 years old'
		 else 'Over 19' end

-- EXERCISE - modify the query above as you did earlier to include age range 20 - 29, 30 - 39 and 40 - 49 and make the last one Over 50.  Make sure
-- to update both CASE statements
SELECT CASE WHEN DATEDIFF(year, DOB, GETDATE())<10 THEN 'Under 10 years of age'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 11 and 19 then '11 - 19 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 20 and 29 then '20 - 29 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 30 and 39 then '30 - 39 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 40 and 49 then '40 - 49 years old'
				ELSE 'Over 50' END 'Age Range',
		count(e.encounterid) 'Visits'
FROM encounters e
JOIN patients p on e.patientid=p.patientid
GROUP BY CASE WHEN DATEDIFF(year, DOB, GETDATE())<10 THEN 'Under 10 years of age'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 11 and 19 then '11 - 19 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 20 and 29 then '20 - 29 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 30 and 39 then '30 - 39 years old'
				WHEN DATEDIFF(year, DOB, GETDATE()) between 40 and 49 then '40 - 49 years old'
				ELSE 'Over 50' END

-- Use MIN to get the first or smallest of something and MAX to get the last or greatest.

	select min(date) 'The Very First Visit', max(date) 'The Very Last Visit'
	from encounters

-- TEMPORARY TABLES AND TRANSACTIONS

-- You can create a TEMPORARY TABLE by preceding its name with '#' or '##'.  TEMPORARY TABLES will remain active in the currect SQL session 
-- and then will be dropped when that session ends.  Using '#' will make the temporary table available only in the current query window
-- whereas '##' will make it available in any open query window. Highlight and execute the code below to make a table called 'RPatients'
-- and to contain the PATIENTID of any patient whose name starts with 'R'.

	create table ##RPatients(patientid int, lastname varchar(100))
	insert into ##RPatients
	select patientid, lastname from patients where lastname like 'r%'

	select * from ##RPatients

-- EXERCISE - create a temporary table for all patients (PatientID, Lastname) whose birthday is before 6/1/1975
CREATE TABLE ##OldPts(PatientID int, LastName varchar(100), DOB date)
INSERT INTO ##OldPts
SELECT PatientID, LastName, DOB
FROM Patients
WHERE DOB < '1965-06-01'

SELECT * FROM ##OldPts

-- TRANSACTIONS, COMMIT AND ROLLBACK

-- Use a transaction to test the code without executing it.  If it is correct, COMMIT the transaction.  If not, use ROLLBACK.  
-- NOTE:  Once a tran has been begun, it MUST either be committed or rolled back.  If you run the code below, you will get the RPatients Table
-- but it will not be dropped until you COMMIT it.  NOTE:  we have to drop it at the beginning because it still exists from the last query.

	Drop table ##RPatients
	create table ##RPatients(patientid int, lastname varchar(100))
	insert into ##RPatients
	select patientid, lastname from patients where lastname like 'r%'

	select * from ##RPatients

	begin tran
		drop table ##RPatients

	--Commit tran
	--Rollback tran

-- EXERCISE - Do the above exercise but for your patients born before 6/1/1975 temporary table
BEGIN TRAN
	DROP TABLE ##OldPts

-- COMMIT TRAN
-- ROLLBACK TRAN
