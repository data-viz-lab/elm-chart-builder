module Data exposing
    ( CoronaStats
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


type alias CoronaStats =
    -- (date, newCases, newDeaths)
    ( String, Float, Float )


coronaStats : List CoronaStats
coronaStats =
    [ ( "2019-12-31", 27, 0 )
    , ( "2020-01-01", 0, 0 )
    , ( "2020-01-02", 0, 0 )
    , ( "2020-01-03", 17, 0 )
    , ( "2020-01-04", 0, 0 )
    , ( "2020-01-05", 15, 0 )
    , ( "2020-01-06", 0, 0 )
    , ( "2020-01-07", 0, 0 )
    , ( "2020-01-08", 0, 0 )
    , ( "2020-01-09", 0, 0 )
    , ( "2020-01-10", 0, 0 )
    , ( "2020-01-11", 0, 1 )
    , ( "2020-01-12", 0, 0 )
    , ( "2020-01-13", 1, 0 )
    , ( "2020-01-14", 1, 0 )
    , ( "2020-01-15", 1, 1 )
    , ( "2020-01-16", 0, 0 )
    , ( "2020-01-17", 5, 0 )
    , ( "2020-01-18", 17, 0 )
    , ( "2020-01-19", 136, 1 )
    , ( "2020-01-20", 20, 0 )
    , ( "2020-01-21", 153, 3 )
    , ( "2020-01-22", 142, 11 )
    , ( "2020-01-23", 97, 0 )
    , ( "2020-01-24", 266, 9 )
    , ( "2020-01-25", 453, 15 )
    , ( "2020-01-26", 673, 15 )
    , ( "2020-01-27", 797, 25 )
    , ( "2020-01-28", 1767, 25 )
    , ( "2020-01-29", 1480, 26 )
    , ( "2020-01-30", 1757, 38 )
    , ( "2020-01-31", 2001, 43 )
    , ( "2020-02-01", 2122, 46 )
    , ( "2020-02-02", 2608, 46 )
    , ( "2020-02-03", 2818, 57 )
    , ( "2020-02-04", 3243, 65 )
    , ( "2020-02-05", 3908, 66 )
    , ( "2020-02-06", 3751, 72 )
    , ( "2020-02-07", 3218, 73 )
    , ( "2020-02-08", 3442, 86 )
    , ( "2020-02-09", 2618, 89 )
    , ( "2020-02-10", 2992, 97 )
    , ( "2020-02-11", 2563, 108 )
    , ( "2020-02-12", 2072, 97 )
    , ( "2020-02-13", 15151, 255 )
    , ( "2020-02-14", 4215, 13 )
    , ( "2020-02-15", 2560, 144 )
    , ( "2020-02-16", 2162, 142 )
    , ( "2020-02-17", 2067, 106 )
    , ( "2020-02-18", 1995, 98 )
    , ( "2020-02-19", 1864, 139 )
    , ( "2020-02-20", 532, 116 )
    , ( "2020-02-21", 996, 119 )
    , ( "2020-02-22", 1085, 112 )
    , ( "2020-02-23", 1010, 104 )
    , ( "2020-02-24", 523, 156 )
    , ( "2020-02-25", 795, 79 )
    , ( "2020-02-26", 867, 64 )
    , ( "2020-02-27", 1114, 38 )
    , ( "2020-02-28", 1271, 57 )
    , ( "2020-02-29", 1860, 64 )
    , ( "2020-03-01", 1825, 58 )
    , ( "2020-03-02", 2086, 67 )
    , ( "2020-03-03", 1858, 72 )
    , ( "2020-03-04", 2315, 84 )
    , ( "2020-03-05", 2357, 80 )
    , ( "2020-03-06", 3060, 102 )
    , ( "2020-03-07", 4120, 104 )
    , ( "2020-03-08", 3978, 97 )
    , ( "2020-03-09", 4179, 228 )
    , ( "2020-03-10", 4818, 208 )
    , ( "2020-03-11", 5118, 273 )
    , ( "2020-03-12", 7922, 333 )
    , ( "2020-03-13", 9474, 350 )
    , ( "2020-03-14", 10455, 443 )
    , ( "2020-03-15", 12200, 367 )
    , ( "2020-03-16", 12479, 751 )
    , ( "2020-03-17", 14241, 606 )
    , ( "2020-03-18", 17092, 811 )
    , ( "2020-03-19", 20294, 963 )
    , ( "2020-03-20", 31196, 1075 )
    , ( "2020-03-21", 31988, 1387 )
    , ( "2020-03-22", 34226, 1716 )
    , ( "2020-03-23", 34270, 1691 )
    , ( "2020-03-24", 44570, 1854 )
    , ( "2020-03-25", 42536, 2315 )
    , ( "2020-03-26", 53835, 2645 )
    , ( "2020-03-27", 61109, 2814 )
    , ( "2020-03-28", 65185, 3492 )
    , ( "2020-03-29", 62854, 3590 )
    , ( "2020-03-30", 57364, 3231 )
    , ( "2020-03-31", 64713, 3993 )
    , ( "2020-04-01", 74839, 4677 )
    , ( "2020-04-02", 77647, 5015 )
    , ( "2020-04-03", 77646, 5026 )
    , ( "2020-04-04", 81999, 6786 )
    , ( "2020-04-05", 85270, 6298 )
    , ( "2020-04-06", 66260, 4771 )
    , ( "2020-04-07", 73265, 5345 )
    , ( "2020-04-08", 77394, 7576 )
    , ( "2020-04-09", 85058, 6570 )
    , ( "2020-04-10", 87433, 7424 )
    , ( "2020-04-11", 89623, 7016 )
    , ( "2020-04-12", 75365, 6064 )
    , ( "2020-04-13", 68523, 5335 )
    , ( "2020-04-14", 65255, 5390 )
    , ( "2020-04-15", 76977, 7619 )
    , ( "2020-04-16", 78812, 10491 )
    , ( "2020-04-17", 84430, 8527 )
    , ( "2020-04-18", 82277, 8463 )
    , ( "2020-04-19", 79696, 6373 )
    , ( "2020-04-20", 70503, 4988 )
    , ( "2020-04-21", 74656, 5450 )
    , ( "2020-04-22", 87321, 7243 )
    , ( "2020-04-23", 66604, 5935 )
    , ( "2020-04-24", 78787, 7335 )
    , ( "2020-04-25", 73150, 5359 )
    , ( "2020-04-26", 99847, 6160 )
    , ( "2020-04-27", 81834, 3913 )
    , ( "2020-04-28", 66773, 4899 )
    , ( "2020-04-29", 72828, 6566 )
    , ( "2020-04-30", 79510, 6562 )
    , ( "2020-05-01", 85673, 5650 )
    , ( "2020-05-02", 88531, 5577 )
    , ( "2020-05-03", 80631, 4808 )
    , ( "2020-05-04", 77023, 3706 )
    , ( "2020-05-05", 77609, 3986 )
    , ( "2020-05-06", 79645, 5957 )
    , ( "2020-05-07", 88213, 6124 )
    , ( "2020-05-08", 92816, 5642 )
    , ( "2020-05-09", 89698, 5112 )
    , ( "2020-05-10", 88418, 4407 )
    , ( "2020-05-11", 74534, 3426 )
    , ( "2020-05-12", 71371, 3590 )
    , ( "2020-05-13", 87119, 5757 )
    , ( "2020-05-14", 87490, 5018 )
    , ( "2020-05-15", 97184, 5256 )
    , ( "2020-05-16", 98231, 5060 )
    , ( "2020-05-17", 92974, 4225 )
    , ( "2020-05-18", 79051, 2898 )
    , ( "2020-05-19", 87951, 3298 )
    , ( "2020-05-20", 96378, 5185 )
    , ( "2020-05-21", 104973, 4718 )
    , ( "2020-05-22", 108785, 5391 )
    , ( "2020-05-23", 106803, 4646 )
    , ( "2020-05-24", 98954, 3916 )
    , ( "2020-05-25", 92252, 1107 )
    , ( "2020-05-26", 90951, 3368 )
    , ( "2020-05-27", 94640, 3871 )
    , ( "2020-05-28", 103813, 5142 )
    , ( "2020-05-29", 119332, 4642 )
    , ( "2020-05-30", 123186, 4654 )
    , ( "2020-05-31", 127766, 4012 )
    , ( "2020-06-01", 105625, 2914 )
    , ( "2020-06-02", 102772, 3145 )
    , ( "2020-06-03", 113212, 4545 )
    , ( "2020-06-04", 126516, 5516 )
    , ( "2020-06-05", 127352, 5130 )
    , ( "2020-06-06", 133857, 4639 )
    , ( "2020-06-07", 125387, 3788 )
    , ( "2020-06-08", 113668, 3511 )
    , ( "2020-06-09", 108750, 3214 )
    , ( "2020-06-10", 126771, 4853 )
    , ( "2020-06-11", 135661, 5131 )
    , ( "2020-06-12", 136728, 4696 )
    , ( "2020-06-13", 144990, 4648 )
    , ( "2020-06-14", 132969, 4139 )
    , ( "2020-06-15", 119616, 3157 )
    , ( "2020-06-16", 121592, 3378 )
    , ( "2020-06-17", 143251, 6719 )
    , ( "2020-06-18", 178028, 5100 )
    , ( "2020-06-19", 138810, 6275 )
    , ( "2020-06-20", 181354, 5032 )
    , ( "2020-06-21", 159136, 4116 )
    , ( "2020-06-22", 126286, 3967 )
    , ( "2020-06-23", 136494, 3395 )
    , ( "2020-06-24", 164177, 5350 )
    , ( "2020-06-25", 175821, 5215 )
    , ( "2020-06-26", 178868, 6578 )
    , ( "2020-06-27", 189700, 4560 )
    , ( "2020-06-28", 181247, 4591 )
    , ( "2020-06-29", 159070, 3070 )
    , ( "2020-06-30", 161815, 3704 )
    , ( "2020-07-01", 193796, 5624 )
    , ( "2020-07-02", 202238, 4840 )
    , ( "2020-07-03", 208884, 5077 )
    , ( "2020-07-04", 205800, 5012 )
    , ( "2020-07-05", 187773, 4339 )
    , ( "2020-07-06", 176549, 3378 )
    , ( "2020-07-07", 177162, 3841 )
    , ( "2020-07-08", 208511, 5996 )
    , ( "2020-07-09", 215912, 5277 )
    , ( "2020-07-10", 224961, 5383 )
    , ( "2020-07-11", 231720, 5277 )
    , ( "2020-07-12", 215719, 4793 )
    , ( "2020-07-13", 194193, 3890 )
    , ( "2020-07-14", 192553, 3841 )
    , ( "2020-07-15", 225054, 5578 )
    , ( "2020-07-16", 234288, 5501 )
    , ( "2020-07-17", 256151, 5744 )
    , ( "2020-07-18", 248827, 7233 )
    , ( "2020-07-19", 227020, 4978 )
    , ( "2020-07-20", 213628, 3936 )
    , ( "2020-07-21", 204636, 4093 )
    , ( "2020-07-22", 241536, 6123 )
    , ( "2020-07-23", 283890, 6877 )
    , ( "2020-07-24", 275841, 9779 )
    , ( "2020-07-25", 284287, 6256 )
    , ( "2020-07-26", 256990, 5733 )
    , ( "2020-07-27", 229343, 3963 )
    , ( "2020-07-28", 215347, 4656 )
    , ( "2020-07-29", 244704, 6162 )
    , ( "2020-07-30", 299976, 6642 )
    , ( "2020-07-31", 290225, 6383 )
    , ( "2020-08-01", 277264, 6123 )
    , ( "2020-08-02", 262022, 5759 )
    , ( "2020-08-03", 220913, 4233 )
    , ( "2020-08-04", 207320, 4226 )
    , ( "2020-08-05", 256810, 6730 )
    , ( "2020-08-06", 278536, 7100 )
    , ( "2020-08-07", 285952, 6895 )
    , ( "2020-08-08", 275725, 6468 )
    , ( "2020-08-09", 265839, 5634 )
    , ( "2020-08-10", 227415, 4824 )
    , ( "2020-08-11", 221294, 4817 )
    , ( "2020-08-12", 261564, 6137 )
    , ( "2020-08-13", 289795, 6900 )
    , ( "2020-08-14", 285548, 9910 )
    , ( "2020-08-15", 289349, 6241 )
    , ( "2020-08-16", 256432, 5657 )
    , ( "2020-08-17", 230176, 4233 )
    , ( "2020-08-18", 199684, 4270 )
    , ( "2020-08-19", 256079, 6691 )
    , ( "2020-08-20", 281874, 6545 )
    , ( "2020-08-21", 275382, 6353 )
    , ( "2020-08-22", 253421, 5869 )
    , ( "2020-08-23", 263276, 5643 )
    , ( "2020-08-24", 222670, 3310 )
    , ( "2020-08-25", 214767, 4277 )
    , ( "2020-08-26", 256559, 6477 )
    , ( "2020-08-27", 278262, 6294 )
    , ( "2020-08-28", 283632, 6082 )
    , ( "2020-08-29", 276981, 5457 )
    , ( "2020-08-30", 266054, 5697 )
    , ( "2020-08-31", 243219, 3773 )
    , ( "2020-09-01", 245516, 4053 )
    , ( "2020-09-02", 269005, 6512 )
    , ( "2020-09-03", 284976, 6078 )
    , ( "2020-09-04", 279065, 5792 )
    , ( "2020-09-05", 293157, 5585 )
    , ( "2020-09-06", 276155, 5363 )
    , ( "2020-09-07", 245999, 9033 )
    , ( "2020-09-08", 209083, 3821 )
    , ( "2020-09-09", 245696, 4964 )
    , ( "2020-09-10", 289184, 6093 )
    , ( "2020-09-11", 305692, 5892 )
    , ( "2020-09-12", 304696, 5885 )
    , ( "2020-09-13", 284091, 4927 )
    , ( "2020-09-14", 269988, 3880 )
    , ( "2020-09-15", 245520, 4236 )
    , ( "2020-09-16", 303523, 6956 )
    , ( "2020-09-17", 289716, 5437 )
    , ( "2020-09-18", 318186, 5319 )
    , ( "2020-09-19", 311968, 5953 )
    , ( "2020-09-20", 293505, 5073 )
    , ( "2020-09-21", 284329, 3745 )
    , ( "2020-09-22", 268939, 4395 )
    , ( "2020-09-23", 282710, 6065 )
    , ( "2020-09-24", 311481, 6365 )
    , ( "2020-09-25", 320888, 5783 )
    , ( "2020-09-26", 311602, 5577 )
    , ( "2020-09-27", 299267, 5421 )
    , ( "2020-09-28", 279856, 3823 )
    , ( "2020-09-29", 238511, 3924 )
    , ( "2020-09-30", 293940, 6219 )
    , ( "2020-10-01", 316009, 6108 )
    , ( "2020-10-02", 323170, 8772 )
    , ( "2020-10-03", 318791, 5535 )
    , ( "2020-10-04", 301912, 4723 )
    , ( "2020-10-05", 281018, 3966 )
    , ( "2020-10-06", 270420, 4453 )
    , ( "2020-10-07", 326756, 5618 )
    , ( "2020-10-08", 353624, 5852 )
    , ( "2020-10-09", 363043, 9119 )
    , ( "2020-10-10", 349229, 5749 )
    , ( "2020-10-11", 345287, 4823 )
    , ( "2020-10-12", 304518, 3978 )
    , ( "2020-10-13", 288737, 3973 )
    , ( "2020-10-14", 330679, 5530 )
    , ( "2020-10-15", 388336, 6037 )
    , ( "2020-10-16", 402364, 6111 )
    , ( "2020-10-17", 396856, 5945 )
    , ( "2020-10-18", 369119, 5538 )
    , ( "2020-10-19", 362204, 3949 )
    , ( "2020-10-20", 348284, 4670 )
    , ( "2020-10-21", 391139, 6405 )
    , ( "2020-10-22", 444483, 6740 )
    , ( "2020-10-23", 457344, 6349 )
    , ( "2020-10-24", 468117, 6250 )
    ]
