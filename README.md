# COVID-19 Data Analysis and Visualization

This project explores the global and continental impact of the COVID-19 pandemic using a comprehensive dataset on deaths, cases, and vaccinations. By leveraging **advanced SQL queries**, I transformed raw data into a structured format, demonstrating the ability to extract meaningful insights from a large dataset. The prepared data was then used to create **interactive dashboards in pOWER bI**, allowing for dynamic and insightful visualizations that tell a clear story.


---

## Overview

The goal of this project was to provide a comprehensive, data-driven narrative of the pandemic's progression, culminating in a powerful visual story. It addresses key questions, such as:

* What is the **total death count** by country and continent?
* What is the **global death percentage**?
* How has the **percentage of the population infected** with COVID-19 evolved over time?
* What is the **rolling percentage of the population vaccinated**?

By answering these questions and visualizing the findings, this project offers a holistic view of the pandemic's impact on a global scale.

---

## Key Insights

* **Global & Continental Trends:** The analysis reveals the overall global death percentage and identifies the continents with the highest death counts, providing a macro-level view of the pandemic's severity.
* **Infection and Death Rates:** Metrics were calculated to show the **total cases relative to population**, and the data was organized to identify the **countries with the highest infection rates** at any given point in time.
* **Vaccination Progress:** A rolling calculation of vaccinated individuals showcases the progression of global vaccination efforts over time.
* **Data-Driven Storytelling:** The final Tableau dashboards effectively present complex data points in a clear and intuitive manner, translating data findings into a compelling visual narrative for a broad audience.

---

## Technical Approach

This project combines advanced SQL for data analysis and Tableau for data visualization.

* **Advanced SQL:**
    * **Data Transformation:** Employed `CAST` and `CONVERT` to handle data type conversions, ensuring accurate calculations for percentages and death counts.
    * **Aggregations & Grouping:** Utilized `SUM` and `MAX` with `GROUP BY` to derive key metrics such as total cases, total deaths, and death counts by continent.
    * **Window Functions & CTEs:** Used the `SUM() OVER (PARTITION BY...)` window function to calculate the `RollingPeopleVaccinated` count. A Common Table Expression (CTE) was used to perform further calculations on this partitioned data, demonstrating proficiency in advanced analytical techniques.
* **Data Visualization:**
    * The SQL queries were specifically designed to serve as the foundational data for building **interactive Power BI dashboards**.
    * The visualizations include charts and maps that allow users to explore key metrics like **total cases**, **deaths**, and **vaccination percentages** with ease.
