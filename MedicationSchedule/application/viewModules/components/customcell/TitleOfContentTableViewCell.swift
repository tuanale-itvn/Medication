//
//  TitleOfContentTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/28/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TitleOfContentTableViewCell: UITableViewCell {
    static let identifier = "TitleOfContentTableViewCell"

    @IBOutlet weak var mLableToday: UILabel!
    @IBOutlet weak var mLableTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func isDontHaveMedicationToday(isDontHave:Bool) {
        if isDontHave {
            mLableTitle.text = "You have not added any mecadition."
            mLableToday.isHidden = true
            self.layoutIfNeeded()
        }
        else{
            mLableTitle.text = "Have you take your medication in today?"
            mLableToday.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
            mLableToday.text = dateFormatter.string(from: NSDate() as Date)
            self.layoutIfNeeded()
        }
    }
}
