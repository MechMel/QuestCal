//
//  QST_GoogleCalendarController.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/3/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation;
import GTMAppAuth;
import GoogleAPIClientForREST;

class QST_GoogleCalendarController {
    // Private Properties
    private static let googleCalendarService = GTLRCalendarService();
    private static let ninetyDaysInSeconds = 10368000 as Double;
    
    // Public Properties
    // Live calendars are Google calendars the user has selected to track
    // Live events are events that are associated with live Google calendars
    public static var liveGoogleCalendarIDs = [String]();
    public static var liveGoogleCalendarsByCalendarID = [String: QST_GoogleCalendar]();
    public static var liveGoogleEventsByEventID = [String: QST_GoogleEvent]();
    //public static var allGoogleCalendarIDs = [String]();
    //public static var allGoogleCalendarsByCalendarID = [String: QST_GoogleCalendar]();
    //public static var downloadedGoogleEventsByEventID = [String: QST_GoogleEvent]();
    public static var calendarControllerIsSetup = false;
    
    // On Change Events
    public static let onLiveGoogleCalendarIDsUpdated = QST_Trigger();
    public static let onLiveGoogleCalendarsUpdated = QST_Trigger();
    public static let onLiveGoogleEventsUpdated = QST_Trigger();
    
    
    // Call this before using any functions in this class
    public static func setupGoogleCalendarController(authorizer: GTMAppAuthFetcherAuthorization) {
        googleCalendarService.authorizer = authorizer;
        calendarControllerIsSetup = true;
    }
    
    public static func updateLiveGoogleCalendars() {
        for calendarID in liveGoogleCalendarIDs {
            let calendarGetQuery = GTLRCalendarQuery_CalendarsGet.query(withCalendarId: calendarID);
            
            googleCalendarService.executeQuery(calendarGetQuery, completionHandler: {(ticket, result, error) in
                if (error == nil) {
                    if let serverSideGoogleCalendar = (result as? GTLRCalendar_Calendar) {
                        if let clientSideGoogleCalendar = QST_GoogleCalendar(fromGTLRGoogleCalendar: serverSideGoogleCalendar) {
                            liveGoogleCalendarsByCalendarID[calendarID] = clientSideGoogleCalendar;
                            onLiveGoogleCalendarsUpdated.trigger();
                        }
                    }
                } else {
                    print(error!);
                }
            });
        }
    }
    
    public static func updateliveGoogleEvents() {
        for calendarID in liveGoogleCalendarIDs {
            let calendarEventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarID);
            
            googleCalendarService.executeQuery(calendarEventsListQuery, completionHandler: {(ticket, result, error) in
                if (error == nil) {
                    if let serverSideEventList = (result as? GTLRCalendar_Events)?.items {
                        for serverSideEvent in serverSideEventList {
                            if let clientSideEvent = QST_GoogleEvent.init(fromGTLRGoogleEvent: serverSideEvent, calendarID: calendarID) {
                                liveGoogleEventsByEventID[clientSideEvent.eventID] = clientSideEvent;
                            }
                        }
                        
                        onLiveGoogleEventsUpdated.trigger();
                    }
                } else {
                    print(error!);
                }
            });
        }
    }
    
    /*public static func getAllGoogleCalendars(callback: ([QST_GoogleCalendar])->Void) {
        let calendarsListQuery = GTLRCalendarQuery_CalendarListList.query();
        
        googleCalendarService.executeQuery(calendarsListQuery, completionHandler: {(ticket, result, error) in
            if (error == nil) {
                var clientSideGoogleCalendars = [QST_GoogleCalendar]();
                
                if let serverSideCalendarList = (result as? GTLRCalendar_CalendarList)?.items {
                    for severSideCalendar in serverSideCalendarList {
                        if let clientSideGoogleCalendar = QST_GoogleCalendar(fromGTLRGoogleCalendarListEntry: severSideCalendar) {
                            clientSideGoogleCalendars.append(clientSideGoogleCalendar);
                        }
                    }
                }
                
                callback(clientSideGoogleCalendars);
            } else {
                print(error!);
            }
        });
    }
    
    public static func getGoogleEventsForCalendar(calendarID: String, callback: ([QST_GoogleEvent])->Void) {
        let eventListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarID);
        eventListQuery.timeMin = GTLRDateTime(date: Date(timeIntervalSinceNow: -ninetyDaysInSeconds));
        eventListQuery.timeMax = GTLRDateTime(date: Date(timeIntervalSinceNow: ninetyDaysInSeconds));
        eventListQuery.maxResults = 500;
        
        googleCalendarService.executeQuery(eventListQuery, completionHandler: {(ticket, result, error) in
            if (error == nil) {
                var clientSideEvents = [QST_GoogleEvent]();
                if let serverSideEvents = (result as? GTLRCalendar_Events)?.items {
                    for serverSideEvent in serverSideEvents {
                        if let clientSideEvent = QST_GoogleEvent(fromGTLRGoogleEvent: serverSideEvent, calendarID: calendarID) {
                            clientSideEvents.append(clientSideEvent);
                        }
                    }
                }
            } else {
                print(error!);
            }
        });
    }*/
    
    /*public static func createGoogleEvent(googleCalendarID: String, googleEventSummary: String, googleEventStartDate: Date, googleEventEndDate: Date) {
        // Create the new Event
        let newEvent = GTLRCalendar_Event();
        newEvent.summary = googleEventSummary;
        newEvent.start = GTLRCalendar_EventDateTime();
        newEvent.start!.date = GTLRDateTime(date: googleEventStartDate);
        newEvent.end = GTLRCalendar_EventDateTime();
        newEvent.end!.date = GTLRDateTime(date: googleEventEndDate);
        newEvent.reminders = GTLRCalendar_Event_Reminders();
        newEvent.reminders!.useDefault = true;
        newEvent.descriptionProperty = "This is a description.";
        //newEvent.sequence = 0;
        
        // Make the push request
        let eventCreateionRequest = GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId: googleCalendarID);
        googleCalendarService.executeQuery(eventCreateionRequest, completionHandler: { (ticket, result, error) in
            print(ticket);
            if (error == nil) {
                updateGoogleEventsForCalendars(googleCalendarID: googleCalendarID);
            } else {
                print(error!);
            }
        });
    }*/
}
