//
//  QST_GoogleCalendar.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/3/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


struct QST_GoogleCalendar {
    let calendarID: String;
    let summary: String;
    
    enum QST_GoogleCalendarErrors: Error {
        case mssingCalendarID
    }
    
    init?(fromGTLRGoogleCalendar: GTLRCalendar_Calendar) {
        guard fromGTLRGoogleCalendar.identifier != nil else {
            return nil;
        }
        calendarID = fromGTLRGoogleCalendar.identifier!;
        summary = (fromGTLRGoogleCalendar.summary ?? "" );
    }
    
    init?(fromGTLRGoogleCalendarListEntry: GTLRCalendar_CalendarListEntry) {
        guard fromGTLRGoogleCalendarListEntry.identifier != nil else {
            return nil;
        }
        calendarID = fromGTLRGoogleCalendarListEntry.identifier!;
        summary = (fromGTLRGoogleCalendarListEntry.summary ?? "" );
    }
}
