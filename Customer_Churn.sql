show databases;
-- 1.Identify the total number of customers and the churn rate

SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate_percentage
FROM 
    customer_churn;
    
-- 2.Find the average age of churned customers
SELECT 
    AVG(Age) AS average_age_of_churned_customers
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned';
    
    -- 3. Discover the most common contract types among churned customers
    SELECT 
    `Contract`, 
    COUNT(*) AS contract_count
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    `Contract`
ORDER BY 
    contract_count DESC;

-- 4. Analyze the distribution of monthly charges among churned customers
SELECT 
    AVG(`Monthly Charge`) AS average_monthly_charges,
    MIN(`Monthly Charge`) AS min_monthly_charges,
    MAX(`Monthly Charge`) AS max_monthly_charges,
    STDDEV(`Monthly Charge`) AS stddev_monthly_charges
FROM 
    customer_churn
WHERE 
`Customer Status` = 'Churned';

-- 5. Create a query to identify the contract types that are most prone to churn

SELECT 
    `Contract`,
    COUNT(CASE WHEN `Customer Status` = 'Churned' THEN 1 END) AS churned_count,
    COUNT(*) AS total_count,
    (COUNT(CASE WHEN `Customer Status` = 'Churned' THEN 1 END) / COUNT(*)) * 100 AS churn_rate_percentage
FROM 	
    customer_churn
GROUP BY 
    `Contract`
ORDER BY 
    churn_rate_percentage DESC;
    
-- 6. Identify customers with high total charges who have churned

SELECT 
    `Customer ID`, 
    `Total Charges`, 
    `Customer Status`
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
ORDER BY 
    `Total Charges` DESC;

-- 7. Calculate the total charges distribution for churned and non-churned customers


SELECT 
    `Customer Status`,
    CASE 
        WHEN `Total Charges` <= 50 THEN '0-50'
        WHEN `Total Charges` <= 100 THEN '51-100'
        WHEN `Total Charges` <= 150 THEN '101-150'
        WHEN `Total Charges` <= 200 THEN '151-200'
        WHEN `Total Charges` <= 300 THEN '201-300'
        WHEN `Total Charges` <= 500 THEN '301-500'
        WHEN `Total Charges` <= 1000 THEN '501-1000'
        WHEN `Total Charges` <= 5000 THEN '1001-5000'
        WHEN `Total Charges` <= 8484 THEN '5001-8484'
        ELSE 'Out of Range'
    END AS charge_range,
    COUNT(*) AS count
FROM (
    SELECT 
        CASE 
            WHEN `Customer Status` = 'Churned' THEN 'Churned' 
            WHEN `Customer Status` IN ('Joined', 'Stayed') THEN 'Joined/Stayed'
            ELSE 'Other'
        END AS `Customer Status`,
        `Total Charges`
    FROM 
        customer_churn
    WHERE
        `Total Charges` BETWEEN 18 AND 8484
) AS subquery
GROUP BY 
    `Customer Status`, charge_range
ORDER BY 
    `Customer Status`, charge_range DESC;
    
    
-- 8.Calculate the average monthly charges for different contract types among churned customers


SELECT 
    `Contract`,
    AVG(`Monthly Charge`) AS average_monthly_charge
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    `Contract`
ORDER BY 
    average_monthly_charge DESC;

-- 9. Identify customers who have both online security and online backup services and have not churned

SELECT 
    `Customer ID`, 
    `Online Security`, 
    `Online Backup`
FROM 
    customer_churn
WHERE 
    `Customer Status` != 'Churned'
    AND `Online Security` = 'Yes'
    AND `Online Backup` = 'Yes';

-- 10. Determine the most common combinations of services among churned customers


SELECT 
    CONCAT(
        `Online Security`, ', ', 
        `Online Backup`, ', ', 
        `Device Protection Plan`, ', ', 
        `Premium Tech Support`, ', ', 
        `Streaming TV`, ', ',
         `Streaming Movies`, ', ', 
         `Streaming Music`, ', ', 
        `Unlimited Data`
    ) AS service_combination,
    COUNT(*) AS combination_count
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    service_combination
ORDER BY 
    combination_count DESC;

-- 11. Identify the average total charges for customers grouped by gender and marital status


SELECT 
    `Gender`,
    `Married`,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
GROUP BY 
    `Gender`, 
    `Married`
ORDER BY 
    `Gender`, 
    `Married`;
	
-- 12.  Calculate the average monthly charges for different age groups among churned customers
 

SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66 and above'
    END AS age_group,
    AVG(`Monthly Charge`) AS average_monthly_charge
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    age_group
ORDER BY 
    age_group;
    
-- 13.  Determine the average age and total charges for customers with multiple lines and online backup

SELECT 
    AVG(Age) AS average_age,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
WHERE 
    `Multiple Lines` = 'Yes'
    AND `Online Backup` = 'Yes';

-- 14.  Identify the contract types with the highest churn rate among senior citizens (age 65 and over)

SELECT 
    `Contract`,
    COUNT(*) AS total_seniors,
    SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) AS churned_seniors,
    (SUM(CASE WHEN `Customer Status` = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate_percentage
FROM 
    customer_churn
WHERE 
    Age >= 65
GROUP BY 
    `Contract`
ORDER BY 
    churn_rate_percentage DESC;

-- 15.  Calculate the average monthly charges for customers who have multiple lines and streaming TV

SELECT 
    AVG(`Monthly Charge`) AS average_monthly_charge
FROM 
    customer_churn
WHERE 
    `Multiple Lines` = 'Yes'
    AND `Streaming TV` = 'Yes';

-- 16.  Identify the customers who have churned and used the most online services


SELECT 
    `Customer ID`,
    `Online Security`,
    `Online Backup`,
    `Device Protection Plan`,
    `Premium Tech Support`,
    `Streaming TV`,
    `Streaming Movies`,
    `Streaming Music`,
    `Unlimited Data`,
    (CASE WHEN `Online Security` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Online Backup` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Device Protection Plan` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Premium Tech Support` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Streaming TV` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Streaming Movies` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Streaming Music` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Unlimited Data` = 'Yes' THEN 1 ELSE 0 END
    ) AS online_services_count
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
ORDER BY 
    online_services_count DESC;


-- 17.  Calculate the average age and total charges for customers with different combinations of streaming services


SELECT 
    CONCAT(
        CASE WHEN `Streaming TV` = 'Yes' THEN 'Streaming TV, ' ELSE '' END,
        CASE WHEN `Streaming Movies` = 'Yes' THEN 'Streaming Movies, ' ELSE '' END,
        CASE WHEN `Streaming Music` = 'Yes' THEN 'Streaming Music' ELSE '' END
    ) AS streaming_services_combination,
    AVG(Age) AS average_age,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
GROUP BY 
    streaming_services_combination
ORDER BY 
    streaming_services_combination;

-- 18.  Identify the gender distribution among customers who have churned and are on yearly contracts

SELECT 
    `Gender`,
    COUNT(*) AS number_of_customers
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
    AND `Contract` = 'One Year'
GROUP BY 
    `Gender`
ORDER BY 
    number_of_customers DESC;

-- 19.  Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type

SELECT 
    `Contract`,
    `Internet Type`,
    AVG(`Monthly Charge`) AS average_monthly_charge,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    `Contract`,
    `Internet Type`
ORDER BY 
    `Contract`, 
    `Internet Type`;
    
-- 20.  Find the customers who have churned and are not using online services, and their average total charges

SELECT 
    `Customer ID`,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
    AND `Online Security` = 'No'
    AND `Online Backup` = 'No'
    AND `Device Protection Plan` = 'No'
    AND `Premium Tech Support` = 'No'
GROUP BY 
    `Customer ID`
ORDER BY 
    `Customer ID`;

-- 21.  Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents

SELECT 
    `Number of Dependents`,
    AVG(`Monthly Charge`) AS average_monthly_charge,
    AVG(`Total Charges`) AS average_total_charges
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    `Number of Dependents`
ORDER BY 
    `Number of Dependents`;
    
    
-- 22.  Identify the customers who have churned, and their contract duration in months (for monthly contracts)
    
    SELECT 
    `Customer ID`,
    `Tenure in Months`
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
    AND `Contract` = 'Month-to-Month';

    -- 23.  Determine the average age and total charges for customers who have churned, grouped by internet service and phone service

SELECT 
    `Internet Service`,
    `Phone Service`,
    AVG(Age) AS average_age,
    SUM(`Total Charges`) AS total_charges
FROM 
    customer_churn
WHERE 
    `Customer Status` = 'Churned'
GROUP BY 
    `Internet Service`,
    `Phone Service`
ORDER BY 
    `Internet Service`,
    `Phone Service`;
    
--  27.  Stored Procedure to Calculate Churn Rate   
DELIMITER //

-- Drop the existing procedure if it exists
DROP PROCEDURE IF EXISTS CalculateChurnRate;

-- Create the new stored procedure
CREATE PROCEDURE CalculateChurnRate()
BEGIN
    DECLARE total_customers INT;
    DECLARE churned_customers INT;
    DECLARE churn_rate DECIMAL(5,2);

    -- Calculate total number of customers
    SELECT COUNT(*) INTO total_customers
    FROM customer_churn;

    -- Calculate number of churned customers
    SELECT COUNT(*) INTO churned_customers
    FROM customer_churn
    WHERE `Customer Status` = 'Churned';

    -- Calculate churn rate
    SET churn_rate = (churned_customers / total_customers) * 100;

    -- Return the result
    SELECT 
        total_customers AS Total_Customers,
        churned_customers AS Churned_Customers,
        churn_rate AS Churn_Rate_Percentage;
END //

-- Reset the delimiter
DELIMITER ;

CALL CalculateChurnRate();


-- 28.  Stored Procedure to Identify High-Value Customers at Risk of Churning.

-- Drop the existing procedure if it exists
DROP PROCEDURE IF EXISTS IdentifyHighValueCustomersAtRisk;

-- Create the new stored procedure
DELIMITER //

CREATE PROCEDURE IdentifyHighValueCustomersAtRisk()
BEGIN
    SELECT 
        `Customer ID`,
        `Total Charges`,
        `Monthly Charge`,
        `Contract`,
        `Customer Status`
    FROM 
        customer_churn
    WHERE 
        `Total Charges` > 1000 AND
        (`Customer Status` = 'Churned' OR `Contract` = 'Month-to-Month')
    ORDER BY 
        `Total Charges` DESC;
END //
CALL IdentifyHighValueCustomersAtRisk();

