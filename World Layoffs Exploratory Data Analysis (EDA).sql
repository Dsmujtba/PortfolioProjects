-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2; 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 

-- Identify the comapnies that went totally under
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- calaculate the total layoffs per company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

-- When did this start?
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- What industry had the most layoffs?
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 

-- What countries experienced the highest layoffs?

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

-- Which year witnessed the highest layoffs?

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- At which stage comapanies were laying off the most?

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Let's have a look at the progressive layoffs

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off, 
SUM(total_off) OVER (ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Who liad off the most people per year? We will utilize CTEs 

WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) As ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranking ASC
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

-- What inudstry had the most laid offs per year

SELECT industry, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY industry, `Year`;


WITH Industry_Year (industry, years, total_laid_off) AS 
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, YEAR(`date`)
), Industry_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) As ranking
FROM Industry_Year
WHERE years IS NOT NULL
ORDER BY ranking ASC
)
SELECT *
FROM Industry_Year_Rank
WHERE ranking <= 10;

