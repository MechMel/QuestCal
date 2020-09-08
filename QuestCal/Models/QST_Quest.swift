//
//  QST_Quest.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/2/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation;
import GoogleAPIClientForREST;

class QST_Quest : Codable {
    public private(set) var googleEventID: String;
    public private(set) var isCompleted: Bool;
    public private(set) var secondsInvested: Double;
    public var campaign: QST_Campaign?  {
        if let calendarID = googleEvent?.calendarID {
            return QST_Campaign.fromID(googleCalendarID: calendarID);
        }
        return nil;
    }
    public var title: String? {
        return googleEvent?.summary;
    }
    public var description: String? {
        return googleEvent?.description;
    }
    public var startDate: Date? {
        return googleEvent?.startDate;
    }
    public var endDate: Date? {
        return googleEvent?.endDate;
    }
    private var googleEvent: QST_GoogleEvent? {
        if let googleEventInstance = QST_GoogleCalendarController.liveGoogleEventsByEventID[googleEventID] {
            return googleEventInstance;
        }
        return nil;
    }
    
    
    // TODO: Learn and apply function comment annotation to all functions.
    // Learn //Mark: Blah and apply it everywhere.
    // Creates a new instance of a QST_Quest for a given Google event ID.
    public static func fromID(googleEventID: String) -> QST_Quest? {
        if let encodedQuest = UserDefaults.standard.object(forKey: googleEventID) as? Data {
            if let decodedQuest = try? JSONDecoder().decode(QST_Quest.self, from: encodedQuest) {
                return decodedQuest;
            }
        }
        return QST_Quest(googleEventID: googleEventID);
    }
    
    // Creates and saves a new QST_Quest for a given Google event ID.
    private init(googleEventID initGoogleEventID: String) {
        googleEventID = initGoogleEventID;
        isCompleted = false;
        secondsInvested = 0;
        save();
    }
    
    public func save() {
        if let encodedQuest = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encodedQuest, forKey: googleEventID);
        }
    }
}
