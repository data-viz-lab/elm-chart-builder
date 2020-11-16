module Data exposing
    ( CoronaData
    , FertilityStats
    , SmokeStats
    , coronaStats
    , fertilityStats
    , smokeStats
    )


type alias SmokeStats =
    { year : Float, percentage : Float, regionPerGender : String }


smokeStats : List SmokeStats
smokeStats =
    [ { regionPerGender = "North East Male", year = 1998, percentage = 30.9 }
    , { regionPerGender = "North West Male", year = 1998, percentage = 29.6 }
    , { regionPerGender = "Yorkshire Male", year = 1998, percentage = 28.7 }
    , { regionPerGender = "East Midlands Male", year = 1998, percentage = 30.9 }
    , { regionPerGender = "West Midlands Male", year = 1998, percentage = 26.4 }
    , { regionPerGender = "East Of England Male", year = 1998, percentage = 29.3 }
    , { regionPerGender = "London Male", year = 1998, percentage = 29.8 }
    , { regionPerGender = "South East Male", year = 1998, percentage = 28.6 }
    , { regionPerGender = "South West Male", year = 1998, percentage = 25.7 }
    , { regionPerGender = "North East Female", year = 1998, percentage = 32.9 }
    , { regionPerGender = "North West Female", year = 1998, percentage = 28.6 }
    , { regionPerGender = "Yorkshire Female", year = 1998, percentage = 30.8 }
    , { regionPerGender = "East Midlands Female", year = 1998, percentage = 27.7 }
    , { regionPerGender = "West Midlands Female", year = 1998, percentage = 27.2 }
    , { regionPerGender = "East Of England Female", year = 1998, percentage = 23.6 }
    , { regionPerGender = "London Female", year = 1998, percentage = 25.4 }
    , { regionPerGender = "South East Female", year = 1998, percentage = 25.1 }
    , { regionPerGender = "South West Female", year = 1998, percentage = 25.7 }
    , { regionPerGender = "North East Male", year = 1999, percentage = 23.5 }
    , { regionPerGender = "North West Male", year = 1999, percentage = 30.2 }
    , { regionPerGender = "Yorkshire Male", year = 1999, percentage = 29.7 }
    , { regionPerGender = "East Midlands Male", year = 1999, percentage = 26.2 }
    , { regionPerGender = "West Midlands Male", year = 1999, percentage = 28.5 }
    , { regionPerGender = "East Of England Male", year = 1999, percentage = 23.9 }
    , { regionPerGender = "London Male", year = 1999, percentage = 31.8 }
    , { regionPerGender = "South East Male", year = 1999, percentage = 25.8 }
    , { regionPerGender = "South West Male", year = 1999, percentage = 26.4 }
    , { regionPerGender = "North East Female", year = 1999, percentage = 29.5 }
    , { regionPerGender = "North West Female", year = 1999, percentage = 31.2 }
    , { regionPerGender = "Yorkshire Female", year = 1999, percentage = 28.1 }
    , { regionPerGender = "East Midlands Female", year = 1999, percentage = 22.0 }
    , { regionPerGender = "West Midlands Female", year = 1999, percentage = 26.7 }
    , { regionPerGender = "East Of England Female", year = 1999, percentage = 24.9 }
    , { regionPerGender = "London Female", year = 1999, percentage = 25.3 }
    , { regionPerGender = "South East Female", year = 1999, percentage = 26.0 }
    , { regionPerGender = "South West Female", year = 1999, percentage = 23.1 }
    , { regionPerGender = "North East Male", year = 2000, percentage = 26.1 }
    , { regionPerGender = "North West Male", year = 2000, percentage = 29.5 }
    , { regionPerGender = "Yorkshire Male", year = 2000, percentage = 32.2 }
    , { regionPerGender = "East Midlands Male", year = 2000, percentage = 25.7 }
    , { regionPerGender = "West Midlands Male", year = 2000, percentage = 25.4 }
    , { regionPerGender = "East Of England Male", year = 2000, percentage = 27.8 }
    , { regionPerGender = "London Male", year = 2000, percentage = 28.9 }
    , { regionPerGender = "South East Male", year = 2000, percentage = 27.9 }
    , { regionPerGender = "South West Male", year = 2000, percentage = 30.1 }
    , { regionPerGender = "North East Female", year = 2000, percentage = 33.5 }
    , { regionPerGender = "North West Female", year = 2000, percentage = 27.4 }
    , { regionPerGender = "Yorkshire Female", year = 2000, percentage = 26.6 }
    , { regionPerGender = "East Midlands Female", year = 2000, percentage = 26.9 }
    , { regionPerGender = "West Midlands Female", year = 2000, percentage = 22.9 }
    , { regionPerGender = "East Of England Female", year = 2000, percentage = 26.0 }
    , { regionPerGender = "London Female", year = 2000, percentage = 21.5 }
    , { regionPerGender = "South East Female", year = 2000, percentage = 23.3 }
    , { regionPerGender = "South West Female", year = 2000, percentage = 24.2 }
    , { regionPerGender = "North East Male", year = 2001, percentage = 27.7 }
    , { regionPerGender = "North West Male", year = 2001, percentage = 25.1 }
    , { regionPerGender = "Yorkshire Male", year = 2001, percentage = 30.2 }
    , { regionPerGender = "East Midlands Male", year = 2001, percentage = 29.2 }
    , { regionPerGender = "West Midlands Male", year = 2001, percentage = 26.3 }
    , { regionPerGender = "East Of England Male", year = 2001, percentage = 26.5 }
    , { regionPerGender = "London Male", year = 2001, percentage = 28.9 }
    , { regionPerGender = "South East Male", year = 2001, percentage = 24.3 }
    , { regionPerGender = "South West Male", year = 2001, percentage = 26.3 }
    , { regionPerGender = "North East Female", year = 2001, percentage = 31.2 }
    , { regionPerGender = "North West Female", year = 2001, percentage = 27.4 }
    , { regionPerGender = "Yorkshire Female", year = 2001, percentage = 26.2 }
    , { regionPerGender = "East Midlands Female", year = 2001, percentage = 25.8 }
    , { regionPerGender = "West Midlands Female", year = 2001, percentage = 22.5 }
    , { regionPerGender = "East Of England Female", year = 2001, percentage = 25.5 }
    , { regionPerGender = "London Female", year = 2001, percentage = 24.5 }
    , { regionPerGender = "South East Female", year = 2001, percentage = 22.1 }
    , { regionPerGender = "South West Female", year = 2001, percentage = 25.4 }
    , { regionPerGender = "North East Male", year = 2002, percentage = 33.0 }
    , { regionPerGender = "North West Male", year = 2002, percentage = 27.8 }
    , { regionPerGender = "Yorkshire Male", year = 2002, percentage = 28.6 }
    , { regionPerGender = "East Midlands Male", year = 2002, percentage = 28.7 }
    , { regionPerGender = "West Midlands Male", year = 2002, percentage = 30.0 }
    , { regionPerGender = "East Of England Male", year = 2002, percentage = 25.6 }
    , { regionPerGender = "London Male", year = 2002, percentage = 28.0 }
    , { regionPerGender = "South East Male", year = 2002, percentage = 25.0 }
    , { regionPerGender = "South West Male", year = 2002, percentage = 26.4 }
    , { regionPerGender = "North East Female", year = 2002, percentage = 32.5 }
    , { regionPerGender = "North West Female", year = 2002, percentage = 28.9 }
    , { regionPerGender = "Yorkshire Female", year = 2002, percentage = 25.7 }
    , { regionPerGender = "East Midlands Female", year = 2002, percentage = 25.7 }
    , { regionPerGender = "West Midlands Female", year = 2002, percentage = 26.6 }
    , { regionPerGender = "East Of England Female", year = 2002, percentage = 21.9 }
    , { regionPerGender = "London Female", year = 2002, percentage = 23.3 }
    , { regionPerGender = "South East Female", year = 2002, percentage = 26.1 }
    , { regionPerGender = "South West Female", year = 2002, percentage = 28.2 }
    , { regionPerGender = "North East Male", year = 2003, percentage = 27.2 }
    , { regionPerGender = "North West Male", year = 2003, percentage = 27.2 }
    , { regionPerGender = "Yorkshire Male", year = 2003, percentage = 28.2 }
    , { regionPerGender = "East Midlands Male", year = 2003, percentage = 24.2 }
    , { regionPerGender = "West Midlands Male", year = 2003, percentage = 25.7 }
    , { regionPerGender = "East Of England Male", year = 2003, percentage = 26.4 }
    , { regionPerGender = "London Male", year = 2003, percentage = 27.0 }
    , { regionPerGender = "South East Male", year = 2003, percentage = 26.4 }
    , { regionPerGender = "South West Male", year = 2003, percentage = 27.4 }
    , { regionPerGender = "North East Female", year = 2003, percentage = 29.7 }
    , { regionPerGender = "North West Female", year = 2003, percentage = 26.5 }
    , { regionPerGender = "Yorkshire Female", year = 2003, percentage = 24.9 }
    , { regionPerGender = "East Midlands Female", year = 2003, percentage = 23.3 }
    , { regionPerGender = "West Midlands Female", year = 2003, percentage = 25.1 }
    , { regionPerGender = "East Of England Female", year = 2003, percentage = 25.2 }
    , { regionPerGender = "London Female", year = 2003, percentage = 21.3 }
    , { regionPerGender = "South East Female", year = 2003, percentage = 24.3 }
    , { regionPerGender = "South West Female", year = 2003, percentage = 24.5 }
    , { regionPerGender = "North East Male", year = 2004, percentage = 24.2 }
    , { regionPerGender = "North West Male", year = 2004, percentage = 24.2 }
    , { regionPerGender = "Yorkshire Male", year = 2004, percentage = 24.0 }
    , { regionPerGender = "East Midlands Male", year = 2004, percentage = 26.1 }
    , { regionPerGender = "West Midlands Male", year = 2004, percentage = 23.7 }
    , { regionPerGender = "East Of England Male", year = 2004, percentage = 24.6 }
    , { regionPerGender = "London Male", year = 2004, percentage = 24.1 }
    , { regionPerGender = "South East Male", year = 2004, percentage = 23.1 }
    , { regionPerGender = "South West Male", year = 2004, percentage = 23.2 }
    , { regionPerGender = "North East Female", year = 2004, percentage = 29.7 }
    , { regionPerGender = "North West Female", year = 2004, percentage = 26.2 }
    , { regionPerGender = "Yorkshire Female", year = 2004, percentage = 27.7 }
    , { regionPerGender = "East Midlands Female", year = 2004, percentage = 27.0 }
    , { regionPerGender = "West Midlands Female", year = 2004, percentage = 26.3 }
    , { regionPerGender = "East Of England Female", year = 2004, percentage = 22.5 }
    , { regionPerGender = "London Female", year = 2004, percentage = 17.9 }
    , { regionPerGender = "South East Female", year = 2004, percentage = 19.7 }
    , { regionPerGender = "South West Female", year = 2004, percentage = 19.7 }
    , { regionPerGender = "North East Male", year = 2005, percentage = 35.1 }
    , { regionPerGender = "North West Male", year = 2005, percentage = 28.8 }
    , { regionPerGender = "Yorkshire Male", year = 2005, percentage = 29.7 }
    , { regionPerGender = "East Midlands Male", year = 2005, percentage = 31.8 }
    , { regionPerGender = "West Midlands Male", year = 2005, percentage = 25.5 }
    , { regionPerGender = "East Of England Male", year = 2005, percentage = 24.0 }
    , { regionPerGender = "London Male", year = 2005, percentage = 27.9 }
    , { regionPerGender = "South East Male", year = 2005, percentage = 24.0 }
    , { regionPerGender = "South West Male", year = 2005, percentage = 24.4 }
    , { regionPerGender = "North East Female", year = 2005, percentage = 31.8 }
    , { regionPerGender = "North West Female", year = 2005, percentage = 28.0 }
    , { regionPerGender = "Yorkshire Female", year = 2005, percentage = 22.1 }
    , { regionPerGender = "East Midlands Female", year = 2005, percentage = 23.2 }
    , { regionPerGender = "West Midlands Female", year = 2005, percentage = 23.8 }
    , { regionPerGender = "East Of England Female", year = 2005, percentage = 22.4 }
    , { regionPerGender = "London Female", year = 2005, percentage = 20.9 }
    , { regionPerGender = "South East Female", year = 2005, percentage = 23.4 }
    , { regionPerGender = "South West Female", year = 2005, percentage = 23.3 }
    , { regionPerGender = "North East Male", year = 2006, percentage = 29.7 }
    , { regionPerGender = "North West Male", year = 2006, percentage = 26.4 }
    , { regionPerGender = "Yorkshire Male", year = 2006, percentage = 24.0 }
    , { regionPerGender = "East Midlands Male", year = 2006, percentage = 28.3 }
    , { regionPerGender = "West Midlands Male", year = 2006, percentage = 24.2 }
    , { regionPerGender = "East Of England Male", year = 2006, percentage = 22.5 }
    , { regionPerGender = "London Male", year = 2006, percentage = 24.2 }
    , { regionPerGender = "South East Male", year = 2006, percentage = 23.7 }
    , { regionPerGender = "South West Male", year = 2006, percentage = 23.5 }
    , { regionPerGender = "North East Female", year = 2006, percentage = 29.3 }
    , { regionPerGender = "North West Female", year = 2006, percentage = 22.8 }
    , { regionPerGender = "Yorkshire Female", year = 2006, percentage = 23.3 }
    , { regionPerGender = "East Midlands Female", year = 2006, percentage = 25.6 }
    , { regionPerGender = "West Midlands Female", year = 2006, percentage = 23.5 }
    , { regionPerGender = "East Of England Female", year = 2006, percentage = 18.6 }
    , { regionPerGender = "London Female", year = 2006, percentage = 18.6 }
    , { regionPerGender = "South East Female", year = 2006, percentage = 19.3 }
    , { regionPerGender = "South West Female", year = 2006, percentage = 20.2 }
    , { regionPerGender = "North East Male", year = 2007, percentage = 30.6 }
    , { regionPerGender = "North West Male", year = 2007, percentage = 24.0 }
    , { regionPerGender = "Yorkshire Male", year = 2007, percentage = 24.2 }
    , { regionPerGender = "East Midlands Male", year = 2007, percentage = 22.9 }
    , { regionPerGender = "West Midlands Male", year = 2007, percentage = 24.8 }
    , { regionPerGender = "East Of England Male", year = 2007, percentage = 23.2 }
    , { regionPerGender = "London Male", year = 2007, percentage = 24.4 }
    , { regionPerGender = "South East Male", year = 2007, percentage = 21.2 }
    , { regionPerGender = "South West Male", year = 2007, percentage = 25.3 }
    , { regionPerGender = "North East Female", year = 2007, percentage = 33.3 }
    , { regionPerGender = "North West Female", year = 2007, percentage = 22.8 }
    , { regionPerGender = "Yorkshire Female", year = 2007, percentage = 26.1 }
    , { regionPerGender = "East Midlands Female", year = 2007, percentage = 22.4 }
    , { regionPerGender = "West Midlands Female", year = 2007, percentage = 22.3 }
    , { regionPerGender = "East Of England Female", year = 2007, percentage = 19.6 }
    , { regionPerGender = "London Female", year = 2007, percentage = 16.7 }
    , { regionPerGender = "South East Female", year = 2007, percentage = 16.5 }
    , { regionPerGender = "South West Female", year = 2007, percentage = 23.5 }
    , { regionPerGender = "North East Male", year = 2008, percentage = 24.4 }
    , { regionPerGender = "North West Male", year = 2008, percentage = 28.4 }
    , { regionPerGender = "Yorkshire Male", year = 2008, percentage = 25.4 }
    , { regionPerGender = "East Midlands Male", year = 2008, percentage = 27.9 }
    , { regionPerGender = "West Midlands Male", year = 2008, percentage = 21.4 }
    , { regionPerGender = "East Of England Male", year = 2008, percentage = 25.1 }
    , { regionPerGender = "London Male", year = 2008, percentage = 21.5 }
    , { regionPerGender = "South East Male", year = 2008, percentage = 22.7 }
    , { regionPerGender = "South West Male", year = 2008, percentage = 20.3 }
    , { regionPerGender = "North East Female", year = 2008, percentage = 26.7 }
    , { regionPerGender = "North West Female", year = 2008, percentage = 22.1 }
    , { regionPerGender = "Yorkshire Female", year = 2008, percentage = 22.6 }
    , { regionPerGender = "East Midlands Female", year = 2008, percentage = 21.2 }
    , { regionPerGender = "West Midlands Female", year = 2008, percentage = 19.1 }
    , { regionPerGender = "East Of England Female", year = 2008, percentage = 21.5 }
    , { regionPerGender = "London Female", year = 2008, percentage = 16.4 }
    , { regionPerGender = "South East Female", year = 2008, percentage = 17.9 }
    , { regionPerGender = "South West Female", year = 2008, percentage = 22.7 }
    , { regionPerGender = "North East Male", year = 2009, percentage = 14.2 }
    , { regionPerGender = "North West Male", year = 2009, percentage = 30.6 }
    , { regionPerGender = "Yorkshire Male", year = 2009, percentage = 25.1 }
    , { regionPerGender = "East Midlands Male", year = 2009, percentage = 19.7 }
    , { regionPerGender = "West Midlands Male", year = 2009, percentage = 26.0 }
    , { regionPerGender = "East Of England Male", year = 2009, percentage = 20.0 }
    , { regionPerGender = "London Male", year = 2009, percentage = 25.9 }
    , { regionPerGender = "South East Male", year = 2009, percentage = 26.3 }
    , { regionPerGender = "South West Male", year = 2009, percentage = 18.6 }
    , { regionPerGender = "North East Female", year = 2009, percentage = 23.3 }
    , { regionPerGender = "North West Female", year = 2009, percentage = 24.8 }
    , { regionPerGender = "Yorkshire Female", year = 2009, percentage = 22.1 }
    , { regionPerGender = "East Midlands Female", year = 2009, percentage = 23.1 }
    , { regionPerGender = "West Midlands Female", year = 2009, percentage = 18.4 }
    , { regionPerGender = "East Of England Female", year = 2009, percentage = 20.6 }
    , { regionPerGender = "London Female", year = 2009, percentage = 18.6 }
    , { regionPerGender = "South East Female", year = 2009, percentage = 19.3 }
    , { regionPerGender = "South West Female", year = 2009, percentage = 18.7 }
    , { regionPerGender = "North East Male", year = 2010, percentage = 27.3 }
    , { regionPerGender = "North West Male", year = 2010, percentage = 24.5 }
    , { regionPerGender = "Yorkshire Male", year = 2010, percentage = 22.0 }
    , { regionPerGender = "East Midlands Male", year = 2010, percentage = 19.3 }
    , { regionPerGender = "West Midlands Male", year = 2010, percentage = 20.3 }
    , { regionPerGender = "East Of England Male", year = 2010, percentage = 21.4 }
    , { regionPerGender = "London Male", year = 2010, percentage = 24.2 }
    , { regionPerGender = "South East Male", year = 2010, percentage = 20.9 }
    , { regionPerGender = "South West Male", year = 2010, percentage = 20.7 }
    , { regionPerGender = "North East Female", year = 2010, percentage = 22.0 }
    , { regionPerGender = "North West Female", year = 2010, percentage = 20.9 }
    , { regionPerGender = "Yorkshire Female", year = 2010, percentage = 21.3 }
    , { regionPerGender = "East Midlands Female", year = 2010, percentage = 20.3 }
    , { regionPerGender = "West Midlands Female", year = 2010, percentage = 18.9 }
    , { regionPerGender = "East Of England Female", year = 2010, percentage = 17.5 }
    , { regionPerGender = "London Female", year = 2010, percentage = 17.6 }
    , { regionPerGender = "South East Female", year = 2010, percentage = 16.0 }
    , { regionPerGender = "South West Female", year = 2010, percentage = 19.8 }
    , { regionPerGender = "North East Male", year = 2011, percentage = 23.6 }
    , { regionPerGender = "North West Male", year = 2011, percentage = 28.1 }
    , { regionPerGender = "Yorkshire Male", year = 2011, percentage = 24.4 }
    , { regionPerGender = "East Midlands Male", year = 2011, percentage = 17.6 }
    , { regionPerGender = "West Midlands Male", year = 2011, percentage = 23.6 }
    , { regionPerGender = "East Of England Male", year = 2011, percentage = 20.6 }
    , { regionPerGender = "London Male", year = 2011, percentage = 24.2 }
    , { regionPerGender = "South East Male", year = 2011, percentage = 21.0 }
    , { regionPerGender = "South West Male", year = 2011, percentage = 24.4 }
    , { regionPerGender = "North East Female", year = 2011, percentage = 25.8 }
    , { regionPerGender = "North West Female", year = 2011, percentage = 23.9 }
    , { regionPerGender = "Yorkshire Female", year = 2011, percentage = 19.9 }
    , { regionPerGender = "East Midlands Female", year = 2011, percentage = 17.9 }
    , { regionPerGender = "West Midlands Female", year = 2011, percentage = 21.6 }
    , { regionPerGender = "East Of England Female", year = 2011, percentage = 17.9 }
    , { regionPerGender = "London Female", year = 2011, percentage = 16.3 }
    , { regionPerGender = "South East Female", year = 2011, percentage = 14.3 }
    , { regionPerGender = "South West Female", year = 2011, percentage = 18.5 }
    ]


type alias FertilityStats =
    { year : Float, countryCode : String, liveBirtshPerWoman : Float, country : String }


fertilityStats : List FertilityStats
fertilityStats =
    [ { country = "Chile", countryCode = "CHL", year = 1950, liveBirtshPerWoman = 4.882 }
    , { country = "Chile", countryCode = "CHL", year = 1951, liveBirtshPerWoman = 4.874 }
    , { country = "Chile", countryCode = "CHL", year = 1952, liveBirtshPerWoman = 4.858 }
    , { country = "Chile", countryCode = "CHL", year = 1953, liveBirtshPerWoman = 4.842 }
    , { country = "Chile", countryCode = "CHL", year = 1954, liveBirtshPerWoman = 4.826 }
    , { country = "Chile", countryCode = "CHL", year = 1955, liveBirtshPerWoman = 4.809 }
    , { country = "Chile", countryCode = "CHL", year = 1956, liveBirtshPerWoman = 4.792 }
    , { country = "Chile", countryCode = "CHL", year = 1957, liveBirtshPerWoman = 4.774 }
    , { country = "Chile", countryCode = "CHL", year = 1958, liveBirtshPerWoman = 4.753 }
    , { country = "Chile", countryCode = "CHL", year = 1959, liveBirtshPerWoman = 4.728 }
    , { country = "Chile", countryCode = "CHL", year = 1960, liveBirtshPerWoman = 4.697 }
    , { country = "Chile", countryCode = "CHL", year = 1961, liveBirtshPerWoman = 4.655 }
    , { country = "Chile", countryCode = "CHL", year = 1962, liveBirtshPerWoman = 4.602 }
    , { country = "Chile", countryCode = "CHL", year = 1963, liveBirtshPerWoman = 4.536 }
    , { country = "Chile", countryCode = "CHL", year = 1964, liveBirtshPerWoman = 4.457 }
    , { country = "Chile", countryCode = "CHL", year = 1965, liveBirtshPerWoman = 4.364 }
    , { country = "Chile", countryCode = "CHL", year = 1966, liveBirtshPerWoman = 4.259 }
    , { country = "Chile", countryCode = "CHL", year = 1967, liveBirtshPerWoman = 4.144 }
    , { country = "Chile", countryCode = "CHL", year = 1968, liveBirtshPerWoman = 4.025 }
    , { country = "Chile", countryCode = "CHL", year = 1969, liveBirtshPerWoman = 3.902 }
    , { country = "Chile", countryCode = "CHL", year = 1970, liveBirtshPerWoman = 3.778 }
    , { country = "Chile", countryCode = "CHL", year = 1971, liveBirtshPerWoman = 3.654 }
    , { country = "Chile", countryCode = "CHL", year = 1972, liveBirtshPerWoman = 3.53 }
    , { country = "Chile", countryCode = "CHL", year = 1973, liveBirtshPerWoman = 3.409 }
    , { country = "Chile", countryCode = "CHL", year = 1974, liveBirtshPerWoman = 3.293 }
    , { country = "Chile", countryCode = "CHL", year = 1975, liveBirtshPerWoman = 3.182 }
    , { country = "Chile", countryCode = "CHL", year = 1976, liveBirtshPerWoman = 3.078 }
    , { country = "Chile", countryCode = "CHL", year = 1977, liveBirtshPerWoman = 2.981 }
    , { country = "Chile", countryCode = "CHL", year = 1978, liveBirtshPerWoman = 2.892 }
    , { country = "Chile", countryCode = "CHL", year = 1979, liveBirtshPerWoman = 2.812 }
    , { country = "Chile", countryCode = "CHL", year = 1980, liveBirtshPerWoman = 2.744 }
    , { country = "Chile", countryCode = "CHL", year = 1981, liveBirtshPerWoman = 2.689 }
    , { country = "Chile", countryCode = "CHL", year = 1982, liveBirtshPerWoman = 2.648 }
    , { country = "Chile", countryCode = "CHL", year = 1983, liveBirtshPerWoman = 2.619 }
    , { country = "Chile", countryCode = "CHL", year = 1984, liveBirtshPerWoman = 2.601 }
    , { country = "Chile", countryCode = "CHL", year = 1985, liveBirtshPerWoman = 2.592 }
    , { country = "Chile", countryCode = "CHL", year = 1986, liveBirtshPerWoman = 2.589 }
    , { country = "Chile", countryCode = "CHL", year = 1987, liveBirtshPerWoman = 2.59 }
    , { country = "Chile", countryCode = "CHL", year = 1988, liveBirtshPerWoman = 2.591 }
    , { country = "Chile", countryCode = "CHL", year = 1989, liveBirtshPerWoman = 2.589 }
    , { country = "Chile", countryCode = "CHL", year = 1990, liveBirtshPerWoman = 2.579 }
    , { country = "Chile", countryCode = "CHL", year = 1991, liveBirtshPerWoman = 2.558 }
    , { country = "Chile", countryCode = "CHL", year = 1992, liveBirtshPerWoman = 2.526 }
    , { country = "Chile", countryCode = "CHL", year = 1993, liveBirtshPerWoman = 2.484 }
    , { country = "Chile", countryCode = "CHL", year = 1994, liveBirtshPerWoman = 2.432 }
    , { country = "Chile", countryCode = "CHL", year = 1995, liveBirtshPerWoman = 2.372 }
    , { country = "Chile", countryCode = "CHL", year = 1996, liveBirtshPerWoman = 2.306 }
    , { country = "Chile", countryCode = "CHL", year = 1997, liveBirtshPerWoman = 2.238 }
    , { country = "Chile", countryCode = "CHL", year = 1998, liveBirtshPerWoman = 2.172 }
    , { country = "Chile", countryCode = "CHL", year = 1999, liveBirtshPerWoman = 2.11 }
    , { country = "Chile", countryCode = "CHL", year = 2000, liveBirtshPerWoman = 2.055 }
    , { country = "Chile", countryCode = "CHL", year = 2001, liveBirtshPerWoman = 2.009 }
    , { country = "Chile", countryCode = "CHL", year = 2002, liveBirtshPerWoman = 1.972 }
    , { country = "Chile", countryCode = "CHL", year = 2003, liveBirtshPerWoman = 1.943 }
    , { country = "Chile", countryCode = "CHL", year = 2004, liveBirtshPerWoman = 1.923 }
    , { country = "Chile", countryCode = "CHL", year = 2005, liveBirtshPerWoman = 1.909 }
    , { country = "Chile", countryCode = "CHL", year = 2006, liveBirtshPerWoman = 1.901 }
    , { country = "Chile", countryCode = "CHL", year = 2007, liveBirtshPerWoman = 1.898 }
    , { country = "Chile", countryCode = "CHL", year = 2008, liveBirtshPerWoman = 1.895 }
    , { country = "Chile", countryCode = "CHL", year = 2009, liveBirtshPerWoman = 1.892 }
    , { country = "Chile", countryCode = "CHL", year = 2010, liveBirtshPerWoman = 1.884 }
    , { country = "Chile", countryCode = "CHL", year = 2011, liveBirtshPerWoman = 1.87 }
    , { country = "Chile", countryCode = "CHL", year = 2012, liveBirtshPerWoman = 1.849 }
    , { country = "Chile", countryCode = "CHL", year = 2013, liveBirtshPerWoman = 1.821 }
    , { country = "Chile", countryCode = "CHL", year = 2014, liveBirtshPerWoman = 1.787 }
    , { country = "Chile", countryCode = "CHL", year = 2015, liveBirtshPerWoman = 1.75 }
    , { country = "Chile", countryCode = "CHL", year = 2016, liveBirtshPerWoman = 1.713 }
    , { country = "Chile", countryCode = "CHL", year = 2017, liveBirtshPerWoman = 1.678 }
    , { country = "Chile", countryCode = "CHL", year = 2018, liveBirtshPerWoman = 1.649 }
    , { country = "Chile", countryCode = "CHL", year = 2019, liveBirtshPerWoman = 1.627 }
    , { country = "Chile", countryCode = "CHL", year = 2020, liveBirtshPerWoman = 1.611 }
    , { country = "China", countryCode = "CHN", year = 1950, liveBirtshPerWoman = 6.709 }
    , { country = "China", countryCode = "CHN", year = 1951, liveBirtshPerWoman = 6.527 }
    , { country = "China", countryCode = "CHN", year = 1952, liveBirtshPerWoman = 6.195 }
    , { country = "China", countryCode = "CHN", year = 1953, liveBirtshPerWoman = 5.928 }
    , { country = "China", countryCode = "CHN", year = 1954, liveBirtshPerWoman = 5.725 }
    , { country = "China", countryCode = "CHN", year = 1955, liveBirtshPerWoman = 5.587 }
    , { country = "China", countryCode = "CHN", year = 1956, liveBirtshPerWoman = 5.513 }
    , { country = "China", countryCode = "CHN", year = 1957, liveBirtshPerWoman = 5.499 }
    , { country = "China", countryCode = "CHN", year = 1958, liveBirtshPerWoman = 5.54 }
    , { country = "China", countryCode = "CHN", year = 1959, liveBirtshPerWoman = 5.63 }
    , { country = "China", countryCode = "CHN", year = 1960, liveBirtshPerWoman = 5.756 }
    , { country = "China", countryCode = "CHN", year = 1961, liveBirtshPerWoman = 5.905 }
    , { country = "China", countryCode = "CHN", year = 1962, liveBirtshPerWoman = 6.062 }
    , { country = "China", countryCode = "CHN", year = 1963, liveBirtshPerWoman = 6.206 }
    , { country = "China", countryCode = "CHN", year = 1964, liveBirtshPerWoman = 6.32 }
    , { country = "China", countryCode = "CHN", year = 1965, liveBirtshPerWoman = 6.385 }
    , { country = "China", countryCode = "CHN", year = 1966, liveBirtshPerWoman = 6.384 }
    , { country = "China", countryCode = "CHN", year = 1967, liveBirtshPerWoman = 6.316 }
    , { country = "China", countryCode = "CHN", year = 1968, liveBirtshPerWoman = 6.184 }
    , { country = "China", countryCode = "CHN", year = 1969, liveBirtshPerWoman = 5.986 }
    , { country = "China", countryCode = "CHN", year = 1970, liveBirtshPerWoman = 5.725 }
    , { country = "China", countryCode = "CHN", year = 1971, liveBirtshPerWoman = 5.403 }
    , { country = "China", countryCode = "CHN", year = 1972, liveBirtshPerWoman = 5.035 }
    , { country = "China", countryCode = "CHN", year = 1973, liveBirtshPerWoman = 4.643 }
    , { country = "China", countryCode = "CHN", year = 1974, liveBirtshPerWoman = 4.244 }
    , { country = "China", countryCode = "CHN", year = 1975, liveBirtshPerWoman = 3.859 }
    , { country = "China", countryCode = "CHN", year = 1976, liveBirtshPerWoman = 3.508 }
    , { country = "China", countryCode = "CHN", year = 1977, liveBirtshPerWoman = 3.2 }
    , { country = "China", countryCode = "CHN", year = 1978, liveBirtshPerWoman = 2.943 }
    , { country = "China", countryCode = "CHN", year = 1979, liveBirtshPerWoman = 2.745 }
    , { country = "China", countryCode = "CHN", year = 1980, liveBirtshPerWoman = 2.613 }
    , { country = "China", countryCode = "CHN", year = 1981, liveBirtshPerWoman = 2.547 }
    , { country = "China", countryCode = "CHN", year = 1982, liveBirtshPerWoman = 2.536 }
    , { country = "China", countryCode = "CHN", year = 1983, liveBirtshPerWoman = 2.561 }
    , { country = "China", countryCode = "CHN", year = 1984, liveBirtshPerWoman = 2.607 }
    , { country = "China", countryCode = "CHN", year = 1985, liveBirtshPerWoman = 2.65 }
    , { country = "China", countryCode = "CHN", year = 1986, liveBirtshPerWoman = 2.666 }
    , { country = "China", countryCode = "CHN", year = 1987, liveBirtshPerWoman = 2.643 }
    , { country = "China", countryCode = "CHN", year = 1988, liveBirtshPerWoman = 2.575 }
    , { country = "China", countryCode = "CHN", year = 1989, liveBirtshPerWoman = 2.46 }
    , { country = "China", countryCode = "CHN", year = 1990, liveBirtshPerWoman = 2.309 }
    , { country = "China", countryCode = "CHN", year = 1991, liveBirtshPerWoman = 2.14 }
    , { country = "China", countryCode = "CHN", year = 1992, liveBirtshPerWoman = 1.977 }
    , { country = "China", countryCode = "CHN", year = 1993, liveBirtshPerWoman = 1.838 }
    , { country = "China", countryCode = "CHN", year = 1994, liveBirtshPerWoman = 1.731 }
    , { country = "China", countryCode = "CHN", year = 1995, liveBirtshPerWoman = 1.66 }
    , { country = "China", countryCode = "CHN", year = 1996, liveBirtshPerWoman = 1.622 }
    , { country = "China", countryCode = "CHN", year = 1997, liveBirtshPerWoman = 1.605 }
    , { country = "China", countryCode = "CHN", year = 1998, liveBirtshPerWoman = 1.597 }
    , { country = "China", countryCode = "CHN", year = 1999, liveBirtshPerWoman = 1.595 }
    , { country = "China", countryCode = "CHN", year = 2000, liveBirtshPerWoman = 1.596 }
    , { country = "China", countryCode = "CHN", year = 2001, liveBirtshPerWoman = 1.597 }
    , { country = "China", countryCode = "CHN", year = 2002, liveBirtshPerWoman = 1.6 }
    , { country = "China", countryCode = "CHN", year = 2003, liveBirtshPerWoman = 1.604 }
    , { country = "China", countryCode = "CHN", year = 2004, liveBirtshPerWoman = 1.608 }
    , { country = "China", countryCode = "CHN", year = 2005, liveBirtshPerWoman = 1.612 }
    , { country = "China", countryCode = "CHN", year = 2006, liveBirtshPerWoman = 1.615 }
    , { country = "China", countryCode = "CHN", year = 2007, liveBirtshPerWoman = 1.617 }
    , { country = "China", countryCode = "CHN", year = 2008, liveBirtshPerWoman = 1.62 }
    , { country = "China", countryCode = "CHN", year = 2009, liveBirtshPerWoman = 1.623 }
    , { country = "China", countryCode = "CHN", year = 2010, liveBirtshPerWoman = 1.627 }
    , { country = "China", countryCode = "CHN", year = 2011, liveBirtshPerWoman = 1.632 }
    , { country = "China", countryCode = "CHN", year = 2012, liveBirtshPerWoman = 1.639 }
    , { country = "China", countryCode = "CHN", year = 2013, liveBirtshPerWoman = 1.647 }
    , { country = "China", countryCode = "CHN", year = 2014, liveBirtshPerWoman = 1.656 }
    , { country = "China", countryCode = "CHN", year = 2015, liveBirtshPerWoman = 1.665 }
    , { country = "China", countryCode = "CHN", year = 2016, liveBirtshPerWoman = 1.675 }
    , { country = "China", countryCode = "CHN", year = 2017, liveBirtshPerWoman = 1.683 }
    , { country = "China", countryCode = "CHN", year = 2018, liveBirtshPerWoman = 1.69 }
    , { country = "China", countryCode = "CHN", year = 2019, liveBirtshPerWoman = 1.696 }
    , { country = "China", countryCode = "CHN", year = 2020, liveBirtshPerWoman = 1.7 }
    , { country = "Italy", countryCode = "ITA", year = 1950, liveBirtshPerWoman = 2.461 }
    , { country = "Italy", countryCode = "ITA", year = 1951, liveBirtshPerWoman = 2.427 }
    , { country = "Italy", countryCode = "ITA", year = 1952, liveBirtshPerWoman = 2.366 }
    , { country = "Italy", countryCode = "ITA", year = 1953, liveBirtshPerWoman = 2.321 }
    , { country = "Italy", countryCode = "ITA", year = 1954, liveBirtshPerWoman = 2.291 }
    , { country = "Italy", countryCode = "ITA", year = 1955, liveBirtshPerWoman = 2.276 }
    , { country = "Italy", countryCode = "ITA", year = 1956, liveBirtshPerWoman = 2.276 }
    , { country = "Italy", countryCode = "ITA", year = 1957, liveBirtshPerWoman = 2.29 }
    , { country = "Italy", countryCode = "ITA", year = 1958, liveBirtshPerWoman = 2.317 }
    , { country = "Italy", countryCode = "ITA", year = 1959, liveBirtshPerWoman = 2.352 }
    , { country = "Italy", countryCode = "ITA", year = 1960, liveBirtshPerWoman = 2.392 }
    , { country = "Italy", countryCode = "ITA", year = 1961, liveBirtshPerWoman = 2.434 }
    , { country = "Italy", countryCode = "ITA", year = 1962, liveBirtshPerWoman = 2.472 }
    , { country = "Italy", countryCode = "ITA", year = 1963, liveBirtshPerWoman = 2.503 }
    , { country = "Italy", countryCode = "ITA", year = 1964, liveBirtshPerWoman = 2.523 }
    , { country = "Italy", countryCode = "ITA", year = 1965, liveBirtshPerWoman = 2.531 }
    , { country = "Italy", countryCode = "ITA", year = 1966, liveBirtshPerWoman = 2.529 }
    , { country = "Italy", countryCode = "ITA", year = 1967, liveBirtshPerWoman = 2.519 }
    , { country = "Italy", countryCode = "ITA", year = 1968, liveBirtshPerWoman = 2.501 }
    , { country = "Italy", countryCode = "ITA", year = 1969, liveBirtshPerWoman = 2.477 }
    , { country = "Italy", countryCode = "ITA", year = 1970, liveBirtshPerWoman = 2.444 }
    , { country = "Italy", countryCode = "ITA", year = 1971, liveBirtshPerWoman = 2.401 }
    , { country = "Italy", countryCode = "ITA", year = 1972, liveBirtshPerWoman = 2.346 }
    , { country = "Italy", countryCode = "ITA", year = 1973, liveBirtshPerWoman = 2.279 }
    , { country = "Italy", countryCode = "ITA", year = 1974, liveBirtshPerWoman = 2.202 }
    , { country = "Italy", countryCode = "ITA", year = 1975, liveBirtshPerWoman = 2.118 }
    , { country = "Italy", countryCode = "ITA", year = 1976, liveBirtshPerWoman = 2.029 }
    , { country = "Italy", countryCode = "ITA", year = 1977, liveBirtshPerWoman = 1.938 }
    , { country = "Italy", countryCode = "ITA", year = 1978, liveBirtshPerWoman = 1.848 }
    , { country = "Italy", countryCode = "ITA", year = 1979, liveBirtshPerWoman = 1.763 }
    , { country = "Italy", countryCode = "ITA", year = 1980, liveBirtshPerWoman = 1.685 }
    , { country = "Italy", countryCode = "ITA", year = 1981, liveBirtshPerWoman = 1.616 }
    , { country = "Italy", countryCode = "ITA", year = 1982, liveBirtshPerWoman = 1.554 }
    , { country = "Italy", countryCode = "ITA", year = 1983, liveBirtshPerWoman = 1.5 }
    , { country = "Italy", countryCode = "ITA", year = 1984, liveBirtshPerWoman = 1.454 }
    , { country = "Italy", countryCode = "ITA", year = 1985, liveBirtshPerWoman = 1.415 }
    , { country = "Italy", countryCode = "ITA", year = 1986, liveBirtshPerWoman = 1.383 }
    , { country = "Italy", countryCode = "ITA", year = 1987, liveBirtshPerWoman = 1.357 }
    , { country = "Italy", countryCode = "ITA", year = 1988, liveBirtshPerWoman = 1.335 }
    , { country = "Italy", countryCode = "ITA", year = 1989, liveBirtshPerWoman = 1.316 }
    , { country = "Italy", countryCode = "ITA", year = 1990, liveBirtshPerWoman = 1.3 }
    , { country = "Italy", countryCode = "ITA", year = 1991, liveBirtshPerWoman = 1.284 }
    , { country = "Italy", countryCode = "ITA", year = 1992, liveBirtshPerWoman = 1.27 }
    , { country = "Italy", countryCode = "ITA", year = 1993, liveBirtshPerWoman = 1.257 }
    , { country = "Italy", countryCode = "ITA", year = 1994, liveBirtshPerWoman = 1.244 }
    , { country = "Italy", countryCode = "ITA", year = 1995, liveBirtshPerWoman = 1.235 }
    , { country = "Italy", countryCode = "ITA", year = 1996, liveBirtshPerWoman = 1.228 }
    , { country = "Italy", countryCode = "ITA", year = 1997, liveBirtshPerWoman = 1.227 }
    , { country = "Italy", countryCode = "ITA", year = 1998, liveBirtshPerWoman = 1.231 }
    , { country = "Italy", countryCode = "ITA", year = 1999, liveBirtshPerWoman = 1.24 }
    , { country = "Italy", countryCode = "ITA", year = 2000, liveBirtshPerWoman = 1.255 }
    , { country = "Italy", countryCode = "ITA", year = 2001, liveBirtshPerWoman = 1.276 }
    , { country = "Italy", countryCode = "ITA", year = 2002, liveBirtshPerWoman = 1.301 }
    , { country = "Italy", countryCode = "ITA", year = 2003, liveBirtshPerWoman = 1.328 }
    , { country = "Italy", countryCode = "ITA", year = 2004, liveBirtshPerWoman = 1.355 }
    , { country = "Italy", countryCode = "ITA", year = 2005, liveBirtshPerWoman = 1.382 }
    , { country = "Italy", countryCode = "ITA", year = 2006, liveBirtshPerWoman = 1.405 }
    , { country = "Italy", countryCode = "ITA", year = 2007, liveBirtshPerWoman = 1.423 }
    , { country = "Italy", countryCode = "ITA", year = 2008, liveBirtshPerWoman = 1.437 }
    , { country = "Italy", countryCode = "ITA", year = 2009, liveBirtshPerWoman = 1.444 }
    , { country = "Italy", countryCode = "ITA", year = 2010, liveBirtshPerWoman = 1.445 }
    , { country = "Italy", countryCode = "ITA", year = 2011, liveBirtshPerWoman = 1.439 }
    , { country = "Italy", countryCode = "ITA", year = 2012, liveBirtshPerWoman = 1.428 }
    , { country = "Italy", countryCode = "ITA", year = 2013, liveBirtshPerWoman = 1.413 }
    , { country = "Italy", countryCode = "ITA", year = 2014, liveBirtshPerWoman = 1.396 }
    , { country = "Italy", countryCode = "ITA", year = 2015, liveBirtshPerWoman = 1.377 }
    , { country = "Italy", countryCode = "ITA", year = 2016, liveBirtshPerWoman = 1.359 }
    , { country = "Italy", countryCode = "ITA", year = 2017, liveBirtshPerWoman = 1.341 }
    , { country = "Italy", countryCode = "ITA", year = 2018, liveBirtshPerWoman = 1.326 }
    , { country = "Italy", countryCode = "ITA", year = 2019, liveBirtshPerWoman = 1.313 }
    , { country = "Italy", countryCode = "ITA", year = 2020, liveBirtshPerWoman = 1.304 }
    , { country = "Zambia", countryCode = "ZMB", year = 1950, liveBirtshPerWoman = 6.623 }
    , { country = "Zambia", countryCode = "ZMB", year = 1951, liveBirtshPerWoman = 6.64 }
    , { country = "Zambia", countryCode = "ZMB", year = 1952, liveBirtshPerWoman = 6.675 }
    , { country = "Zambia", countryCode = "ZMB", year = 1953, liveBirtshPerWoman = 6.717 }
    , { country = "Zambia", countryCode = "ZMB", year = 1954, liveBirtshPerWoman = 6.763 }
    , { country = "Zambia", countryCode = "ZMB", year = 1955, liveBirtshPerWoman = 6.815 }
    , { country = "Zambia", countryCode = "ZMB", year = 1956, liveBirtshPerWoman = 6.871 }
    , { country = "Zambia", countryCode = "ZMB", year = 1957, liveBirtshPerWoman = 6.931 }
    , { country = "Zambia", countryCode = "ZMB", year = 1958, liveBirtshPerWoman = 6.993 }
    , { country = "Zambia", countryCode = "ZMB", year = 1959, liveBirtshPerWoman = 7.056 }
    , { country = "Zambia", countryCode = "ZMB", year = 1960, liveBirtshPerWoman = 7.115 }
    , { country = "Zambia", countryCode = "ZMB", year = 1961, liveBirtshPerWoman = 7.169 }
    , { country = "Zambia", countryCode = "ZMB", year = 1962, liveBirtshPerWoman = 7.214 }
    , { country = "Zambia", countryCode = "ZMB", year = 1963, liveBirtshPerWoman = 7.249 }
    , { country = "Zambia", countryCode = "ZMB", year = 1964, liveBirtshPerWoman = 7.274 }
    , { country = "Zambia", countryCode = "ZMB", year = 1965, liveBirtshPerWoman = 7.291 }
    , { country = "Zambia", countryCode = "ZMB", year = 1966, liveBirtshPerWoman = 7.304 }
    , { country = "Zambia", countryCode = "ZMB", year = 1967, liveBirtshPerWoman = 7.317 }
    , { country = "Zambia", countryCode = "ZMB", year = 1968, liveBirtshPerWoman = 7.332 }
    , { country = "Zambia", countryCode = "ZMB", year = 1969, liveBirtshPerWoman = 7.349 }
    , { country = "Zambia", countryCode = "ZMB", year = 1970, liveBirtshPerWoman = 7.367 }
    , { country = "Zambia", countryCode = "ZMB", year = 1971, liveBirtshPerWoman = 7.383 }
    , { country = "Zambia", countryCode = "ZMB", year = 1972, liveBirtshPerWoman = 7.392 }
    , { country = "Zambia", countryCode = "ZMB", year = 1973, liveBirtshPerWoman = 7.393 }
    , { country = "Zambia", countryCode = "ZMB", year = 1974, liveBirtshPerWoman = 7.382 }
    , { country = "Zambia", countryCode = "ZMB", year = 1975, liveBirtshPerWoman = 7.359 }
    , { country = "Zambia", countryCode = "ZMB", year = 1976, liveBirtshPerWoman = 7.323 }
    , { country = "Zambia", countryCode = "ZMB", year = 1977, liveBirtshPerWoman = 7.276 }
    , { country = "Zambia", countryCode = "ZMB", year = 1978, liveBirtshPerWoman = 7.219 }
    , { country = "Zambia", countryCode = "ZMB", year = 1979, liveBirtshPerWoman = 7.156 }
    , { country = "Zambia", countryCode = "ZMB", year = 1980, liveBirtshPerWoman = 7.087 }
    , { country = "Zambia", countryCode = "ZMB", year = 1981, liveBirtshPerWoman = 7.017 }
    , { country = "Zambia", countryCode = "ZMB", year = 1982, liveBirtshPerWoman = 6.946 }
    , { country = "Zambia", countryCode = "ZMB", year = 1983, liveBirtshPerWoman = 6.877 }
    , { country = "Zambia", countryCode = "ZMB", year = 1984, liveBirtshPerWoman = 6.81 }
    , { country = "Zambia", countryCode = "ZMB", year = 1985, liveBirtshPerWoman = 6.746 }
    , { country = "Zambia", countryCode = "ZMB", year = 1986, liveBirtshPerWoman = 6.685 }
    , { country = "Zambia", countryCode = "ZMB", year = 1987, liveBirtshPerWoman = 6.624 }
    , { country = "Zambia", countryCode = "ZMB", year = 1988, liveBirtshPerWoman = 6.563 }
    , { country = "Zambia", countryCode = "ZMB", year = 1989, liveBirtshPerWoman = 6.502 }
    , { country = "Zambia", countryCode = "ZMB", year = 1990, liveBirtshPerWoman = 6.442 }
    , { country = "Zambia", countryCode = "ZMB", year = 1991, liveBirtshPerWoman = 6.384 }
    , { country = "Zambia", countryCode = "ZMB", year = 1992, liveBirtshPerWoman = 6.329 }
    , { country = "Zambia", countryCode = "ZMB", year = 1993, liveBirtshPerWoman = 6.278 }
    , { country = "Zambia", countryCode = "ZMB", year = 1994, liveBirtshPerWoman = 6.231 }
    , { country = "Zambia", countryCode = "ZMB", year = 1995, liveBirtshPerWoman = 6.189 }
    , { country = "Zambia", countryCode = "ZMB", year = 1996, liveBirtshPerWoman = 6.153 }
    , { country = "Zambia", countryCode = "ZMB", year = 1997, liveBirtshPerWoman = 6.121 }
    , { country = "Zambia", countryCode = "ZMB", year = 1998, liveBirtshPerWoman = 6.093 }
    , { country = "Zambia", countryCode = "ZMB", year = 1999, liveBirtshPerWoman = 6.065 }
    , { country = "Zambia", countryCode = "ZMB", year = 2000, liveBirtshPerWoman = 6.036 }
    , { country = "Zambia", countryCode = "ZMB", year = 2001, liveBirtshPerWoman = 6.003 }
    , { country = "Zambia", countryCode = "ZMB", year = 2002, liveBirtshPerWoman = 5.963 }
    , { country = "Zambia", countryCode = "ZMB", year = 2003, liveBirtshPerWoman = 5.915 }
    , { country = "Zambia", countryCode = "ZMB", year = 2004, liveBirtshPerWoman = 5.859 }
    , { country = "Zambia", countryCode = "ZMB", year = 2005, liveBirtshPerWoman = 5.794 }
    , { country = "Zambia", countryCode = "ZMB", year = 2006, liveBirtshPerWoman = 5.724 }
    , { country = "Zambia", countryCode = "ZMB", year = 2007, liveBirtshPerWoman = 5.65 }
    , { country = "Zambia", countryCode = "ZMB", year = 2008, liveBirtshPerWoman = 5.574 }
    , { country = "Zambia", countryCode = "ZMB", year = 2009, liveBirtshPerWoman = 5.496 }
    , { country = "Zambia", countryCode = "ZMB", year = 2010, liveBirtshPerWoman = 5.415 }
    , { country = "Zambia", countryCode = "ZMB", year = 2011, liveBirtshPerWoman = 5.328 }
    , { country = "Zambia", countryCode = "ZMB", year = 2012, liveBirtshPerWoman = 5.233 }
    , { country = "Zambia", countryCode = "ZMB", year = 2013, liveBirtshPerWoman = 5.132 }
    , { country = "Zambia", countryCode = "ZMB", year = 2014, liveBirtshPerWoman = 5.026 }
    , { country = "Zambia", countryCode = "ZMB", year = 2015, liveBirtshPerWoman = 4.918 }
    , { country = "Zambia", countryCode = "ZMB", year = 2016, liveBirtshPerWoman = 4.814 }
    , { country = "Zambia", countryCode = "ZMB", year = 2017, liveBirtshPerWoman = 4.718 }
    , { country = "Zambia", countryCode = "ZMB", year = 2018, liveBirtshPerWoman = 4.633 }
    , { country = "Zambia", countryCode = "ZMB", year = 2019, liveBirtshPerWoman = 4.559 }
    , { country = "Zambia", countryCode = "ZMB", year = 2020, liveBirtshPerWoman = 4.496 }
    ]


type alias CoronaData =
    -- (date, country, newDeaths)
    ( String, String, Float )


coronaStats : List CoronaData
coronaStats =
    [ ( "2020-01-05", "World", 0 )
    , ( "2020-01-06", "World", 0 )
    , ( "2020-01-07", "World", 0 )
    , ( "2020-01-08", "World", 0 )
    , ( "2020-01-09", "World", 0 )
    , ( "2020-01-10", "World", 0 )
    , ( "2020-01-11", "World", 1 )
    , ( "2020-01-12", "World", 0 )
    , ( "2020-01-13", "World", 0 )
    , ( "2020-01-14", "World", 0 )
    , ( "2020-01-15", "World", 1 )
    , ( "2020-01-16", "World", 0 )
    , ( "2020-01-17", "World", 0 )
    , ( "2020-01-18", "World", 0 )
    , ( "2020-01-19", "World", 1 )
    , ( "2020-01-20", "World", 0 )
    , ( "2020-01-21", "World", 3 )
    , ( "2020-01-22", "World", 11 )
    , ( "2020-01-23", "World", 0 )
    , ( "2020-01-24", "World", 9 )
    , ( "2020-01-25", "World", 15 )
    , ( "2020-01-26", "World", 15 )
    , ( "2020-01-27", "World", 25 )
    , ( "2020-01-28", "World", 25 )
    , ( "2020-01-29", "World", 26 )
    , ( "2020-01-30", "World", 38 )
    , ( "2020-01-31", "World", 43 )
    , ( "2020-02-01", "World", 46 )
    , ( "2020-02-02", "World", 46 )
    , ( "2020-02-03", "World", 57 )
    , ( "2020-02-04", "World", 65 )
    , ( "2020-02-05", "World", 66 )
    , ( "2020-02-06", "World", 72 )
    , ( "2020-02-07", "World", 73 )
    , ( "2020-02-08", "World", 86 )
    , ( "2020-02-09", "World", 89 )
    , ( "2020-02-10", "World", 97 )
    , ( "2020-02-11", "World", 108 )
    , ( "2020-02-12", "World", 97 )
    , ( "2020-02-13", "World", 255 )
    , ( "2020-02-14", "World", 13 )
    , ( "2020-02-15", "World", 144 )
    , ( "2020-02-16", "World", 142 )
    , ( "2020-02-17", "World", 106 )
    , ( "2020-02-18", "World", 98 )
    , ( "2020-02-19", "World", 139 )
    , ( "2020-02-20", "World", 116 )
    , ( "2020-02-21", "World", 119 )
    , ( "2020-02-22", "World", 112 )
    , ( "2020-02-23", "World", 104 )
    , ( "2020-02-24", "World", 156 )
    , ( "2020-02-25", "World", 79 )
    , ( "2020-02-26", "World", 64 )
    , ( "2020-02-27", "World", 38 )
    , ( "2020-02-28", "World", 57 )
    , ( "2020-02-29", "World", 64 )
    , ( "2020-03-01", "World", 58 )
    , ( "2020-03-02", "World", 67 )
    , ( "2020-03-03", "World", 72 )
    , ( "2020-03-04", "World", 84 )
    , ( "2020-03-05", "World", 80 )
    , ( "2020-03-06", "World", 102 )
    , ( "2020-03-07", "World", 104 )
    , ( "2020-03-08", "World", 97 )
    , ( "2020-03-09", "World", 228 )
    , ( "2020-03-10", "World", 208 )
    , ( "2020-03-11", "World", 273 )
    , ( "2020-03-12", "World", 333 )
    , ( "2020-03-13", "World", 350 )
    , ( "2020-03-14", "World", 443 )
    , ( "2020-03-15", "World", 367 )
    , ( "2020-03-16", "World", 751 )
    , ( "2020-03-17", "World", 606 )
    , ( "2020-03-18", "World", 811 )
    , ( "2020-03-19", "World", 963 )
    , ( "2020-03-20", "World", 1075 )
    , ( "2020-03-21", "World", 1387 )
    , ( "2020-03-22", "World", 1716 )
    , ( "2020-03-23", "World", 1691 )
    , ( "2020-03-24", "World", 1854 )
    , ( "2020-03-25", "World", 2315 )
    , ( "2020-03-26", "World", 2645 )
    , ( "2020-03-27", "World", 2814 )
    , ( "2020-03-28", "World", 3492 )
    , ( "2020-03-29", "World", 3590 )
    , ( "2020-03-30", "World", 3231 )
    , ( "2020-03-31", "World", 3993 )
    , ( "2020-04-01", "World", 4677 )
    , ( "2020-04-02", "World", 5015 )
    , ( "2020-04-03", "World", 5026 )
    , ( "2020-04-04", "World", 6786 )
    , ( "2020-04-05", "World", 6298 )
    , ( "2020-04-06", "World", 4771 )
    , ( "2020-04-07", "World", 5345 )
    , ( "2020-04-08", "World", 7576 )
    , ( "2020-04-09", "World", 6570 )
    , ( "2020-04-10", "World", 7424 )
    , ( "2020-04-11", "World", 7016 )
    , ( "2020-04-12", "World", 6064 )
    , ( "2020-04-13", "World", 5335 )
    , ( "2020-04-14", "World", 5390 )
    , ( "2020-04-15", "World", 7619 )
    , ( "2020-04-16", "World", 10491 )
    , ( "2020-04-17", "World", 8527 )
    , ( "2020-04-18", "World", 8463 )
    , ( "2020-04-19", "World", 6373 )
    , ( "2020-04-20", "World", 4988 )
    , ( "2020-04-21", "World", 5450 )
    , ( "2020-04-22", "World", 7243 )
    , ( "2020-04-23", "World", 5935 )
    , ( "2020-04-24", "World", 7335 )
    , ( "2020-04-25", "World", 5359 )
    , ( "2020-04-26", "World", 6160 )
    , ( "2020-04-27", "World", 3913 )
    , ( "2020-04-28", "World", 4899 )
    , ( "2020-04-29", "World", 6566 )
    , ( "2020-04-30", "World", 6562 )
    , ( "2020-05-01", "World", 5650 )
    , ( "2020-05-02", "World", 5577 )
    , ( "2020-05-03", "World", 4808 )
    , ( "2020-05-04", "World", 3706 )
    , ( "2020-05-05", "World", 3986 )
    , ( "2020-05-06", "World", 5957 )
    , ( "2020-05-07", "World", 6124 )
    , ( "2020-05-08", "World", 5642 )
    , ( "2020-05-09", "World", 5112 )
    , ( "2020-05-10", "World", 4407 )
    , ( "2020-05-11", "World", 3426 )
    , ( "2020-05-12", "World", 3590 )
    , ( "2020-05-13", "World", 5757 )
    , ( "2020-05-14", "World", 5018 )
    , ( "2020-05-15", "World", 5256 )
    , ( "2020-05-16", "World", 5060 )
    , ( "2020-05-17", "World", 4225 )
    , ( "2020-05-18", "World", 2898 )
    , ( "2020-05-19", "World", 3298 )
    , ( "2020-05-20", "World", 5185 )
    , ( "2020-05-21", "World", 4718 )
    , ( "2020-05-22", "World", 5391 )
    , ( "2020-05-23", "World", 4646 )
    , ( "2020-05-24", "World", 3916 )
    , ( "2020-05-25", "World", 1107 )
    , ( "2020-05-26", "World", 3368 )
    , ( "2020-05-27", "World", 3871 )
    , ( "2020-05-28", "World", 5142 )
    , ( "2020-05-29", "World", 4642 )
    , ( "2020-05-30", "World", 4654 )
    , ( "2020-05-31", "World", 4012 )
    , ( "2020-06-01", "World", 2914 )
    , ( "2020-06-02", "World", 3145 )
    , ( "2020-06-03", "World", 4545 )
    , ( "2020-06-04", "World", 5516 )
    , ( "2020-06-05", "World", 5130 )
    , ( "2020-06-06", "World", 4639 )
    , ( "2020-06-07", "World", 3788 )
    , ( "2020-06-08", "World", 3511 )
    , ( "2020-06-09", "World", 3214 )
    , ( "2020-06-10", "World", 4853 )
    , ( "2020-06-11", "World", 5131 )
    , ( "2020-06-12", "World", 4696 )
    , ( "2020-06-13", "World", 4648 )
    , ( "2020-06-14", "World", 4139 )
    , ( "2020-06-15", "World", 3157 )
    , ( "2020-06-16", "World", 3378 )
    , ( "2020-06-17", "World", 6719 )
    , ( "2020-06-18", "World", 5100 )
    , ( "2020-06-19", "World", 6275 )
    , ( "2020-06-20", "World", 5032 )
    , ( "2020-06-21", "World", 4116 )
    , ( "2020-06-22", "World", 3967 )
    , ( "2020-06-23", "World", 3395 )
    , ( "2020-06-24", "World", 5350 )
    , ( "2020-06-25", "World", 5215 )
    , ( "2020-06-26", "World", 6578 )
    , ( "2020-06-27", "World", 4560 )
    , ( "2020-06-28", "World", 4591 )
    , ( "2020-06-29", "World", 3070 )
    , ( "2020-06-30", "World", 3704 )
    , ( "2020-07-01", "World", 5624 )
    , ( "2020-07-02", "World", 4840 )
    , ( "2020-07-03", "World", 5077 )
    , ( "2020-07-04", "World", 5012 )
    , ( "2020-07-05", "World", 4339 )
    , ( "2020-07-06", "World", 3378 )
    , ( "2020-07-07", "World", 3841 )
    , ( "2020-07-08", "World", 5996 )
    , ( "2020-07-09", "World", 5277 )
    , ( "2020-07-10", "World", 5383 )
    , ( "2020-07-11", "World", 5277 )
    , ( "2020-07-12", "World", 4793 )
    , ( "2020-07-13", "World", 3890 )
    , ( "2020-07-14", "World", 3841 )
    , ( "2020-07-15", "World", 5578 )
    , ( "2020-07-16", "World", 5501 )
    , ( "2020-07-17", "World", 5744 )
    , ( "2020-07-18", "World", 7233 )
    , ( "2020-07-19", "World", 4978 )
    , ( "2020-07-20", "World", 3936 )
    , ( "2020-07-21", "World", 4093 )
    , ( "2020-07-22", "World", 6123 )
    , ( "2020-07-23", "World", 6877 )
    , ( "2020-07-24", "World", 9779 )
    , ( "2020-07-25", "World", 6256 )
    , ( "2020-07-26", "World", 5733 )
    , ( "2020-07-27", "World", 3963 )
    , ( "2020-07-28", "World", 4656 )
    , ( "2020-07-29", "World", 6162 )
    , ( "2020-07-30", "World", 6642 )
    , ( "2020-07-31", "World", 6383 )
    , ( "2020-08-01", "World", 6123 )
    , ( "2020-08-02", "World", 5759 )
    , ( "2020-08-03", "World", 4233 )
    , ( "2020-08-04", "World", 4226 )
    , ( "2020-08-05", "World", 6730 )
    , ( "2020-08-06", "World", 7100 )
    , ( "2020-08-07", "World", 6895 )
    , ( "2020-08-08", "World", 6468 )
    , ( "2020-08-09", "World", 5634 )
    , ( "2020-08-10", "World", 4824 )
    , ( "2020-08-11", "World", 4817 )
    , ( "2020-08-12", "World", 6137 )
    , ( "2020-08-13", "World", 6900 )
    , ( "2020-08-14", "World", 9910 )
    , ( "2020-08-15", "World", 6241 )
    , ( "2020-08-16", "World", 5657 )
    , ( "2020-08-17", "World", 4233 )
    , ( "2020-08-18", "World", 4270 )
    , ( "2020-08-19", "World", 6691 )
    , ( "2020-08-20", "World", 6545 )
    , ( "2020-08-21", "World", 6353 )
    , ( "2020-08-22", "World", 5869 )
    , ( "2020-08-23", "World", 5643 )
    , ( "2020-08-24", "World", 3310 )
    , ( "2020-08-25", "World", 4277 )
    , ( "2020-08-26", "World", 6477 )
    , ( "2020-08-27", "World", 6294 )
    , ( "2020-08-28", "World", 6082 )
    , ( "2020-08-29", "World", 5457 )
    , ( "2020-08-30", "World", 5697 )
    , ( "2020-08-31", "World", 3773 )
    , ( "2020-09-01", "World", 4053 )
    , ( "2020-09-02", "World", 6512 )
    , ( "2020-09-03", "World", 6078 )
    , ( "2020-09-04", "World", 5792 )
    , ( "2020-09-05", "World", 5585 )
    , ( "2020-09-06", "World", 5363 )
    , ( "2020-09-07", "World", 9033 )
    , ( "2020-09-08", "World", 3821 )
    , ( "2020-09-09", "World", 4964 )
    , ( "2020-09-10", "World", 6093 )
    , ( "2020-09-11", "World", 5892 )
    , ( "2020-09-12", "World", 5885 )
    , ( "2020-09-13", "World", 4927 )
    , ( "2020-09-14", "World", 3880 )
    , ( "2020-09-15", "World", 4236 )
    , ( "2020-09-16", "World", 6956 )
    , ( "2020-09-17", "World", 5437 )
    , ( "2020-09-18", "World", 5319 )
    , ( "2020-09-19", "World", 5953 )
    , ( "2020-09-20", "World", 5073 )
    , ( "2020-09-21", "World", 3745 )
    , ( "2020-09-22", "World", 4395 )
    , ( "2020-09-23", "World", 6065 )
    , ( "2020-09-24", "World", 6365 )
    , ( "2020-09-25", "World", 5783 )
    , ( "2020-09-26", "World", 5577 )
    , ( "2020-09-27", "World", 5421 )
    , ( "2020-09-28", "World", 3823 )
    , ( "2020-09-29", "World", 3924 )
    , ( "2020-09-30", "World", 6219 )
    , ( "2020-10-01", "World", 6108 )
    , ( "2020-10-02", "World", 8772 )
    , ( "2020-10-03", "World", 5535 )
    , ( "2020-10-04", "World", 4723 )
    , ( "2020-10-05", "World", 3966 )
    , ( "2020-10-06", "World", 4453 )
    , ( "2020-10-07", "World", 5618 )
    , ( "2020-10-08", "World", 5852 )
    , ( "2020-10-09", "World", 9119 )
    , ( "2020-10-10", "World", 5749 )
    , ( "2020-10-11", "World", 4823 )
    , ( "2020-10-12", "World", 3978 )
    , ( "2020-10-13", "World", 3973 )
    , ( "2020-10-14", "World", 5530 )
    , ( "2020-10-15", "World", 6037 )
    , ( "2020-10-16", "World", 6111 )
    , ( "2020-10-17", "World", 5945 )
    , ( "2020-10-18", "World", 5538 )
    , ( "2020-10-19", "World", 3949 )
    , ( "2020-10-20", "World", 4670 )
    , ( "2020-10-21", "World", 6405 )
    , ( "2020-10-22", "World", 6740 )
    , ( "2020-10-23", "World", 6349 )
    , ( "2020-10-24", "World", 6250 )
    ]
