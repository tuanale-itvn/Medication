//
//  HomeTodayTakeMedicationTableViewCell.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/5/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class HomeTodayTakeMedicationTableViewCell: UITableViewCell {
    static let identifier = "HomeTodayTakeMedicationTableViewCell"
    @IBOutlet weak var mCollectionView: UICollectionView!

    var mMedicationModel: [MedicationRecordModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCollectionCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //Load data
    func loadCell(categoryList list: [MedicationRecordModel]) {
        mMedicationModel = list
        self.mCollectionView.reloadData()
    }
    
    func registerCollectionCell() {
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.register(UINib.init(nibName: "HomeTodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeTodayCollectionViewCell.identifier)
    }
}

//Handle collection view
extension HomeTodayTakeMedicationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mMedicationModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mCollectionView.dequeueReusableCell(withReuseIdentifier: HomeTodayCollectionViewCell.identifier, for: indexPath)  as! HomeTodayCollectionViewCell
        let record = mMedicationModel[indexPath.row]
        cell.loadData(record:record)
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.didSelectCategory(withCategory: mMedicationModel[indexPath.row])
    }
}

extension HomeTodayTakeMedicationTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
protocol HomeFoodCategoryDelegate {
    //func didSelectCategory(withCategory category:CategoryModel)
}
