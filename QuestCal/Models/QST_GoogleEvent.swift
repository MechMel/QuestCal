//
//  QST_GoogleEvent.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/3/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


struct QST_GoogleEvent {
    let eventID: String;
    let calendarID: String;
    let summary: String;
    let description: String;
    let startDate: Date;
    let endDate: Date;
    
    init?(fromGTLRGoogleEvent: GTLRCalendar_Event, calendarID initCalendarID: String) {
        guard fromGTLRGoogleEvent.identifier != nil else {
            return nil;
        }
        eventID = fromGTLRGoogleEvent.identifier!;
        calendarID = initCalendarID;
        summary = (fromGTLRGoogleEvent.summary ?? "");
        description = (fromGTLRGoogleEvent.descriptionProperty ?? "");
        // TODO: Figure out how to handle a Google event that is missing start or end date.
        startDate = (fromGTLRGoogleEvent.start?.date?.date ?? Date());
        endDate = (fromGTLRGoogleEvent.end?.date?.date ?? Date());
    }
}
