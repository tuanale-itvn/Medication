//
//  SummaryTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/5/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    static let identifier = "SummaryTableViewCell"

    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
