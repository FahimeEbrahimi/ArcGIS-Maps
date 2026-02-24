/* SAS code to create STATIC HHI map data for 2008, 2019, and change (2019-2008) */
/* Uses HHI_ADMSTC_HSA (static admission HHI) instead of HHI_ADMANN_HSA (annual) */
/* Outputs DBF files for direct use in ArcGIS                                     */
/* GEOID = zero-padded 5-char FIPS to match counties2021 shapefile GEOID field    */
/*                                                                                */
/* NOTE: The underlying county-level data is derived from the American Hospital   */
/* Association (AHA) Annual Survey, which requires a license. The HHI variable    */
/* is pre-computed from hospital admission shares within each HSA. Update the     */
/* libname and dataset name below to point to your own licensed copy.             */

libname mylib "<YOUR_DATA_DIRECTORY>";

%let outdir = <YOUR_OUTPUT_DIRECTORY>;

/*======================================================================*/
/* DIAGNOSTIC: Check HHI_ADMSTC_HSA availability for 2008 and 2019     */
/*======================================================================*/
proc sql;
    select YEAR, count(*) as n_counties,
           nmiss(HHI_ADMSTC_HSA) as n_missing_hhi,
           count(HHI_ADMSTC_HSA) as n_nonmissing_hhi
    from mylib.counties
    where YEAR in (2008, 2019)
    group by YEAR;
    title "Static HHI row counts for 2008 and 2019";
quit;

/*======================================================================*/
/* 2008 Static HHI by county                                           */
/*======================================================================*/
data work.counties2008;
    set mylib.counties(keep=FIPSCODE HSACODE HSANAME HHI_ADMSTC_HSA YEAR);
    where YEAR = 2008;
    /* Convert numeric FIPSCODE to 5-char zero-padded string to match shapefile */
    length GEOID $5;
    GEOID = put(FIPSCODE, z5.);
    rename HHI_ADMSTC_HSA = HHI_STATIC;
    drop YEAR FIPSCODE;
run;

proc sql;
    select count(*) as n_2008 from work.counties2008;
    title "Total rows in 2008 static extract";
quit;

proc export data=work.counties2008
    outfile="&outdir.\HSA_HHI_Static2008.dbf"
    dbms=dbf replace;
run;

/*======================================================================*/
/* 2019 Static HHI by county                                           */
/*======================================================================*/
data work.counties2019;
    set mylib.counties(keep=FIPSCODE HSACODE HSANAME HHI_ADMSTC_HSA YEAR);
    where YEAR = 2019;
    /* Convert numeric FIPSCODE to 5-char zero-padded string to match shapefile */
    length GEOID $5;
    GEOID = put(FIPSCODE, z5.);
    rename HHI_ADMSTC_HSA = HHI_STATIC;
    drop YEAR FIPSCODE;
run;

proc sql;
    select count(*) as n_2019 from work.counties2019;
    title "Total rows in 2019 static extract";
quit;

proc export data=work.counties2019
    outfile="&outdir.\HSA_HHI_Static2019.dbf"
    dbms=dbf replace;
run;

/*======================================================================*/
/* Change map: 2019 minus 2008                                         */
/*======================================================================*/
proc sort data=work.counties2008; by GEOID; run;
proc sort data=work.counties2019; by GEOID; run;

data work.hhi_change;
    merge work.counties2008(in=in08 rename=(HHI_STATIC=HHI_2008 HSACODE=HSACODE_08 HSANAME=HSANAME_08))
          work.counties2019(in=in19 rename=(HHI_STATIC=HHI_2019));
    by GEOID;
    /* Keep only counties present in both years */
    if in08 and in19;
    /* Compute change: positive = increased concentration */
    if not missing(HHI_2019) and not missing(HHI_2008) then
        HHI_CHANGE = HHI_2019 - HHI_2008;
    /* Flag direction for symbology */
    length DIRECTION $10;
    if HHI_CHANGE > 0 then DIRECTION = "Increase";
    else if HHI_CHANGE < 0 then DIRECTION = "Decrease";
    else if HHI_CHANGE = 0 then DIRECTION = "No Change";
run;

proc sql;
    select count(*) as n_change from work.hhi_change;
    title "Total rows in static HHI change dataset";
quit;

proc export data=work.hhi_change
    outfile="&outdir.\HSA_HHI_Static_Change.dbf"
    dbms=dbf replace;
run;

/* Summary stats */
proc means data=work.hhi_change n mean std min max;
    var HHI_2008 HHI_2019 HHI_CHANGE;
    title "Summary of Static HHI: 2008, 2019, and Change";
run;

proc freq data=work.hhi_change;
    tables DIRECTION / missing;
    title "Direction of Static HHI change (2008 to 2019)";
run;
