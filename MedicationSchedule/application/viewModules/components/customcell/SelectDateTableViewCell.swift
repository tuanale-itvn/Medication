//
//  SelectDateTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/28/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {

    /*Static variable */
    static let identifier = "SelectDateTableViewCell"
    /***/

    /*UI view control */
    @IBOutlet weak var mDateLable: UITextField!
    /***/

    /*Variable of view */
    var delegate : TGAddMedicationViewController? = nil
    /***/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /*Handle event select in text => show date picker*/
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(SelectDateTableViewCell.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    /*Event picker change value*/
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        mDateLable.text = dateFormatter.string(from: sender.date)
    }
    
    /*Press done button in the date picker view*/
    @objc func donePressed(sender: UIBarButtonItem) {
        mDateLable.resignFirstResponder()
        delegate?.setDateOfDoctorVisit(date: mDateLable.text ?? "")
    }
    
    /*Press today button in the date picker view*/
    @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        mDateLable.text = dateFormatter.string(from: NSDate() as Date)
        mDateLable.resignFirstResponder()
        delegate?.setDateOfDoctorVisit(date: mDateLable.text!)
    }
    
    /*Handle add toolbar in the picker view*/
    func addToolBarForDatePicker(view:TGAddMedicationViewController) -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x:0, y:view.view.frame.size.height/6, width: view.view.frame.size.width, height:40.0))
        toolBar.layer.position = CGPoint(x: view.view.frame.size.width/2, y: view.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(tappedToolBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.view.frame.size.width / 3, height: view.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select date of doctor's visit"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        return toolBar
    }
}
