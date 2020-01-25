module Data exposing (SmokeStats, smokeStats)


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
