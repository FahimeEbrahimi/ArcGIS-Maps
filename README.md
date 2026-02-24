# Hospital Market Concentration Maps

Choropleth maps and time-series plots visualizing hospital market concentration (Herfindahl-Hirschman Index) across the United States, built with ArcGIS Pro and SAS.

## Overview

These maps support research on hospital consolidation and its effects on healthcare markets. The HHI is computed from hospital admission shares within Health Service Areas (HSAs) defined by the Dartmouth Atlas. Higher HHI indicates greater market concentration (less competition).

## Maps

### US Hospital Market Concentration (2023)
- [`maps/US_HHI_2023.pdf`](maps/US_HHI_2023.pdf) — County-level choropleth of static admissions-based HHI across the continental US

### New England Regional Maps
- [`maps/NewEngland_County_HHI.pdf`](maps/NewEngland_County_HHI.pdf) — County-level HHI for the six New England states
- [`maps/NewEngland_HSA_HHI.pdf`](maps/NewEngland_HSA_HHI.pdf) — HSA-level HHI for New England

### Time-Series Plots (SAS SGPLOT)
- [`plots/NE_States_HHI_OverTime.png`](plots/NE_States_HHI_OverTime.png) — Population-weighted HHI trends for each New England state vs. the US average (1995–2023)
- [`plots/NH_HSA_HHI_OverTime.png`](plots/NH_HSA_HHI_OverTime.png) — HHI trends by HSA within New Hampshire

## Code

| File | Description |
|------|-------------|
| [`code/HHI_ADMSTC_HSA_2008_2019.sas`](code/HHI_ADMSTC_HSA_2008_2019.sas) | Generates county-level static HHI data (2008, 2019, change) as DBF files for ArcGIS |
| [`code/HHI_HSA_NE_Plots.sas`](code/HHI_HSA_NE_Plots.sas) | Computes population-weighted HHI by state/region and generates time-series plots |

## Data Sources

- **Hospital data:** American Hospital Association (AHA) Annual Survey
- **Market definitions:** Dartmouth Atlas Health Service Areas (HSAs)
- **Boundaries:** US Census Bureau TIGER/Line county shapefiles

> **Note:** The underlying hospital data requires a license from the AHA. The SAS code is provided to demonstrate methodology; update the `libname` paths to point to your own licensed data. Raw data is not included in this repository.

## Tools

- ArcGIS Pro (choropleth maps)
- SAS 9.4 (data processing and time-series plots)
