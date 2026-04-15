-- Compute (a) daily DefectCount and DefectRate per Plant
SELECT 
    DATE(Timestamp) AS Date,
    Plant,
    SUM(DefectCount) AS DailyDefectCount,
    SUM(ProductionUnits) AS DailyProductionUnits,
    SUM(DefectCount) / SUM(ProductionUnits) AS DailyDefectRate
FROM quality_defect_reduction
GROUP BY DATE(Timestamp), Plant
ORDER BY Date, Plant;

-- (b) rolling 7-day average of DefectRate per Plant
SELECT 
    Date,
    Plant,
    DailyDefectRate,
    
    AVG(DailyDefectRate) OVER (
        PARTITION BY Plant
        ORDER BY Date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS Rolling7DayAvgDefectRate

FROM (
    SELECT 
        DATE(Timestamp) AS Date,
        Plant,
        SUM(DefectCount) / SUM(ProductionUnits) AS DailyDefectRate
    FROM quality_defect_reduction
    GROUP BY DATE(Timestamp), Plant
) daily_data
ORDER BY Plant, Date;

