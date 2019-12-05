//
//  ControllManager.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/30/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import Foundation
import SQLite

class ControllManager {
    //Data manager
    var mDataManager:SqliteDBServices = SqliteDBServices.instance
    
    static let instance : ControllManager = {
        let instance = ControllManager()
        return instance
    }()
    
    init() {
        print ("init controlManager")
        mDataManager = SqliteDBServices.instance
        var _ = self.createMedicationRecordTable()
    }
    
    func loadMedicationRecord(completion : @escaping(_ listRecord: [MedicationRecordModel],_ status: Bool,_ message: String) -> ()) {
        let medications = mDataManager.getDataFrom(table: MedicationRecordModel.getTable())
        var result:[MedicationRecordModel] = []
        if medications != nil {
            for medication in medications! {
                let medicationModel = MedicationRecordModel.init(id: medication[MedicationRecordModel.getColumnID()], doctorVisitTime: medication[MedicationRecordModel.getColumnDoctorVisitTime()], medicationName: medication[MedicationRecordModel.getColumnMedicationName()], dose: medication[MedicationRecordModel.getColumnDose()], frequency: medication[MedicationRecordModel.getColumnFrequencyInDay()], takeMedication:MedicationRecordModel.TAKE_MEDICATION(rawValue: medication[MedicationRecordModel.getColumnTakeMedication()]) ?? MedicationRecordModel.TAKE_MEDICATION.AFTER_MEAL, medicationTime: medication[MedicationRecordModel.getColumnMedicationTime()])
                result.append(medicationModel)
                print("take medication: ", medication[MedicationRecordModel.getColumnTakeMedication()])
            }
            completion(result ,true, "Suscess")
        }
        else{
            completion(result ,false, "Fails")
        }
    }
    
    func createMedicationRecordTable() -> Bool{
        print ("createMedicationRecordTable")
        if !mDataManager.isExistTable(table: MedicationRecordModel.getTable()){
            print ("create new table")
            let medicationRecordTable = MedicationRecordModel.getTable()
            let createTable = medicationRecordTable.create { (table) in
                table.column(MedicationRecordModel.getColumnID(), primaryKey: true)
                table.column(MedicationRecordModel.getColumnDoctorVisitTime())
                table.column(MedicationRecordModel.getColumnMedicationName())
                table.column(MedicationRecordModel.getColumnDose())
                table.column(MedicationRecordModel.getColumnFrequencyInDay())
                table.column(MedicationRecordModel.getColumnTakeMedication())
                table.column(MedicationRecordModel.getColumnMedicationTime())
            }
            return mDataManager.executeCreate(query: createTable)
        }
        print ("table already exist")
        return false
    }
    
    func insertMedicationRecord(medication:MedicationRecordModel, completion : @escaping(_ status: Bool,_ message: String) -> ()) {
        print ("insertMedicationRecord")
        if mDataManager.isExistTable(table: MedicationRecordModel.getTable()){
            let medicationRecordTable = MedicationRecordModel.getTable()
            print ("insert new record")
            let insertMedication = medicationRecordTable.insert(
                                MedicationRecordModel.getColumnDoctorVisitTime() <- medication.mDoctorVisitTime,
                                MedicationRecordModel.getColumnMedicationName() <- medication.mMedicationName,
                                MedicationRecordModel.getColumnDose() <- medication.mDose,
                                MedicationRecordModel.getColumnFrequencyInDay() <- medication.mFrequencyInDay,
                                MedicationRecordModel.getColumnTakeMedication() <- medication.mTakeMedication.rawValue,
                                MedicationRecordModel.getColumnMedicationTime() <-
                                    medication.mMedicationTime)
            
            var _ = mDataManager.executeInsert(insert: insertMedication)
            completion(true, "Suscess")
        }
        else{
            print ("table not exist")
            var _=self.createMedicationRecordTable()
            completion(false, "Fail")
        }
        completion(false, "Fail")
    }
}
