SELECT Ownerid,PropertyId, name
FROM OwnerProperty
Inner join Property 
ON Ownerproperty.PropertyId = Property.id
WHERE Ownerid = 1426

SELECT p.Name AS PropertyName, op.OwnerID AS OwnerId, v.Value AS PropertyValue
FROM dbo.OwnerProperty AS op
INNER JOIN dbo.Property AS p on op.PropertyId = p.id
INNER JOIN dbo.PropertyHomeValue AS v on v.PropertyId = p.Id
WHERE op.OwnerId=1426
AND v.IsActive =1


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


SELECT j.PropertyId,jm.JobId, j.JobDescription AS Curently_available_job_Description, j.PaymentAmount
FROM Job as j
LEFT JOIN JobMedia as jm
ON j.PropertyId= jm.PropertyId
WHERE JobStatusId=1;


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

