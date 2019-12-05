//
//  SqliteDBServices.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/29/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import Foundation
import SQLite

class SqliteDBServices {
    var mDatabase: Connection!
    
    static let instance : SqliteDBServices = {
        let instance = SqliteDBServices()
        return instance
    }()
    
    init() {
        self.initDataBase()
    }
    
    /*
     * Init data base
     */
    func initDataBase(){
        print("init DataBase")
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.mDatabase = database
        } catch {
            print(error)
        }
    }
    
    func isExistTable(table:Table) -> Bool {
        var isExist = false
        do {
            var _ = try mDatabase.scalar(table.exists)
            isExist = true
        } catch {
            isExist = false
            print(error)
        }
        return isExist
    }
    
    func executeCreate(query:String) -> Bool{
        print("execute Create")
        do {
            try self.mDatabase.run(query)
            print("Create sucess")
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func executeInsert(insert:Insert) -> Bool{
        print("execute Insert")
        do {
            try self.mDatabase.run(insert)
            print("Insert sucess")
            return true
        } catch {
            print(error)
            return false
        }
    }

    func getDataFrom(table: Table) -> AnySequence<Row>?{
        print("execute printf Medication")
        do {
            let medications = try self.mDatabase.prepare(table)
            return medications
        } catch {
            print(error)
            return nil
        }
    }
}
