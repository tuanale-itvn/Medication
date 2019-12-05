//
//  HomeTodayCollectionViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/5/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class HomeTodayCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeTodayCollectionViewCell"

    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mLableMedicationName: UILabel!
    @IBOutlet weak var mLableMedicationTablet: UILabel!
    @IBOutlet weak var mLableTimeInDay: UILabel!
    @IBOutlet weak var mLableMeal: UILabel!
    @IBOutlet weak var mButtonYes: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initUI()
    }
    
    func initUI() {
        mContentView.layer.cornerRadius = 8
    }
    func loadData(record:MedicationRecordModel) {
        mLableMedicationName.text = record.mMedicationName
        mLableMedicationTablet.text = String(record.mDose) + " Tablet"
        mLableTimeInDay.text = String(record.mFrequencyInDay) + " Time in a day"
        print("take medication: ", record.mTakeMedication)
        if record.mTakeMedication == MedicationRecordModel.TAKE_MEDICATION.AFTER_MEAL{
            mLableMeal.text = "After meal"
        }
        else {mLableMeal.text = "Before meal"}
    }
    
    @IBAction func touchUpYesButton(_ sender: Any) {
        self.mContentView.isUserInteractionEnabled = false
        self.mContentView.alpha = 0.3
    }
    
}
