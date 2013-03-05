# Count of no-results trials
SELECT COUNT(class)
FROM trials, sponsors, sponsorClasses
WHERE trials.sponsor_id = sponsors.id
AND sponsors.class_id = sponsorClasses.id
AND resultsDate = 0;


# Counts of no-results trials by sponsor class
SELECT class, COUNT(class)
FROM trials, sponsors, sponsorClasses
WHERE trials.sponsor_id = sponsors.id
AND sponsors.class_id = sponsorClasses.id
AND resultsDate = 0
GROUP BY class;


# Counts of no-results trials by intervention type
SELECT allTrials.type, allTrials.count, haveResults.count
FROM
(SELECT type, COUNT(type) as count
FROM trials, interventions, interventionTypes
WHERE trials.id = interventions.trial_id
AND interventionTypes.id = interventions.type_id
AND trials.resultsDate = 0
AND trials.completionDate > 0
GROUP BY type) as allTrials
LEFT JOIN
(SELECT type, COUNT(type) as count
FROM trials, interventions, interventionTypes
WHERE trials.id = interventions.trial_id
AND interventionTypes.id = interventions.type_id
AND trials.resultsDate > 0
AND trials.completionDate > 0
GROUP BY type) as haveResults
ON allTrials.type = haveResults.type
GROUP BY allTrials.type;


# List of all trials vs. those which have results by year commenced
SELECT allTrials.year, allTrials.count, haveResults.count
FROM
(SELECT strftime('%Y',trials.startDate) AS year, COUNT(trials.id) AS count FROM trials WHERE trials.completionDate > 0 GROUP BY year) AS allTrials
LEFT JOIN
(SELECT strftime('%Y', t.startDate) AS year, COUNT(t.id) as count
FROM trials AS t
WHERE t.resultsDate > 0
GROUP BY year) AS haveResults
ON allTrials.year = haveResults.year
GROUP BY allTrials.year;


