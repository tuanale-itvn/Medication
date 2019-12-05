//
//  MedicationNameTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/1/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class MedicationNameTableViewCell: UITableViewCell {
    static let identifier = "MedicationNameTableViewCell"

    @IBOutlet weak var mLableName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setName(name:String) {
        mLableName.text = name
    }
}
