//
//  EnumExtension.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 12/3/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import Foundation
import UIKit

extension TGHomeViewController{
    enum SECTION_TABLE :Int{
        case USER = 0
        case CONTROL
        case TITLE
        case CONTENT
        case COUNT
    }
}

extension TGAddMedicationViewController{
    enum SECTION_TABLE :Int{
        case DATE = 0
        case MEDICATIONLIST
        case NEWMEDICATION
        case COUNT
    }
    enum ADD_MEDICATION_STATE :Int{
        case ADD_STATE = 0
        case CANCEL_STATE
    }
}
