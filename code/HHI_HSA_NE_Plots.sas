/* SAS code to compute population-weighted HHI by state/region and plot trends */
/* Generates time-series of hospital market concentration for New England      */
/* states, New England aggregate, and the US as a whole.                       */
/*                                                                             */
/* NOTE: The underlying county-level data is derived from the American Hospital*/
/* Association (AHA) Annual Survey, which requires a license. Update the       */
/* libname and dataset name below to point to your own licensed copy.          */

libname mylib "<YOUR_DATA_DIRECTORY>";

/* Required variables in the counties dataset:                       */
/*   STATEABBRV  — two-letter state abbreviation                     */
/*   YEAR        — survey year                                       */
/*   CYTTLPOPX   — county total population (for weighting)           */
/*   HHI_ADMANN_HSA — annual admissions-based HHI at the HSA level   */

/***************************************************/
/* Define New England States */
%let NE_states = "CT" "VT" "NH" "MA" "ME" "RI";

/* Compute weighted HHI for each of the 6 New England states */
proc sql;
    create table NE_states as
    select 
        STATEABBRV,
        YEAR,
        sum(CYTTLPOPX * HHI_ADMANN_HSA) / sum(CYTTLPOPX) as weighted_HHI
    from mylib.counties
    where STATEABBRV in (&NE_states)
    group by STATEABBRV, YEAR;
quit;

/* Compute weighted HHI for New England as a whole */
proc sql;
    create table NE_total as
    select 
        "New England" as STATEABBRV length=20,
        YEAR,
        sum(CYTTLPOPX * HHI_ADMANN_HSA) / sum(CYTTLPOPX) as weighted_HHI
    from mylib.counties
    where STATEABBRV in (&NE_states)
    group by YEAR;
quit;

/* Compute weighted HHI for USA */
proc sql;
    create table US_total as
    select 
        "USA" as STATEABBRV length=20,
        YEAR,
        sum(CYTTLPOPX * HHI_ADMANN_HSA) / sum(CYTTLPOPX) as weighted_HHI
    from mylib.counties
    group by YEAR;
quit;

/* Combine all series */
data final_hhi_plot;
    set NE_states NE_total US_total;
run;

/* Plot the curves */
proc sgplot data=final_hhi_plot;
    series x=YEAR y=weighted_HHI / group=STATEABBRV lineattrs=(thickness=2);
    xaxis label="Year";
    yaxis label="Population-Weighted HHI (HSA)";
    title "Population-Weighted HHI Over Time (USA, New England, and States)";
run;
