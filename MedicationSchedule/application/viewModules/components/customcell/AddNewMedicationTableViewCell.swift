//
//  AddNewMedicationTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/29/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation

class AddNewMedicationTableViewCell: UITableViewCell {
    static let identifier = "AddNewMedicationTableViewCell"
    //Outlet
    @IBOutlet weak var mMedicationName: UITextField!
    @IBOutlet weak var mDose: CustomCountUIView!
    @IBOutlet weak var mFrequency: CustomCountUIView!
    @IBOutlet weak var mLableAddTime: UITextField!
    @IBOutlet weak var mLableTakeMedicationBefore: UILabel!
    @IBOutlet weak var mLableTakeMedicationAfter: UILabel!
    
    /*Variable of view */
    var delegate : TGAddMedicationViewController? = nil
    var mIsTakeMedicationAfterMeal:Bool = true;
    var mTimeString:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()//Init UI
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initUI(){
        // Init for Take Medication default value
        let tapAfter = UITapGestureRecognizer(target: self, action: #selector(AddNewMedicationTableViewCell.tapTakeMedicationAfter))
        mLableTakeMedicationAfter.isUserInteractionEnabled = true
        mLableTakeMedicationAfter.addGestureRecognizer(tapAfter)

        let tapBefore = UITapGestureRecognizer(target: self, action: #selector(AddNewMedicationTableViewCell.tapTakeMedicationBefore))
        mLableTakeMedicationBefore.isUserInteractionEnabled = true
        mLableTakeMedicationBefore.addGestureRecognizer(tapBefore)

        mIsTakeMedicationAfterMeal = true
        let medicationAfterText = NSAttributedString(string: "After",
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        mLableTakeMedicationAfter.attributedText = medicationAfterText
        
        let medicationBeforeText = NSAttributedString(string: "Before",
                                                      attributes: nil)
        mLableTakeMedicationBefore.attributedText = medicationBeforeText
    }
    
    @objc func tapTakeMedicationAfter(sender:UITapGestureRecognizer) {
        print("tap takeMedicationAfter")
        if !mIsTakeMedicationAfterMeal {
            mIsTakeMedicationAfterMeal = true;
            let medicationAfterText = NSAttributedString(string: "After",
                                                         attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            mLableTakeMedicationAfter.attributedText = medicationAfterText
            let medicationBeforeText = NSAttributedString(string: "Before",
                                                          attributes: nil)
            mLableTakeMedicationBefore.attributedText = medicationBeforeText
        }
    }

    @objc func tapTakeMedicationBefore(sender:UITapGestureRecognizer) {
        print("tap takeMedicationBefore")
        if mIsTakeMedicationAfterMeal {
            mIsTakeMedicationAfterMeal = false;
            let medicationAfterText = NSAttributedString(string: "After",
                                                         attributes: nil)
            mLableTakeMedicationAfter.attributedText = medicationAfterText
            
            let medicationBeforeText = NSAttributedString(string: "Before",
                                                          attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            mLableTakeMedicationBefore.attributedText = medicationBeforeText
        }
    }

    @IBAction func touchUpSave(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        let todayString:String = dateFormatter.string(from: NSDate() as Date)
        if mMedicationName.text!.isEmpty {mMedicationName.text = "DEFAULT MEDICATION NAME"} //Set default value for name of medication
        
        let newMedication:MedicationRecordModel = MedicationRecordModel.init(id: 0, doctorVisitTime: delegate?.getDateOfDoctorVisit() ?? todayString, medicationName: mMedicationName.text ?? "DEFAULT MEDICATION NAME", dose: mDose.getValue(), frequency: mFrequency.getValue(), takeMedication: MedicationRecordModel.TAKE_MEDICATION.BEFORE_MEAL, medicationTime: mTimeString)
        
        ControllManager.instance.insertMedicationRecord(medication: newMedication){(status, message) in
            print("Message load medication record list: \(message)")
            if(status) {
                self.delegate?.loadData()
                self.resetData()
                //TODO - Show done dialog in view
            } else {
                //TODO: - Show error
            }
        }
    }
    
    /*Reset data when to save done*/
    func resetData() {
        self.initUI()
        self.mMedicationName.text = ""
        self.mFrequency.resetValue()
        self.mDose.resetValue()
        self.mTimeString = ""
        self.mLableAddTime.text = ""
    }
}

extension AddNewMedicationTableViewCell : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    @IBAction func touchupCamera(_ sender: Any) {
        if self.checkCameraAccess(){
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.delegate!.present(imagePicker, animated: true, completion: nil)
            }
            else {presentCameraSettings()}
        }
    }
    
    func checkCameraAccess() -> Bool{
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            presentCameraSettings()
            return false
        case .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
            return false
        default:
            return false
        }
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is error",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        delegate!.present(alertController, animated: true)
    }
}

/*Handle for UIView of select time of medication*/
extension AddNewMedicationTableViewCell{
    @IBAction func editTimeChange(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddNewMedicationTableViewCell.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    /*Value change of picker view*/
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.TIME_FORMAT
        if self.mTimeString.isEmpty {
            mLableAddTime.text = dateFormatter.string(from: sender.date)
        }
        else {
            mLableAddTime.text = self.mTimeString + ", " + dateFormatter.string(from: sender.date)
        }
    }
    
    /*Handle toolbar for picker view*/
    func addToolBarForDatePicker(view:TGAddMedicationViewController) -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x:0, y:view.view.frame.size.height/6, width: view.view.frame.size.width, height:40.0))
        toolBar.layer.position = CGPoint(x: view.view.frame.size.width/2, y: view.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.view.frame.size.width / 3, height: view.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select time of Medication"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        return toolBar
    }
    
    /*Press done in picker view*/
    @objc func donePressed(sender: UIBarButtonItem) {
        mLableAddTime.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        let currentTime:String = dateFormatter.string(from: NSDate() as Date)
        if self.mTimeString.isEmpty {
            self.mTimeString =  mLableAddTime.text ?? currentTime //If can not get value of time => using current time
        }
        else {
            let time:String = mLableAddTime.text ?? currentTime //If can not get value of time => using current time
            self.mTimeString = self.mTimeString + ", " + time
        }
    }
}
