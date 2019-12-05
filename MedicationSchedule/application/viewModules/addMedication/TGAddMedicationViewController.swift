//
//  TGAddMedicationViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/27/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TGAddMedicationViewController: UIViewController {
    //Outlet
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var mAddMedication: UIButton!
    @IBOutlet var mContraintTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mBottomView: UIView!
    
    //Variable
    var mListMedication: [MedicationRecordModel] = []
    var isShowAddMedicationCell:Bool = false
    var mDateDoctorVisit:String = ""
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.initData()//init data
        self.registerTableView()//register table cell
        self.setupUI()//first setup for ui
        self.loadData()//load data from data-base
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.setupNavigationBar(animated: animated)
    }
    
    /*Init data for view */
    func initData() {
        self.isShowAddMedicationCell = false;
        self.mAddMedication.tag = TGAddMedicationViewController.ADD_MEDICATION_STATE.ADD_STATE.rawValue;
    }
    
    /*Setup navigation bar for view*/
    func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor.init(red:256,green:256,blue:256, alpha: 1)
        navigationController?.navigationBar.topItem?.hidesBackButton = false
        navigationController?.navigationBar.topItem?.title = "Back"
        self.navigationItem.title = "Add Prescribed Medication"
    }
    
    func registerTableView() {
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.register(UINib.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: SelectDateTableViewCell.identifier)
        mTableView.register(UINib.init(nibName: "AddNewMedicationTableViewCell", bundle: nil), forCellReuseIdentifier: AddNewMedicationTableViewCell.identifier)
        mTableView.register(UINib.init(nibName: "MedicationNameTableViewCell", bundle: nil), forCellReuseIdentifier: MedicationNameTableViewCell.identifier)
    }

    func setupUI() {
        mAddMedication.layer.cornerRadius = 8
        mTableView.rowHeight = UITableView.automaticDimension
        mAddMedication.setTitle("ADD", for: UIControl.State.normal)
        self.mContentView.layer.cornerRadius = 8
        let colorGray: UIColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        self.mContentView.dropShadow(color: colorGray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
        self.mTableView.layer.masksToBounds = true
        self.mTableView.layer.cornerRadius = 8
    }
    
    func updateUI() {
        self.mTableView.reloadData()
        self.mTableView.layoutIfNeeded()
        if (self.mTableView.frame.origin.y + self.mTableView!.contentSize.height) >= self.mBottomView.frame.origin.y{
            self.mContraintTableHeight.isActive = false
        }
        else{
            self.mContraintTableHeight!.isActive = true
            self.mContraintTableHeight!.constant = self.mTableView!.contentSize.height
        }
    }
    
    func setDateOfDoctorVisit(date:String) {
        mDateDoctorVisit = date
    }
    
    func getDateOfDoctorVisit() -> String {
        if mDateDoctorVisit.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
            return dateFormatter.string(from: NSDate() as Date)
        }
        else{
            return mDateDoctorVisit
        }
    }
    
    @IBAction func addMedicationTouchUp(_ sender: Any) {
        //Change button from add to cancel
        if mAddMedication.tag == TGAddMedicationViewController.ADD_MEDICATION_STATE.ADD_STATE.rawValue {
            mAddMedication.tag = TGAddMedicationViewController.ADD_MEDICATION_STATE.CANCEL_STATE.rawValue
            isShowAddMedicationCell = true
            mAddMedication.setTitle("CANCEL", for: UIControl.State.normal)
        }
        //Change button from cancel to add
        else {
            mAddMedication.tag = TGAddMedicationViewController.ADD_MEDICATION_STATE.ADD_STATE.rawValue
            isShowAddMedicationCell = false
            mAddMedication.setTitle("ADD", for: UIControl.State.normal)
        }
        self.updateUI() // Update constraint for tableview
    }
}

/*Handle logic control for add medication */
extension TGAddMedicationViewController{
    func loadData(){
        //TODO - Handle loading dialog view
        ControllManager.instance.loadMedicationRecord{(medicationsModel, status, message) in
            print("Message load medication record list: \(message)")
            if(status) {
                self.mListMedication = medicationsModel
                self.updateUI()// Update constraint for tableview
            } else {
                //TODO: - Show error
            }
        }
    }
}

/*Handle table view for UI*/
extension TGAddMedicationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        /*Handle section of date*/
        case SECTION_TABLE.DATE.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.identifier, for: indexPath) as! SelectDateTableViewCell
            cell.delegate = self
            cell.mDateLable.inputAccessoryView = cell.addToolBarForDatePicker(view: self)
            return cell
        /*Handle section of list medication record added*/
        case SECTION_TABLE.MEDICATIONLIST.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: MedicationNameTableViewCell.identifier, for: indexPath) as! MedicationNameTableViewCell
            cell.setName(name: mListMedication[indexPath.row].mMedicationName)
            return cell
        /*Handle section of add new 1 medication record*/
        case SECTION_TABLE.NEWMEDICATION.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: AddNewMedicationTableViewCell.identifier, for: indexPath) as! AddNewMedicationTableViewCell
            cell.isHidden = !self.isShowAddMedicationCell //Hidden this cell when to load in view
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.mLableAddTime.inputAccessoryView = cell.addToolBarForDatePicker(view: self)
            cell.delegate = self
            return cell
        default:
            let cell = mTableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.identifier, for: indexPath) as! SelectDateTableViewCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTION_TABLE.COUNT.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Row of section medication record*/
        if section == SECTION_TABLE.MEDICATIONLIST.rawValue {
            return mListMedication.count;
        }
        /*Other section have row is: 1*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SECTION_TABLE.NEWMEDICATION.rawValue:
            if self.isShowAddMedicationCell{
                return CGFloat(DEFAULT_VALUE.NEWMEDICATION_HEIGHT_OF_CELL)
            }
            else {return 0}
        default:
            return CGFloat(DEFAULT_VALUE.NORMAL_HEIGHT_OF_CELL)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
