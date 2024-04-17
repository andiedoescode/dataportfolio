-- -- SQL Quiz - Entire Document
-- -- Level 1

-- Write a query to select all rows and columns from the Patients table.   

select * from patients

-- Write a query to return all providers (lastname, firstname) in order by last name from A-Z.

select lastname+', '+firstname 'Provider'
from doctors 
order by lastname

-- Write a query to return all patients whose last name is Jones.

select lastname, firstname 
from patients
where lastname='Jones'

-- Write a query to return any patient (lastname, firstname) whose last name is either Lee or Smith.

select lastname+', '+firstname 'Patient'
from patients
where lastname in ('Lee', 'Smith') -- or you could say where lastname='Lee' or lastname='Smith'

-- Write a query to return all patients whose last name starts with R

select lastname+', '+firstname 'Patient' 
from patients
where lastname like 'r%'

-- Write a query to return patients (lastname, firstname) whose last name starts and ends with A

select lastname+', '+firstname
from patients
where lastname like 'a%a'

-- Write a query to return all all patients (lastname, firstname) in order by age (youngest to oldest).  You don't need to calculate ages, you can use date of birth.

select lastname+', '+firstname
from patients
order by DOB

-- Write a query to list each patient and their encounter dates in order by patient last name (A-Z) and encounter date (oldest first).

select p.lastname+', '+p.firstname 'Patient', e.date 'Encounter Date'
from encounters e
join patients p on e.patientid=p.patientid
order by p.lastname+', '+p.firstname, e.date

-- -- Level 2

-- Write a query to return patient name (you know the format), date of encounter, facility of encounter, provider of encounter (you know the format), and visit type.  Sort by patient last name (a-z) and date (oldest first).

select p.lastname+', '+p.firstname 'Patient', e.date 'Encounter Date', f.name 'Facility', d.lastname+', '+d.firstname 'Provider', e.visittype
from encounters e 
join patients p on e.patientid=p.patientid
join facilities f on e.facilityid=f.facilityid
join doctors d on e.doctorid=d.doctorid
order by p.lastname+', '+p.firstname, e.date

-- Write a query to return encounter date for the first quarter of 2021.  Include patient name, date of visit, facility, provider name and provider specialty.

select p.lastname+', '+p.firstname 'Patient', e.date 'Encounter Date', f.name 'Facility', d.lastname+', '+d.firstname 'Provider', d.specialty
from encounters e
join patients p on e.patientid=p.patientid
join facilities f on e.facilityid=f.facilityid
join doctors d on e.doctorid=d.doctorid
where e.date between '2021-01-01' and '2021-03-31' -- Quarter 1

-- Write a query to return patient name and encounter date and make sure it includes patients who have had no encounters, if any.  For those, we should still see the name but no encounter date.

select p.lastname+', '+p.firstname 'Patient', e.date 'Encounter Date'
from patients p
LEFT JOIN encounters e on p.patientid=e.patientid

-- Write a query to show patient name and the number of encounters they had in 2023.

select p.lastname+', '+p.firstname 'Patient', count(e.encounterid) 'Visits in 2023'
from encounters e 
join patients p on e.patientid=p.patientid
where year(e.date) = '2023'
group by p.lastname+', '+p.firstname


-- Write a query to select cardiology visits from the first of 2024 to the present day (regardless of what day the query is run).  Show patient name, date of visit, facility and provider.

select p.lastname+', '+p.firstname 'Patient', e.date 'Visit Date', f.name 'Facility', d.lastname+', '+d.firstname 'Provider'
from encounters e
join patients p on e.patientid=p.patientid
join facilities f on e.facilityid=f.facilityid
join doctors d on e.doctorid=d.doctorid
where e.date between '2024-01-01' and getdate()
and d.Specialty='Cardiology'

-- Write a query to show the facility with the most encounters.  (This is a bad question because they all have the same number of encounters).

select top 1 f.name 'Facility', count(e.encounterid) 'Visits'
from encounters e 
join facilities f on e.facilityid=f.facilityid
group by f.name
order by count(e.encounterid) desc

 -- Who is the oldest patient and how old are they in years?

select top 1 lastname+', '+firstname 'Patient', datediff(year, dob, getdate()) 'Age'
    from patients 
    group by lastname+', '+firstname, dob
order by dob

-- or

select lastname+', '+firstname 'Patient', datediff(year, dob, getdate()) 'Age'
from patients 
where datediff(year, dob, getdate()) =
(
select  max(datediff(year, dob, getdate()))
from patients
)

-- Which provider has seen the most patients?  How many patients have they seen? ( NOTE:  They may have all had the same number of encounters)

select d.lastname+', '+d.firstname 'Provider', count(distinct e.patientid) 'Unique Patients Seen'
from encounters e
join doctors d on e.doctorid=d.doctorid
group by d.lastname+', '+d.FirstName
order by count(distinct e.patientid) desc

-- Write a query to identify all blood pressures that are not valid because they don't contain a single backslash (/).

select bpid, bp
from BloodPressure
where bp not like '%/%'
and bp not like '%/%/%'

-- Write a query to identify all blood pressures that are either too long or too short.  A valid blood pressure contains 2 or 3 numbers, a backslash (/), and 2 or 3 numbers. Include the patient name, date of visit, facility and provider.

select p.lastname+', '+p.firstname 'Patient', e.date 'Visit Date', f.name 'Facility', d.lastname+', '+d.firstname 'Provider', bp.BP
from encounters e
join BloodPressure bp on e.EncounterID=bp.EncounterID
join patients p on e.patientid=p.patientid
join facilities f on e.facilityid=f.FacilityID
join doctors d on e.DoctorID=d.DoctorID
where len(bp.bp)<5

-- -- Level 3

-- Write a query that lists the numbers of patients in the age groups 0 - 1, 2 - 10, 11 - 20, over 20 (in years).


select case when datediff(year, dob, getdate()) between 0 and 1 then '0 - 1'
            when datediff(year, dob, getdate()) between 2 and 10 then '2 - 10'
            when datediff(year, dob, getdate()) between 11 and 20 then '11 - 20'
            else 'Over 20' end AgeRange, count(patientid) 'Patient Count'
from patients
group by case when datediff(year, dob, getdate()) between 0 and 1 then '0 - 1'
            when datediff(year, dob, getdate()) between 2 and 10 then '2 - 10'
            when datediff(year, dob, getdate()) between 11 and 20 then '11 - 20'
            else 'Over 20' end 

-- Is the facility that had the most visits on the first day of operations also the facility that has had the most visits overall?

select top 1 f.name 'Facility', count(e.encounterID) 'Visits on First Day', allvisits.Visits 'Visits Overall'
from encounters e 
join facilities f on e.facilityid=f.facilityid
    join (select f.name 'Facility', count(e.encounterID) 'Visits'
    from encounters e 
    join facilities f on e.facilityid=f.facilityid
    group by f.name) allvisits on f.name=allvisits.Facility
where e.date='2015-05-01'
group by f.name, allvisits.Visits


-- Write a query to list patient id's of patients taking the medication Nicorette.  Save these patient id's to a temporary table that will be available to any query window in the current SSMS session.  Write another query that will list all patients by name and date of birth and make sure this data set excludes the patients in your Nicorette temporary table.

create table ##NicorettePatients(patientid int)
insert into ##NicorettePatients(Patientid)
select patientid
from medications
where medname = 'nicorette'


select lastname+', '+firstname 'Patient', DOB
from patients
where patientid not in (select patientid from ##NicorettePatients)


-- Create a temporary table that is available in any current SSMS session.  It should have the columns PatientID and Name).  Insert the following data into this temporary table:  99997, Elmo and  99998, Kermit the Frog and 99999, Miss Piggy.
 

-- Now write a query to delete the Miss Piggy row from your temporary table.  Wrap this in a transaction.  Run it and then roll it back.


create table ##TempTable(Patientid int, Name varchar(100))
insert into ##TempTable(Patientid, Name) values(99997, 'Elmo')
insert into ##TempTable(Patientid, Name) values(99998, 'Kermit the Frog')
insert into ##TempTable(Patientid, Name) values(99999, 'Miss Piggy')

begin tran
delete from ##TempTable where Name='Miss Piggy'
--commit tran
--rollback tran