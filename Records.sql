

-- Day with largest diurnal range for Stiebel Eltron ISG outdoor temperature sensor

SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(mean), 2) AS max_temp,
    round(MIN(mean), 2) AS min_temp,
    round(MAX(mean) - MIN(mean), 2) AS temperature_range
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.stiebel_eltron_isg_outdoor_temperature'
AND start_ts >= strftime('%s', 'now', '-30 days')
GROUP BY 
    observation_date
ORDER BY 
    temperature_range DESC
LIMIT 1;





-- Day with lowest temperature for Stiebel Eltron ISG outdoor temperature sensor


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(mean), 2) AS max_temp,
    round(MIN(mean), 2) AS min_temp
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.stiebel_eltron_isg_outdoor_temperature'
AND start_ts >= strftime('%s', 'now', '-30 days')
GROUP BY 
    observation_date
ORDER BY 
    min_temp ASC
LIMIT 1;

-- Day with highest temperature for Stiebel Eltron ISG outdoor temperature sensor


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(mean), 2) AS max_temp,
    round(MIN(mean), 2) AS min_temp
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.stiebel_eltron_isg_outdoor_temperature'
AND start_ts >= strftime('%s', 'now', '-30 days')
GROUP BY 
    observation_date
ORDER BY 
    max_temp DESC
LIMIT 1;

-- Day with highest electricity consumption


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state), 2) AS max_energy,
    round(MIN(state), 2) AS min_energy
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.octopus_energy_electricity_19m1039794_1030000402501_previous_accumulative_consumption'
AND start_ts >= strftime('%s', 'now', '-321 days')
GROUP BY 
    observation_date
ORDER BY 
    max_energy DESC
LIMIT 1;

-- Month with highest electricity import cost

WITH daily_maxes AS (
    SELECT 
        date(start_ts, 'unixepoch', 'localtime') AS d,
        MAX(state) AS v
    FROM statistics
    INNER JOIN statistics_meta ON statistics.metadata_id = statistics_meta.id
    WHERE statistics_meta.statistic_id = 'sensor.octopus_energy_electricity_19m1039794_1030000402501_previous_accumulative_consumption'
    AND start_ts >= strftime('%s', 'now', '-365 days')
    GROUP BY d
),
monthly_totals AS (
    SELECT 
        strftime('%Y-%m', d) AS month_label,
        ROUND(SUM(v), 2) AS total
    FROM daily_maxes
    GROUP BY month_label
)
SELECT 
    (SELECT total FROM monthly_totals ORDER BY total DESC LIMIT 1) AS max_energy,
    (SELECT month_label FROM monthly_totals ORDER BY total DESC LIMIT 1) AS observation_date,
    GROUP_CONCAT(month_label || ':' || total) AS monthly_history
FROM monthly_totals;



-- Day with highest electricity export

SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state), 2) AS max_energy,
    round(MIN(state), 2) AS min_energy
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.octopus_energy_electricity_19m1039794_1050003203800_export_previous_accumulative_consumption'
AND start_ts >= strftime('%s', 'now', '-321 days')
GROUP BY 
    observation_date
ORDER BY 
    max_energy DESC
LIMIT 1;


-- Month with highest electricity export cost

WITH daily_maxes AS (
    SELECT 
        date(start_ts, 'unixepoch', 'localtime') AS d,
        MAX(state) AS v
    FROM statistics
    INNER JOIN statistics_meta ON statistics.metadata_id = statistics_meta.id
    WHERE statistics_meta.statistic_id = 'sensor.octopus_energy_electricity_19m1039794_1050003203800_export_previous_accumulative_cost'
    AND start_ts >= strftime('%s', 'now', '-365 days')
    GROUP BY d
),
monthly_totals AS (
    SELECT 
        strftime('%Y-%m', d) AS month_label,
        ROUND(SUM(v), 2) AS total
    FROM daily_maxes
    GROUP BY month_label
)
SELECT 
    (SELECT total FROM monthly_totals ORDER BY total DESC LIMIT 1) AS max_cost,
    (SELECT month_label FROM monthly_totals ORDER BY total DESC LIMIT 1) AS observation_date,
    GROUP_CONCAT(month_label || ':' || total) AS monthly_history
FROM monthly_totals;



-- Day with highest electricity consumed for heating

SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state), 2) AS total_daily_consumption
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.stiebel_eltron_isg_consumed_heating_today'
    AND state IS NOT NULL
GROUP BY 
    observation_date
ORDER BY 
    total_daily_consumption DESC
LIMIT 1;

-- Day with highest produced heating

SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state), 2) AS total_daily_consumption
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.stiebel_eltron_isg_produced_heating_today'
    AND state IS NOT NULL
GROUP BY 
    observation_date
ORDER BY 
    total_daily_consumption DESC
LIMIT 1;





-- Day with highest grid import


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state) - MIN(state), 2) AS max_energy
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.wilkinsonsolar_site_import'
AND start_ts >= strftime('%s', 'now', '-321 days')
GROUP BY 
    observation_date
ORDER BY 
    max_energy DESC
LIMIT 1;


-- Day with highest electricity use


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state) - MIN(state), 2) AS max_energy
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.wilkinsonsolar_load_import'
AND start_ts >= strftime('%s', 'now', '-321 days')
GROUP BY 
    observation_date
ORDER BY 
    max_energy DESC
LIMIT 1;

-- Day with highest solar production


SELECT 
    date(start_ts, 'unixepoch', 'localtime') AS observation_date,
    round(MAX(state) - MIN(state), 2) AS max_energy
FROM 
    statistics
INNER JOIN 
    statistics_meta ON statistics.metadata_id = statistics_meta.id
WHERE 
    statistics_meta.statistic_id = 'sensor.wilkinsonsolar_solar_export'
AND start_ts >= strftime('%s', 'now', '-321 days')
GROUP BY 
    observation_date
ORDER BY 
    max_energy DESC
LIMIT 1;

