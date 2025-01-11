-- WE ARE GIVEN LAYOFFS FROM VARIOUS COMPANIES WHICH HAPPENED IN 2022, COMPILED INTO A HUGE DATASET, DATA CLEANING IS REQUIRED BEFORE ANALYSING THIS DATASET
-- FOR THIS PROJECT I MAINLY FOLLOWED THESE STEPS
-- 1.DELETING THE DUPLICATE VALUES
-- 2.STANDARDIZE DATA AND FIXING ERRORS
-- 3.POPULATING THE NULL VALUES IF WE HAVE THE INFORMATION IN THE TABLE
-- 4.DELETING ROWS WHICH DOESNT REPRESENT USEFUL INFORMATION



-- CREATING BACKUP TABLE TO NOT MODIFY THE RAW/ORIGINAL DATA
CREATE TABLE parks_and_recreation.layoffs_staging
LIKE parks_and_recreation.layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- CHECKING DUPLICATES FROM LAYOFFS_STAGING TABLE
SELECT * FROM 
		(SELECT company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions,
		ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions)
        AS row_num
        FROM layoffs_staging) duplicates
WHERE row_num > 1;

-- MAKING TEMPORARY TABLE TO STORE THE UNIQUE DATA AND REPLACING THE ENTIRE LAYOFFS_STAGING TABLE WITH IT
CREATE TEMPORARY TABLE layoffs_staging2
SELECT *
FROM (SELECT *,
	ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
    FROM layoffs_staging) AS ranked
WHERE row_num = 1;

DELETE FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions
FROM layoffs_staging2;

DROP TEMPORARY TABLE layoffs_staging2;

-- POPULATING NULL VALUES WITH ALREADY GIVEN VALUES ON DIFFERENT ROW IN INDUSTRY COLUMN
SELECT *
FROM layoffs_staging
WHERE industry = ''
OR industry = NULL;

SELECT *
FROM layoffs_staging
WHERE company LIKE 'Airbnb';

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging t1
JOIN layoffs_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- FIXING IF THERE IS ANY INCONSISTENCIES IN COUNTRY COLUMN
SELECT DISTINCT country
FROM layoffs_staging
ORDER BY country;

-- FIXING THE TRAILING DOT AFTER COUNTRIES
UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country);

-- STANDARDIZING THE INDUSTRY DATA WHICH HAS DIFFERENT FORM OF SAME INDUSTRY LIKE ('CRYPTO' AND 'CRYPTOCURRENCY')
SELECT DISTINCT industry
FROM layoffs_staging;

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry IN ('CryptoCurrency','Crypto Currency');

-- STANDARDIZING THE DATA COLUMN
UPDATE layoffs_staging
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

-- REMOVING THE ROWS THAT HAS NO USEFUL INFORMATION ABOUT LAYOFFS
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

