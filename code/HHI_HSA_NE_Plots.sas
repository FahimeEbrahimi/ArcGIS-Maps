/*SAS code to make excel files for each year to make HSA HHI maps*/
libname mylib "C:\Users\ebrah\OneDrive - USNH\UNH\Thesis\Brad Data Shared\Data\Counties";

data work.counties2023;
    set mylib.counties20250819(keep=STATEABBRV YEAR CYTTLPOPX HSACODE HSANAME HHI_ADMANN_HSA);
run;

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

/* Combine all 7 series */
data final_hhi_plot;
    set NE_states NE_total US_total;
run;

/* Plot the 7 curves */
proc sgplot data=final_hhi_plot;
    series x=YEAR y=weighted_HHI / group=STATEABBRV lineattrs=(thickness=2);
    xaxis label="Year";
    yaxis label="Population-Weighted HHI (HSA)";
    title "Population-Weighted HHI Over Time (USA, New England, and States)";
run;
/***********************************************************************/


/****************************************************************************************************/
