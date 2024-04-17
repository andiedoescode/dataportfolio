----QUESTION 1
-- Using the database schema shown here, write a query that selects data
-- for all Facilities that have encounters between 2/1/2024 and 2/5/2024.
-- Include the Facility Name, Date of Visit and Encounter ID. Sort the data
-- by date from earliest to latest

SELECT f.name 'Facility Name', CAST(e.date as date) 'Date of Visit', e.id 'Encounter ID'
FROM enc e
JOIN edi_facilities f ON e.facilityid = f.id
WHERE e.date BETWEEN '2024-02-01' AND '2024-02-05'
ORDER BY e.date


----QUESTION 2
-- Update the query to give the number of Encounters by Facility Name for
-- that same date range

SELECT f.name 'Facility Name', COUNT(e.encounterid)
FROM enc e
JOIN edi_facilities f ON e.facilityid = f.id
WHERE e.date BETWEEN '2024-02-01' AND '2024-02-05'
GROUP BY (f.name)


----QUESTION 3
-- Update the query to give the number of Encounters by Facility Name for
-- each day in that same date range.

SELECT f.name 'Facility Name', COUNT(e.encounterID) AS 'Number of Visits', CAST(e.date as date) 'Visit Date'
FROM enc e
JOIN edi_facilities f ON e.facilityid = f.id
WHERE e.date BETWEEN '2024-02-01' AND '2024-02-05'
GROUP BY f.name, CAST(e.date as date)


----QUESTION 4
-- Update the query to give a count of Encounters by Facility Name for all
-- of 2024 to date. Make sure you code the date so the query will run
-- again tomorrow without needing to be edited. Put them in order by the
-- highest encounter count to lowest.

SELECT f.name 'Facility Name', COUNT(e.encounterid) AS 'Number of Visits'
FROM enc e
JOIN edi_facilities f ON e.facilityid = f.id
WHERE e.date BETWEEN '2024-01-01' AND getDate()
GROUP BY f.name
ORDER BY COUNT(e.encounterid) desc


-- BONUS
----QUESTION 5
-- Organizing by month.

SELECT f.name 'Facility Name', MONTH(e.date) 'Month of Visit', COUNT(e.encounterid) 'Encounters'
FROM enc e
JOIN edi_facilities f ON e.facilityid = f.id
WHERE e.date BETWEEN '2024-01-01' AND getDate()
GROUP BY DATENAME('mm', e.date)
ORDER BY MONTH(e.date)


