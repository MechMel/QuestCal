//
//  QST_Campaign.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/2/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation;

class QST_Campaign : Codable  {
    public private(set) var googleCalendarID: String;
    public private(set) var isLive: Bool;
    public var title: String? {
        return googleCalendar?.summary;
    }
    private var googleCalendar: QST_GoogleCalendar? {
        if let googleCalendarInstance = QST_GoogleCalendarController.liveGoogleCalendarsByCalendarID[googleCalendarID] {
            return googleCalendarInstance;
        }
        return nil;
    }
    // We don't want to change the google values, but maybe override
    // the properties(summary, color, description) of google calendars
    // and events.
    
    
    // Creates a new instance of a QST_Campaign for a given Google calendar ID.
    public static func fromID(googleCalendarID: String) -> QST_Campaign? {
        if let encodedCampaign = UserDefaults.standard.object(forKey: googleCalendarID) as? Data {
            if let decodedCampaign = try? JSONDecoder().decode(QST_Campaign.self, from: encodedCampaign) {
                return decodedCampaign;
            }
        }
        return QST_Campaign(googleCalendarID: googleCalendarID);
    }
    
    // Creates and saves a new QST_Campaign for a given Google calendar ID.
    private init(googleCalendarID initGoogleCalendarID: String) {
        googleCalendarID = initGoogleCalendarID;
        isLive = false;
        save();
    }
    
    func save() {
        if let encodedCampaign = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encodedCampaign, forKey: googleCalendarID);
        }
    }
}

