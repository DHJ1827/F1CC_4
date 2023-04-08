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
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic]
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
                        
                        Text("resultRecs1")  // Translated(Name CL CR PL ACa NCo)
                            .font(.system(size: 9, design: .monospaced))
                            .fontWeight(.regular)
                            .frame(width: 320, alignment: .leading)
                            .background(cmode[Int(db.sPart[RecNumber][13])!])
                        Text(RecsDispParts[index_v/11 * 4])     // string 0
                            .font(.system(size: 13, design: .monospaced))
                            .fontWeight(.semibold)
                            .frame(width: 320, alignment: .leading)
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
    @State var teamScore:Int = 0
    @State var upgradeID:Int = -1     //dummy integer
    
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
    
    let Spaces = "                                        "
    
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic]
    let factors = ["Power", "Aero", "Grip", "Reliability", "Pit Stop Time", "Overtaking", "Defending", "Consistency", "Fuel Management", "Tire Management", "Wet Weather Ability"]
    
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
            VStack(alignment: .center) {     //  picker, image, button
                
                Picker(selection: $db.sSelectedMode, label: Text("Mode:")) {
                    Text("basicMode").tag("basicMode")
                    Text("detailMode").tag("detailMode")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
                
            }   //VStack
            
            Spacer(minLength: 15)
            
            if (db.sSelectedMode == "detailMode") {
                
                VStack {
                    Text("legend")
                        .font(.system(size: 11))
                        .frame(width: 100)
                    HStack(spacing: 0) {
                        /*
                         Image(db.photoNum)
                         .resizable()
                         .frame(width: 150, height: 150)
                         .offset(x: 5, y: 0)
                         */
                        VStack {
                            Text("common")
                                .font(.system(size: 11))
                                .frame(width: 100)
                                .background(cmode[1])
                            
                            Text("rare")
                                .font(.system(size: 11))
                                .frame(width: 100)
                                .background(cmode[2])
                            
                            Text("epic")
                                .font(.system(size: 11))
                                .frame(width: 100)
                                .background(cmode[3])
                            
                        }
                        
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
                        
                    }
                    .border(.black)
                    
                    Spacer(minLength: 35)
                    Text("recommendations")
                        .font(.system(size: 16, weight: .bold, design: .default))
                    Spacer(minLength: 15)
                    
                    HStack(spacing: 0) {
                        Text("ST")   //ST Driver Rec1
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sDriver[Int(Recs[0][0])][1])   //ST Driver Rec1
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 120)
                            .background(cmode[Int(db.sDriver[Int(Recs[0][0])][13])!])
                        Text(db.sDriver[Int(Recs[1][0])][1])   //ST Driver Rec2
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 120)
                            .background(cmode[Int(db.sDriver[Int(Recs[1][0])][13])!])
                    }
                    HStack(spacing: 0) {
                        Text("MT")   //MT Driver Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sDriver[Int(Recs[2][0])][1])   //MT Driver Rec
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 240)
                            .background(cmode[Int(db.sDriver[Int(Recs[2][0])][13])!])
                    }
                    HStack(spacing: 0) {
                        Text("LT")   //LT Driver Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        
                        Text(db.sDriver[Int(Recs[3][0])][1])   //LT Driver Rec
                            .font(.system(size: 16))
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
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[4][0])][13])!])
                        Text(db.sPart[Int(Recs[7][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[5][0])][13])!])
                        Text(db.sPart[Int(Recs[10][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[6][0])][13])!])
                    }
                    HStack {
                        Text("MT")   //MT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[5][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[7][0])][13])!])
                        Text(db.sPart[Int(Recs[8][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[8][0])][13])!])
                        Text(db.sPart[Int(Recs[11][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[9][0])][13])!])
                    }
                    HStack {
                        Text("LT")   //LT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[6][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[10][0])][13])!])
                        Text(db.sPart[Int(Recs[9][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[11][0])][13])!])
                        Text(db.sPart[Int(Recs[12][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[12][0])][13])!])
                    }
                }   //VStack
                Spacer(minLength: 25)
                VStack{                                   // ST, MT and LT Parts Recs Block 2
                    HStack {
                        Text("ST")   //ST Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[13][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[13][0])][13])!])
                        Text(db.sPart[Int(Recs[16][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[14][0])][13])!])
                        Text(db.sPart[Int(Recs[19][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[15][0])][13])!])
                    }
                    
                    HStack {
                        Text("MT")   //MT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[14][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[16][0])][13])!])
                        Text(db.sPart[Int(Recs[17][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[17][0])][13])!])
                        Text(db.sPart[Int(Recs[20][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[18][0])][13])!])
                    }
                    HStack {
                        Text("LT")   //LT Parts Rec
                            .font(.system(size: 12))
                            .frame(width: 20)
                        Text(db.sPart[Int(Recs[15][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[19][0])][13])!])
                        Text(db.sPart[Int(Recs[18][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[20][0])][13])!])
                        Text(db.sPart[Int(Recs[21][0])][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 110)
                            .background(cmode[Int(db.sDriver[Int(Recs[21][0])][13])!])
                    }
                    
                    Spacer(minLength: 15)
                    
                    VStack(alignment: .center) {
                        HStack{
                            Text("coins \(db.sMult[11][1])")       // Coins display
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        Spacer(minLength: 15)
                        
                        VStack(alignment: .center) {
                            let pitString: String = String(Double(Int(pitStopTime * 100))/100) + " s."
                            Text("pitStopTime \(pitString)")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        Spacer(minLength: 15)
                        
                        VStack(alignment: .center) {
                            Text("teamScore \(teamScore)")
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .frame(minWidth: 100, minHeight: 30, alignment: .center)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.white)
                                .background(Color.colours.backgrd_blue)
                        }
                        
                        
                    }    //VStack
                    Spacer(minLength: 15)
                }
                
                Spacer(minLength: 15)
                
                VStack(alignment: .leading) {
                    Text("driver")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .leading)
                        .padding(.horizontal, 30)
                    
                    ForEach(Array(stride(from: 0, to: 34, by: 11)), id: \.self) { index_v in
                        
                        let sDriverList: [String] = ["ST", "ST", "MT", "LT"]
                        let iDriverTerm = Int(index_v)/11      // index_v is not an Int- needs to be cast first !!!!!!!
                        let transDriverString = LocalizedStringKey(sDriverList[iDriverTerm]) // works
                        
                        HStack(alignment: .top) {
                            
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
                                    
                                    Text(RecsDispDriver[index_v/11 * 4])     // string 0
                                        .font(.system(size: 13, design: .monospaced))
                                        .fontWeight(.semibold)
                                        .frame(width: 320, alignment: .leading)
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
                                    //.background(cmode[Int(db.sDriver[ctr][13])!])
                                    // Text("123456789012345678901234567890123456789")
                                    // .font(.system(size: 13, design: .monospaced))
                                    // .fontWeight(.semibold)
                                    // .frame(width: 320, alignment: .center)
                                    Text(RecsDispDriver[index_v/11 * 4 + 3])     // string 3, can be multi-line
                                        .font(.system(size: 13, design: .monospaced))
                                        .fontWeight(.semibold)
                                        .frame(width: 320, alignment: .leading)
                                }
                                .border(.black)
                            }
                        }
                        Spacer(minLength: 15)
                    }
                    
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
                VStack {    //    Basic
                    
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
                    
                    Spacer(minLength: 20)
                    
                    Text("driver")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .center)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color.white)
                        .background(Color.colours.backgrd_blue)
                    
                    VStack {
                        if ((db.sDriver[Int(Recs[0][0])][15] == db.sDriver[Int(Recs[0][0])][17]) && (db.sDriver[Int(Recs[1][0])][15] == db.sDriver[Int(Recs[1][0])][17])) {
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1]) \(db.sDriver[Int(Recs[1][0])][1])")
                        } else {
                            Text("basicDrSelect \(db.sDriver[Int(Recs[0][0])][1]) \(db.sDriver[Int(Recs[1][0])][1])") + Text("basicOneUpgrade \(db.sDriver[upgradeID][1]) \(db.sDriver[upgradeID][31])")
                            //Text("Yup")
                        }
                        
                    }
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .frame(width: 360)
                    
                    Spacer(minLength: 20)
                    
                    Text("components")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(minWidth: 100, minHeight: 30, alignment: .center)
                        .padding(.horizontal, 10)
                        .foregroundColor(Color.white)
                        .background(Color.colours.backgrd_blue)
                    
                    VStack(alignment: .leading) {
                        Group {
                            if (db.sPart[Int(Recs[4][0])][15] == db.sPart[Int(Recs[4][0])][17]) {
                                Text("brakes") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[4][0])][1])") + Text(" \n")
                            } else {
                                Text("brakes") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[4][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[4][0])][15])!+1))") + Text(" \n")
                            }
                            if (db.sPart[Int(Recs[7][0])][15] == db.sPart[Int(Recs[7][0])][17]) {
                                Text("gearbox") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[7][0])][1])") + Text(" \n")
                            } else {
                                Text("gearbox") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[7][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[7][0])][15])!+1))") + Text(" \n")
                            }
                            if (db.sPart[Int(Recs[10][0])][15] == db.sPart[Int(Recs[10][0])][17]) {
                                Text("rearwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[10][0])][1])") + Text(" \n")
                            } else {
                                Text("rearwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[10][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[10][0])][15])!+1))") + Text(" \n")
                            }
                        }    // group
                        .font(.system(size: 14, weight: .bold, design: .default))
                        
                        Group {
                            if (db.sPart[Int(Recs[13][0])][15] == db.sPart[Int(Recs[13][0])][17]) {
                                Text("frontwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[13][0])][1])") + Text(" \n")
                            } else {
                                Text("frontwing") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[13][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[13][0])][15])!+1))") + Text(" \n")
                            }
                            if (db.sPart[Int(Recs[16][0])][15] == db.sPart[Int(Recs[16][0])][17]) {
                                Text("suspension") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[16][0])][1])") + Text(" \n")
                            } else {
                                Text("suspension") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[16][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[16][0])][15])!+1))") + Text(" \n")
                            }
                            if (db.sPart[Int(Recs[19][0])][15] == db.sPart[Int(Recs[19][0])][17]) {
                                Text("engine") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[19][0])][1])")
                            } else {
                                Text("engine") + Text(": ") + Text("basicPaSelect \(db.sPart[Int(Recs[19][0])][1])") + Text("basicPaUpgrade \(String(Int(db.sPart[Int(Recs[19][0])][15])!+1))")
                            }
                        }     //group
                        .font(.system(size: 14, weight: .bold, design: .default))
                    }   //VStack
                    
                    Spacer(minLength: 20)
                    
                    Text("teamScore: \(teamScore)")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding()
                        .border(Color.colours.backgrd_blue, width: 4)
                        .multilineTextAlignment(.center)
                    
                    Text("rememberRecs")
                        .font(.system(size: 14, weight: .bold, design: .default))
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
        //db.sMult[11][1] = commFormatter.string(from: Int(db.sMult[11][1].replacingOccurrences(of: ",", with: ""))! as NSNumber)!   //update format for coins
        let sMultStripped = db.sMult[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
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
       row_ctr = 0
        Recs[0][0] = Double(row_ctr)    // clear array to start over
        Recs[0][1] = Double(row_ctr)
        Recs[1][0] = Double(row_ctr)
        Recs[1][1] = Double(row_ctr)
        print("!!RV784 \(Recs[0][0]) \(Recs[0][1]) \(Recs[1][0]) \(Recs[1][1])")
        while row_ctr < 659 {   // go through all drivers, 11 rows at a time
            print("!!RV787 \(db.sDriver[row_ctr][32]) \(Recs[0][1]) \(db.sDriver[row_ctr][1]) \(db.sDriver[Int(Recs[0][0])][1])")
            
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
        // now find out the id to be upgraded
        print("!!RV 800 \(Recs[0][0]) \(Recs[0][1]) \(Recs[1][0]) \(Recs[1][1])")
        if ((Double(db.sDriver[Int(Recs[0][0])][32])! - Double(db.sDriver[Int(Recs[0][0])][16])!) >= (Double(db.sDriver[Int(Recs[1][0])][32])! - Double(db.sDriver[Int(Recs[1][0])][16])!)) {    // Recs0 PR > Recs1 PR
            upgradeID = Int(Recs[0][0])
        } else {
            upgradeID = Int(Recs[1][0])
        }
        print("!!RV811 upgradeID= \(upgradeID)")
        //******  OLD   *********
        /*
        row_ctr = 0
        Recs[0][0] = Double(row_ctr)    // clear array to start over
        Recs[0][1] = Double(row_ctr)
        Recs[1][0] = Double(row_ctr)
        Recs[1][1] = Double(row_ctr)
        while row_ctr < 659 {   // go through all drivers, 11 rows at a time
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
            //print("!! Recs659 \(row_ctr) \(Double(db.sDriver[row_ctr][18])) \(Double(db.sDriver[row_ctr][20])) \(Double(db.sDriver[row_ctr][21])) \(Double(db.sDriver[row_ctr][22])) \(Double(sMultStripped)) \(Recs[0][0]) \(Recs[1][0])")
            //print("!! Recs664 \(db.sMult[11][1])")
            
            // if there are enough coins and cards and PR is bigger than the current CRs then choose it (its a IU)
            if ((Double(db.sDriver[row_ctr][18])! > Recs[0][1]) &&          // PR[18]
                (Double(sMultStripped)! > Double(db.sDriver[row_ctr][22])!) &&          // ACo(converted from string to # > NCo
                (Double(db.sDriver[row_ctr][21])!) > Double(db.sDriver[row_ctr][20])! &&         // ACa > NCa
                (Double(row_ctr) != Recs[1][0])) {       // no double drivers
                Recs[1][0] = Recs[0][0]   // push [0] id down to [1]
                Recs[1][1] = Recs[0][1]   // push value [0] down to [1]
                Recs[0][0] = Double(row_ctr) //  id of new
                Recs[0][1] = Double(db.sDriver[row_ctr][18])!  // value of new
                // if CL0 < PL0 then theres an upgrade possibility. Same for CL1 and PL1. Check the PRs and upgrade the driver with the highest PR
            } else if (Double(db.sDriver[row_ctr][18])! > Recs[1][1]) &&          // PR > [1]
                        (Double(sMultStripped)! > Double(db.sDriver[row_ctr][22])!) &&          // ACo > NC0
                        (Double(db.sDriver[row_ctr][21])! > Double(db.sDriver[row_ctr][20])! &&        // ACa > NCa
                         (Double(row_ctr) != Recs[0][0])) {      // no double drivers
                Recs[1][0] = Double(row_ctr)    // id of new
                Recs[1][1] = Double(db.sDriver[row_ctr][18])!  // value of new
            }
         */

        
        
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
            ($0[3],$0[1],$0[2]) > ($1[3],$1[1],$1[2])
        })
        Recs[2][0] = dSorted[0][0]
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
        
        // ************************* new way
        while row_start <= 461  { // < 461
            //print("row_start= ",row_crow_start)
            
            while row_ctr <= row_start + 76 {     // 7 parts per category * 11 rows per part = 0-76
                
                //print("!!row_ctr= ", row_ctr, "row_start= ",row_start, " cat_ctr= ", cat_ctr+3)
                //print("!!Recs[cat_ctr + 3][0]= ", Recs[cat_ctr + 3][0], " Recs[cat_ctr + 3][1]= ", Recs[cat_ctr + 3][1])
                //print( cat_ctr, Recs[cat_ctr + 3][0], Recs[cat_ctr + 3][1])
                if (Double(db.sPart[row_ctr][16])! > Recs[cat_ctr + 3][1]) {      // CR > current highest CR
                    Recs[cat_ctr + 3][0] = Double(row_ctr) //  id of new
                    Recs[cat_ctr + 3][1] = Double(db.sPart[row_ctr][16])!     // CR of new
                } else if ((Double(db.sPart[row_ctr][18])! > Recs[cat_ctr + 3][1]) &&          // PR > [0][1]
                           (Double(sMultStripped)! > Double(db.sPart[row_ctr][22])!) &&          // ACo > NC0
                           (Double(db.sPart[row_ctr][21])! > Double(db.sPart[row_ctr][20])!)) {          // ACa > NCa
                    Recs[cat_ctr + 3][0] = Double(row_ctr)    // id of new
                    Recs[cat_ctr + 3][1] = Double(db.sPart[row_ctr][16])!     // CR of new
                }
                row_ctr = row_ctr + 11
                
            }
            //print("Recs[cat_ctr + 3][0]= ", Recs[cat_ctr + 3][0], " Recs[cat_ctr + 3][1]= ", Recs[cat_ctr + 3][1])
            //print("\n")
            cat_ctr = cat_ctr + 3   // next category in Recs[]
            
            row_start = row_start + 77     // next category in sPart[[]]
        }
        
        //print("!!ST Recs (Final)= ", Recs)
        
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
            var dfg: Double = 0.0
            dfg = dSorted[0][0]
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
        
        
        let langCode = Bundle.main.preferredLocalizations[0]
        var maxDriverStat = 0     //  length of longest capability stat
        
        if (langCode == "fr") {
            maxDriverStat = 24
            factors = ["Puissance", "Aérodynamique", "Adhérence", "Fiabilité", "Durée moyenne d\'un Pit Stop", "Dépassement", "Défense", "Régularité", "Économie d\'essence", "Gestion des pneus", "Performance sous la pluie"]
        } else if (langCode == "es") {
            maxDriverStat = 27
            factors = ["Potecia", "Aero", "Agarre", "Fiabilidad", "Tiempo de parada en boxes", "Adelantamiento", "Defender", "Consistencia", "Gestión de combustible", "Gestión de neumáticos", "Capacidad para clima húmedo"]
        } else if (langCode == "it") {
            maxDriverStat = 27
            factors = ["Potenza", "Aerodinamica", "Aderenza", "Affidabilità", "Tempo media del pit stop", "Sorpasso", "Defesa", "Constanza", "Gestione del carburate", "Gestione delle gomme", "Abilità in caso di pioggia"]
        } else if (langCode == "de") {
            maxDriverStat = 16
            factors = ["Leistung", "Aero", "Grip", "Zuverlässigker", "Durchschnittliche Zeit für PS", "Überholvorgang", "Verterdigen", "Konstanz", "Sprit-Management", "Reifen-Management", "Können bei Nässe"]
        } else {    // "en" is default
            maxDriverStat = 19           //always even
            factors = ["Power", "Aero", "Grip", "Reliability", "Pit Stop Time", "Overtaking", "Defending", "Consistency", "Fuel Management", "Tire Management", "Wet Weather Ability"]
        }
        //            1         2         3
        //   123456789012345678901234567890123456789
        
        
        var LStart = 14 - Int(maxDriverStat/2)   // left start column for capabilities= middle - 1/2 of longest -2 spaces - possible 2 for CL
        var RStart = 20 + Int(maxDriverStat/2)   // right start column for capabilities= middle + 1/2 of longest +2 spaces + possible 1 for CL
        //    print("!!! Lstart: \(LStart)")
        //    print("!!! Rstart: \(RStart)")
        //    print("!!! maxDriverStat: \(maxDriverStat)")
        var col = 0    // current column position
        var RecNumber = 0  // 22 values of recommended drivers and parts
        var sTemp = ""   // to be removed whenever
        var rSp = ""   // to be removed whenever
        
        row_ctr = 0    // 4 drivers x 4 strings
        var rec_ctr = 0   // 4 drivers (0 to 3) in Recs[]
        while row_ctr < 15 {
            
            RecNumber = Int(Recs[rec_ctr][0])
            
            // build string 0
            var iSumStr = 0   //length of concatenated string of all string 0
            iSumStr = (db.sDriver[RecNumber][1] + db.sDriver[RecNumber][15] + db.sDriver[RecNumber][16] + db.sDriver[RecNumber][17] + db.sDriver[RecNumber][20] + db.sMult[11][1]).count
            var iLSpacer = 40 - (iSumStr + Int((40 - iSumStr) / 7) * 5)
            var iSpacer = Int((40 - iSumStr) / 7 )
            //var iLeftSpacer = Int(iLSpacer/2)
            var iLeftSpacer = 0   // left justified
            var iDriverSpacer = 0
            iDriverSpacer = 9 - db.sDriver[RecNumber][1].count   //9 is perfect for Driver length. if its <9 then add spaces to iSpacer. if its >9 then remove spaces
            
            //print("!! iLSpacer= \(iLSpacer)")
            //print("!! iSpacer= \(iSpacer)")
            //print("!! iLeftSpacer= \(iSpacer)")
            
            RecsDispDriver[row_ctr] = db.sDriver[RecNumber][1] + Spaces.prefix(iSpacer + iDriverSpacer) + db.sDriver[RecNumber][15] + Spaces.prefix(iSpacer) + db.sDriver[RecNumber][16] + Spaces.prefix(iSpacer) + db.sDriver[RecNumber][17] + Spaces.prefix(iSpacer) + db.sDriver[RecNumber][20] + Spaces.prefix(iSpacer) + "\(db.sMult[11][1])"
            
            
            // build string 1
            // string 2- concatenate 5 strings. pos 5 + pos 12 + pos 20 + pos 28 + pos 37
            // for cl to pl (assume 1 and 3) and also try (4 and 4)
            // if pl=cl then just show pl in 1 row else do loop
            // if pl,cl <10 then add a space in front
            RecsDispDriver[row_ctr + 1] = ""   //clear it
            
            if (db.sDriver[RecNumber][15] == db.sDriver[RecNumber][17]) {
                xMR = Int(Double(db.sDriver[RecNumber][19])!)  //Get MR for RecNumber
                xPL = Int(db.sDriver[RecNumber][17])!  //Get PL for RecNumber
                xPR = Int(Double(db.sDriver[RecNumber][18])!)  //Get PR for RecNumber
                xNCa = Int(db.sDriver[RecNumber][21])!  //Get NCa for RecNumber
                xNCo = Int(db.sDriver[RecNumber][22])!  //Get NCo for RecNumber
                
                iSumStr = String(xPL).count + String(xPR).count + String(xMR).count + String(xNCa).count + String(xNCo).count
                iLSpacer = 40 - (iSumStr + Int((40 - iSumStr) / 7) * 5)
                iSpacer = Int((40 - iSumStr)/7)
                iLeftSpacer = Int(iLSpacer/2)
                
                //RecsDispDriver[row_ctr  + 1] = String(Spaces.prefix(iLeftSpacer)) + String(xPL) + String(Spaces.prefix(iSpacer)) + String(xPR) + String(Spaces.prefix(iSpacer)) + String(xMR) + String(Spaces.prefix(iSpacer)) + String(xNCa) + String(Spaces.prefix(iSpacer)) + String(xNCo)
                
                RecsDispDriver[row_ctr + 1] = Spaces.prefix(6) + String(xPL) + Spaces.prefix(4) + String(xPR) + Spaces.prefix(4) + String(xMR)
                RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(7) + String(xNCa) + Spaces.prefix(3) + String(xNCo)      //PL, PR, MR, NCa, NCo
                // *************** need to fix for long NCa and NCo
            } else {
                //do loop
                var curr_ctr = Int(db.sDriver[RecNumber][15])!  // 1st line = CL
                
                while curr_ctr <= Int(db.sDriver[RecNumber][17])! {  // loop until PL is reached
                    
                    xPL = Int(db.sDriver[RecNumber + curr_ctr - 1][2])!  //Get level for curr_ctr
                    xPR = Int(Double(db.sDriver[RecNumber + curr_ctr - 1][12])!)  //Get PR for curr_ctr
                    xMR = Int(Double(db.sDriver[RecNumber][19])!)  //Get MR for curr_ctr
                    xNCa = Int(db.sCard[curr_ctr - 1][1])!  //Get NCa for curr_ctr
                    xNCo = Int(db.sDriver[RecNumber + curr_ctr - 1][10])!  //Get NCo for curr_ctr
                    
                    iSumStr = String(xPL).count + String(xPR).count + String(xMR).count + String(xNCa).count + String(xNCo).count
                    iLSpacer = 40 - (iSumStr + Int((40 - iSumStr) / 7) * 5)
                    iSpacer = Int((40 - iSumStr)/7)
                    iLeftSpacer = Int(iLSpacer/2)
                    
                    // RecsDispDriver[row_ctr  + 1] = RecsDispDriver[row_ctr + 1] + String(Spaces.prefix(iLeftSpacer)) + String(xPL) + String(Spaces.prefix(iSpacer)) + String(xPR) + String(Spaces.prefix(iSpacer)) + String(xMR) + String(Spaces.prefix(iSpacer)) + String(xNCa) + String(Spaces.prefix(iSpacer)) + String(xNCo) + "\n"
                    
                    // RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(4) + String(xPL) + Spaces.prefix(4) + String(xPR)
                    // RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(4) + String(xMR) + Spaces.prefix(2)
                    // RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + String(xNCa) + Spaces.prefix(1) + String(xNCo) + "\n"
                    
                    RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(6) + String(xPL) + Spaces.prefix(4) + String(xPR) + Spaces.prefix(4) + String(xMR)    // PL, PR, MR
                    RecsDispDriver[row_ctr + 1] = RecsDispDriver[row_ctr + 1] + Spaces.prefix(7) + String(xNCa) + Spaces.prefix(3) + String(xNCo) + "\n"    // NCa, NCo, \n
                    
                    curr_ctr = curr_ctr + 1
                    // if curr cl is still less than pl, then + \n, next
                }
                //print("!!row_ctr: \(row_ctr)")
                //println(RecsDispDriver)
                //RecsDispDriver.forEach() { print("!!",$0) }        // print array
                //dump(RecsDispDriver)
                //print("!!RecsDispDriver: \(RecsDispDriver[row_ctr + 1].count)")
                let subString = RecsDispDriver[row_ctr + 1].prefix((RecsDispDriver[row_ctr + 1].count) - 1)
                RecsDispDriver[row_ctr + 1] = String(subString)  // remove last \n
            }
            
            // build string 2
            //
            RecsDispDriver[row_ctr + 2] = Spaces.prefix(Int(Double(LStart) * 1.45)) + "CL=\(db.sDriver[RecNumber][15])" + Spaces.prefix(Int(Double(RStart - 2 - LStart) * 1.55)) + "PL=\(db.sDriver[RecNumber][17])"   // 1.45= big:little multiplier
            
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
            
            var sSpaceleft = RStart - LStart + 1 - factors[5].count     //space between left and right columns and Overtaking
            var LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            var RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][3] + String(Spaces.prefix(LHSpace)) + factors[5] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][3] + "\n"  // left of Overtaking spaces and Overtaking CL value and right of Overtaking CL spaces and transl(Overtaking) and right of Overtaking spaces and Overtaking PL value
            
            //Defending
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][4])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][4])! < 10) {
                xRSpace = 1
            }
            
            sSpaceleft = RStart - LStart + 1 - factors[6].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][4] + String(Spaces.prefix(LHSpace)) + factors[6] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][4] + "\n"  // see Overtaking comment above for details
            
            //Consistency
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][5])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][5])! < 10) {
                xRSpace = 1
            }
            
            sSpaceleft = RStart - LStart + 1 - factors[7].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][5] + String(Spaces.prefix(LHSpace)) + factors[7] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][5] + "\n"  // see Overtaking comment above for details
            
            //Fuel Management
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][6])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][6])! < 10) {
                xRSpace = 1
            }
            
            sSpaceleft = RStart - LStart + 1 - factors[8].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][6] + String(Spaces.prefix(LHSpace)) + factors[8] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][6] + "\n"  // see Overtaking comment above for details
            
            //Tire Management
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][7])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][7])! < 10) {
                xRSpace = 1
            }
            
            sSpaceleft = RStart - LStart + 1 - factors[9].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][7] + String(Spaces.prefix(LHSpace)) + factors[9] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][7] + "\n"  // see Overtaking comment above for details
            
            //Wet Weather
            xLSpace = 0   //extra LH space needed for small values
            xRSpace = 0   //extra RH space needed for small values
            if (Int(db.sDriver[RecNumber + xCL - 1][8])! < 10) {
                xLSpace = 1
            }
            if (Int(db.sDriver[RecNumber + xPL - 1][8])! < 10) {
                xRSpace = 1
            }
            
            sSpaceleft = RStart - LStart + 1 - factors[10].count     //space between left and right columns and Overtaking
            LHSpace = Int(Double(sSpaceleft)/2)   //LH is smaller if odd
            RHSpace = Int(Double(sSpaceleft)/2 + 0.5)  //RH is bigger if odd
            //sTemp = String(Spaces.prefix(xLSpace + LStart) + db.sDriver[RecNumber + xCL - 1][8] + String(Spaces.prefix(LHSpace)) + factors[10])
            //sTemp = sTemp + String(Spaces.prefix(RHSpace)) + db.sDriver[RecNumber + xPL - 1][8]
            RecsDispDriver[row_ctr + 3] = RecsDispDriver[row_ctr + 3] + String(Spaces.prefix(xLSpace + LStart)) + db.sDriver[RecNumber + xCL - 1][8] + String(Spaces.prefix(LHSpace)) + factors[10] + String(Spaces.prefix(RHSpace + xRSpace)) + db.sDriver[RecNumber + xPL - 1][8]  // see Overtaking comment above for details
            
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
            maxPartStat = 13
        } else if (langCode == "es") {
            maxPartStat = 10
        } else if (langCode == "it") {
            maxPartStat = 12
        } else if (langCode == "de") {
            maxPartStat = 13
        }
        if (maxPartStat%2 == 0) {   //even
            LStart = 20 - Int(maxPartStat/2) - 4   // left start column for even capabilities
            RStart = 19 + Int(maxPartStat/2) + 3   // right start column for odd capabilities- shifted one to the left since its off centre
        } else {
            LStart = 20 - Int(maxPartStat/2) - 4   // left start column for capabilities
            RStart = 20 + Int(maxPartStat/2) + 3   // right start column for capabilities
        }
        //print("!!************ \(LStart)")
        col = 0    // current column position
        RecNumber = 0  // 22 values of recommended drivers and parts
        
        
        row_ctr = 16    // 18 parts x 4 strings
        rec_ctr = 4   // 18 parts (0 to 3 are Drivers, 4-22 are Parts) in Recs[]
        while row_ctr < 87 {
            
            RecNumber = Int(Recs[rec_ctr][0])
            
            // build string 0
            //RecsDispParts[row_ctr] = Spaces.prefix(6 - Int(db.sPart[RecNumber][1].count/2)) + db.sPart[RecNumber][1]     //Name
            RecsDispParts[row_ctr] = db.sPart[RecNumber][1]     // Part Name, left justified
            col = RecsDispParts[row_ctr].count
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(13 - col) + db.sPart[RecNumber][15]    //CL
            col = RecsDispParts[row_ctr].count
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(19 - col - 3) + db.sPart[RecNumber][16]   //CR
            col = RecsDispParts[row_ctr].count
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(23 - col) + db.sPart[RecNumber][17]   //PL
            col = RecsDispParts[row_ctr].count
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(28 - col - 1) + db.sPart[RecNumber][20]   //ACa
            col = RecsDispParts[row_ctr].count
            RecsDispParts[row_ctr] = RecsDispParts[row_ctr] + Spaces.prefix(37 - col - 3) + "\(db.sMult[11][1])"   //ACo
            
            // build parts string 1
            // string 2- concatenate 5 strings. pos 5 + pos 12 + pos 20 + pos 28 + pos 37
            // for cl to pl (assume 1 and 3) and also try (4 and 4)
            // if pl=cl then just show pl in 1 row else do loop
            RecsDispParts[row_ctr + 1] = ""   //clear it
            
            if (db.sPart[RecNumber][15] == db.sPart[RecNumber][17]) {
                RecsDispParts[row_ctr + 1] = Spaces.prefix(4) + db.sPart[RecNumber][17] + Spaces.prefix(4) + db.sPart[RecNumber][18] + Spaces.prefix(4) + db.sPart[RecNumber][19] + Spaces.prefix(5) + db.sPart[RecNumber][21] + Spaces.prefix(5) + db.sPart[RecNumber][22]      //PL, PR, MR, NCa, NCo
                //print("!!RecsDisParts[row_ctr+1]if: \(RecsDispParts[row_ctr+1])")
                // *************** need to fix for long NCa and NCo
            } else {
                //do loop
                var curr_ctr = Int(db.sPart[RecNumber][15])!  // 1st line = CL
                xMR = Int(Double(db.sPart[RecNumber][19])!)  //Get NR for curr_ctr
                while curr_ctr <= Int(db.sPart[RecNumber][17])! {  // loop until PL is reached
                    
                    xPL = Int(db.sPart[RecNumber + curr_ctr - 1][2])!  //Get level for curr_ctr
                    xPR = Int(Double(db.sPart[RecNumber + curr_ctr - 1][12])!)  //Get PR for curr_ctr
                    xNCa = Int(db.sCard[curr_ctr - 1][1])!  //Get NCa for curr_ctr
                    xNCo = Int(db.sPart[RecNumber + curr_ctr - 1][10])!  //Get NCo for curr_ctr
                    
                    RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1] + Spaces.prefix(4) + String(xPL) + Spaces.prefix(4) + String(xPR)
                    if (xNCa < 10) {
                        RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1] + Spaces.prefix(4) + String(xMR) + Spaces.prefix(3)    // add a single space for small xNCA for alignment
                    } else {
                        RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1] + Spaces.prefix(4) + String(xMR) + Spaces.prefix(2)
                    }
                    RecsDispParts[row_ctr + 1] = RecsDispParts[row_ctr + 1] + String(xNCa) + Spaces.prefix(1) + String(xNCo) + "\n"
                    //print("!!RecsDispParts[row_ctr+1]then: \(RecsDispParts[row_ctr+1])")
                    curr_ctr = curr_ctr + 1
                    // if curr cl is still less than pl, then + \n, next
                }
                //print("row_ctr: ", row_ctr)
                let subString = RecsDispParts[row_ctr + 1].prefix((RecsDispParts[row_ctr + 1].count) - 1)
                RecsDispParts[row_ctr + 1] = String(subString)  // remove last \n
            }
            
            
            // build parts string 2
            let transCL = NSLocalizedString("CL", comment: "a test")
            let transPL = NSLocalizedString("PL", comment: "another test")
            RecsDispParts[row_ctr + 2] = Spaces.prefix(LStart - 2) + transCL + "=\(db.sPart[RecNumber][15])" + Spaces.prefix(RStart - 2 - LStart) + transPL + "=\(db.sPart[RecNumber][17])"
            
            
            
            //CLStart = "testing..."
            //CLStart = String(Spaces.prefix(LStart - 2))   // to be transfered to SubView for localizable to work properly
            //CLMid = "=" + db.sPart[RecNumber][15] + Spaces.prefix(RStart - 2 - LStart)
            //CLEnd = "=" + db.sPart[RecNumber][17]
            //print("!!CLMid: ", CLMid, RecNumber)
            //print("!!CLEnd: ", CLEnd, RecNumber)
            
            // build parts string 3
            //
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
            
            
            //Power
            pos2 = 20 - Int(factors[0].count/2)
            pos3 = 20 + Int(factors[0].count/2)
            var sCL = db.sPart[RecNumber + xCL - 1][3]
            var sPL = db.sPart[RecNumber + xPL - 1][3]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            
            //        var sTemp = Spaces.prefix(xLSpace + LStart) + db.sPart[RecNumber + xCL - 1][3] + "W"    //space is needed and CL
            //        sTemp = sTemp + String(Spaces.prefix(Int(maxPartStat/2)-Int((factors[0].count)/2))) + factors[0] // spaces and Power
            //var rSp = RStart - sTemp.count + xRSpace
            //RecsDispParts[row_ctr + 3] = sTemp + String(Spaces.prefix(rSp)) + db.sPart[RecNumber + xPL - 1][3] + "\n"
            RecsDispParts[row_ctr + 3] = String(Spaces.prefix(pos1 - 1)) +  sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[0] + String(Spaces.prefix(pos4 - pos3 - 1)) + sPL + "\n"
            
            //Aero
            pos2 = 20 - Int(factors[1].count/2)
            pos3 = 19 + Int(factors[1].count/2)    //shifted because Aero is even
            sCL = db.sPart[RecNumber + xCL - 1][4]
            sPL = db.sPart[RecNumber + xPL - 1][4]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            //        sTemp = Spaces.prefix(xLSpace + LStart) + db.sPart[RecNumber + xCL - 1][4] + "W"     //space is needed and CL
            //        sTemp = sTemp + String(Spaces.prefix(Int(maxPartStat/2)-Int((factors[1].count)/2))) + factors[1] // spaces and Aero
            //rSp = RStart - sTemp.count + xRSpace
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + String(Spaces.prefix(pos1 - 1))  + sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[1] + String(Spaces.prefix(pos4 - pos3 - 1)) + sPL + "\n"
            
            //Grip
            pos2 = 20 - Int(factors[2].count/2)
            pos3 = 19 + Int(factors[2].count/2)    //shifted because Grip is even
            sCL = db.sPart[RecNumber + xCL - 1][5]
            sPL = db.sPart[RecNumber + xPL - 1][5]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            //        sTemp = Spaces.prefix(xLSpace + LStart) + db.sPart[RecNumber + xCL - 1][5]     //space is needed and CL
            //        sTemp = sTemp + String(Spaces.prefix(Int(maxPartStat/2)-Int((factors[2].count)/2))) + factors[2] // spaces and Grip
            //        rSp = RStart - sTemp.count + xRSpace
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + String(Spaces.prefix(pos1 - 1))  + sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[2] + String(Spaces.prefix(pos4 - pos3 - 1)) + sPL + "\n"
            
            //Reliability
            pos2 = 20 - Int(factors[3].count/2)
            pos3 = 20 + Int(factors[3].count/2)
            sCL = db.sPart[RecNumber + xCL - 1][6]
            sPL = db.sPart[RecNumber + xPL - 1][6]
            if (Int(sCL)! < 10) {
                sCL = " " + sCL
            }
            if (Int(sPL)! < 10) {
                sPL = " " + sPL
            }
            //        sTemp = Spaces.prefix(xLSpace + LStart) + db.sPart[RecNumber + xCL - 1][6]     //space is needed and CL
            //        print("!! sTemp, count=...\(sTemp)...\(sTemp.count)")
            //        sTemp = sTemp + String(Spaces.prefix(Int(maxPartStat/2)-Int((factors[3].count)/2))) + factors[3] // spaces and Overtaking
            //        rSp = RStart - sTemp.count + xRSpace
            //        print("!! sTemp, count=...\(sTemp)...\(sTemp.count)")
            RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + String(Spaces.prefix(pos1 - 1))  + sCL + String(Spaces.prefix(pos2 - pos1 - 2)) + factors[3] + String(Spaces.prefix(pos4 - pos3 - 1)) + sPL + ""
            
            
            
            
            //        RecsDispParts[row_ctr + 3] = Spaces.prefix(3) + db.sPart[RecNumber + xCL - 1][3] + Spaces.prefix(3) + factors[0] + Spaces.prefix(3) + db.sPart[RecNumber + xPL - 1][3] + "\n"
            //        RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + Spaces.prefix(3) + db.sPart[RecNumber + xCL - 1][4] + Spaces.prefix(3) + factors[1] + Spaces.prefix(3) + db.sPart[RecNumber + xPL - 1][4] + "\n"
            //        + Spaces.prefix(3) + db.sPart[RecNumber + xCL - 1][5] + Spaces.prefix(3) + factors[2] + Spaces.prefix(3) + db.sPart[RecNumber + xPL - 1][5] + "\n"
            //        RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + Spaces.prefix(3) + db.sPart[RecNumber + xCL - 1][6] + Spaces.prefix(3) + factors[8] + Spaces.prefix(3)
            //        RecsDispParts[row_ctr + 3] = RecsDispParts[row_ctr + 3] + db.sPart[RecNumber + xPL - 1][6]
            
            
            //        var maxPartStat = 19     //  length of longest capability stat
            //        var LStart = 20 - Int(maxPartStat/2) - 4   // left start column for capabilities
            //        var RStart = 20 + Int(maxPartStat/2) + 2   // right start column for capabilities
            
            row_ctr = row_ctr + 4
            rec_ctr = rec_ctr + 1
        }
        
        // get the CL or CL+1 from the driver/part. Look up the CR.
        
        // **********************************************************************************
        // **********************************************************************************
        // Calculate teamScore
        //
        
        teamScore = 0    //clear old value
        

        // PR= and PR1 = 0
        // so we have Rec0 and Rec1. If their CLs = PLs then choose both with no upgrades
        // if Rec0 Cl < PL then with the ACo how many levels up can you upgrade? Start at CL+1, determine PR, then repeat until you reach PL. Whatever PR0 you have wins. Record PLRec0.
        // Do the same for Rec1 to find PR1. Record PLRec1.
        // If PR0 >= PR1 then upgrade PR0 to level ? else upgrade  PR1 to level ??
        
        //        var step3 = 0
        //        var iFinal: Int = 0
        //        var dFinal: Double = 0.0
        
        //        var step1: Int = Int(Recs[0][0])
        //        var step2: Int = Int(db.sDriver[step1][15])!
        //        var test345: String = db.sDriver[step1 + step2][12]   //works
        //        test345 = db.sDriver[Int(Recs[0][0]) + step2][12]    //works
        //        print(type(of: test345))
        //        test345 = db.sDriver[Int(Recs[0][0]) + step2][12]    //works
        //        dFinal = Double(test345)!   //works, must have !
        //        iFinal = Int(dFinal)  // works
        //        iFinal = Int(Double(test345)!)    // now combine, works
        //        iFinal = Int(Double(db.sDriver[Int(Recs[0][0]) + step2][12])!)    // more combining, works
        //        iFinal = Int(Double(db.sDriver[Int(Recs[0][0]) + Int(db.sDriver[step1][15])!][12])!)    // even more combining, works
        //        iFinal = Int(Double(db.sDriver[Int(Recs[0][0]) + Int(db.sDriver[Int(Recs[0][0])][15])!][12])!)    // final combining, works
        
        // get the row number for the weighted rating for the current CL
        if (db.sDriver[Int(Recs[0][0])][15] == db.sDriver[Int(Recs[0][0])][17]) {
            teamScore = teamScore + Int(Double(db.sDriver[Int(Recs[0][0]) + Int(db.sDriver[Int(Recs[0][0])][15])!][12])!)    //CL row
            
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sDriver[Int(Recs[0][0]) + 1 + Int(db.sDriver[Int(Recs[0][0])][15])!][12])!) // 1 more row after CL row *******************  if C < 10, 11, 12? logic needed
        }
        
        if (db.sDriver[Int(Recs[1][0])][15] == db.sDriver[Int(Recs[1][0])][17]) {
            teamScore = teamScore + Int(Double(db.sDriver[Int(Recs[1][0]) + Int(db.sDriver[Int(Recs[1][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sDriver[Int(Recs[1][0]) + 1 + Int(db.sDriver[Int(Recs[1][0])][15])!][12])!)
        }
        
        if (db.sPart[Int(Recs[4][0])][15] == db.sPart[Int(Recs[4][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[4][0]) + Int(db.sPart[Int(Recs[4][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[4][0]) + 1 + Int(db.sPart[Int(Recs[4][0])][15])!][12])!)
        }
        if (db.sPart[Int(Recs[7][0])][15] == db.sPart[Int(Recs[7][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[7][0]) + Int(db.sPart[Int(Recs[7][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[7][0]) + 1 + Int(db.sPart[Int(Recs[7][0])][15])!][12])!)
        }
        if (db.sPart[Int(Recs[10][0])][15] == db.sPart[Int(Recs[10][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[10][0]) + Int(db.sPart[Int(Recs[10][0])][4])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[10][0]) + 1 + Int(db.sPart[Int(Recs[10][0])][15])!][12])!)
        }
        if (db.sPart[Int(Recs[13][0])][15] == db.sPart[Int(Recs[13][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[13][0]) + Int(db.sPart[Int(Recs[13][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[13][0]) + 1 + Int(db.sPart[Int(Recs[13][0])][15])!][12])!)
        }
        if (db.sPart[Int(Recs[16][0])][15] == db.sPart[Int(Recs[16][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[16][0]) + Int(db.sPart[Int(Recs[16][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[16][0]) + 1 + Int(db.sPart[Int(Recs[16][0])][15])!][12])!)
        }
        if (db.sPart[Int(Recs[19][0])][15] == db.sPart[Int(Recs[19][0])][17]) {
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[19][0]) + Int(db.sPart[Int(Recs[19][0])][15])!][12])!)
        } else {        // Cl < PL
            teamScore = teamScore + Int(Double(db.sPart[Int(Recs[19][0]) + 1 + Int(db.sPart[Int(Recs[19][0])][15])!][12])!)
        }
        
        print("!! teamScore = \(teamScore)")
        dump(Recs)
        
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
    
    
    func printRecs(Recs: [[Double]]) {
        
        /*       print("!!Driver: ", Recs[0][0], Recs[1][0], Recs[2][0], Recs[3][0], db.sPart[Int(Recs[0][0])][1], db.sPart[Int(Recs[1][0])][1], db.sPart[Int(Recs[2][0])][1], db.sPart[Int(Recs[3][0])][1])
         print("!!Brakes: ", Recs[4][0], Recs[5][0], Recs[6][0], db.sPart[Int(Recs[4][0])][1], db.sPart[Int(Recs[5][0])][1], db.sPart[Int(Recs[6][0])][1])
         print("!!Driver: ", Recs[0][0], Recs[1][0], Recs[2][0], Recs[3][0], db.sDriver[Int(Recs[0][0])][1], db.sDriver[Int(Recs[1][0])][1], db.sDriver[Int(Recs[2][0])][1], db.sDriver[Int(Recs[3][0])][1])
         print("!!Brakes: ", Recs[4][0], Recs[5][0], Recs[6][0], db.sPart[Int(Recs[4][0])][1], db.sPart[Int(Recs[5][0])][1], db.sPart[Int(Recs[6][0])][1])
         print("!!Gearbox: ", Recs[7][0], Recs[8][0], Recs[9][0], db.sPart[Int(Recs[7][0])][1], db.sPart[Int(Recs[8][0])][1], db.sPart[Int(Recs[9][0])][1])
         print("!!RearWing: ", Recs[10][0], Recs[11][0], Recs[12][0], db.sPart[Int(Recs[10][0])][1], db.sPart[Int(Recs[11][0])][1], db.sPart[Int(Recs[12][0])][1])
         print("!!FrontWing: ", Recs[13][0], Recs[14][0], Recs[15][0], db.sPart[Int(Recs[13][0])][1], db.sPart[Int(Recs[14][0])][1], db.sPart[Int(Recs[15][0])][1])
         print("!!Suspension: ", Recs[16][0] ,Recs[17][0], Recs[18][0], db.sPart[Int(Recs[16][0])][1], db.sPart[Int(Recs[17][0])][1], db.sPart[Int(Recs[18][0])][1])
         print("!!Engine: ", Recs[19][0], Recs[20][0], Recs[21][0], db.sPart[Int(Recs[19][0])][1], db.sPart[Int(Recs[20][0])][1], db.sPart[Int(Recs[21][0])][1])
         
         */
    }
    
}   // struct


struct InfoSheetRecsView: View {
    var body: some View {
        ScrollView() {
            Text("info_contents_recs")
                .font(.system(size: 12))
                .frame(width: 300)
                .padding()
        }
    }
}



struct RecsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
    }
}

