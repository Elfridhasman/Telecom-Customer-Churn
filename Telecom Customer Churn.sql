-- Exploratory data analysis - Telecom Customer Churn (Maven Analytics Challenge)
-- Author : Elfridus Hasman
-- Year : 2022
-- Source Data : (https://www.mavenanalytics.io/data-playground)

-----------------------------------------------------------------------------------

-- Make sure you USE the right database
USE ExploratoryData;

-- Select telecom_customer_churn
SELECT * FROM telecom_customer_churn;

-- Select telecom_customer_churn
SELECT * FROM telecom_zipcode_population;

-- Row Count
SELECT COUNT(*) FROM telecom_customer_churn;

-- Count Distinct Customer ID to remove any duplicate
SELECT COUNT(DISTINCT "Customer_ID") FROM telecom_customer_churn;

-- comparison of customer status (Stayed, Churned and New Joined Customer)
SELECT 
    Gender = ISNULL(Gender,'Total'),
    COUNT(CASE WHEN "Customer_Status" = 'Stayed' THEN Customer_ID ELSE NULL END) AS Stayed,
    COUNT(CASE WHEN "Customer_Status" = 'Churned' THEN Customer_ID ELSE NULL END)  AS Churned,
    COUNT(CASE WHEN "Customer_Status" = 'Joined' THEN Customer_ID ELSE NULL END) AS Joined
FROM telecom_customer_churn
GROUP BY ROLLUP(Gender);

-- Percentage comparison of customer status (Stayed, Churned and New Joined Customer)
SELECT 
    COUNT(CASE WHEN "Customer_Status" = 'Stayed' THEN Customer_ID ELSE NULL END) AS Stayed,
	CONCAT(COUNT(CASE WHEN "Customer_Status" = 'Stayed' THEN Customer_ID ELSE NULL END) *100 / COUNT(DISTINCT Customer_ID),'%') AS Percen_Stayed,
	COUNT(CASE WHEN "Customer_Status" = 'Churned' THEN Customer_ID ELSE NULL END) AS Churned,
    CONCAT(COUNT(CASE WHEN "Customer_Status" = 'Churned' THEN Customer_ID ELSE NULL END)*100 / COUNT (DISTINCT Customer_ID),'%') AS Percen_Churned,
    COUNT(CASE WHEN "Customer_Status" = 'Joined' THEN Customer_ID ELSE NULL END) AS Joined,
	CONCAT(COUNT(CASE WHEN "Customer_Status" = 'Joined' THEN Customer_ID ELSE NULL END) * 100 / COUNT (DISTINCT Customer_ID),'%') AS Joined
FROM telecom_customer_churn;

-- Total Poppulation Count Distinct City
WITH uniq_city AS(
	SELECT 
		DISTINCT(city),
		Population
	FROM telecom_customer_churn 
	LEFT JOIN telecom_zipcode_population 
		ON telecom_customer_churn.Zip_Code =telecom_zipcode_population.Zip_Code
)

SELECT SUM(Population) AS Total_Population FROM uniq_city;


--Sum of total revenue
SELECT ROUND(SUM(Total_Revenue),0) AS Total_Revenue FROM telecom_customer_churn;

-- Sum revenue by category
SELECT 
	ROUND(SUM(CASE WHEN Customer_Status = 'Stayed' THEN Total_Revenue ELSE NULL END),0) AS Rev_Stayed,
	ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN Total_Revenue ELSE NULL END),0) AS Lost_Rev,
	ROUND(SUM(CASE WHEN Customer_Status = 'Joined' THEN Total_Revenue ELSE NULL END),0) AS New_Rev
FROM telecom_customer_churn;

-- Top 5 city with the biggest customer churn
SELECT TOP 5
    city,
	COUNT(Customer_ID) AS Total_Customer
FROM telecom_customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY City
ORDER BY Total_Customer DESC;

-- Churn Category
SELECT 
	Churn_Category,
	COUNT(Customer_ID) AS Total_Customer
FROM telecom_customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Category;

-- Churn Reason Where Customer Customer_Status = 'Churned' AND Churn_Category = 'Competitor'
SELECT 
	Churn_Reason,
	COUNT(Customer_ID) AS Total_Customer
FROM telecom_customer_churn
WHERE Customer_Status = 'Churned' AND Churn_Category = 'Competitor'
GROUP BY Churn_Reason;
