//
//  RecsView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI
import SQLite3
import GoogleMobileAds
//***************

struct RecsSubView: View {
    
    @EnvironmentObject var db: DBHandler
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic, Color.black, Color.red]
    @State var fontSize: [Int] = Array(repeating: 13, count: 461)
    var ctr_start: Int
    var ctr_stop: Int
    @Binding var Recs: [[Double]]
    @Binding var RecsDispParts: [String]
    //@Binding var CLStart: String
    //@Binding var CLMidd: String
    //@Binding var CLEnd: String
    
    
    var body: some View {
        ForEach(Array(stride(from: ctr_start, to: ctr_stop, by: 11)), id: \.self) { index_v in
            //let RecNumber: Int = Int(Recs[index_v/11])!
            let sPartList: [String] = ["ST", "MT", "LT"]
            let iPartTerm: Int = (index_v - ctr_start)/11
            //let textString: LocalizedStringKey = "ST"  // works
            //let textString: LocalizedStringKey = sPartList[0]  // works
            let transPartString = LocalizedStringKey(sPartList[iPartTerm]) // works
            //let textString: LocalizedStringKey = sPartList[iPartTerm] // doesnt work
            
            
            //let textString: String = sPartList[0]
            //let textString: LocalizedStringKey = interString
            //let textFinal = Text(textString)
            //44-67, 77-100, 110-133, 143-166, 176-199, 209-232
            // 44,55,66   77,88,99
            
            HStack(alignment: .top) {
                //Text("4")   //  choose ST, ST, MT and then LT for tshe 4 drivers recs
                //Text(sPartList[iPartTerm/11])   //  choose ST, MT and then LT for the 3 part recs
                Text(transPartString)
                    .font(.system(size: 12))
                    .frame(width: 20)
                VStack {
                    let RecNumber: Int = Int(Recs[index_v/11][0])
                    VStack {
                        //Text("\(CLStart) \(CLMid) CL \(CLEnd)")
                        //Text("CL\(CLMidd)")
                        
                        //Text(String(RecNumber))  // Translated(Name CL CR PL ACa NCo)
                        
                        Text("resultRecs1")  // Translated(Name CL CR PL ACa NCo)
                            .font(.system(size: 9, design: .monospaced))
                            .fontWeight(.regular)
                            .frame(width: 320, alignment: .leading)
                            .background(cmode[Int(db.sPart[RecNumber][13])!])
                        Text(RecsDispParts[index_v/11 * 4])     // string 0  Part Name and stats
                            .font(.system(size: 13, design: .monospaced))
                            .fontWeight(.semibold)
                            .frame(width: 320, alignment: .leading)
                            .foregroundColor(cmode[Int(db.sPart[RecNumber ][8])!])
                            .background(cmode[Int(db.sPart[RecNumber][13])!])
                    }
                    .border(.black)
                    VStack {
                        Text("resultRecs2")    //  Translated(PL PR MR NCa NCo)
                            .font(.system(size: 9, design: .monospaced))
                            .fontWeight(.regular)
                            .frame(width: 320, alignment: .leading)
                        Text(RecsDispParts[index_v/11 * 4 + 1])     // string 1, can be multi-line
                            .font(.system(size: 13, design: .monospaced))
                            .fontWeight(.semibold)
                            .frame(width: 320, alignment: .leading)
                    }
                    .border(.black)
                    VStack {
                        //Text("\(CLStart) CL\(CLMid) PL\(CLEnd)")
                        //Text("        CL\(CLMidd)")
                        Text(RecsDispParts[index_v/11 * 4 + 2])     // string 2, CL=x  PL=y
                            .font(.system(size: 9, design: .monospaced))
                            .fontWeight(.regular)
                            .frame(width: 320, alignment: .leading)
                        Text(RecsDispParts[index_v/11 * 4 + 3])     // string 3, can be multi-line
                            .font(.system(size: 13, design: .monospaced))
                            .fontWeight(.semibold)
                            .frame(width: 320, alignment: .leading)
                        
                    }
                    .border(.black)
                    
                }   //VStack
            }    //HStack
            Spacer(minLength: 15)
        }   //ForEach
        
    }
}


struct RecsView: View {
    
    //******************************************************************
    //
    // Recs Driver ST, MT, LT= [0-3], Brakes [4-6, Gear[7-9], FW[10-12], RW[13-15], Susp[16-18], Engine[19-21]
    //
    // Short term driver/part picks
    // Loop through 60 drivers and 6x7 parts. Find the top 2 drivers and 1 part that have the highest CR or highest PR where ACo>=NCo (sMult[11][1] > [22] and ACa>=NCa [20]>[21]
    
    //Medium  term driver/part picks
    // Add 1 to the PL,  do calcs. build array with drivers(1), ACards/NCumulCards(2) and ACoins/NCumulCoins(3) and avg(4). If any of these is >1, then =1.
    // 4th column of array = avg of cols 2 and 3. Sort by col 4 then 2 then 3. Loop through array, if PR+1 is greater
    // than Driver 2 iRecs[2] then pick it!
    // Add 1 to the PL,  Take the max 4 PR+1s[23] where PR >= CR ORDER BY ACards/NCards[25] ASC, ACoins/NCoins[24] ASC
    // One or more have to have a higher PR than your current ST driver/part- since it's' included in the st list
    //
    
    //Long term driver/part picks
    // Add 2 to the PL,  do calcs. build array with drivers(1), ACards/NCumulCards(2) and ACoins/NCumulCoins(3) and avg(4). If any of these is >1, then =1.
    // 4th column of array = avg of cols 2 and 3. Sort by col 4 then 2 then 3. Loop through array, if PR+1 is greater
    // than Driver 2 iRecs[2] then pick it!
    // Add 2 to the PL, per above- pick the highest PR+2s[26] with best ACards/NCards[28] and ACoins/NCoins[27]
    // Take the max 4 PR(+1)s where PR(+1) >= CR ORDER BY ACards/NCards(+1) ASC, ACoins/NCoins(+1) ASC
    //
    
    //******************************************************************
    
    @EnvironmentObject var db: DBHandler
    
    var modes = ["Basic", "Detail"]
    
    var interstitial : Interstitial = Interstitial()
    
    @State var string = ""
    @State var row_ctr = 0
    @State var row_start = 0
    @State var cat_ctr = 1
    @State var maxPart = 0
    @State var pitStopTime: Double = 0
    @State var max_count = 0    //largest RecsDisp
    @State var maxLH = 0   // and its CL factor length
    @State var maxRH = 0   // and its PL factor length
    @State var longestLength = 0
    @State var iTeamScore:Int = 0
    @State var STDriverRecID:Int = 0     //dummy integer
    @State var STPartRecID:Int = 0   // dummy integer
    @State var sMultStripped = "0"
    @State var DrRecCase = 0   //driver recommendation case 1-5
    @State var PaRecCase = 0  //parts recommendation case 1-2
    
    @State private var showingInfoSheet = false
    
    @State var t1 = ""
    @State var t2 = 0
    @State var xPL = 0  //PL for the current line's level
    @State var xPR = 0  //PR for the current line's level
    @State var xMR = 0  //MR for the current line's level
    @State var xNCa = 0  //NCa for the current line's level
    @State var xNCo = 0  //NCo for the current line's level
    
    //@State var CLStart: String = "11"
    //@State var CLMid: String = "22"
    //@State var CLEnd: String = "33"
    
    @State var Spaces = "                                              "
    
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic, Color.black, Color.red]
    let factors = ["Speed", "Cornering", "Power Unit", "Reliability", "Pit Stop Time", "Overtaking", "Defending", "Qualifying", "Race Start", "Tire Management", "Wet Weather Ability"]
    let assetLevel = ["","common", "rare", "epic"]
    let maxLevel = [0,11,9,8]
    
    
    @State var RecsDisp: [[String]]  = Array(repeating: Array(repeating: "", count: 9), count: 22)     //Detailed strings for 22 drivers and parts, each with 1st line, 2nd line, 3rd line and 4th-9th for Driver details or 4th-7th for Parts details
    @State var RecsDispDriver: [String]  = Array(repeating: "", count: 36)
    @State var RecsDispParts: [String]  = Array(repeating: "", count: 126)
    @State var Recs:[[Double]] =  Array(repeating: Array(repeating: 0, count: 2), count: 22)//  Drivers [0-3 = ST, ST, MT, LT][ratings], Brakes [4-6 ST, MT, LT][not used], Gear[7-9 ST, MT, LT][not used], FW[10-12 ST, MT, LT][not used], RW[13-15 ST, MT, LT][not used], Susp[16-18 ST, MT, LT][not used], Engine[19-21 ST, MT, LT][not used]
    //******************************************************************
    
    
    
    
    var body: some View {
        ScrollView {
            
            VStack {
                ZStack {
                    Color.colours.backgrd_blue
                        .frame(minWidth: 400)
                    HStack {     //title and info button
                        
                        Text("F1 Clash Companion")
                            .font(.title3)
                            .foregroundColor(.white)
                            .offset(x: 5, y: 0)
                            .padding(20)
                        Spacer()
                        Button {
                            print("Launch info")
                            showingInfoSheet.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                        }
                        .offset(x: -10, y: 0)
                        .sheet(isPresented: $showingInfoSheet) {
                            InfoSheetRecsView()
                        }
                    }    //HStack
                }    //ZStack
                
            }    //VStack
            
            
            Spacer(minLength: 15)
            
            if (db.sSelectedMode == "detailMode") {     // detail mode
                
                HStack(alignment: .top) {
                        
                        Picker(selection: $db.sSelectedMode, label: Text("Mode:")) {
                            Text("basicMode").tag("basicMode")
                            Text("detailMode").tag("detailMode")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150)
                        .offset(x:-40, y:0)
                        
                    
                    
                    VStack {     // legends together for colours and acronyms
                        Text("legend")
                            .font(.system(size: 13))
                            .frame(width: 100)
                        
                        VStack {
                            Text("common")
                                .font(.system(size: 11))
                                .frame(width: 130)
                                .background(cmode[1])
                            
                            Text("rare")
                                .font(.system(size: 11))
                                .frame(width: 130)
                                .background(cmode[2])
                            
                            Text("epic")
                                .font(.system(size: 11))
                                .frame(width: 130)
                                .background(cmode[3])
                            
                        }
                        .border(.black)
                        Spacer(minLength: 3)
                        VStack {
                            Text("ST_recs")
                                .font(.system(size: 11))
                                .frame(width: 130)
                            
                            Text("MT_recs")
                                .font(.system(size: 11))
                                .frame(width: 130)
                            
                            Text("LT_recs")
                                .font(.system(size: 11))
                                .frame(width: 130)
                            
                        }
                        .border(.black)
                    }
                    .offset(x:20, y:0)
                }
                
                Spacer(minLength: 35)
                
// ************************************************************************************************************************************
// ******    Top of Details Tables- Driver  and Parts tables
// ************************************************************************************************************************************
                
                VStack{
                    Text("recommendations")
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer(minLength: 15)
                
                HStack(spacing: 0) {
                    Text("ST")   //ST Driver Rec1
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text(db.sDriver[Int(Recs[0][0])][1])   //ST Driver Rec1
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(width: 120)
                        .foregroundColor(cmode[Int(db.sDriver[Int(Recs[0][0])][8])!])
                        .background(cmode[Int(db.sDriver[Int(Recs[0][0])][13])!])
                    Text(db.sDriver[Int(Recs[1][0])][1])   //ST Driver Rec2
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(width: 120)
                        .foregroundColor(cmode[Int(db.sDriver[Int(Recs[1][0])][8])!])
                        .background(cmode[Int(db.sDriver[Int(Recs[1][0])][13])!])
                }
                HStack(spacing: 0) {
                    Text("MT")   //MT Driver Rec
                        .font(.system(size: 12))
                        .frame(width: 20)
                    Text(db.sDriver[Int(Recs[2][0])][1])   //MT Driver Rec
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(width: 240)
                        .background(cmode[Int(db.sDriver[Int(Recs[2][0])][13])!])
                }
                HStack(spacing: 0) {
                    Text("LT")   //LT Driver Rec
                        .font(.system(size: 12))
                        .frame(width: 20)
                    
                    Text(db.sDriver[Int(Recs[3][0])][1])   //LT Driver Rec
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(width: 240)
                        .background(cmode[Int(db.sDriver[Int(Recs[3][0])][13])!])
                }
                
            }
            
                Spacer(minLength: 25)
                VStack{                                   // ST, MT and LT Parts Recs Block 1
                    HStack {
                        Text("ST")   //ST Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[4][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[4][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[4][0])][13])!])
                        Text(db.sPart[Int(Recs[7][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[7][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[7][0])][13])!])
                        Text(db.sPart[Int(Recs[10][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[10][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[10][0])][13])!])
                    }
                    HStack {
                        Text("MT")   //MT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[5][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[5][0])][13])!])
                        Text(db.sPart[Int(Recs[8][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[8][0])][13])!])
                        Text(db.sPart[Int(Recs[11][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[11][0])][13])!])
                    }
                    HStack {
                        Text("LT")   //LT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[6][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[6][0])][13])!])
                        Text(db.sPart[Int(Recs[9][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[9][0])][13])!])
                        Text(db.sPart[Int(Recs[12][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[12][0])][13])!])
                    }
                }   //VStack
                Spacer(minLength: 25)
                VStack{                                   // ST, MT and LT Parts Recs Block 2
                    HStack {
                        Text("ST")   //ST Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[13][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[13][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[13][0])][13])!])
                        Text(db.sPart[Int(Recs[16][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[16][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[16][0])][13])!])
                        Text(db.sPart[Int(Recs[19][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .foregroundColor(cmode[Int(db.sPart[Int(Recs[19][0])][8])!])
                            .background(cmode[Int(db.sPart[Int(Recs[19][0])][13])!])
                    }
                    
                    HStack {
                        Text("MT")   //MT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[14][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[14][0])][13])!])
                        Text(db.sPart[Int(Recs[17][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[17][0])][13])!])
                        Text(db.sPart[Int(Recs[20][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[20][0])][13])!])
                    }
                    HStack {
                        Text("LT")   //LT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[15][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[15][0])][13])!])
                        Text(db.sPart[Int(Recs[18][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[18][0])][13])!])
                        Text(db.sPart[Int(Recs[21][0])][1])
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sPart[Int(Recs[21][0])][13])!])
                    }
                    
                    Spacer(minLength: 15)
                    
// ************************************************************************************************************************************
// ******    Middle of Details- Coins, Pit Stop Time, Team Score
// ************************************************************************************************************************************

                    VStack(alignment: .center) {
                        HStack{
                            Text("coins \(db.sMult[11][1])")       // Coins display
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 175, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        Spacer(minLength: 15)
                        
                        VStack(alignment: .center) {
                            let pitString: String = String(Double(Int(pitStopTime * 100))/100) + " s."
                            Text("pitStopTime \(pitString)")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 250, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        Spacer(minLength: 15)
                        
                        VStack(alignment: .center) {
                            //Text("teamScore \(iTeamScore)")
                            Text("teamScore \(String(iTeamScore))")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 250, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        
                    }    //VStack
                    Spacer(minLength: 15)
                }
                
                Spacer(minLength: 15)

// ************************************************************************************************************************************
// ******    Bottom of Details- Driver and parts statistics
// ************************************************************************************************************************************
                
                VStack(alignment: .leading) {
                    Text("driver")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    ForEach(Array(stride(from: 0, to: 34, by: 11)), id: \.self) { index_v in
                        
                        let sDriverList: [String] = ["ST", "ST", "MT", "LT"]
                        var iDriverTerm = Int(index_v)/11      // index_v is not an Int- needs to be cast first !!!!!!!
                        let transDriverString = LocalizedStringKey(sDriverList[iDriverTerm]) // works
                        let colorInt2: Int = Int(db.sDriver[index_v][30])!
                        let colorFont = cmode[colorInt2]      //  get the level and apply the right background colour to it
                        
                        HStack(alignment: .top) {
                            
                            if (iDriverTerm <= 1) {   // ST Drivers, highlight immediate upgrade recommendations with red font
                                
                                Text(transDriverString)   //  choose ST, ST, MT and then LT for the 4 drivers recs
                                    .font(.system(size: 12))
                                    .frame(width: 20)
                                VStack {
                                    let RecNumber: Int = Int(Recs[index_v/11][0])
                                    
                                    VStack {
                                        //Text("1234567890123456789012345678901234567890123456789012345")  // to be commented
                                        Text("resultRecs1")  // Translated(Name CL CR PL ACa NCo)
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)
                                            .background(cmode[Int(db.sDriver[RecNumber][13])!])
                                        
                                        Text(RecsDispDriver[index_v/11 * 4])     // string 0, 4, 8, 12   Driver name and stats
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                            .foregroundColor(cmode[Int(db.sDriver[RecNumber][8])!])      //66, 0, 66, 66
                                            .background(cmode[Int(db.sDriver[RecNumber][13])!])
                                    }
                                    .border(.black)
                                    
                                    VStack {
                                        Text("resultRecs2")    //  Translated(PL PR MR NCa NCo)
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)
                                        Text(RecsDispDriver[index_v/11 * 4 + 1])     // string 1, can be multi-line
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                    }
                                    .border(.black)
                                    VStack {
                                        Text(RecsDispDriver[index_v/11 * 4 + 2])     // string 2, CL=x  PL=y
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)

                                        Text(RecsDispDriver[index_v/11 * 4 + 3])     // string 3, can be multi-line
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                    }
                                    .border(.black)
                                }   //VStack
                                
                            } else {      // MT, LT Drivers so no immediate upgrade recommendations
                                Text(transDriverString)   //  choose ST, ST, MT and then LT for the 4 drivers recs
                                    .font(.system(size: 12))
                                    .frame(width: 20)
                                VStack {
                                    let RecNumber: Int = Int(Recs[index_v/11][0])
                                    
                                    VStack {
                                        //Text("1234567890123456789012345678901234567890123456789012345")  // to be commented
                                        Text("resultRecs1")  // Translated(Name CL CR PL ACa NCo)
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)
                                            .background(cmode[Int(db.sDriver[RecNumber][13])!])
                                        
                                        Text(RecsDispDriver[index_v/11 * 4])     // string 0, 4, 8, 12   Driver name and stats
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                            .foregroundColor(Color.black)      //66, 0, 66, 66
                                            .background(cmode[Int(db.sDriver[RecNumber][13])!])
                                    }
                                    .border(.black)
                                    
                                    VStack {
                                        Text("resultRecs2")    //  Translated(PL PR MR NCa NCo)
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)
                                        Text(RecsDispDriver[index_v/11 * 4 + 1])     // string 1, can be multi-line
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                    }
                                    .border(.black)
                                    VStack {
                                        Text(RecsDispDriver[index_v/11 * 4 + 2])     // string 2, CL=x  PL=y
                                            .font(.system(size: 9, design: .monospaced))
                                            .fontWeight(.regular)
                                            .frame(width: 320, alignment: .leading)

                                        Text(RecsDispDriver[index_v/11 * 4 + 3])     // string 3, can be multi-line
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 320, alignment: .leading)
                                    }
                                    .border(.black)
                                }   //VStack
                            }
                            
                            
                            
                            
                        }  //HStack
                        Spacer(minLength: 15)
                    }
                    // *******  Detail Parts lower details
                    //  44 55 66, 77 88 99, 110 121 132, 143 154 165, 176 187 198, 209 220 231
                    
                    VStack(alignment: .leading) {
                        Group{
                            Text("brakes")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            RecsSubView(ctr_start: 44, ctr_stop: 67, Recs: $Recs, RecsDispParts: $RecsDispParts)
                            Spacer(minLength: 15)
                        }
                        Group{
                            Text("suspension")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            RecsSubView(ctr_start: 77, ctr_stop: 100, Recs: $Recs, RecsDispParts: $RecsDispParts)
                            Spacer(minLength: 15)
                        }
                        Group{
                            Text("frontwing")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            Spacer(minLength: 10)
                            RecsSubView(ctr_start: 110, ctr_stop: 133, Recs: $Recs, RecsDispParts: $RecsDispParts)
                            Spacer(minLength: 15)
                        }
                        Group{
                            Text("rearwing")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            RecsSubView(ctr_start: 143, ctr_stop: 166, Recs: $Recs, RecsDispParts: $RecsDispParts)
                            Spacer(minLength: 15)
                        }
                        Group{
                            Text("gearbox")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            RecsSubView(ctr_start: 176, ctr_stop: 199, Recs: $Recs, RecsDispParts: $RecsDispParts)
                            Spacer(minLength: 15)
                        }
                        Group{
                            Text("engine")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                                .padding(.horizontal, 30)
                            RecsSubView(ctr_start: 209, ctr_stop: 232, Recs: $Recs, RecsDispParts: $RecsDispParts)
                        }
                    } //VStack
                    
                }  //VStack
            } else {
            
// ************************************************************************************************************************************
// ******    Top of Basic- Driver recommendations
// ************************************************************************************************************************************
                
                VStack {    //    Basic mode
                    
                    // WORKING Text("driver") + Text(": ") + Text(CLStart) + Text("cancel") + Text(" lol, \(CLMid) the end")
                    
                    //Drivers:
                    // You should select A and B/ after upgrading A to level 4 and B to level 5/ after upgrading A to level 4/ and/ after upgrading B to level 4/.
                    // basicDrSelect / basicTwoUpgrade / basicOneUpgrade @/ and /
                    
                    // You should select A and B.
                    // You should select A and B after upgrading A to level 4 and after upgrading B to level 5.
                    // You should select A and B after upgrading A to level 4.
                    // You should select A and B after upgrading B to level 2.
                    
                    //Parts:
                    // You should select A/ after upgrading A to level 4/.
                    // basicPaSelect / basicOneUpgrade @C
                    
                    // You should select A.
                    // You should select A after upgrading A to level 4.
                    VStack(alignment: .center) {     //  picker
                        
                        Picker(selection: $db.sSelectedMode, label: Text("Mode:")) {
                            Text("basicMode").tag("basicMode")
                            Text("detailMode").tag("detailMode")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150)
                        
                    }   //VStack
                    Spacer(minLength: 20)
                    
                    Text("driverSummary")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .center)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color.white)
                        .background(Color.colours.backgrd_blue)
                    
                    
                    VStack {
                        if (DrRecCase == 1) {   // no upgrades possible, select 2 drivers
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1])") + Text("(") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) + Text(") ") + Text("and") + Text(" ") + Text(db.sDriver[Int(Recs[1][0])][1]) + Text(" (") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) + Text(")")
                            
                        } else if (DrRecCase == 2) {   // upgrade D0 immediately
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1])") + Text("(") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) + Text(") ") + Text("and") + Text(" ") + Text(db.sDriver[Int(Recs[1][0])][1]) + Text(" (") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) + Text(")") + Text("basicOneUpgrade \(db.sDriver[Int(Recs[0][0])][1]) \(db.sDriver[Int(Recs[0][0])][31])").foregroundColor(.red) + Text("immediate")
                        
                        } else if (DrRecCase == 3) {   // upgrade D1 immediately
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1])") + Text("(") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) + Text(") ") + Text("and") + Text(" ") + Text(db.sDriver[Int(Recs[1][0])][1]) + Text(" (") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) + Text(")") + Text("basicOneUpgrade \(db.sDriver[Int(Recs[1][0])][1]) \(db.sDriver[Int(Recs[1][0])][31])").foregroundColor(.red) + Text("immediate")
                        
                        } else if (DrRecCase == 4) {    // upgrade D0 as soon as possible
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1])") + Text("(") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) + Text(") ") + Text("and") + Text(" ") + Text(db.sDriver[Int(Recs[1][0])][1]) + Text(" (") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) + Text(")") + Text("basicOneUpgrade \(db.sDriver[Int(Recs[0][0])][1]) \(db.sDriver[Int(Recs[0][0])][31])") + Text("asSoon")
                            
                        } else if (DrRecCase == 5) {   // upgrade D1 as soon as possible
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1])") + Text("(") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) + Text(") ") + Text("and") + Text(" ") + Text(db.sDriver[Int(Recs[1][0])][1]) + Text(" (") + Text(LocalizedStringKey(assetLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) + Text(")") + Text("basicOneUpgrade \(db.sDriver[Int(Recs[1][0])][1]) \(db.sDriver[Int(Recs[1][0])][31])") + Text("asSoon")
                        }
                        
                    }
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .frame(width: 360)
                    
                    Spacer(minLength: 20)
                    
// ************************************************************************************************************************************
// ******    Top of Basic- Parts recommendations
// ************************************************************************************************************************************
                    
                    Text("componentsSummary")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .center)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color.white)
                        .background(Color.colours.backgrd_blue)
                    
                    VStack(alignment: .leading) {
                        Group {
                            if (STPartRecID <=  76) {
                                switch PaRecCase {
                                case 1:
                                    Text("brakes") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[4][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[4][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                case 2:
                                    Text("brakes") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[4][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[4][0])][31])") + Text("asSoon") + Text(" \n")
                                default:
                                    Text("brakes") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[4][0])][1])") + Text(" \n")
                                }
                            }
                            
                            if (STPartRecID >  76 && STPartRecID <=  153 ) {
                                if (PaRecCase == 1) {
                                    Text("gearbox") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[7][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[7][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                } else {
                                    Text("gearbox") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[7][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[7][0])][31])") + Text("asSoon") + Text(" \n")
                                }
                            } else {
                                Text("gearbox") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[7][0])][1])") + Text(" \n")
                            }
                            
                            if (STPartRecID >  153 && STPartRecID <=  230 ) {
                                if (PaRecCase == 1) {
                                    Text("rearwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[10][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[10][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                } else {
                                    Text("rearwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[10][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[10][0])][31])") + Text("asSoon") + Text(" \n")
                                }
                            } else {
                                Text("rearwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[10][0])][1])") + Text(" \n")
                            }
                        }    // group
                        .font(.system(size: 14, weight: .bold, design: .default))
                        
                        Group {
                            if (STPartRecID >  230 && STPartRecID <= 307 ) {
                                if (PaRecCase == 1) {
                                    Text("frontwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[13][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[13][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                } else {
                                    Text("frontwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[13][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[13][0])][31])") + Text("asSoon") + Text(" \n")
                                }
                            } else {
                                Text("frontwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[13][0])][1])") + Text(" \n")
                            }
                            
                            if (STPartRecID >  307 && STPartRecID <=  384 ) {
                                if (PaRecCase == 1) {
                                    Text("suspension") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[16][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[16][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                } else {
                                    Text("suspension") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[16][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[16][0])][31])") + Text("asSoon") + Text(" \n")
                                }
                            } else {
                                Text("suspension") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[16][0])][1])") + Text(" \n")
                            }
                            
                            if (STPartRecID > 384 ) {
                                if (PaRecCase == 1) {
                                    Text("engine") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[19][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[19][0])][31])").foregroundColor(.red) + Text("immediate") + Text(" \n")
                                } else {
                                    Text("engine") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[19][0])][1])") + Text("basicPaUpgrade \(db.sPart[Int(Recs[19][0])][31])") + Text("asSoon") + Text(" \n")
                                }
                            } else {
                                Text("engine") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[19][0])][1])")
                            }
                        }     //group
                        .font(.system(size: 14, weight: .bold, design: .default))
                    }   //VStack
                    
                    Spacer(minLength: 20)
                    
                    Text("teamScore \(String(iTeamScore))")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding()
                        .border(Color.colours.backgrd_blue, width: 4)
                        .multilineTextAlignment(.center)
                    
                    (Text(Image(systemName: "exclamationmark.octagon")) + Text("rememberRecs"))
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .padding()
                        .border(Color.colours.backgrd_blue, width: 4)
                        .multilineTextAlignment(.center)
                    
                }  //VStack
                .font(.system(size: 13, design: .monospaced))
                .frame(width: 360, alignment: .leading)
            }
        } //ScrollView
        .clipped()
        .onAppear(perform: start)
    }  //View
    
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    //let commaFormatter: NumberFormatter = {
    //    let commFormatter = NumberFormatter()
    //    //formatter.groupingSeparator = ","
    //    commFormatter.locale = .current
    //    commFormatter.numberStyle = .decimal
    //    return commFormatter
    //}()
    
    
    func start() {
        // used in DispRecs calcs:
        //    var test1: (String)
        //    var CL1: (Int)
        //    var PL1: (Int)
        //    var LH: (String)
        //    var RH: (String)
        //    var factor: (String)
        //    var strFactor: (String)
        //    var spaces: (Int)
        //    var interstitial: GADInterstitialAd?
        
        var factors: [String]
        
        
        
        print("RV start....")
        //print("RV start2= ", Double(db.sDriver[0][16])!)
        //print(Recs)
        
        let commFormatter = NumberFormatter()
        commFormatter.locale = .current
        commFormatter.numberStyle = .decimal
        //print("!!1", db.sMult[11][1])

        sMultStripped = db.sMult[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
        
        //print("!!2", db.sMult[11][1])
        //print("!!", sMultStripped)
        
        //*********************************************************************************************************
        // ADMOB
        
        //var interstitial : Interstitial = Interstitial()
        
        db.adMobCtr = db.adMobCtr + 1
        //print("adMobCtr= ",db.adMobCtr)
        if (db.adMobCtr >= 3) {
            db.adMobCtr = 0
            //self.interstitial.showAd()
        }
        
        print("!!adMobCtr= ",db.adMobCtr)
        
        
        //*********************************************************************************************************
        //  ST Driver     Recs[0][0] is the id of the highest CR or PR for drivers, [0][1] is the CR for that id
        //                Recs[1][0] is the id of the 2nd highest CR or PR for drivers, [1[1] is the CR for that id
        //   Take a look at Rec[0] and [1]. Find the largest PR and recommend its upgraded first.
        // For parts, do the same ie. which part gives the largest PR boost
        
        // STDriverRecId is the best driver id to be upgraded
        
        row_ctr = 0
        Recs[0][0] = Double(row_ctr)    // clear array to start over
        Recs[0][1] = Double(row_ctr)
        Recs[1][0] = Double(row_ctr)
        Recs[1][1] = Double(row_ctr)
        //print("!!RV784 \(Recs[0][0]) \(Recs[0][1]) \(Recs[1][0]) \(Recs[1][1])")
        //printArrRow(arrName: db.sDriver, xRow: 253)
        while row_ctr < 659 {   // go through all drivers, 11 rows at a time
            //print("!!RV787 new candidate: \(db.sDriver[row_ctr][32]) Recs[0][1]= \(Recs[0][1])")
            //printArrRow(arrName: db.sDriver, xRow: 253)

            if (Double(db.sDriver[row_ctr][32])! > Recs[0][1]) {   // PR > current Recs[0]
                if(db.sDriver[row_ctr][1] != db.sDriver[Int(Recs[0][0])][1]) {   //check to make sure drivers names are different
                    Recs[1][0] = Recs[0][0]   // push [0] down to [1]
                    Recs[1][1] = Recs[0][1]   // push value [0] down to [1]
                    Recs[0][0] = Double(row_ctr) //  id of new
                    Recs[0][1] = Double(db.sDriver[row_ctr][32])!  // value of new
                } else {    //drivers names are the same so add driver[0] but keep old driver[1]
                    Recs[0][0] = Double(row_ctr) //  id of new
                    Recs[0][1] = Double(db.sDriver[row_ctr][32])!  // value of new
                }
            } else if (Double(db.sDriver[row_ctr][32])! > Recs[1][1]) {    // CR > Recs[1]
                Recs[1][0] = Double(row_ctr)    // id of new
                Recs[1][1] = Double(db.sDriver[row_ctr][32])!  // value of new
            }

            row_ctr = row_ctr + 11      //next driver
        }
        
        //  Five Cases for Driver Upgrades
        // 1. All levels equal: if D0 CL=PL and D1 CL=PL then no upgrade. msg: Select D0 and D1
        // 2. is D0 upgradeable: else if (ACa>NCa and ACo>NCo and D0 CL is not max), D0 font red,  msg: Select D1 and D0 and upgrade D0 immediately
        // 3. else is D1 upgradeable: else if (ACa>NCa and ACo>NCo and D1 CL is not max), D1 font red,  msg: Select D0 and D1 and upgrade D1 immediately
        // 4. otherwise: else if (RecPR0-PR0 > RecPR1-PR1) and D0 is not max. msg: Select D0 and D1 and upgrade D0 ASAP
        // 5. else if (RecPR1-PR1 > RecPR0-PR0) and D1 is not max.  msg: Select D0 and D1 and upgrade D0 ASAP
        
        if ((db.sDriver[Int(Recs[0][0])][15] == db.sDriver[Int(Recs[0][0])][17]) && (db.sDriver[Int(Recs[1][0])][15] == db.sDriver[Int(Recs[1][0])][17])) {
            DrRecCase = 1;
        } else if ((Double(sMultStripped)! > Double(db.sDriver[Int(Recs[0][0])][22])!) &&                            // ACo > NCo
            (Double(db.sDriver[Int(Recs[0][0])][20])! > Double(db.sDriver[Int(Recs[0][0])][21])!) &&         // ACa > NCa
            ((Int(db.sDriver[Int(Recs[0][0])][15])!) != maxLevel[Int(db.sDriver[Int(Recs[0][0])][13])!])) {  // CL is not maxLvl
            DrRecCase = 2;
            db.sDriver[Int(Recs[0][0])][8] = "5"    // set the immediate upgrade font to red
        } else if ((Double(sMultStripped)! > Double(db.sDriver[Int(Recs[1][0])][22])!) &&                            // ACo > NCo
            (Double(db.sDriver[Int(Recs[1][0])][20])! > Double(db.sDriver[Int(Recs[1][0])][21])!) &&         // ACa > NCa
            ((Int(db.sDriver[Int(Recs[1][0])][15])!) != maxLevel[Int(db.sDriver[Int(Recs[1][0])][13])!])) {  // CL is not maxLvl
            DrRecCase = 3;
            db.sDriver[Int(Recs[1][0])][8] = "5"    // set the immediate upgrade font to red
        } else if ((Double(db.sDriver[Int(Recs[0][0])][32])! - Double(db.sDriver[Int(Recs[0][0])][16])!) >= (Double(db.sDriver[Int(Recs[1][0])][32])! - Double(db.sDriver[Int(Recs[1][0])][16])!)) {    // delta Recs0 PR > delta Recs1 PR
            DrRecCase = 4;
        } else if ((Double(db.sDriver[Int(Recs[1][0])][32])! - Double(db.sDriver[Int(Recs[1][0])][16])!) >= (Double(db.sDriver[Int(Recs[0][0])][32])! - Double(db.sDriver[Int(Recs[0][0])][16])!)) {    // delta Recs1 PR > delta Recs0 PR
            DrRecCase = 5;
        }
        
        
   
        //db.sDriver.forEach{print($0)}
        // **********************************************************************************************
        // MT DRIVER
        
        var dToSort: [[Double]] = [[]]
        dToSort.removeAll()
        row_ctr = 0
        while row_ctr < 659 {   //loop through drivers
            if(Double(db.sDriver[row_ctr][23])! > Double(db.sDriver[row_ctr][16])!) {    //PR+ > CR
                dToSort.append([Double(row_ctr), Double(db.sDriver[row_ctr][24])!, Double(db.sDriver[row_ctr][25])!,(Double(db.sDriver[row_ctr][24])! + Double(db.sDriver[row_ctr][25])!)/2])     // sort array: id, ACoins/+NCumulCoins, Acards/+NCumulCards and avg(ACoins/+NCumulCoins + Acards/+NCumulCards)
            }
            row_ctr = row_ctr + 11
        }
        var dSorted = dToSort.sorted(by: {
            ($0[3],$0[1],$0[2]) > ($1[3],$1[1],$1[2])    // sort 0 and 1 strings by col 3 then 1 then 2
        })
        Recs[2][0] = dSorted[0][0]     //  get the driver id of the sorted result
        //print("Recs (Driver)= ", Recs)
        
        
        // **********************************************************************************************
        //LT Driver
        
        dToSort.removeAll()
        row_ctr = 0
        while row_ctr < 659 {   //loop through drivers
            if(Double(db.sDriver[row_ctr][26])! > Double(db.sDriver[row_ctr][16])!) {    //PR+ > CR
                dToSort.append([Double(row_ctr), Double(db.sDriver[row_ctr][27])!, Double(db.sDriver[row_ctr][28])!,(Double(db.sDriver[row_ctr][27])! + Double(db.sDriver[row_ctr][28])!)/2])     // sort array: id, ACoins/++NCumulCoins, Acards/++NCumulCards and avg(ACoins/++NCumulCoins + Acards/++NCumulCards)
            }
            row_ctr = row_ctr + 11
        }
        dSorted = dToSort.sorted(by: {
            ($0[3],$0[1],$0[2]) > ($1[3],$1[1],$1[2])
        })
        
        Recs[3][0] = dSorted[0][0]
        //print("Recs (Driver)= ", Recs)
        
        
        // **********************************************************************************************
        //ST Part
        
        row_ctr = 0
        row_start = 0
        cat_ctr = 1
        maxPart = 0
        
        // ***********************************************************************************************
        //  Five Cases for Parts Upgrades
        // go through each category
        // 1. All levels equal: if D0 CL=PL and D1 CL=PL then no upgrade. msg: Select D0 and D1
        // 2. is D0 upgradeable: else if (ACa>NCa and ACo>NCo and D0 CL is not max), D0 font red,  msg: Select D1 and D0 and upgrade D0 immediately
        // 3. else is D1 upgradeable: else if (ACa>NCa and ACo>NCo and D1 CL is not max), D1 font red,  msg: Select D0 and D1 and upgrade D1 immediately
        // 4. otherwise: else if (RecPR0-PR0 > RecPR1-PR1) and D0 is not max. msg: Select D0 and D1 and upgrade D0 ASAP
        // 5. else if (RecPR1-PR1 > RecPR0-PR0) and D1 is not max.  msg: Select D0 and D1 and upgrade D0 ASAP
        
        // find for each category
        
        while row_start <= 461  { // < 461
            //print("row_start= ",row_crow_start)
            
            while row_ctr <= row_start + 76 {     // 7 parts per category * 11 rows per part = 0-76
                
                //print("!!row_ctr= ", row_ctr, "row_start= ",row_start, " cat_ctr= ", cat_ctr+3)
                //print("!!Recs[cat_ctr + 3][0]= ", Recs[cat_ctr + 3][0], " Recs[cat_ctr + 3][1]= ", Recs[cat_ctr + 3][1])
                //print( cat_ctr, Recs[cat_ctr + 3][0], Recs[cat_ctr + 3][1])
                
                // loop through each part category. If CR > current Rec part then dump the old Rec and put the id and CR in as the new Rec
                if (Double(db.sPart[row_ctr][16])! > Recs[cat_ctr + 3][1]) {      // if CR > current highest CR
                    Recs[cat_ctr + 3][0] = Double(row_ctr) //  id of new
                    Recs[cat_ctr + 3][1] = Double(db.sPart[row_ctr][16])!     // CR of new
                
                    // If PR > current Rec and ACo abnd ACa are large enough then put the id and CR in as the new Rec
                } else if ((Double(db.sPart[row_ctr][18])! > Recs[cat_ctr + 3][1]) &&          // if PR > [0][1]
                           (Double(sMultStripped)! > Double(db.sPart[row_ctr][22])!) &&          // ACo > NCo
                           (Double(db.sPart[row_ctr][20])! > Double(db.sPart[row_ctr][21])!)) {          // ACa > NCa
                    Recs[cat_ctr + 3][0] = Double(row_ctr)    // id of new
                    Recs[cat_ctr + 3][1] = Double(db.sPart[row_ctr][16])!     // CR of new
                }
                row_ctr = row_ctr + 11
                
            }
            //print("Recs[cat_ctr + 3][0]= ", Recs[cat_ctr + 3][0], " Recs[cat_ctr + 3][1]= ", Recs[cat_ctr + 3][1])
            
            cat_ctr = cat_ctr + 3   // next category in Recs[] for ST
            row_start = row_start + 77     // next category in sPart[[]]
        }
        
        //print("!!ST Recs (Final)= ", Recs)
        // ************************************************************************************************************************
        // Find best ST Part for Basic Recs in all part categories
        // loop through the Parts Recs[x][1]s and find the highest value and set it as the one to upgrade first
        // STPartRecId is the best part id to be upgraded
        
        // find which ones are immediate upgrade- pick the highest PR. If no immediates,
        
        row_ctr = 0
        
        var STPartRecPR: Double = 0.0
        while row_ctr <= 461  {
            if (Double(db.sPart[row_ctr][32])! > STPartRecPR) {     // [32] > current PR so set it
                STPartRecPR = Double(db.sPart[row_ctr][32])!
                STPartRecID = row_ctr
            }
                row_ctr = row_ctr + 11
        }
        
        
        // 1: immediate upgrade: if (ACa>NCa and ACo>NCo and STPartRecID is not max), STPartRecID font red,  msg: Select STPartRecID and upgrade immediately
        // 2: ASAP upgrade, msg: Select STPartRecID and upgrade ASAP
        
        // test to see if it's an immediate upgrade
        PaRecCase = 2    // ASAP upgrade to start
        if ((Double(sMultStripped)! > Double(db.sPart[STPartRecID][22])!) &&          // ACo > NCo
            (Double(db.sPart[STPartRecID][20])! > Double(db.sPart[STPartRecID][21])!) &&
            ((Int(db.sPart[STPartRecID][15])!) < maxLevel[Int(db.sPart[STPartRecID][13])!])) {          // CL is not maxLevel
            PaRecCase = 1
            db.sPart[STPartRecID][8] = "5"    // set the immediate upgrade font to red
        }
        
        if ((Int(db.sPart[STPartRecID][15])!) >= maxLevel[Int(db.sPart[STPartRecID][13])!]) {
            PaRecCase = 3         // no upgrade allowed if CL= maxLevel
        }
        //db.sDriver.forEach{print($0)}
        //db.sPart.forEach{print($0)}
       // print("**************************", db.sPart[132][1])
        //print("**************************", db.sPart[132][8])
        
        // ************************************************************************************************************************
        // Calc pit stop time
        // ************************************************************************************************************************
        
        row_ctr = 4     // 0-3 = drivers, 4-21 are parts
        pitStopTime = 0
        while row_ctr <= 7  { // < 461
            var id = Int(Recs[row_ctr][0])
            var CL = Int(db.sPart[id][15])!
            var pit = 0.0
            pitStopTime = pitStopTime + Double(db.sPart[Int(Recs[row_ctr][0]) + Int(db.sPart[id][15])! - 1][7])!
            pit = Double(db.sPart[id + CL - 1][7])!
            
            //pitStopTime = pitStopTime + sPart[Recs[row_ctr + sPart[row_ctr][15] - 1][0]][7]   // sRecs[rowctr] finds id. get CL[15] - 1 to get pitstoptime in [7]
            row_ctr += 1
        }
        
        
        
        // **********************************************************************************************
        //MT Part
        
        dToSort.removeAll()
        
        row_ctr = 0
        row_start = 0
        cat_ctr = 2
        maxPart = 0
        
        while row_start <= 461  { // < 461
            //print("row_start= ",row_start)
            
            while row_ctr <= row_start + 76 {
                if(Double(db.sPart[row_ctr][23])! > Double(db.sPart[row_ctr][16])!) {    //PR+ > CR
                    dToSort.append([Double(row_ctr), Double(db.sPart[row_ctr][24])!, Double(db.sPart[row_ctr][25])!,(Double(db.sPart[row_ctr][24])! + Double(db.sPart[row_ctr][25])!)/2])    // row, ACoins/++NCumulCoins, Acards/++NCumulCards and avg(ACoins/++NCumulCoins + Acards/++NCumulCards)
                }
                row_ctr = row_ctr + 11
                
            }
            //print("!! MT To sort: ", dToSort)
            dSorted = dToSort.sorted(by: {
                ($0[3],$0[1],$0[2]) > ($1[3],$1[1],$1[2])
                
            })
            //print("!! MT Sort done: ", dSorted)
            Recs[cat_ctr + 3][0] = dSorted[0][0]
            //print("!! MT Recs[cat_ctr + 3][0]= ", cat_ctr + 3, Recs[cat_ctr + 4][0])
            dToSort.removeAll()
            cat_ctr = cat_ctr + 3     // next category block in Recs displa
            row_start = row_start + 77    // next category in sPart
        }
        
        
        
        // **********************************************************************************************
        //LT Part
        
        dToSort.removeAll()
        
        row_ctr = 0
        row_start = 0
        cat_ctr = 3
        maxPart = 0
        
        // ************************* new way
        while row_start <= 450  { // < 461
            //print("row_start= ",row_start)
            
            while row_ctr <= row_start + 76 {
                if(Double(db.sPart[row_ctr][26])! > Double(db.sPart[row_ctr][16])!) {    //PR+ > CR
                    dToSort.append([Double(row_ctr), Double(db.sPart[row_ctr][27])!, Double(db.sPart[row_ctr][28])!,(Double(db.sPart[row_ctr][27])! + Double(db.sPart[row_ctr][28])!)/2])
                }
                row_ctr = row_ctr + 11
                
            }
            //print("!! LT To sort: ", dToSort)
            dSorted = dToSort.sorted(by: {
                ($0[3],$0[1],$0[2]) > ($1[3],$1[1],$1[2])
                
            })
            //print("!! LT Sort done: ", dSorted)
            Recs[cat_ctr + 3][0] = dSorted[0][0]
            cat_ctr = cat_ctr + 3
            dToSort.removeAll()
            row_start = row_start + 77
        }
        
        //print("Recs (Parts)= ", Recs)
        
        
        // *************************************************************************************************************************
        
        // Recs Display Driver Calcs- update RecsDispDriver[35] = 4 drivers 4 lines ie. 0-3, 4-7, 8-11, 12-15
        
        // find longest driverr ability by language
        // if lang = Eng, maxDriverStat = Wet Weather Ability (19), if German, maxStat = Ang Stuess van dr Vicken (assume 29)
        // string 1 is driver stats, string 2 is PL/PR stats, string 3 is CL= and Pl= stats, strings 4-9 are capabilities
        // string 1- concatenate 6 strings. Length of name/2 at pos 6 + pos 13 + pos 19 + pos 23 + pos 28 + pos 37
        // string 2- concatenate 5 strings. pos 5 + pos 12 + pos 20 + pos 28 + pos 37
        // string 2- concatenate 2 strings. pos 10 + pos 26
        // string 4 to 9- concatenate 3 strings. MaxStat/2 at pos 20. 4 spaces before from 1st stat= pos for all stats if stat > 9 otherwise subtract 1 space. 2 spaces after for 2 stat= pos for all 2nd stats if stat > 9, otherwise add 1 space.
        
        // big:little mapping. 10:14, 20:28+, 30:43, 39:56+. So mult factor = 1.4+, try 1.45
        
        // Speed    Cornering    PowerUnit    Reliability |   PitTime  |  Overtaking    Defending    Qualifying    RaceStart    Tire
        // en de es fr it
        
        
        // "Speed"; "Tempo"; "Velocidad";  "Vitesse";  "Velocità";
        // "Cornering"; "Kurenverhalten"; "Curvas"; "Courbe";  "Sterzata";
        //  "Power Unit"; "Triebwerk"; "Unidad de Potencia";"Unité de puissance"; "Check F1 Clash!";
        // "Reliability"; "Kuverlässignkeit";  "Fiabilidad"; "Fiabilité"; "Affidabilità";
        //
        // "Overtaking"; "Überholen"; "Adelantamiento"; "Dépassement"; "Sorpasso";
        // "Defending"; "Verterdigen";  "Defensa"; "Défense"; "Defesa";
        // "Qualifying"; "Qualifikation"; "Clasificación"; ="Qualification"; "Qualifiche";
        // "Race Start"; "Rennstart";  "Incio de Carrera"; "Début de course"; "Partenza";
        // "Tire Management"; "Reifen-Management"; "Gestión de neumáticos"; "Gestion des pneus";  "Gestione delle gomme";
        
        let langCode = Bundle.main.preferredLocalizations[0]
        var maxDriverStat = 0     //  length of longest capability stat
       
        
        if (langCode == "fr") {
            maxDriverStat = 17
            factors = ["Dépassement", "Défense", "Qualification", "Début de course", "Gestion des pneus", "Vitesse", "Courbe", "Unité de puissance", "Fiabilité"]
        } else if (langCode == "es") {
            maxDriverStat = 21
            factors = ["Adelantamiento", "Defensa", "Clasificación", "Incio de Carrera", "Gestión de neumáticos", "Velocidad", "Curvas", "Unidad de Potencia", "Fiabilidad"]
        } else if (langCode == "it") {
            maxDriverStat = 20
            factors = ["Sorpasso", "Defesa", "Qualifiche", "Partenza", "Gestione delle gomme", "Velocità", "Sterzata", "Check F1 Clash!", "Affidabilità"]
        } else if (langCode == "de") {
            maxDriverStat = 17
            factors = ["Überholen", "Verterdigen", "Qualifikation", "Rennstart", "Reifen-Management", "Tempo", "Kurenverhalten", "Triebwerk", "Kuverlässignkeit"]
        } else {    // "en" is default
            maxDriverStat = 15           //always even
            factors = ["Overtaking", "Defending", "Qualifying", "Race Start", "Tire Management", "Speed", "Cornering", "Power Unit", "Reliability"]
        }
        //            1         2         3
        //   123456789012345678901234567890123456789
        
        
        var LStart = 14 - Int(maxDriverStat/2)   // left start column for capabilities= middle - 1/2 of longest -2 spaces - possible 2 for CL
        var RStart = 20 + Int(maxDriverStat/2)   // right start column for capabilities= middle + 1/2 of longest +2 spaces + possible 1 for CL
        //    print("!!! Lstart: \(LStart)")
        //    print("!!! Rstart: \(RStart)")
        //    print("!!! maxDriverStat: \(maxDriverStat)")
        var RecNumber = 0  // 22 values of recommended drivers and parts
        var sTemp = ""
        
        row_ctr = 0    // 4 drivers x 4 strings
        var rec_ctr = 0   // 4 drivers (0 to 3) in Recs[]
        while row_ctr < 15 {
            
            RecNumber = Int(Recs[rec_ctr][0])
            
            // build string 0
            //Name starts at pos 1, CL right justified back from 14, 2 spaces for CR starting at 17, PL right justified back from 23, ACa right justified back from 30, ACo right justified back from 38.
            
            RecsDispDriver[row_ctr] = db.sDriver[RecNumber][1] + Spaces.prefix(14 - db.sDriver[RecNumber][1].count - db.sDriver[RecNumber][15].count) + db.sDriver[RecNumber][15]     // Name, CL
            RecsDispDriver[row_ctr] = RecsDispDriver[row_ctr] + Spaces.prefix(2) + db.sDriver[RecNumber][16]     // CR
            RecsDispDriver[row_ctr] = RecsDispDriver[row_ctr] + Spaces.prefix(3 - db.sDriver[RecNumber][17].count) + db.sDriver[RecNumber][17]     // PL
            RecsDispDriver[row_ctr] = RecsDispDriver[row_ctr] + Spaces.prefix(7 - db.sDriver[RecNumber][20].count) + db.sDriver[RecNumber][20]     // ACa
            RecsDispDriver[row_ctr] = RecsDispDriver[row_ctr] + String(Spaces.prefix(9 - db.sMult[11][1].count)) + db.sMult[11][1]   // Name, CL, CR, PL, ACa, ACo

            
            // build string 1
            // string 2- concatenate 5 strings. pos 5 + pos 12 + pos 20 + pos 28 + pos 37
            // for cl to pl (assume 1 and 3) and also try (4 and 4)
            // if pl=cl then just show pl in 1 row else do loop
            // if pl,cl <10 then add a space in front
            
            RecsDispDriver[row_ctr + 1] = ""   //clear it
            
            if (db.sDriver[RecNumber][15] == db.sDriver[RecNumber][17]) {     // CL = PL so 1 displayed line
                RecsDispDriver[row_ctr + 1] = Spaces.prefix(4 - db.sDriver[RecNumber][17].count) + db.sDriver[RecNumber][17] + Spaces.prefix(4) + db.sDriver[RecNumber][18] + Spaces.prefix(8 - db.sDriver[RecNumber][19].count) + db.sDriver[RecNumber][19]
                RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(7 - db.sDriver[RecNumber][21].count) + db.sDriver[RecNumber][21] + Spaces.prefix(10 - db.sDriver[RecNumber][22].count) + db.sDriver[RecNumber][22]      //PL, PR, MR, NCa, NCo
            } else {     // CL < PL so display multiple lines
                var curr_ctr = Int(db.sDriver[RecNumber][15])! + 1  // 1st line = CL + 1
                
                while curr_ctr <= Int(db.sDriver[RecNumber][17])! {  // loop until PL is reached
                    
                    RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1]
                    + Spaces.prefix(4 - db.sDriver[RecNumber + curr_ctr - 1][2].count) + db.sDriver[RecNumber + curr_ctr - 1][2]
                    + Spaces.prefix(8 - db.sDriver[RecNumber + curr_ctr - 1][12].count) + db.sDriver[RecNumber + curr_ctr - 1][12]
                    + Spaces.prefix(3) + db.sDriver[RecNumber][19]
                    + Spaces.prefix(9 - db.sCard[curr_ctr - 1][1].count) + db.sCard[curr_ctr - 1][1]
                    + Spaces.prefix(10 - db.sDriver[RecNumber + curr_ctr - 1][9].count) + db.sDriver[RecNumber + curr_ctr - 1][9]
                     + "\n"      //PL, PR, MR, NCa, NCo
                    
                    curr_ctr = curr_ctr + 1
                    // if curr cl is still less than pl, then + \n, next
                }
                let subString = RecsDispDriver[row_ctr + 1].prefix((RecsDispDriver[row_ctr + 1].count) - 1)
                RecsDispDriver[row_ctr + 1] = String(subString)  // remove last \n
            }
                        
            
            // build string 2
            //
            let transCL = NSLocalizedString("CL", comment: "a test")
            let transPL = NSLocalizedString("PL", comment: "another test")
            
            //RecsDispDriver[row_ctr + 2] = "driver test"
            //var tempSp:Double = 0.0
            //var tempSp = Int(Double(maxDriverStat) * 1.4 + 0.5)
            //print("!! \(tempSp)")
            
            RecsDispDriver[row_ctr + 2] = Spaces.prefix(Int(Double(LStart) * 1.3)) + transCL + "=\(db.sDriver[RecNumber][15])" + Spaces.prefix(Int(Double(maxDriverStat) * 1.9 + 0.5)) + transPL + "=\(db.sDriver[RecNumber][17])"
            
            
           
            // build string 3
            //
            //        var maxDriverStat = 19     //  length of longest capability stat for emglish
            //        var LStart = 20 - Int(maxDriverStat/2) - 4   // left start column for capabilities = 7 for english
            //        var RStart = 20 + Int(maxDriverStat/2) + 2   // right start column for capabilities = 31 for english
            //
            // line = LStart, value with/without extra space, LHSpace, value, RHSpace, value with/without extra space
            //
            
            let xCL = Int(db.sDriver[RecNumber][15])!    // CL value
            let xPL = Int(db.sDriver[RecNumber][17])!    // PL value
            var sTemp = ""
            
            //Overtaking
            //if overtaking(CL) < 10, add space. if overtaking(PL) < 10, add space.
            var xLSpace = 0   //extra LH space needed for small values
            var xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][3])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][3])! < 10) {
                xRSpace = 1
            }
            var sSpaceleft = RStart - LStart + 1 - factors[0].count     //space between left and right columns and Overtaking
            var LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            var RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][3] + String(Spaces.prefix(LHSpace)) + factors[0] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][3] + "\n"  // left of Overtaking spaces and Overtaking CL value and right of Overtaking CL spaces and transl(Overtaking) and right of Overtaking spaces and Overtaking PL value
            
            //Defending
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][4])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][4])! < 10) {
                xRSpace = 1
            }
            sSpaceleft = RStart - LStart + 1 - factors[1].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][4] + String(Spaces.prefix(LHSpace)) + factors[1] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][4] + "\n"  // see Overtaking comment above for details
            
            //Qualifying
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][5])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][5])! < 10) {
                xRSpace = 1
            }
            sSpaceleft = RStart - LStart + 1 - factors[2].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][5] + String(Spaces.prefix(LHSpace)) + factors[2] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][5] + "\n"  // see Overtaking comment above for details
            
            //Race Start
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][6])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][6])! < 10) {
                xRSpace = 1
            }
            sSpaceleft = RStart - LStart + 1 - factors[3].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][6] + String(Spaces.prefix(LHSpace)) + factors[3] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][6] + "\n"  // see Overtaking comment above for details
            
            //Tire Management
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][7])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][7])! < 10) {
                xRSpace = 1
            }
            sSpaceleft = RStart - LStart + 1 - factors[4].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][7] + String(Spaces.prefix(LHSpace)) + factors[4] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][7]  // see Overtaking comment above for details
            
            
            //sSpaceleft = RStart - LStart + 1 - factors[10].count     //space between left and right columns and Overtaking
            //LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            //RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            //sTemp = String(Spaces.prefix(xLSpace + LStart) + db.sDriver[RecNumber + xCL - 1][8] + String(Spaces.prefix(LHSpace)) + factors[10])
            //sTemp = sTemp + String(Spaces.prefix(RHSpace)) + db.sDriver[RecNumber + xPL - 1][8]
            //RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][8] + String(Spaces.prefix(LHSpace)) + factors[10] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][8]  // see Overtaking comment above for details
            //RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) +  String(Spaces.prefix(LHSpace)) + factors[10] + String(Spaces.prefix(RHSpace + xRSpace))   // see Overtaking comment above for details
            
            row_ctr = row_ctr + 4
            rec_ctr = rec_ctr + 1
        }
        
        
        
        
        
        // *************************************************************************************************************************
        
        // Recs Display Parts Calcs- update RecsDispParts[125] = 18 parts 4 lines ie. 0-3, 4-7, 8-11, 12-15, ......., 68-71
        
        // find longest parts ability by language
        // if lang = Eng, maxStat = Wet Weather Ability (19), if German, maxStat = Ang Stuess van dr Vicken (assume 29)
        // string 1 is driver stats, string 2 is PL/PR stats, string 3 is CL= and Pl= stats, strings 4-9 are capabilities
        // string 1- concatenate 6 strings. Length of name/2 at pos 6 + pos 13 + pos 19 + pos 23 + pos 28 + pos 37
        // string 2- concatenate 5 strings. pos 5 + pos 12 + pos 20 + pos 28 + pos 37
        // string 2- concatenate 2 strings. pos 10 + pos 26
        // string 4- concatenate 3 strings. MaxStat/2 at pos 20. 4 spaces before from 1st stat= pos for all stats if stat > 9 otherwise subtract 1 space. 2 spaces after for 2 stat= pos for all 2nd stats if stat > 9, otherwise add 1 space.
        
        
        // find longest parts capability ability by language
        // if lang = Eng, maxStat = Reliability (11), if German, maxStat = Ang Stuess van dr Vicken (assume 29)
        var maxPartStat = 0
        if (langCode == "en") {
            maxPartStat = 11   // length of longest capability stat- Reliability
        } else if (langCode == "fr") {
            maxPartStat = 18
        } else if (langCode == "es") {
            maxPartStat = 18
        } else if (langCode == "it") {
            maxPartStat = 15
        } else if (langCode == "de") {
            maxPartStat = 16
        }
        if (maxPartStat%2 == 0) {   //even
            LStart = 20 - Int(maxPartStat/2) - 4   // left start column for even capabilities
            RStart = 19 + Int(maxPartStat/2) + 3   // right start column for odd capabilities- shifted one to the left since its off centre
        } else {
            LStart = 20 - Int(maxPartStat/2) - 4   // left start column for capabilities
            RStart = 20 + Int(maxPartStat/2) + 3   // right start column for capabilities
        }

        RecNumber = 0  // 22 values of recommended drivers and parts
        
        row_ctr = 16    // 18 parts x 4 strings
        rec_ctr = 4   // 18 parts (0 to 3 are Drivers, 4-22 are Parts) in Recs[]
        while row_ctr < 87 {
            
            RecNumber = Int(Recs[rec_ctr][0])
            //print("!!1317 \(Recs[rec_ctr][0])")
            
            // **********************************
            // build string 0
            
            RecsDispParts[row_ctr] = db.sPart[RecNumber][1] + Spaces.prefix(14 - db.sPart[RecNumber][1].count - db.sPart[RecNumber][15].count) + db.sPart[RecNumber][15]     // Name, CL
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(2) + db.sPart[RecNumber][16]     // CR
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(3 - db.sPart[RecNumber][17].count) + db.sPart[RecNumber][17]     // PL
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(7 - db.sPart[RecNumber][20].count) + db.sPart[RecNumber][20]     // ACa
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + String(Spaces.prefix(9 - db.sMult[11][1].count)) + db.sMult[11][1]   // Name, CL, CR, PL, ACa, ACo
            
            // **********************************
            // build parts string 1
            
            RecsDispParts[row_ctr + 1] = ""   //clear it
            
            if (db.sPart[RecNumber][15] == db.sPart[RecNumber][17]) {     // CL = PL so 1 displayed line
                RecsDispParts[row_ctr + 1] = Spaces.prefix(4 - db.sPart[RecNumber][17].count) + db.sPart[RecNumber][17] + Spaces.prefix(4) + db.sPart[RecNumber][18] + Spaces.prefix(8 - db.sPart[RecNumber][19].count) + db.sPart[RecNumber][19]
                RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1] + Spaces.prefix(7 - db.sPart[RecNumber][21].count) + db.sPart[RecNumber][21] + Spaces.prefix(10 - db.sPart[RecNumber][22].count) + db.sPart[RecNumber][22]      //PL, PR, MR, NCa, NCo
            } else {     // CL < PL so display multiple lines
                var curr_ctr = Int(db.sPart[RecNumber][15])! + 1  // 1st line = CL + 1
                
                while curr_ctr <= Int(db.sPart[RecNumber][17])! {  // loop until PL is reached
                    
                    RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1]
                    + Spaces.prefix(4 - db.sPart[RecNumber + curr_ctr - 1][2].count) + db.sPart[RecNumber + curr_ctr - 1][2]
                    + Spaces.prefix(8 - db.sPart[RecNumber + curr_ctr - 1][12].count) + db.sPart[RecNumber + curr_ctr - 1][12]
                    + Spaces.prefix(3) + db.sPart[RecNumber][19]
                    + Spaces.prefix(9 - db.sCard[curr_ctr - 1][1].count) + db.sCard[curr_ctr - 1][1]
                    + Spaces.prefix(10 - db.sPart[RecNumber + curr_ctr - 1][9].count) + db.sPart[RecNumber + curr_ctr - 1][9]
                     + "\n"      //PL, PR, MR, NCa, NCo
                    
                    curr_ctr = curr_ctr + 1
                    // if curr cl is still less than pl, then + \n, next
                }
                let subString = RecsDispParts[row_ctr + 1].prefix((RecsDispParts[row_ctr + 1].count) - 1)
                RecsDispParts[row_ctr + 1] = String(subString)  // remove last \n
            }
            
            // **********************************
            // build parts string 2
            
            let transCL = NSLocalizedString("CL", comment: "a test")
            let transPL = NSLocalizedString("PL", comment: "another test")
            
            //RecsDispParts[row_ctr + 2] = "parts test"
            //tempSp = maxPartStat * 1.4
            //print("!! \(tempSp)")

            RecsDispParts[row_ctr + 2] = Spaces.prefix(Int(Double(LStart) * 1.3)) + transCL + "=\(db.sPart[RecNumber][15])" + Spaces.prefix(Int(Double(maxPartStat) * 1.9 + 0.5)) + transPL + "=\(db.sPart[RecNumber][17])"
            
            
            // **********************************
            // build parts string 3
            
            let xCL = Int(db.sPart[RecNumber][15])!
            let xPL = Int(db.sPart[RecNumber][17])!
            var xLSpace = 0   //extra LH space needed for small CL
            var xRSpace = 0   //extra RH space needed for small PL
            
            LStart = 20 - Int(maxPartStat/2) - 4   // left start column for capabilities ie pos1
            RStart = 20 + Int(maxPartStat/2) + 3   // right start column for capabilities ie pos4
            let pos1 = LStart   // start pos of CL
            var pos2 = 0   // start pos of capabilities
            var pos3 = 0   // end pos of capabilities
            let pos4 = RStart   // start pos of PL
            
            //Speed
            pos2 = 20 - Int(factors[5].count/2)
            pos3 = 20 + Int(factors[5].count/2)
            var sCL = db.sPart[RecNumber + xCL - 1][3]
            var sPL = db.sPart[RecNumber + xPL - 1][3]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            var sTemp = String(Spaces.prefix(pos1 - 1)) +  sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[5]
            RecsDispParts[row_ctr + 3] = sTemp + String(Spaces.prefix(pos4 - sTemp.count)) + sPL + "\n"
            
            //Cornering
            pos2 = 20 - Int(factors[6].count/2)
            pos3 = 19 + Int(factors[6].count/2)    //shifted because Aero is even
            sCL = db.sPart[RecNumber + xCL - 1][4]
            sPL = db.sPart[RecNumber + xPL - 1][4]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            sTemp = String(Spaces.prefix(pos1 - 1)) +  sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[6]
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + sTemp + String(Spaces.prefix(pos4 - sTemp.count)) + sPL + "\n"
            
            //Power unit
            pos2 = 20 - Int(factors[7].count/2)
            pos3 = 19 + Int(factors[7].count/2)    //shifted because Grip is even
            sCL = db.sPart[RecNumber + xCL - 1][5]
            sPL = db.sPart[RecNumber + xPL - 1][5]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            sTemp = String(Spaces.prefix(pos1 - 1)) +  sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[7]
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + sTemp + String(Spaces.prefix(pos4 - sTemp.count)) + sPL + "\n"
             
            //Reliability
            pos2 = 20 - Int(factors[8].count/2)
            pos3 = 20 + Int(factors[8].count/2)
            sCL = db.sPart[RecNumber + xCL - 1][6]
            sPL = db.sPart[RecNumber + xPL - 1][6]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            sTemp = String(Spaces.prefix(pos1 - 1)) +  sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[8]
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + sTemp + String(Spaces.prefix(pos4 - sTemp.count)) + sPL

            row_ctr = row_ctr + 4
            rec_ctr = rec_ctr + 1
        }
        
        
        // **********************************************************************************
        // **********************************************************************************
        // Calculate teamScore
        //
        
        // STDriverRecID and STPartRecID have the row numbers for the upgrades. Go through the RECs and get the [16] PRs. If Rec[x][0] = STDriverRecID or STPartRecID, use the [32]s upgraded PRs.
        // Use Recs[][] 0,1,4,7,10,13,16,19
        // PR= and PR1 = 0
        // so we have Rec0 and Rec1. If their CLs = PLs then choose both with no upgrades
        // if Rec0 Cl < PL then with the ACo how many levels up can you upgrade? Start at CL+1, determine PR, then repeat until you reach PL. Whatever PR0 you have wins. Record PLRec0.
        // Do the same for Rec1 to find PR1. Record PLRec1.
        // If PR0 >= PR1 then upgrade PR0 to level ? else upgrade  PR1 to level ??
        // iFinal = Int(Double(db.sDriver[Int(Recs[0][0]) + Int(db.sDriver[Int(Recs[0][0])][15])!][12])!)    // final combining, works
        // if RecCL=RecPL, then get RecCL and add that row to Rec[0][0] to get the offset value and look up the normalized rating for RecCL. Add it to the teamScore

        iTeamScore = 0    //clear
        let recDrRange = [0,1]   // 2 driver recs
        let recPaRange = [4,7,10,13,16,19]  // 6 category parts recs
        let STDriverRecID = db.sDriver[Int(Recs[0][0])][1]
        let STPartRecID = db.sDriver[Int(Recs[0][0])][1]
        for row_ctr in recDrRange {
            if (Recs[row_ctr][0] == Double(STDriverRecID)) {
                iTeamScore = iTeamScore + Int(Double(db.sDriver[Int(Recs[row_ctr][0])][32])!)
            } else {
                iTeamScore = iTeamScore + Int(Double(db.sDriver[Int(Recs[row_ctr][0])][16])!)
            }
        }

        for row_ctr in recPaRange {
            if (Recs[row_ctr][0] == Double(STPartRecID)) {
                iTeamScore = iTeamScore + Int(Double(db.sPart[Int(Recs[row_ctr][0])][32])!)
            } else {
                iTeamScore = iTeamScore + Int(Double(db.sPart[Int(Recs[row_ctr][0])][16])!)
            }
        }
        //dump(Recs)
        
    }  // start()
    
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    func printArrRow(arrName: [[String]], xRow: Int) {
        for m in 0..<33 {
            print("!! [\(m)] = \(arrName[xRow][m])")
        }
    }
    
    func printArrCol(arrName: [[String]], xRow: Int) {
        for m in 0..<33 {
            print("!! [\(m)] = \(arrName[m][xRow])")
        }
    }
    
}   // struct


struct InfoSheetRecsView: View {
    var body: some View {
        VStack {
            Text("recommendationsScreen")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 300)
            }
            .frame(maxWidth: .infinity, maxHeight: 50) // 1
            .accentColor(Color.black)
            .background(Color.colours.backgrd_blue)
            .padding(.bottom, 20)
        VStack {
            Text("info_contents_recs")
                .font(.system(size: 14))
                .frame(width: 300)
            }
    }
}



struct RecsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
    }
}

