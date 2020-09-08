//
//  QST_QuestTableViewController.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/4/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import UIKit

class QST_QuestTableViewController: UITableViewController {
    let liveCalendars = [ "pcc.edu_al4s4t27tmfjdkks5hieon1464@group.calendar.google.com" ];
    
    // TODO: This is super innefficient fix it.
    private var uncompletedQuestsSortedByEndDate = [QST_Quest]();

    private func compileUncompletedQuestsSortedByEndDate() -> [QST_Quest] {
        // Compile the uncompleted quests
        var unsortedUncompltedQuests = [QST_Quest]();
        for googleEvent in QST_GoogleCalendarController.liveGoogleEventsByEventID.values {
            if let quest = QST_Quest.fromID(googleEventID: googleEvent.eventID) {
                if (!quest.isCompleted) {
                    unsortedUncompltedQuests.append(quest);
                }
            }
        }
        
        // Sort the uncompleted quests by start date
        let sortedUncompletedQuests = unsortedUncompltedQuests.sorted(by: {(questA, questB) in
            let questAEndDate = (questA.endDate ?? Date());
            let questBEndDate = (questB.endDate ?? Date());
            return questAEndDate < questBEndDate;
        });
        return sortedUncompletedQuests;
    }
    
    func refresh() {
        uncompletedQuestsSortedByEndDate = compileUncompletedQuestsSortedByEndDate();
        self.tableView.reloadData();
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        
        if let authorizer = QST_GoogleAuthController.authorization {
            QST_GoogleCalendarController.setupGoogleCalendarController(authorizer: authorizer);
            QST_GoogleCalendarController.liveGoogleCalendarIDs = liveCalendars;
            QST_GoogleCalendarController.onLiveGoogleEventsUpdated.addListener(listener: refresh);
            QST_GoogleCalendarController.updateLiveGoogleCalendars();
            QST_GoogleCalendarController.updateliveGoogleEvents();
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uncompletedQuestsSortedByEndDate.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "QuestTableViewCell";
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QST_QuestTableViewCell else {
            fatalError("The dequeued cell is not an instance of QuestTableViewCell.");
        }// Fetches the appropriate meal for the data source layout.
        let quest = self.uncompletedQuestsSortedByEndDate[indexPath.row]

        // Configure the cell...
        cell.setQuest(googleEventID: quest.googleEventID);
        //let margins = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4);
        //cell.frame = CGRect.in UIEdgeInsetsInsetRect(cell.frame, margins);

        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
