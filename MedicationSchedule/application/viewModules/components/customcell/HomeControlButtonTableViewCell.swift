//
//  HomeControlButtonTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/27/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class HomeControlButtonTableViewCell: UITableViewCell {
    static let identifier = "HomeControlButtonTableViewCell"
    var delegate : TGHomeViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onSummaryTouchUp(_ sender: Any) {
        print("onSummaryTouchUp")
        delegate?.onSummaryTouchUp(sender)
    }
    
    @IBAction func onAddSymptomsTouchUp(_ sender: Any) {
        print("onAddSymptomsTouchUp")
        delegate?.onAddSymptomsTouchUp(sender)
    }
    
    @IBAction func onAddMedicationTouchUp(_ sender: Any) {
        print("onAddMedicationTouchUp")
        delegate?.onAddMedicationTouchUp(sender)
    }
}
