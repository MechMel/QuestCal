//
//  QST_Trigger.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/2/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation;

class QST_Trigger {
    typealias Listener = () -> Void;
    
    private var listeners = [Listener]();

    func addListener(listener: Listener!) {
        listeners.append(listener);
    }
    
    func trigger() {
        for listener in listeners {
            listener();
        }
    }
}
