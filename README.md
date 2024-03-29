# Does Wealth Lead to Health? Exploring the Association Between GDP and Life Expectancy Over Time
I explore the association between gross domestic product per capita and life expectancy over time with country-year as the unit of analysis. I use the gapminder dataset, which collects this information on countries around the world every five years. Much of the analysis is based on data visualization, where I examine the relationship between the variables of interest (economic growth, time, life expectancy, and location) in bivariate, trivariate, and hypervariate plots. In these plots, I utilize LOESS smoothers (weighted by country population) to discern relationships. Armed with the insights from this exploratory data analysis, I then build two models with life expectancy as the dependent variable: a linear model for non-African countries and a non-parametric model for countries in Africa. I finish the analysis testing the assumptions of these two models and interpreting their coefficients / fitted values. I find that economic growth is indeed related to life expectancy, and that the nature of this relationship varies between countries in Africa and countries not in Africa.

This project was completed for STAT-S 670: Exploratory Data Analysis taught by Professor Fukuyama at Indiana University Bloomington in Spring 2023.

## Analytical Report
The files Write-Up.docx and Write-Up.pdf describe the motivation, methodology, results, and implications of this project. They also contain a detailed step-by-step walkthrough of the analysis.

## Necessary Software
You will need the following software and packages installed to run the code file and reproduce the analysis.

Necessary software: `R`

Necessary `R` packages: `tidyverse`, `broom`, `gapminder`

## File Descriptions
    1. Instructions.pdf : Guidelines for this project provided by Professor Fukuyama
    2. Replication Code.R : R file that contains all data cleaning, manipulation, visualization, and statistical analyses.
    3. Write-Up.docx : Written description of the motivation, methodology, analysis, results, and implications of this project in .docx format. Includes all necessary figures. 
    4. Write-Up.pdf : Written description of the motivation, methodology, analysis, results, and implicaitons of this project in PDF format. Includes all necessary figures. 

## Installation and File Execution
To begin, dowload "Replication Code.R" into a folder. Open `R` and set this folder as your working directory using `setwd()`. Running "Replication Code.R" will produce all data importation, data wrangling, data visualizations, and statistical models. The data is imported using the `gapminder` package.

## Acknowledgements
[Gapminder](https://www.gapminder.org)

## License
See LICENSE for licensing details for this repository. 
