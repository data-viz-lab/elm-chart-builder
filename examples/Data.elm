module Data exposing
    ( FertilityStats
    , SmokeStats
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
