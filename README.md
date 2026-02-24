# Hospital Market Concentration Maps

Choropleth maps and time-series plots visualizing hospital market concentration (Herfindahl-Hirschman Index) across the United States, built with ArcGIS Pro and SAS.

## Overview

These maps support research on hospital consolidation and its effects on healthcare markets. The HHI is computed from hospital admission shares within Health Service Areas (HSAs) defined by the Dartmouth Atlas. Higher HHI indicates greater market concentration (less competition).

## Maps

### Static Admissions HHI (HSA Level)
Maps based on static (base-year) admission shares — the primary concentration measure.

| Map | Description |
|-----|-------------|
| [`US_Static_HHI_2008.pdf`](maps/static-hhi/US_Static_HHI_2008.pdf) | US county-level static HHI, 2008 |
| [`US_Static_HHI_2019.pdf`](maps/static-hhi/US_Static_HHI_2019.pdf) | US county-level static HHI, 2019 |
| [`US_Static_HHI_Change_2008_2019.pdf`](maps/static-hhi/US_Static_HHI_Change_2008_2019.pdf) | Change in static HHI (2008–2019); red = increase, green = decrease |

### Annual Admissions HHI (HSA Level)
Maps based on annual (contemporaneous) admission shares — a sensitivity measure.

| Map | Description |
|-----|-------------|
| [`US_Annual_HHI_2008.pdf`](maps/annual-hhi/US_Annual_HHI_2008.pdf) | US county-level annual HHI, 2008 |
| [`US_Annual_HHI_2019.pdf`](maps/annual-hhi/US_Annual_HHI_2019.pdf) | US county-level annual HHI, 2019 |
| [`US_Annual_HHI_Change_2008_2019.pdf`](maps/annual-hhi/US_Annual_HHI_Change_2008_2019.pdf) | Change in annual HHI (2008–2019) |

### New England Regional Maps
| Map | Description |
|-----|-------------|
| [`NE_HHI_2023.pdf`](maps/new-england/NE_HHI_2023.pdf) | New England county-level HHI |
| [`NE_4States_Buffer.pdf`](maps/new-england/NE_4States_Buffer.pdf) | Four-state buffer region with state borders |

### New Hampshire Detail Maps
| Map | Description |
|-----|-------------|
| [`NH_Neighboring_HSA_Counties.pdf`](maps/new-hampshire/NH_Neighboring_HSA_Counties.pdf) | NH and neighboring HSA counties |
| [`NH_HSAs_Buffer.pdf`](maps/new-hampshire/NH_HSAs_Buffer.pdf) | NH HSAs with buffer region |

### Legends
| Legend | Used for |
|--------|----------|
| [`legend_hhi_levels.jpg`](maps/legends/legend_hhi_levels.jpg) | HHI level maps (blue scale, 0–10) |
| [`legend_hhi_changes.jpg`](maps/legends/legend_hhi_changes.jpg) | HHI change maps (green = decrease, red = increase) |

### Time-Series Plots (SAS)
| Plot | Description |
|------|-------------|
| [`NE_States_HHI_OverTime.png`](plots/NE_States_HHI_OverTime.png) | Population-weighted HHI trends by New England state vs. US (1995–2023) |
| [`NH_HSA_HHI_OverTime.png`](plots/NH_HSA_HHI_OverTime.png) | HHI trends by HSA within New Hampshire |

## Code

| File | Description |
|------|-------------|
| [`HHI_ADMSTC_HSA_2008_2019.sas`](code/HHI_ADMSTC_HSA_2008_2019.sas) | Generates county-level static HHI data (2008, 2019, change) as DBF files for ArcGIS |
| [`HHI_HSA_NE_Plots.sas`](code/HHI_HSA_NE_Plots.sas) | Computes population-weighted HHI by state/region and generates time-series plots |

## Data Sources

- **Hospital data:** American Hospital Association (AHA) Annual Survey
- **Market definitions:** Dartmouth Atlas Health Service Areas (HSAs)
- **Boundaries:** US Census Bureau TIGER/Line county shapefiles

> **Note:** The underlying hospital data requires a license from the AHA. The SAS code is provided to demonstrate methodology; update the `libname` paths to point to your own licensed data. Raw data is not included in this repository.

## Tools

- ArcGIS Pro (choropleth maps)
- SAS 9.4 (data processing and time-series plots)
