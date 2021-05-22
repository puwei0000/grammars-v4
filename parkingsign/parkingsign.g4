/*
@licstart  The following is the entire license notice for the
grammar in this file.
Copyright (C) 2020  Stephen V. Kowalski
steve@objectmethods.com
The grammar in this page is free software: you can
redistribute it and/or modify it under the terms of the GNU
General Public License (GNU GPL) as published by the Free Software
Foundation, either version 3 of the License, or (at your option)
any later version.  The code is distributed WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU GPL for more details.
As additional permission under GNU GPL version 3 section 7, you
may distribute non-source (e.g., minimized or compacted) forms of
that code without the copy of the GNU GPL normally required by
section 4, provided you include this license notice and a URL
through which recipients can access the Corresponding Source.
@licend  The above is the entire license notice
for the grammar in this file.
*/

/*
This parking sign grammar is for Los Angeles City parking signs but probably will
work well with signs in other cities. A repository of parking sign images can be
found at https://github.com/steveobjectmethods/parking-signs

Here are some example text streams to test with (generated by text recognition):

streetSweepingSign:
NO PARKING 9AM TO 12 NOON MONDAY STREET CLEANING
NO PARKING 8AM - 10AM TUESDAY STREET CLEANING
8AM TO 10 AM TUESDAY STREET SWEEPING
9AM TO 12NOON MONDAY STREET SWEEPING

noParkingSign:
NO PARKING 6PM TO 8AM NIGHTLY
NO PARKING 6PM TO 8AM
NO PARKING ANY TIME
NO PARKING ANY TIME EXCEPT

noStoppingSign:
NO STOPPING 7AM TO 9AM 4PM TO 7PM EXCEPT SATURDAY & SUNDAY
TOW AWAY NO STOPPING 7 TO 9A.M. 4 TO 7P.M. EXCEPT SAT & SUN
TOW AWAY VALET PARKING ONLY 6PM TO 3AM NIGHTLY

passengerLoadingSign:
PASSENGER LOADING ONLY 6PM TO 1AM

singleTimeLimitSign:
4 HOUR PARKING 8AM TO 6PM EXCEPT SUNDAY
2 HOUR PARKING 8AM TO 6PM DAILY
1 HOUR PARKING 8AM TO 4PM EXCEPT SUNDAY
2 HOUR PARKING 8AM THRU 6PM MONDAY THRU FRIDAY
15 MIN PARKING 7AM TO 5PM SCHOOL DAYS
2 HOUR PARKING 8AM TO 6PM

doubleTimeLimitSign:
2 HOUR PARKING MON TO SAT SUN 8 AM 11 AM TO TO 11 AM 8 PM
2 HOUR PARKING MON TO SAT SUNDAY 8 AM 11 AM TO TO 6 PM 6 PM EXCEPT HOLIDAYS

temporaryNoParkingSign:
TOW-AWAY TEMPORARY NO PARKING 6:30AM TO 4PM EXCEPT SATURDAY & SUNDAY
TOW-AWAY TEMPORARY NO PARKING 5PM TO MIDNIGHT MONDAY THRU FRIDAY
TOW-AWAY TEMPORARY NO PARKING 11AM TO 11PM SATURDAY & SUNDAY
TOW-AWAY TEMPORARY NO PARKING ANYTIME THURSDAY ONLY

permitSign:
DISTRICT NO. 78 PERMITS EXEMPT
VEHICLES WITH DISTRICT NO. 78 PERMITS EXEMPTED
DISTRICT NO.34 PERMITS EXEMPT

*/
grammar parkingsign;
/*
There can be multiple parking signs on the same pole that together determine
the parking rules for the location.  Assume we have at least one sign in the image
we are analyzing.
*/


parkingSigns
   : parkingSign*
   ;

parkingSign
   : streetSweepingSign
   | noParkingSign
   | noStoppingSign
   | passengerLoadingSign
   | singleTimeLimitSign
   | doubleTimeLimitSign
   | temporaryNoParkingSign
   | permitSign
   ;
/*
Sometimes there are the words NO PARKING and sometimes there is a graphic P
with a circle and line through it.  We don't include the graphic in the grammar
*/
   
   
streetSweepingSign
   : noParking? timeRange day streetSweeping
   ;
   // Sometimes the exception is on a different sign below the no parking sign
   
noParkingSign
   : noParking? (anyTime | timeRange) EXCEPT? dayRange?
   ;

noStoppingSign
   : towAway? (noStopping | valetOnly) timeRange+ EXCEPT? dayRange?
   ;

passengerLoadingSign
   : towAway? loadingOnly timeRange+ EXCEPT? dayRange?
   ;

temporaryNoParkingSign
   : towAway TEMPORARY noParking (anyTime | timeRange) EXCEPT? dayRange?
   ;

singleTimeLimitSign
   : ((INT HOUR) | (INT minute)) PARKING timeRange EXCEPT? dayRange?
   ;
/*
The double time limit sign is a challenge in that the order of the tokens
is not ideal.  If there is 2 hour parking Mon-Sat from 8am to 8pm and on
Sun from 11am to 8pm, the order of the tokens will be
2 HOUR PARKING MON TO SAT SUN 8 AM 11 AM TO TO 11 AM 8 PM
because of the vertical arrangement of the day/time ranges
*/
   
   
doubleTimeLimitSign
   : INT HOUR PARKING dayRange dayRange time time TO TO time time (EXCEPT HOLIDAYS)?
   ;

permitSign
   : (VEHICLES WITH)? DISTRICT NO INT PERMITS exempt
   ;
   // Phrases
   
streetSweeping
   : STREET (SWEEPING | CLEANING)
   ;

noParking
   : NO PARKING
   ;

noStopping
   : NO STOPPING
   ;

valetOnly
   : VALET PARKING ONLY
   ;

loadingOnly
   : PASSENGER LOADING ONLY
   ;

schoolDays
   : SCHOOL DAYS
   ;

timeRange
   : (time to time)
   | (INT to time)
   ;

everyDay
   : DAILY
   | NIGHTLY
   ;

dayToDay
   : day to day
   ;

dayAndDay
   : day and_ day
   ;

dayRange
   : everyDay
   | schoolDays
   | HOLIDAYS
   | dayAndDay
   | dayToDay
   | day ONLY
   | day
   ;

dayRangePlus
   : dayRange
   ;

to
   : TO
   | DASH
   | THRU
   ;

and_
   : AND
   | AMPERSAND
   ;

towAway
   : TOW DASH? AWAY
   ;

minute
   : MIN
   | MINUTE
   ;

exempt
   : EXEMPT
   | EXEMPTED
   ;

anyTime
   : ANYTIME
   | (ANY TIME)
   ;

NO
   : 'NO'
   ; // two meanings : negative (no) and abbreviation for number (No.)
   
PARKING
   : 'PARKING'
   ;

TO
   : 'TO'
   ;

THRU
   : 'THRU'
   ;

DASH
   : '-'
   ;

ANYTIME
   : 'ANYTIME'
   ;

ANY
   : 'ANY'
   ;

TIME
   : 'TIME'
   ;

EXCEPT
   : 'EXCEPT'
   ;

DAILY
   : 'DAILY'
   ;

NIGHTLY
   : 'NIGHTLY'
   ;

SCHOOL
   : 'SCHOOL'
   ;

DAYS
   : 'DAYS'
   ;

HOLIDAYS
   : 'HOLIDAYS'
   ;

AND
   : 'AND'
   ;

AMPERSAND
   : '&'
   ;

TOW
   : 'TOW'
   ;

AWAY
   : 'AWAY'
   ;

STOPPING
   : 'STOPPING'
   ;

VALET
   : 'VALET'
   ;

ONLY
   : 'ONLY'
   ;

VEHICLES
   : 'VEHICLES'
   ;

WITH
   : 'WITH'
   ;

DISTRICT
   : 'DISTRICT'
   ;

PERMITS
   : 'PERMITS'
   ;

EXEMPTED
   : 'EXEMPTED'
   ;

EXEMPT
   : 'EXEMPT'
   ;

HOUR
   : 'HOUR'
   ;

MINUTE
   : 'MINUTE'
   ;

MIN
   : 'MIN'
   ;

TEMPORARY
   : 'TEMPORARY'
   ;

PASSENGER
   : 'PASSENGER'
   ;

LOADING
   : 'LOADING'
   ;

day
   : MON
   | TUE
   | WED
   | THU
   | FRI
   | SAT
   | SUN
   ;

MON
   : 'MONDAY'
   | 'MON'
   ;

TUE
   : 'TUESDAY'
   | 'TUE'
   ;

WED
   : 'WEDNESDAY'
   | 'WED'
   ;

THU
   : 'THURSDAY'
   | 'THU'
   ;

FRI
   : 'FRIDAY'
   | 'FRI'
   ;

SAT
   : 'SATURDAY'
   | 'SAT'
   ;

SUN
   : 'SUNDAY'
   | 'SUN'
   ;

STREET
   : 'STREET'
   ;

SWEEPING
   : 'SWEEPING'
   ;

CLEANING
   : 'CLEANING'
   ;

time
   : INT (':' INT)? (am | pm)?
   | twelveNoon
   | twelveMidnight
   ;

twelveNoon
   : NOON
   | ('12' NOON)
   ;

twelveMidnight
   : MIDNIGHT
   | ('12' MIDNIGHT)
   ;

am
   : 'AM'
   | ('A.M.')
   ;

pm
   : 'PM'
   | ('P.M.')
   ;

NOON
   : 'NOON'
   ;

MIDNIGHT
   : 'MIDNIGHT'
   ;

INT
   : [0-9]+
   ;
   // skip whitespace and periods (e.g., 7a.m.)
   
WS
   : [ \t\r\n.]+ -> skip
   ;

