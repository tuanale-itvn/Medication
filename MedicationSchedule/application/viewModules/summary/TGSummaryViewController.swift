//
//  TGSummaryViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/27/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TGSummaryViewController: UIViewController {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet var mContraintTableHeight: NSLayoutConstraint!

    var mMedicationList = [DateSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerTableView()
        mTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    func registerTableView() {
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.register(UINib.init(nibName: "SummaryTableViewCell", bundle: nil), forCellReuseIdentifier: SummaryTableViewCell.identifier)
    }
}

/*Handle logic control for today medication */
extension TGSummaryViewController{
    func loadData(){
        //TODO - Handle loading dialog view
        ControllManager.instance.loadMedicationRecord{(medicationsModel, status, message) in
            print("Message load medication record list: \(message)")
            if(status) {
                self.mMedicationList = DateSection.group(records: medicationsModel)
                self.mMedicationList.sort { lhs, rhs in lhs.date < rhs.date }
                self.mTableView.reloadData()
                self.mTableView.layoutIfNeeded()
                self.mContraintTableHeight!.constant = self.mTableView!.contentSize.height
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

extension TGSummaryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mMedicationList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.mMedicationList[section]
        let date = section.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_VALUE.DATE_FORMAT
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.mMedicationList[section]
        return section.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell

        let section = self.mMedicationList[indexPath.section]
        let record = section.records[indexPath.row]
        cell.mTime.text = record.mMedicationTime
        cell.mLable.text = record.mMedicationName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
        myLabel.font = UIFont.boldSystemFont(ofSize: 17)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

private func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}
private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = DEFAULT_VALUE.DATE_FORMAT
    return dateFormat.date(from: str)!
}
struct DateSection {
    var date : Date
    var records : [MedicationRecordModel]
    
    static func group(records : [MedicationRecordModel]) -> [DateSection] {
        let groups = Dictionary(grouping: records) { record in
            firstDayOfMonth(date: parseDate(record.mDoctorVisitTime))
        }
        return groups.map(DateSection.init(date:records:))

    }
}
