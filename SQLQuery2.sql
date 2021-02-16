
--Property Analysis BI Developer - On-boarding Task
--Name- Harkirat Singh


--1a Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT Ownerid,PropertyId, name
FROM OwnerProperty
Inner join Property 
ON Ownerproperty.PropertyId = Property.id
WHERE Ownerid = 1426

--1b Display the current home value for each property in question a). 
SELECT p.Name AS PropertyName, op.OwnerID AS OwnerId, v.Value AS PropertyValue
FROM dbo.OwnerProperty AS op
INNER JOIN dbo.Property AS p on op.PropertyId = p.id
INNER JOIN dbo.PropertyHomeValue AS v on v.PropertyId = p.Id
WHERE op.OwnerId=1426
AND v.IsActive =1

--1c For each property in question a), return the following:                                                                      
--1 Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 

SELECT  tp.PropertyID, op.OwnerID, p.Name,
( CASE 
WHEN tp.PaymentFrequencyId= 1
THEN 
DATEDIFF(Week, StartDate,EndDate) * PaymentAmount
WHEN tp.PaymentFrequencyId= 2
THEN (
DATEDIFF(Week, StartDate,EndDate) /2) * PaymentAmount
WHEN tp.PaymentFrequencyId= 3
THEN 
DATEDIFF(Month, StartDate,EndDate) * PaymentAmount
ELSE ''
END
) AS TotalRent
FROM dbo.TenantProperty AS tp 
LEFT JOIN Property AS P ON TP.PropertyId= p.ID
LEFT JOIN OwnerProperty AS op ON p.Id = op.PropertyId
WHERE op.OwnerId= 1426

--1c 2 Display the yield. 

SELECT 
	tp.PropertyId,op.OwnerId,p.Name as 'Property_Name',
(CASE
WHEN tp.PaymentFrequencyId= 1
THEN DATEDIFF(Week, StartDate, EndDate)*tp.PaymentAmount

WHEN tp.PaymentFrequencyId= 2
THEN (DATEDIFF(Week, StartDate, EndDate)/2)*tp.PaymentAmount

WHEN tp.PaymentFrequencyId= 3
THEN (DATEDIFF(Month, StartDate, EndDate)+1)*tp.PaymentAmount
ELSE ''
END ) AS Total_Rent_Received,phv.value AS 'Property_Value',

(CASE
WHEN tp.PaymentFrequencyId= 1
THEN ((DATEDIFF(Week, StartDate, EndDate)*tp.PaymentAmount)/phv.Value)*100

WHEN tp.PaymentFrequencyId= 2
THEN ((DATEDIFF(Week, StartDate, EndDate)/2)*tp.PaymentAmount/phv.Value)*100

WHEN tp.PaymentFrequencyId= 3
THEN ((DATEDIFF(Month, StartDate, EndDate)+1)*tp.PaymentAmount/phv.Value)*100
ELSE ''
END ) AS Yield

FROM 
	TenantProperty AS tp
	LEFT JOIN Property AS p
	ON tp.PropertyId= p.Id
	LEFT JOIN OwnerProperty AS op
	ON p.Id = op.PropertyId
	LEFT JOIN dbo.PropertyHomeValue AS phv ON phv.PropertyId= p.id
WHERE op.OwnerId=1426
AND phv.IsActive=1;

--1d Display all the jobs available
SELECT j.PropertyId,jm.JobId, j.JobDescription AS Curently_available_job_Description, j.PaymentAmount
FROM Job as j
LEFT JOIN JobMedia as jm
ON j.PropertyId= jm.PropertyId
WHERE JobStatusId=1;

--1e Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a). 

SELECT  tp.PaymentAmount, pr.Name AS PropertyName, concat (pn.FirstName,'',pn.MiddleName,'',pn.LastName) AS Person_Name,
( CASE 
WHEN tp.PaymentFrequencyId= 1
THEN 'WEEKLY'

WHEN tp.PaymentFrequencyId= 2
THEN 'FORTNITELY'

WHEN tp.PaymentFrequencyId= 3
THEN 'MONTHLY'
ELSE ''
END
) AS PaymentType
FROM [dbo].[TenantProperty] AS tp, [dbo].[Person] AS pn, [dbo].[Property] AS pr
WHERE tp.PropertyId=pr.Id
AND tp.TenantId=pn.Id 
AND tp.PropertyId 
IN
( SELECT distinct p.id
FROM Property p, [dbo].[OwnerProperty] o
WHERE pr.Id= o.PropertyId
AND o.OwnerId=1426
)

--2 Use Report Builder or Visual Studio (SSRS) to develop the following report:

SELECT p.Name 'PropertyName',
CONCAT( Person.FirstName, ' ' , Person.LastNAme) AS CurrentOwner,
CONCAT (A.Number,' ' , A.Suburb, ' ' , A.City, ' ' , A.PostCode) 'Property address' ,
CONCAT (p.Bedroom,' ' , 'Bedroom  ,  ' , p.Bathroom, ' ' , 'Bathroom')'Property Details',
PRP.Amount 'Rent',
RentFrequency = ( case when tpf.id=1 THEN 'Per week'
WHEN tpf.id=2 THEN 'Per Fortnight'
WHEN tpf.id=3 THEN 'Per Month'
END ),

PE.Description 'Expense' , PE.Amount 'ExpenseAmount ' , PE.Date 'ExpenseDate'
FROM Property p, Address A , PropertyRentalPayment PRP, Ownerproperty OP ,Person, PropertyExpense PE, TenantPaymentFrequencies TPF
WHERE p.Name= 'Property A'
and p.AddressId= a.AddressID
and PRP.PropertyID=p.Id
and op.PropertyID=p.Id
and op.OwnerID=person.Id
and pe.PropertyId=p.Id
and PRP.FrequencyType=tpf.Id;