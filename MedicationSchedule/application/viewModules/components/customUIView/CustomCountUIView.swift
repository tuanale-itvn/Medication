//
//  CustomCountUIView.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/3/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class CustomCountUIView: UIView {
    @IBOutlet var mContentView: UIView!
    @IBOutlet weak var mLableValue: UILabel!
    
    var mValue:Int = 0;
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    func initial() -> Void {
        Bundle.main.loadNibNamed("CustomCountUIView", owner: self, options: nil)
        addSubview(mContentView)
        mContentView.frame = self.bounds
        mContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mValue = 0
        mLableValue.text = String(mValue)
    }

    @IBAction func touchValueUp(_ sender: Any) {
        if mValue < 9 && mValue >= 0{
            mValue = mValue + 1
        }
        mLableValue.text = String(mValue)
    }
    
    @IBAction func touchValueDown(_ sender: Any) {
        if mValue > 0 && mValue <= 9{
            mValue = mValue - 1
        }
        mLableValue.text = String(mValue)
    }
    
    func getValue()-> Int{
        if mValue <= 9 && mValue >= 0 {
            return mValue
        }
        else {return 0}
    }
    func resetValue(){
        mValue = 0
        mLableValue.text = "0"
    }
}
