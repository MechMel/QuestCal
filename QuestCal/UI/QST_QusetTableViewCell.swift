//
//  QST_QusetTableViewCell.swift
//  GoogleCalanderSandbox
//
//  Created by Melchiah Mauck on 9/4/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//


import UIKit

class QST_QuestTableViewCell: UITableViewCell {
    //MARK: Constants
    private let monthAbbreviationFromMonthNumber = [
        "01": "Jan",
        "02": "Feb",
        "03": "Mar",
        "04": "Apr",
        "05": "May",
        "06": "Jun",
        "07": "Jul",
        "08": "Aug",
        "09": "Sep",
        "10": "Oct",
        "11": "Nov",
        "12": "Dec"
    ];
    
    //MARK: Properties
    private var quest: QST_Quest?;
    @IBOutlet weak var superDateLabel: UILabel!;
    @IBOutlet weak var subDateLabel: UILabel!;
    @IBOutlet weak var questTitle: UILabel!;
    
    
    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);

        // Configure the view for the selected state
    }

    public func setQuest(googleEventID: String) {
        quest = QST_Quest.fromID(googleEventID: googleEventID);
        questTitle.text = getQuestLabelText();
        superDateLabel.text = getSuperDateLabelText();
        subDateLabel.text = getSubDateLabelText();
    }
    
    private func getQuestLabelText() -> String {
        var newQuestLabelText = "";
        
        // Add the campaign title
        if let campaignTitle = quest?.campaign?.title {
            newQuestLabelText += campaignTitle + ": "
        }
        
        // Add the quest title
        newQuestLabelText += (quest?.title ?? "");
        
        return newQuestLabelText;
    }
    
    private func getSubDateLabelText() -> String {
        if (quest?.endDate != nil) {
            let df = DateFormatter();
            df.dateFormat = "dd";
            return df.string(from: quest!.endDate!);
        }
        return "";
    }
    
    private func getSuperDateLabelText() -> String {
        if (quest?.endDate != nil) {
            let df = DateFormatter();
            df.dateFormat = "MM";
            let monthNumberAsString = df.string(from: quest!.endDate!);
            if let monthAbbreviation = monthAbbreviationFromMonthNumber[monthNumberAsString] {
                return monthAbbreviation;
            }
        }
        return "";
    }
}
