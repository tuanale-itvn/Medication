//
//  MedicationRecordModel.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/29/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import Foundation
import SQLite

class MedicationRecordModel {
    var mID: Int
    var mDoctorVisitTime:String //"dd/mm/yyyy"
    var mMedicationName: String
    var mDose: Int
    var mFrequencyInDay: Int
    var mTakeMedication: TAKE_MEDICATION //1,2
    var mMedicationTime: String //"12:00,01:00,15:00"
    
    init(id:Int, doctorVisitTime:String, medicationName:String, dose:Int, frequency:Int, takeMedication:TAKE_MEDICATION, medicationTime:String) {
        mID = id
        mDoctorVisitTime = doctorVisitTime
        mMedicationName = medicationName
        mDose = dose
        mFrequencyInDay = frequency
        mTakeMedication = takeMedication
        mMedicationTime = medicationTime
    }
    
    static func getTable() -> Table {
        return Table("MedicationRecord")
    }
    
    static func getColumnID() -> Expression<Int> {
        return Expression<Int>("id")
    }
    
    static func getColumnDoctorVisitTime() -> Expression<String> {
        return Expression<String>("DoctorVisitTime")
    }

    static func getColumnMedicationName() -> Expression<String> {
        return Expression<String>("MedicationName")
    }
    
    static func getColumnDose() -> Expression<Int> {
        return Expression<Int>("Dose")
    }
    
    static func getColumnFrequencyInDay() -> Expression<Int> {
        return Expression<Int>("FrequencyInDay")
    }
    
    static func getColumnTakeMedication() -> Expression<Int> {
        return Expression<Int>("TakeMedication")
    }
    
    static func getColumnMedicationTime() -> Expression<String> {
        return Expression<String>("MedicationTime")
    }
}

extension MedicationRecordModel{
    enum TAKE_MEDICATION :Int{
        case BEFORE_MEAL = 0
        case AFTER_MEAL
    }
}
