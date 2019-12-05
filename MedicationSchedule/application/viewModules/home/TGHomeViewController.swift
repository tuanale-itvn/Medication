//
//  TGHomeViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/27/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TGHomeViewController: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    var mMedicationList: [MedicationRecordModel] = []
    var mMedicationListToday: [MedicationRecordModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar(animated: animated)
        self.loadData()
    }
    
    /*Setup navigation bar for view*/
    func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor.init(red:256,green:256,blue:256, alpha: 1)
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.navigationItem.title = "Medication Schedule"
    }

    /*Register table view cell*/
    func registerTableView() {
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.register(UINib.init(nibName: "UserCustomTableViewCell", bundle: nil), forCellReuseIdentifier: UserCustomTableViewCell.identifier)
        mTableView.register(UINib.init(nibName: "HomeControlButtonTableViewCell", bundle: nil), forCellReuseIdentifier: HomeControlButtonTableViewCell.identifier)
        mTableView.register(UINib.init(nibName: "TitleOfContentTableViewCell", bundle: nil), forCellReuseIdentifier: TitleOfContentTableViewCell.identifier)
        mTableView.register(UINib.init(nibName: "HomeTodayTakeMedicationTableViewCell", bundle: nil), forCellReuseIdentifier: HomeTodayTakeMedicationTableViewCell.identifier)
    }

    /*Touch in summary control*/
    func onSummaryTouchUp(_ sender: Any) {
        print("onSummaryTouchUp")
        let vc = TGSummaryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*Touch in Add Symptoms control*/
    func onAddSymptomsTouchUp(_ sender: Any) {
        print("onAddSymptomsTouchUp")
        let vc = TGAddSymptomsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*Touch in Add Medication control*/
    func onAddMedicationTouchUp(_ sender: Any) {
        print("onAddMedicationTouchUp")
        let vc = TGAddMedicationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*Handle logic control for today medication */
extension TGHomeViewController{
    func loadData(){
        //TODO - Handle loading dialog view
        ControllManager.instance.loadMedicationRecord{(medicationsModel, status, message) in
            print("Message load medication record list: \(message)")
            if(status) {
                self.mMedicationList = medicationsModel
                self.mMedicationListToday = self.filterTodayMedication(records: self.mMedicationList)
                self.mTableView.reloadData()
            } else {
                //TODO: - Show error
            }
        }
    }
    
    //TODO - update condition filter for today take medication
    func filterTodayMedication(records:[MedicationRecordModel]) -> [MedicationRecordModel] {
        var result:[MedicationRecordModel] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        let todayString = dateFormatter.string(from: NSDate() as Date)
        
        for record in records {
            if record.mDoctorVisitTime == todayString{
                result.append(record)
            }
        }
        return result
    }
}

extension TGHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SECTION_TABLE.USER.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: UserCustomTableViewCell.identifier, for: indexPath) as! UserCustomTableViewCell
            return cell
        case SECTION_TABLE.CONTROL.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: HomeControlButtonTableViewCell.identifier, for: indexPath) as! HomeControlButtonTableViewCell
            cell.delegate = self
            return cell
        case SECTION_TABLE.TITLE.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: TitleOfContentTableViewCell.identifier, for: indexPath) as! TitleOfContentTableViewCell
            if(!mMedicationListToday.isEmpty) {
                cell.isDontHaveMedicationToday(isDontHave: false)
            }
            else {cell.isDontHaveMedicationToday(isDontHave: true)}
            return cell
        case SECTION_TABLE.CONTENT.rawValue:
            let cell = mTableView.dequeueReusableCell(withIdentifier: HomeTodayTakeMedicationTableViewCell.identifier, for: indexPath) as! HomeTodayTakeMedicationTableViewCell
            if(!mMedicationListToday.isEmpty) {
                cell.loadCell(categoryList: mMedicationListToday)
            }
            return cell
        default:
            let cell = mTableView.dequeueReusableCell(withIdentifier: UserCustomTableViewCell.identifier, for: indexPath) as! UserCustomTableViewCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTION_TABLE.COUNT.rawValue
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SECTION_TABLE.USER.rawValue:
            return 110
        case SECTION_TABLE.CONTROL.rawValue:
            return 50
        case SECTION_TABLE.TITLE.rawValue:
            return 70
            
        case SECTION_TABLE.CONTENT.rawValue:
            return CGFloat(170 * (mMedicationListToday.count/2 + mMedicationListToday.count%2))
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == SECTION_TABLE.SUGGESTION.rawValue {
//        }
    }
}
