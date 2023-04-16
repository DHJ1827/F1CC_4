//
//  DBHandler.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import Foundation
import GRDB
import SwiftUI

var dbQueue: DatabaseQueue!
var dbName = "/dbF1CC6.sqlite"


class DBHandler: ObservableObject {
    
    @Published var sDriver: [[String]] = Array(repeating: [String](repeating: "1", count: 33), count: 661)
    @Published var sPart: [[String]] = Array(repeating: [String](repeating: "1", count: 32), count: 463)
    @Published var sMult: [[String]] = Array(repeating: [String](repeating: "1", count: 2), count: 13)
    @Published var sCard: [[String]] = Array(repeating: [String](repeating: "1", count: 3), count: 13)
    @Published var bDriverBoost: [Bool] = Array(repeating: false, count: 661)
    @Published var sSelectedMode: String = "basicMode"
    @Published var photoNum: String = "F11" + String(Int.random(in: 1...3))
    @Published var adMobCtr: Int = 3
    @Published var bFirstTimeLoad: Bool = false
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first!
    
    
    // ******************************************
    // ******************************************
    
    func setup() throws {
        // 1. Open a database connection
        let dbQueue = try DatabaseQueue(path: path + dbName)
        print("!!!DB location: ", path)
        // 2. Define the database schema- only runs if dbF1CC doesn't exist
        do {
            try dbQueue.write { db in
                try db.execute(literal:"""
                                  create table driver (
                                  driver_pk integer primary key autoincrement,
                                  driver_name text,
                                  driver_level text,
                                  driver_over text,
                                  driver_defend text,
                                  driver_consist text,
                                  driver_fuel text,
                                  driver_tire text,
                                  driver_wet text,
                                  driver_upgrade_coin_cost text,
                                  driver_cumul_coin_cost text,
                                  driver_asset_level text,
                                  driver_ten_percent text,
                                  driver_current_level text,
                                  driver_available_cards text,
                                  driver_max_level text)
                               """)
            }
            
            try dbQueue.write { db in
                try db.execute(literal:"""
                                create table part (
                                part_pk integer primary key autoincrement,
                                part_category text,
                                part_name text,
                                part_level text,
                                part_power text,
                                part_aero text,
                                part_grip text,
                                part_reliability text,
                                part_pit_stop_time text,
                                part_upgrade_coin_cost text,
                                part_upgrade_cumul_coin_cost text,
                                part_asset_level text,
                                part_ten_percent text,
                                part_current_level text,
                                part_available_cards text,
                                part_max_level text)
                               """)
            }
            try dbQueue.write { db in
                try db.execute(literal:"""
                                create table card_upgrade (
                                card_upgrade_pk integer primary key autoincrement,
                                card_upgrade_level text,
                                card_upgrade_upgrade_cost text,
                                card_upgrade_cumul_cost text)
                                """)
            }
            
            try dbQueue.write { db in
                try db.execute(literal:"""
                                create table mult (
                                mult_pk integer primary key autoincrement,
                                mult_name text,
                                mult_value text)
                               """)
            }
            
            
            if let path = Bundle.main.url(forResource: "testdata5.txt", withExtension: "") {
                print("!!File loaded...")
                let content = try? String(contentsOf: path)
                let fileData = content!.components(separatedBy: "\n")
                var fileArray = fileData[1].components(separatedBy: ",")
                // text files rows: 1-660,661-1122,1123-1134,1135-1146  --> 0-659, 660-1121, 1122-1133, 1134-1145
                for i in 0...659 {    // 660 rows in driver
                    fileArray = fileData[i].components(separatedBy: ",")
                    print(fileArray[0], fileArray[1])
                    try dbQueue.inDatabase { db in
                        try db.execute(literal:"""
                            INSERT INTO driver (driver_name, driver_level, driver_over, driver_defend, driver_consist, driver_fuel , driver_tire, driver_wet, driver_upgrade_coin_cost, driver_cumul_coin_cost, driver_asset_level, driver_ten_percent,driver_current_level, driver_available_cards, driver_max_level) VALUES (\(fileArray[0]),\(fileArray[1]), \(fileArray[2]),\(fileArray[3]), \(fileArray[4]), \(fileArray[5]), \(fileArray[6]), \(fileArray[7]),\(fileArray[8]), \(fileArray[9]),\(fileArray[10]),\(fileArray[11]),\(fileArray[12]),\(fileArray[13]),\(fileArray[14]))
                            """)
                        print("Inserted into driver: ", db.lastInsertedRowID)
                    }   // end of db write/insert
                }   // end of for driver loop
                
                for i in 660...1121 {    // 462 rows in part
                    fileArray = fileData[i].components(separatedBy: ",")
                    try dbQueue.inDatabase { db in
                        try db.execute(literal:"""
                            INSERT INTO part (part_category, part_name, part_level, part_power, part_aero, part_grip, part_reliability, part_pit_stop_time, part_upgrade_coin_cost, part_upgrade_cumul_coin_cost, part_asset_level, part_ten_percent, part_current_level, part_available_cards, part_max_level) VALUES (\(fileArray[0]),\(fileArray[1]), \(fileArray[2]),\(fileArray[3]), \(fileArray[4]), \(fileArray[5]), \(fileArray[6]), \(fileArray[7]),\(fileArray[8]), \(fileArray[9]),\(fileArray[10]),\(fileArray[11]),\(fileArray[12]),\(fileArray[13]),\(fileArray[14]))
                            """)
                        //print("Inserted into part: ", db.lastInsertedRowID)
                    }   // end of db write/insert
                }   // end of for part loop
                
                for i in 1122...1133 {    // 12 rows in card_upgrade
                    fileArray = fileData[i].components(separatedBy: ",")
                    try dbQueue.inDatabase { db in
                        try db.execute(literal:"""
                            INSERT INTO card_upgrade (card_upgrade_level, card_upgrade_upgrade_cost, card_upgrade_cumul_cost) VALUES (\(fileArray[0]),\(fileArray[1]), \(fileArray[2]))
                            """)
                        //print("Inserted into cards_upgrade ", db.lastInsertedRowID)
                    }   // end of db write/insert
                }   // end of for cards loop
                
                for i in 1134...1145 {    // 12 rows in mult
                    fileArray = fileData[i].components(separatedBy: ",")
                    try dbQueue.inDatabase { db in
                        try db.execute(literal:"""
                            INSERT INTO mult (mult_name, mult_value) VALUES (\(fileArray[0]),\(fileArray[1]))
                            """)
                        //print("Inserted into mult: ", db.lastInsertedRowID)
                    }   // end of db write/insert
                }   // end of for mult loop
                bFirstTimeLoad = true
            } else {
                print("dummy, added for code readability")
            }
        } catch {
            print("!!!!   DB already exists with sDriver[0][29] = \(sDriver[0][29])   !!!!")
        }
        
        print("!!!! bFirstTimeLoad leaving dbHandler= \(bFirstTimeLoad)")
    }
    
    // ******************************************
    // ******************************************
    
    
    func dbReadMult() throws -> [[String]]  {
        let dbQueue = try DatabaseQueue(path: path + dbName)
        return try dbQueue.read { db -> [[String]] in     // if fetch fails, returns nil
            let rows = try Row.fetchAll(db, sql: "SELECT * FROM " + "mult")
            var row_ctr = 0
            var arrRow = ["1","2"]
            var arrReturned = [[String]]()
            for row in rows {
                arrRow[0] =  row["mult_name"]
                arrRow[1] =  row["mult_value"]
                arrReturned.append(arrRow)
                row_ctr = row_ctr + 1
            }
            //print("arrReturned= ", arrReturned)
            return(arrReturned)
        }
    }
    
    // ******************************************
    // ******************************************
    
    func tester() -> String {
        return("Done")
    }
    
    
    func dbReadCards() throws -> [[String]]  {
        let dbQueue = try DatabaseQueue(path: path + dbName)
        return try dbQueue.read { db -> [[String]] in     // if fetch fails, returns nil
            let rows = try Row.fetchAll(db, sql: "SELECT * FROM " + "card_upgrade")
            var row_ctr = 0
            var arrRow = ["1","2","3"]
            var arrReturned = [[String]]()
            for row in rows {
                arrRow[0] =  row["card_upgrade_level"]
                arrRow[1] =  row["card_upgrade_upgrade_cost"]
                arrRow[2] =  row["card_upgrade_cumul_cost"]
                arrReturned.append(arrRow)
                row_ctr = row_ctr + 1
            }
            return(arrReturned)
        }
    }
    
    // ******************************************
    // ******************************************
    
    func dbReadDriver() throws -> [[String]]  {
        let dbQueue = try DatabaseQueue(path: path + dbName)
        return try dbQueue.read { db -> [[String]] in     // if fetch fails, returns nil
            let rows = try Row.fetchAll(db, sql: "SELECT * FROM " + "driver")
            var row_ctr = 0
            var arrRow = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]    //len = 33 ie. [0]->[32]
            var arrReturned = [[String]]()
            for row in rows {
                arrRow[0] = "0"
                arrRow[1] =  row["driver_name"]
                arrRow[2] =  row["driver_level"]
                arrRow[3] = row["driver_over"]
                arrRow[4] = row["driver_defend"]
                arrRow[5] = row["driver_consist"]
                arrRow[6] = row["driver_fuel"]
                arrRow[7] = row["driver_tire"]
                arrRow[8] = row["driver_wet"]
                arrRow[9] = row["driver_upgrade_coin_cost"]
                arrRow[10] = row["driver_cumul_coin_cost"]
                arrRow[13] = row["driver_asset_level"]
                arrRow[14] = row["driver_ten_percent"]
                arrRow[15] = row["driver_current_level"]
                arrRow[20] = row["driver_available_cards"]
                arrRow[29] = row["driver_max_level"]
                arrRow[31] = "0"
                arrRow[32] = "0"
                arrReturned.append(arrRow)
                row_ctr = row_ctr + 1
            }

            return(arrReturned)
        }
    }
    
    // ******************************************
    // ******************************************
    
    func dbReadPart() throws -> [[String]]  {
        let dbQueue = try DatabaseQueue(path: path + dbName)
        return try dbQueue.read { db -> [[String]] in     // if fetch fails, returns nil
            let rows = try Row.fetchAll(db, sql: "SELECT * FROM " + "part")
            var row_ctr = 0
            //var arrRow = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
            var arrRow = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]    //len = 33 ie. [0]->[32]
            var arrReturned = [[String]]()
            for row in rows {
                arrRow[0] = row["part_category"]
                arrRow[1] =  row["part_name"]
                arrRow[2] =  row["part_level"]
                arrRow[3] = row["part_power"]
                arrRow[4] = row["part_aero"]
                arrRow[5] = row["part_grip"]
                arrRow[6] = row["part_reliability"]
                arrRow[7] = row["part_pit_stop_time"]
                arrRow[8] = "0"   // dummy
                arrRow[9] = row["part_upgrade_coin_cost"]
                arrRow[10] = row["part_upgrade_cumul_coin_cost"]
                arrRow[13] = row["part_asset_level"]
                arrRow[14] = row["part_ten_percent"]
                arrRow[15] = row["part_current_level"]
                arrRow[20] = row["part_available_cards"]
                arrRow[29] = row["part_max_level"]
                arrRow[31] = "0"
                arrRow[32] = "0"
                arrReturned.append(arrRow)
                row_ctr = row_ctr + 1
            }
            return(arrReturned)
        }
    }
    
    // ******************************************
    // ******************************************e
    
    func dbReadDriverBoost(sDriver: [[String]], bDriverBoost: [Bool]) throws -> [Bool] {
        var bDriverBoostt = bDriverBoost
        return bDriverBoostt
    }
    
    // ******************************************
    // ******************************************e
    
    func updateDriver(sDriver: [[String]]) throws -> [[String]]  {
        var sDriverr = sDriver
        let dbQueue = try DatabaseQueue(path: path + dbName)
        
        do {
            try dbQueue.write { db in
                
                for i in stride(from: 0, to: 659, by: 11) {
                    try db.execute(literal:"""
                        UPDATE driver SET driver_current_level = \(sDriverr[i][15]), driver_available_cards = \(sDriverr[i][20]), driver_ten_percent = \(sDriverr[i][14]) WHERE driver_pk = \(i+1);
                        """)
                    //}
                }
            }
            //print("db.updateDriver done sDriver [11][1, 15, 20]= ",sDriverr[11][1], sDriverr[11][15], sDriverr[11][20])
            
        } catch {
            print("Error")
        }
        
        return sDriverr
        
    }  //updateDriver()
    
    // ******************************************
    // ******************************************
    
    func updatePart(sPart: [[String]]) throws -> [[String]] {
        var sPartt = sPart
        let dbQueue = try DatabaseQueue(path: path + dbName)
        
        do {
            try dbQueue.write { db in
                for i in stride(from: 0, to: 461, by: 11) {
                    try db.execute(literal:"""
                        UPDATE part SET part_current_level = \(sPartt[i][15]), part_available_cards = \(sPartt[i][20]), part_ten_percent = \(sPartt[i][14]) WHERE part_pk = \(i+1);
                        """)
                    //}
                }
                
                //}
                
                
            }
            //print("db.updatePart done sPart [11][1, 15, 20]= ",sPartt[11][1], sPartt[11][15], sPartt[11][20])
            
        } catch {
            print("Error")
        }
        
        return sPartt
    }  //updateDriver()
    // ******************************************
    // ******************************************
    
    func updateMult() throws  {
        
        //print("!!", sMult)
        
        let dbQueue = try DatabaseQueue(path: path + dbName)
        do {
            try dbQueue.write { db in
                //sMult[3][1] = "93"
                for i in 0...11 {
                    try db.execute(literal:"""
                        UPDATE mult SET mult_value = \(sMult[i][1]) WHERE mult_name = \(sMult[i][0]);
                        """)
                }
            }
            //print("db.updateMult done sMult[1][1], sMult[5][1], sMult[11][1]= ",sMultt[1][1],sMultt[5][1],sMultt[11][1])
            
        } catch {
            print("Error")
        }
        //return sMultt
    }        //updateMult()
    
    
    
    func sDriverCalc(sDriver: [[String]], sMult: [[String]], sCard: [[String]], bDriverBoost: [Bool]) -> [[String]] {
        //  Calculate sDriver values
        
        var sDriverr = sDriver
        var sMultt = sMult
        var sCardd = sCard
        
        
        var ACo = Int(sMult[11][1].replacingOccurrences(of: ",", with: ""))!  // available coins
        var tempPLplus1Coins = 0
        var tempPLplus2Coins = 0
        var row_ctr = 0
        
        // **********************************************************************************************************************************************************
        
        // update all [14] and [30] with bDriverBoost values
        //print("\nstart: ", sDriver[11])
        var driver_start = 0
        //print("!!DBH bDriverBoost[0] \(bDriverBoost[0])")
        while (driver_start <= 659) {  //check every 11th row for bDriverBoost = true. If true, then fill in 11 rows of sDriverr
            row_ctr = 0
            while (row_ctr <= 10) {
                //print(driver_start/11)
                if (bDriverBoost[driver_start]) {
                    sDriverr[row_ctr + driver_start][14] = "1.1"
                    sDriverr[row_ctr + driver_start][30] = "5"   //red
                } else {
                    sDriverr[row_ctr + driver_start][14] = "1.0"
                    sDriverr[row_ctr + driver_start][30] = "4"  //black
                }
                //print("sDriverr: ", row_ctr + driver_start, sDriverr[row_ctr + driver_start][14])
                row_ctr = row_ctr + 1
            }
            driver_start = driver_start + 11
        }
        //print ("!!DBH 385: ", sDriverr[0][14], sDriverr[11][14], sDriverr[22][14], sDriverr[33][14],",", bDriverBoost[0], bDriverBoost[11], bDriverBoost[22], bDriverBoost[33],"\n\n**********\n********\n\n")
        
        
        // **********************************************************************************************************************************************************
        // weighted rating and 10% font colours
        // sum of atributes x mult values
        // if [14] is 10% then change font to red
        
        row_ctr = 0
        while row_ctr <= 659 {
            
            // update font colours for 10%
            if (sDriverr[row_ctr][14] == "1.1") {
                sDriverr[row_ctr][30] = "5"   //red
            } else {
                sDriverr[row_ctr][30] = "4"  //black
            }
            
            // multiply the weighted ratings by any 10% boost
            var dbl1 = Double(Int(sDriverr[row_ctr][3])! * Int(sMultt[5][1])! + Int(sDriverr[row_ctr][4])! * Int(sMultt[6][1])! + Int(sDriverr[row_ctr][5])! * Int(sMultt[7][1])! + Int(sDriverr[row_ctr][6])! * Int(sMultt[8][1])! + Int(sDriverr[row_ctr][7])! * Int(sMultt[9][1])! + Int(sDriverr[row_ctr][8])! * Int(sMultt[10][1])!)
            var dbl2 = Double(sDriverr[row_ctr][14])
            sDriverr[row_ctr][11] = String(format: "%.0f", dbl1 * dbl2!)
            
            
            /*
             sDriverr[row_ctr][11] = String(format: "%.0f", Double(Int(sDriverr[row_ctr][3])! * Int(sMultt[5][1])! + Int(sDriverr[row_ctr][4])! * Int(sMultt[6][1])! + Int(sDriverr[row_ctr][5])! * Int(sMultt[7][1])! + Int(sDriverr[row_ctr][6])! * Int(sMultt[8][1])! + Int(sDriverr[row_ctr][7])! * Int(sMultt[9][1])! + Int(sDriverr[row_ctr][8])! * Int(sMultt[10][1])!) * Double(sDriverr[row_ctr][14]))
             */
            
            //            sDriverr[row_ctr][11] = String(Int(sDriverr[row_ctr][3])! * Int(sMultt[5][1])! + Int(sDriverr[row_ctr][4])! * Int(sMultt[6][1])! + Int(sDriverr[row_ctr][5])! * Int(sMultt[7][1])! + Int(sDriverr[row_ctr][6])! * Int(sMultt[8][1])! + Int(sDriverr[row_ctr][7])! * Int(sMultt[9][1])! + Int(sDriverr[row_ctr][8])! * Int(sMultt[10][1])!)
            row_ctr = row_ctr + 1
        }
        
        // **********************************************************************************************************************************************************
        // NR normalized rating. normalize out of 100. Find max, in [11], for all drivers and use it to normalize all others.
        
        row_ctr = 0
        var maxDriver = 0
        var dTemp: Double = 0.0
        //var dBoost: Double = 1.0
        while row_ctr <= 659 {
            if (Int(sDriverr[row_ctr][11])! > maxDriver) {    //find the max driver rating
                maxDriver = Int(sDriverr[row_ctr][11])!
            }
            row_ctr = row_ctr + 1
        }
        row_ctr = 0
        while row_ctr <= 659 {
            dTemp = Double(sDriverr[row_ctr][11])!
            //dBoost = Double(sDriverr[row_ctr][14])!  //boost of driver
            //dTemp = dTemp * dBoost / Double(maxDriver)
            dTemp = dTemp / Double(maxDriver)
            if (dTemp < 1 ) {
                sDriverr[row_ctr][12] = String(format: "%.1f", 100 * dTemp)   // get the weighted / max, * 100 formatted to 1 decimal
            } else {
                sDriverr[row_ctr][12] = "99.9"
            }
            row_ctr = row_ctr + 1
        }
        
        // **********************************************************************************************************************************************************
        // CR Current Rating for current CL. Get the CL in [15]. Subtract 1 from CL value and add that to the row_ctr to get the CR ie. if CL=1, subtract 1 as a offset so when you add row_ctr, you get a proper CR.
        
        // **** for this driver boost CR, MR and PR. Then update db so if file closes, boost values will be retained
        var tempCL = 0
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempCL = Int(sDriverr[row_ctr][15])! // get CL
            if (tempCL == 0) {    // check to see if CL=0
                sDriverr[row_ctr][16] = "0"  // force PL = 0
            } else {
                sDriverr[row_ctr][16] = sDriverr[row_ctr + tempCL - 1][12]
            }
            row_ctr = row_ctr + 11
        }
        //print ("!!DBH 454 (after CR calc): ", sDriverr[0][16], sDriverr[11][16], sDriverr[22][16], sDriverr[33][16], "")
        // **********************************************************************************************************************************************************
        //NCa Needed Cards to go from CL to CL+1. take the CL[15] and look up its value in sCard [1] to go from CL to CL+1
        
        row_ctr = 0
        while row_ctr <= 659 {
            sDriverr[row_ctr][21] = sCardd[Int(sDriverr[row_ctr][15])!][1]
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //PL Possible Level use all available cards to determine PL. Get the current ACa[20], added to the CL[15]'s value in sCard ie. the number of cumulative cards to date. Find the PL
        
        row_ctr = 0
        var totCards = 0
        while row_ctr <= 659 {
            tempCL = Int(sDriverr[row_ctr][15])! // get CL
            if (tempCL == 0) {
                totCards = 0
                sDriverr[row_ctr][17] = "0"
            } else {
                totCards = Int(sDriverr[row_ctr][20])! + Int(sCardd[tempCL - 1][2])!    // ACa + cumul to date ie. cards[CL-1] for actual cumul cost
            }
            var card_ctr = 11
            while card_ctr >= 0 {   // start at max level 11 and loop down looking where total cards is slightly less than sCard level
                if (totCards >= Int(sCardd[card_ctr][2])! && tempCL > 0) {
                    if (card_ctr == 11) {
                        sDriverr[row_ctr][17] = "11"    // coorect a potential error if CL is high
                    } else {
                        sDriverr[row_ctr][17] = sCardd[card_ctr + 1][0]     //found the PL
                    }
                    break
                }
                card_ctr = card_ctr - 1
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // PR Possible Rating for current PL. Get the PL in [17]. Subtract 1 from PL value and add that to the row_ctr to get the PR ie. if PL=1, subtract 1 as a offset so when you add row_ctr, you get a proper PR.
        
        var tempPL = 0
        row_ctr = 0
        while row_ctr <= 659 {
            tempPL = Int(sDriverr[row_ctr][17])!     // get PL
            if (tempPL == 0) {    // check to see if PL=0
                sDriverr[row_ctr][18] = "0"   // force PR=0
            } else {
                sDriverr[row_ctr][18] = sDriverr[row_ctr + tempPL - 1][12]
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // MR Max Rating for current driver. Add 10 ie. level=11 to row_ctr and look up the normalized NR[12]
        
        row_ctr = 0
        while row_ctr <= 659 {
            sDriverr[row_ctr][19] = sDriverr[row_ctr + 10][12]
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // NCo Needed Coins to get to the PL. First determine the number of coins needed to get to PL[17]. Save it temporarily in [22].Second subtract [22] from the number of coins already spent to get to CL[15]- take the CL[15] and look up its value in sCard to go from CL to CL+1
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempCL = Int(sDriverr[row_ctr][15])!
            tempPL = Int(sDriverr[row_ctr][17])!
            sDriverr[row_ctr][22] = "0"  // assume PL or CL = 0, set an initial value
            if (tempPL > 1) {    // if PL>1
                sDriverr[row_ctr][22] = sDriverr[row_ctr + tempPL - 1][10]  // get the PL cumul coins
            }
            if (tempCL > 1) {    // if CL>1
                sDriverr[row_ctr][22] = String(Int(sDriverr[row_ctr][22])! - Int(sDriverr[row_ctr + tempCL - 1][10])!)  // and subtract the CL cumul coins already spent
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // +PR Possible Rating for current PL + 1
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempPL = Int(sDriverr[row_ctr][17])!
            if ((row_ctr + tempPL) <= 659) {   // check if [12] is maxed out
                sDriverr[row_ctr][23] = sDriverr[row_ctr + tempPL][12]   //get the NR for at the PL row
            } else {
                sDriverr[row_ctr][23] = sDriverr[row_ctr][12]   //get the NR for at the PL row
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //   ACards/+NCa Needed Cards to go to PL + 1
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempPL = Int(sDriverr[row_ctr][17])!
            if (tempPL == 0) {
                sDriverr[row_ctr][25] = ".000001"  // assume PL = 0, set an initial value
            } else if (tempPL > 10) {    // if PL is to big to jump up +1
                sDriverr[row_ctr][25] = String(Double(sDriverr[row_ctr][20])! / Double(sCardd[tempPL][1])!)
            } else {
                sDriverr[row_ctr][25] = String(Double(sDriverr[row_ctr][20])! / Double(sCardd[tempPL + 1][1])!)
            }
            if (Double(sDriverr[row_ctr][25])! > 1) {
                sDriverr[row_ctr][25] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // ACoins/+NCo Needed Coins to get to the PL+1. Get cumul coins for PL+1 and subtract cumul coins for CL ie. from rows PL to CL-1
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempCL = Int(sDriverr[row_ctr][15])!
            tempPL = Int(sDriverr[row_ctr][17])!
            sDriverr[row_ctr][24] = "0.000001"  // assume PL = 0, set an initial value
            if (tempPL == 11) {
                tempPL = 10        // PL+1 maxes out at 11
            } else {
                tempPLplus1Coins = Int(sDriverr[row_ctr + tempPL][10])!    //get cumul coins for PL+1 ie. row PL
            }

            if (tempCL > 0) {   //  otherwise[24] stays at .0000001
                if (tempPLplus1Coins != Int(sDriverr[row_ctr + tempCL - 1][10])!) {    // handle divide by zero
                    sDriverr[row_ctr][24] =  String( ACo / (tempPLplus1Coins - Int(sDriverr[row_ctr + tempCL - 1][10])!) )
                }
            }
            
            if (Double(sDriverr[row_ctr][24])! > 1) {
                sDriverr[row_ctr][24] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        
        // **********************************************************************************************************************************************************
        // ++PR Possible Rating for current PL + 2
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempPL = Int(sDriverr[row_ctr][17])!
            if (tempPL > 9) {        // if PL > 9 then max out at 11
                sDriverr[row_ctr][26] = sDriverr[row_ctr + 10][12]
            } else {
                sDriverr[row_ctr][26] = sDriverr[row_ctr + tempPL + 2][12]    // jump up 2
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //   ACards/++NCa Needed Cards to go to PL + 2
        
        row_ctr = 0
        while row_ctr <= 659 {
            tempPL = Int(sDriverr[row_ctr][17])!
            if (tempPL == 0) {
                sDriverr[row_ctr][28] = ".000001"  // assume PL = 0, set an initial value
            } else if (tempPL > 9) {    // if PL is to big to jump up + 2
                sDriverr[row_ctr][28] = String(Double(sDriverr[row_ctr][20])! / Double(sCardd[tempPL][1])!)
            } else {
                sDriverr[row_ctr][28] = String(Double(sDriverr[row_ctr][20])! / Double(sCardd[tempPL + 2][1])!)
            }
            if (Double(sDriverr[row_ctr][28])! > 1) {
                sDriverr[row_ctr][28] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // ACoins/+NCo Needed Coins to get to the PL + 2. Get cumul coins for PL+2 and subtract cumul coins for CL ie. from rows PL+1 to CL-1

        
        row_ctr = 0
        while row_ctr <= 659 {
            tempCL = Int(sDriverr[row_ctr][15])!
            tempPL = Int(sDriverr[row_ctr][17])!
            sDriverr[row_ctr][27] = "0.000001"  // assume PL = 0, set an initial value
            if (tempPL > 9) {
                tempPL = 9        // PL+2 maxes out at 11
            } else {
                tempPLplus2Coins = Int(sDriverr[row_ctr + tempPL + 1][10])!    //get cumul coins for PL+2 ie. row PL+1
            }

            if (tempCL > 0) {   //  otherwise[27] stays at .0000001
                var testtt = Int(sDriverr[row_ctr + tempCL - 1][10])!
                if (tempPLplus2Coins != Int(sDriverr[row_ctr + tempCL - 1][10])!) {    // handle divide by 0
                    sDriverr[row_ctr][27] =  String( ACo / (tempPLplus2Coins - Int(sDriverr[row_ctr + tempCL - 1][10])!) )
                }

            }
            if (Double(sDriverr[row_ctr][27])! > 1) {
                sDriverr[row_ctr][27] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // fill in [31] and [32]= true PR when ACo>NCo. [31] is true PL, [32] is [31]'s PR.
        let sMultStripped = sMultt[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
        var ctrCL = 0
        var ctrPL = 0
        var ctrNCo = 0
        var startNCo = 0
        row_ctr = 0
        
        while row_ctr <= 659 {
            if (sDriverr[row_ctr][15] == sDriverr[row_ctr][17]) {   // CL=PL so set [31 and [32] to same
                //print("!!379 \(sDriverr[0][15]) \(sDriverr[0][31])")
                sDriverr[row_ctr][31] = sDriverr[row_ctr][17]   // save PL(ACo>NCo) = PL
                sDriverr[row_ctr][32] = sDriverr[row_ctr][18]   // save PR(ACo>NCo) = PR
            } else if ((sDriverr[row_ctr][15] < sDriverr[row_ctr][17]) &&          // PR[18]
                       (Double(sMultStripped)! > Double(sDriverr[row_ctr][22])!)) {   // CL<PL and ACo > NCo
                //printArrRow(arrName: sDriverr, xRow: 11)
                sDriverr[row_ctr][31] = sDriverr[row_ctr][17]   // save PL(ACo>NCo) = PL
                sDriverr[row_ctr][32] = sDriverr[row_ctr][18]   // save PR(ACo>NCo) = PL
            } else {      //  CL<PL but there aren't enough coins to get to PL, so figure out if a lower PL can br reached
                let startCL = Int(sDriverr[row_ctr][15])!    // CL   2
                ctrPL = Int(sDriverr[row_ctr][17])!    // PL   6
                ctrCL = startCL   // counter for CL      2
                if (startCL > 1) {
                    startNCo = Int(sDriverr[row_ctr + ctrCL - 2][10])!  // get the base cumul coins for starting CL
                } else {
                    startNCo = 0   // for low CLs, starting=0
                }
                while (ctrCL < ctrPL) {      // CL<PL
                    // get the NCo for ctrCL. If ACo>NCo then save the PR  for that ctrCL.
                    // add +1 to ctrCL and see if it still works
                    ctrNCo = 0    //get the ctrNCo
                    if (ctrPL >= 1) {    // if PL>=1   ie. CL<>0
                        ctrNCo = Int(sDriverr[row_ctr + ctrCL - 1][10])! - startNCo  // and subtract the CL cumul coins already spent
                    }
                    //print("!! Row: \(row_ctr). Start NCo= \(startNCo). To upgrade from \(startCL) to CL= \(ctrCL + 1) to PL= \(ctrPL); NCo= \(ctrNCo) and ACo= \(sMultStripped)")
                    
                    if (Int(Double(sMultStripped)!) >= ctrNCo ) {
                        sDriverr[row_ctr][31] = String(ctrCL + 1)   // save PL(ACo>NCo)
                        sDriverr[row_ctr][32] = sDriverr[row_ctr + ctrCL - 1][12]   // save PR(ACo>NCo)
                        //print("!!DV419 Saving PR(ACo>NCo) for row= \(row_ctr) with PL= \(ctrCL + 1) and PR= \(sDriverr[row_ctr + ctrCL][12])")
                    } else {     //CL<PL but there aren't enough coins to do anything
                        sDriverr[row_ctr][31] = sDriverr[row_ctr][15]   // save PL(ACo>NCo) = CL
                        sDriverr[row_ctr][32] = sDriverr[row_ctr][16]   // save PR(ACo>NCo) = CR
                    }
                    
                    ctrCL = ctrCL + 1   // next CL
                }
            }
            row_ctr = row_ctr + 1
        }   //  row_ctr
        
        // *****  DONE  ******************************************************************************************************************************
  
        return sDriverr
        
    }  //sDriverCalc()
    
    
    func sPartCalc(sPart: [[String]], sMult: [[String]], sCard: [[String]]) -> [[String]] {
        //  Calculate sPart values
        
        var sPartt = sPart
        var sMultt = sMult
        var sCardd = sCard
        
        var ACo = Int(sMult[11][1].replacingOccurrences(of: ",", with: ""))!  // available coins
        var tempPLplus1Coins = 0
        var tempPLplus2Coins = 0
        
        // **********************************************************************************************************************************************************
        // weighted rating: sum of atributes x mult values
        
        var row_ctr = 0
        while row_ctr <= 461 {
            sPartt[row_ctr][11] = String(Int(sPartt[row_ctr][3])! * Int(sMultt[0][1])! + Int(sPartt[row_ctr][4])! * Int(sMultt[1][1])! + Int(sPartt[row_ctr][5])! * Int(sMultt[2][1])! + Int(sPartt[row_ctr][6])! * Int(sMultt[3][1])!)
            row_ctr = row_ctr + 1
        }
        
        // **********************************************************************************************************************************************************
        // NR normalized rating. normalize out of 100. Find max, in [11], for all drivers and use it to normalize all others.
        
        //0-76, 77-153,154-230, 231-307, 308-384, 385-461
        
        row_ctr = 0
        var row_start = 0
        var maxPart = 0
        var dTemp: Double = 0.0
        
        while row_start <= 450  { // < 461
            
            
            while row_ctr <= row_start + 76 {
                //print("sPart MR max= ",row_ctr)
                if (Int(sPartt[row_ctr][11])! > maxPart) {    //find the max driver rating
                    maxPart = Int(sPartt[row_ctr][11])!
                }
                row_ctr = row_ctr + 1
            }
            
            row_ctr = row_ctr - 77
            while row_ctr <= row_start + 76 {
                //print("sPart MR norm= ",row_ctr)
                dTemp = Double(sPartt[row_ctr][11])!
                dTemp = dTemp / Double(maxPart)
                if (dTemp < 1 ) {
                    sPartt[row_ctr][12] = String(format: "%.1f", 100 * dTemp)   // get the weighted / max, * 100 formatted to 1 decimal
                } else {
                    sPartt[row_ctr][12] = "99.9"
                }
                row_ctr = row_ctr + 1
            }
            
            row_start = row_start + 77
        }

        
        // **********************************************************************************************************************************************************
        // CR Current Rating for current CL. Get the CL in [15]. Subtract 1 from CL value and add that to the row_ctr to get the CR ie. if CL=1, subtract 1 as a offset so when you add row_ctr, you get a proper CR.
        
        var tempCL = 0
        row_ctr = 0
        while row_ctr <= 461 {
            tempCL = Int(sPartt[row_ctr][15])! // get CL
            if (tempCL == 0) {    // check to see if CL=0
                sPartt[row_ctr][16] = "0"  // force CR = 0
            } else {
                sPartt[row_ctr][16] = sPartt[row_ctr + tempCL - 1][12]
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //NCa Needed Cards to go from CL to CL+1. take the CL[15] and look up its value in sCard [1] to go from CL to CL+1
        
        row_ctr = 0
        while row_ctr <= 461 {
            sPartt[row_ctr][21] = sCardd[Int(sPartt[row_ctr][15])!][1]
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //PL Possible Level use all available cards to determine PL. Get the current ACa[20], added to the CL[15]'s value in sCard ie. the number of cumulative cards to date. Find the PL
        
        row_ctr = 0
        var totCards = 0
        while row_ctr <= 461 {
            tempCL = Int(sPartt[row_ctr][15])! // get CL
            if (tempCL == 0) {
                totCards = 0
                sPartt[row_ctr][17] = "0"
            } else {
                totCards = Int(sPartt[row_ctr][20])! + Int(sCardd[tempCL - 1][2])!    // ACa + cumul to date ie. cards[CL-1] for actual cumul cost
            }
            var card_ctr = 11
            while card_ctr >= 0 {   // start at max level 11 and loop down looking where total cards is slightly less than sCard level
                if (totCards >= Int(sCardd[card_ctr][2])! && tempCL > 0) {
                    sPartt[row_ctr][17] = sCardd[card_ctr + 1][0]     //found the PL
                    break
                }
                card_ctr = card_ctr - 1
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // PR Possible Rating for current PL. Get the PL in [17]. Subtract 1 from PL value and add that to the row_ctr to get the PR ie. if PL=1, subtract 1 as a offset so when you add row_ctr, you get a proper PR.
        
        var tempPL = 0
        row_ctr = 0
        while row_ctr <= 461 {
            tempPL = Int(sPartt[row_ctr][17])!     // get PL
            if (tempPL == 0) {    // check to see if PL=0
                sPartt[row_ctr][18] = "0"   // force PR=0
            } else {
                sPartt[row_ctr][18] = sPartt[row_ctr + tempPL - 1][12]
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // MR Max Rating for current driver. Add 10 ie. level=11 to row_ctr and look up the normalized NR[12]
        
        row_ctr = 0
        while row_ctr <= 461 {
            sPartt[row_ctr][19] = sPartt[row_ctr + 10][12]
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // NCo Needed Coins to get to the PL. First determine the number of coins needed to get to PL[17]. Save it temporarily in [22].Second subtract [22] from the number of coins already spent to get to CL[15]- take the CL[15] and look up its value in sCard to go from CL to CL+1
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempCL = Int(sPartt[row_ctr][15])!
            tempPL = Int(sPartt[row_ctr][17])!
            sPartt[row_ctr][22] = "0"  // assume PL or CL = 0, set an initial value
            if (tempPL > 1) {    // if PL>1
                sPartt[row_ctr][22] = sPartt[row_ctr + tempPL - 1][10]  // get the PL cumul coins
            }
            if (tempCL > 1) {    // if CL>1
                sPartt[row_ctr][22] = String(Int(sPartt[row_ctr][22])! - Int(sPartt[row_ctr + tempCL - 1][10])!)  // and subtract the CL cumul coins already spent
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // +PR Possible Rating for current PL + 1
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempPL = Int(sPartt[row_ctr][17])!
            sPartt[row_ctr][23] = sPartt[row_ctr + tempPL][12]   //get the NR for at the PL row
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //   ACards/+NCa Needed Cards to go to PL + 1
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempPL = Int(sPartt[row_ctr][17])!
            if (tempPL == 0) {
                sPartt[row_ctr][25] = ".000001"  // assume PL = 0, set an initial value
            } else if (tempPL > 10) {    // if PL is to big to jump up +1
                sPartt[row_ctr][25] = String(Double(sPartt[row_ctr][20])! / Double(sCardd[tempPL][1])!)
            } else {
                sPartt[row_ctr][25] = String(Double(sPartt[row_ctr][20])! / Double(sCardd[tempPL + 1][1])!)
            }
            if (Double(sPartt[row_ctr][25])! > 1) {
                sPartt[row_ctr][25] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // ACoins/+NCo Needed Coins to get to the PL+1. Get cumul coins for PL+1 and subtract cumul coins for CL ie. from rows PL to CL-1
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempCL = Int(sPartt[row_ctr][15])!
            tempPL = Int(sPartt[row_ctr][17])!
            sPartt[row_ctr][24] = "0.000001"  // assume PL = 0, set an initial value
            if (tempPL == 11) {
                tempPL = 10        // PL+1 maxes out at 11
            } else {
                tempPLplus1Coins = Int(sPartt[row_ctr + tempPL][10])!    //get cumul coins for PL+1 ie. row PL
            }
            
            if (tempCL > 0) {   //  otherwise[24] stays at .0000001
                if (tempPLplus1Coins != Int(sPartt[row_ctr + tempCL - 1][10])!) {
                    sPartt[row_ctr][24] =  String( ACo / (tempPLplus1Coins - Int(sPartt[row_ctr + tempCL - 1][10])!) )
                }
            }
            if (Double(sPartt[row_ctr][24])! > 1) {
                sPartt[row_ctr][24] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // ++PR Possible Rating for current PL + 2
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempPL = Int(sPartt[row_ctr][17])!
            if (tempPL > 9) {        // if PL > 9 then max out at 11
                sPartt[row_ctr][26] = sPartt[row_ctr + 10][12]
            } else {
                sPartt[row_ctr][26] = sPartt[row_ctr + tempPL + 2][12]    // jump up 2
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        //   ACards/++NCa Needed Cards to go to PL + 2
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempPL = Int(sPartt[row_ctr][17])!
            if (tempPL == 0) {
                sPartt[row_ctr][28] = ".000001"  // assume PL = 0, set an initial value
            } else if (tempPL > 9) {    // if PL is to big to jump up + 2
                sPartt[row_ctr][28] = String(Double(sPartt[row_ctr][20])! / Double(sCardd[tempPL][1])!)
            } else {
                sPartt[row_ctr][28] = String(Double(sPartt[row_ctr][20])! / Double(sCardd[tempPL + 2][1])!)
            }
            if (Double(sPartt[row_ctr][28])! > 1) {
                sPartt[row_ctr][28] = "1"
            }
            
            row_ctr = row_ctr + 11
        }
                
        // **********************************************************************************************************************************************************
        // ACoins/+NCo Needed Coins to get to the PL + 2. Get cumul coins for PL+2 and subtract cumul coins for CL ie. from rows PL+1 to CL-1
        
        row_ctr = 0
        while row_ctr <= 461 {
            tempCL = Int(sPartt[row_ctr][15])!     //CL
            tempPL = Int(sPartt[row_ctr][17])!     //PL
            sPartt[row_ctr][27] = "0.000001"  // assume PL = 0, set an initial value for ACoins/++NCumulCoins
            if (tempPL > 9) {
                tempPL = 9        // PL+2 maxes out at 11
            } else {
                tempPLplus2Coins = Int(sPartt[row_ctr + tempPL + 1][10])!    //get cumul coins for PL+2 ie. row PL+1
            }
            
            if (tempCL > 0) {   //  otherwise[27] stays at .0000001
                if (tempPLplus2Coins != Int(sPartt[row_ctr + tempCL - 1][10])!) {
                    sPartt[row_ctr][27] =  String( ACo / (tempPLplus2Coins - Int(sPartt[row_ctr + tempCL - 1][10])!) )
                }
            }
            if (Double(sPartt[row_ctr][24])! > 1) {
                sPartt[row_ctr][25] = "1"
            }
            row_ctr = row_ctr + 11
        }
        
        // **********************************************************************************************************************************************************
        // fill in [31] and [32]= true PR when ACo>NCo. [31] is true PL, [32] is [31]'s PR.
        let sMultStripped = sMultt[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
        var ctrCL = 0
        var ctrPL = 0
        var ctrNCo = 0
        var startNCo = 0
        row_ctr = 0
        
        while row_ctr <= 461 {
            if (sPartt[row_ctr][15] == sPartt[row_ctr][17]) {   // CL=PL so set [31 and [32] to same
                //print("!!379 \(sPartt[0][15]) \(sPartt[0][31])")
                sPartt[row_ctr][31] = sPartt[row_ctr][17]   // save PL(ACo>NCo) = PL
                sPartt[row_ctr][32] = sPartt[row_ctr][18]   // save PR(ACo>NCo) = PR
            } else if ((sPartt[row_ctr][15] < sPartt[row_ctr][17]) &&          // PR[18]
                       (Double(sMultStripped)! > Double(sPartt[row_ctr][22])!)) {   // CL<PL and ACo > NCo
                sPartt[row_ctr][31] = sPartt[row_ctr][17]   // save PL(ACo>NCo) = PL
                sPartt[row_ctr][32] = sPartt[row_ctr][18]   // save PR(ACo>NCo) = PL
            } else {      //  CL<PL but there aren't enough coins to get to PL, so figure out if a lower PL can br reached
                let startCL = Int(sPartt[row_ctr][15])!    // CL   2
                ctrPL = Int(sPartt[row_ctr][17])!    // PL   6
                ctrCL = startCL   // counter for CL      2
                if (startCL > 1) {
                    startNCo = Int(sPartt[row_ctr + ctrCL - 2][10])!  // get the base cumul coins for starting CL
                } else {
                    startNCo = 0   // for low CLs, starting=0
                }
                while (ctrCL < ctrPL) {      // CL<PL
                    // get the NCo for ctrCL. If ACo>NCo then save the PR  for that ctrCL.
                    // add +1 to ctrCL and see if it still works
                    ctrNCo = 0    //get the ctrNCo
                    if (ctrPL >= 1) {    // if PL>=1   ie. CL<>0
                        ctrNCo = Int(sPartt[row_ctr + ctrCL - 1][10])! - startNCo  // and subtract the CL cumul coins already spent
                    }
                    //print("!! Row: \(row_ctr). Start NCo= \(startNCo). To upgrade from \(startCL) to CL= \(ctrCL + 1) to PL= \(ctrPL); NCo= \(ctrNCo) and ACo= \(sMultStripped)")
                    
                    if (Int(Double(sMultStripped)!) >= ctrNCo ) {
                        sPartt[row_ctr][31] = String(ctrCL + 1)   // save PL(ACo>NCo)
                        sPartt[row_ctr][32] = sPartt[row_ctr + ctrCL - 1][12]   // save PR(ACo>NCo)
                        //print("!!DV419 Saving PR(ACo>NCo) for row= \(row_ctr) with PL= \(ctrCL + 1) and PR= \(sPartt[row_ctr + ctrCL][12])")
                    } else {     //CL<PL but there aren't enough coins to do anything
                        sPartt[row_ctr][31] = sPartt[row_ctr][15]   // save PL(ACo>NCo) = CL
                        sPartt[row_ctr][32] = sPartt[row_ctr][16]   // save PR(ACo>NCo) = CR
                    }
                    
                    ctrCL = ctrCL + 1   // next CL
                }
            }
            row_ctr = row_ctr + 1
        }   //  row_ctr
        
        // *****  DONE  ******************************************************************************************************************************************
        
        return sPartt
    }  //sPartCalc()
    
    
    func updateIsDisplayed(sDriver: [[String]], isDisplayed: [Bool]) -> [[String]]  {
        
        var isDisplayedd = isDisplayed   //temp holder
        var sDriverr = sDriver
        
        var row_ctr = 0
        while row_ctr <= 659 {
            if (isDisplayedd[row_ctr]) {
                sDriverr[row_ctr][14] = "1.1"
            } else {
                sDriverr[row_ctr][14] = "1"
            }
            
        }
        return sDriverr
    }  // end of func updateIsDisplayed
    
    
    
    
}           //end of DBHandler()

