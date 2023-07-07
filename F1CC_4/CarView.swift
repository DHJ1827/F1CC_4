//
//  CarView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI

struct CarSubView: View {
    
    @EnvironmentObject var db: DBHandler
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic, Color.black, Color.red]
    //@State var PartDisplay : [[String]] = Array(repeating: Array(repeating: "1", count: 2), count: 461)
    //@State var PartDisplay : [[String]] = Array(repeating: Array(repeating: "1", count: 2), count: 461)
    @State var fontSize: [Int] = Array(repeating: 13, count: 461)
    var ctr: Int
    var stop: Int
    var PDisplay: [[String]]
    
    var body: some View {
        VStack{   //  parts
            HStack {
                // instead of doing 3 per row
                // do 2 rows of 3 and 1 row of 1
                ForEach(Array(stride(from: 0, to: stop, by: 11)), id: \.self) { index_h in
                    
                    let colorInt1: Int = Int(db.sPart[index_h + ctr][13])!
                    let colorBack = cmode[colorInt1]      //  get the level and apply the right background colour to it
                    var ctr3 = Int(db.sPart[(index_h + ctr)][16]) ?? 77

                    
                    VStack {
                        Text("resultsLine1")
                            .font(.system(size: 9))
                            .frame(width: 120, alignment: .leading)
                            .background(colorBack)
                        
                        Text(PDisplay[(index_h + ctr)][0])    // Stats for CL ACa/NCa PL
                        //Text("\(db.sPart[ctr + index_h][15])     \(db.sPart[ctr + index_h][20])/\(db.sPart[ctr + index_h][21])  \(db.sPart[ctr + index_h][17])")      // CL ACa NCa  PL
                            .font(.system(size: CGFloat(fontSize[1]), design: .monospaced))
                            .fontWeight(.semibold)
                            .frame(width: 120, alignment: .leading)
                            .background(colorBack)
                        Text(db.sPart[ctr + index_h][1])
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .frame(width: 120)
                            .background(colorBack)
                        
                        if (db.sSelectedMode == "detailMode") {
                            VStack{
                                Text("resultsLine4D")
                                    .font(.system(size: 9))
                                    .frame(width: 120)
                                    .background(colorBack)
                                
                                
                                //var ctr3 = Int(db.sDriver[(index_h + index_v)][16]) ?? 77

                                if (Float(db.sPart[(ctr + index_h)][16])! < 10) {    //CR < 10 so need more spaces
                                    VStack{
                                        Text(db.sPart[ctr + index_h][16] + "   " + db.sPart[ctr + index_h][19] + "   " + db.sPart[ctr + index_h][18])   // Stats for CR MR PR
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 120)
                                            .foregroundColor(cmode[4])
                                            .background(colorBack)
                                    }
                                } else {
                                    VStack{
                                        Text(db.sPart[ctr + index_h][16] + " " +  db.sPart[ctr + index_h][19] + " " + db.sPart[ctr + index_h][18])   // Stats for CR MR PR
                                            .font(.system(size: 13, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 120)
                                            .foregroundColor(cmode[4])
                                            .background(colorBack)
                                    }  //VStack
                                }  // else
                                
                                
                                
                                
                                
                                
                                
//                                Text("\(db.sPart[ctr + index_h][16]) \(db.sPart[ctr + index_h][19]) \(db.sPart[ctr + index_h][18])")
//                                    .font(.system(size: 13, design: .monospaced))
//                                    .fontWeight(.semibold)
//                                    .frame(width: 120)
//                                    .background(colorBack)
                                Text("NCo")
                                    .font(.system(size: 9, design: .monospaced))
                                    .frame(width: 120, alignment: .center)
                                    .background(colorBack)
                                Text("\(db.sPart[ctr + index_h][22])")
                                    .font(.system(size: 13, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .frame(width: 120)
                                    .background(colorBack)
                            } // VStack
                        } else {      //Basic mode
                            VStack{
                                Text("resultsLine4B")
                                    .font(.system(size: 9))
                                    .frame(width: 120)
                                    .background(colorBack)
                                Text("\(db.sPart[ctr + index_h][16])    \(db.sPart[ctr + index_h][18])")
                                //Text("\(sPart[ctr + index_h][16])     \(sPart[0][19])    \(sPart[0][18])")
                                    .font(.system(size: 13, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .frame(width: 120)
                                    .background(colorBack)

                            } // VStack
                        }
                    }  //VStack
                    .padding(.bottom, 6)
                    
                    
                }  //ForEach
            }   //HStack
            
            
        }
    }
}

struct CarView: View {
    
    @EnvironmentObject var db: DBHandler
    
    @State  var multSpeed: Double = 100
    @State  var multCorner: Double = 100
    @State  var multPowerUnit: Double = 100
    @State  var multReliability: Double = 100
    @State var pitStopTime: Double = 100        // ???????????????????????? where is this pitstop needed, Recs?
    
    @State var showingAlert = false
    @State var alphaToShow = ""
    @State var isPartUpdateViewShowing: Bool = false
    @State private var showingInfoSheet = false
    @State var errMsg = ""
    
    var ctr = 0
    var ctr1 = 0
    @State var ctr5: Int = 0
    
    @State var PartDisplay : [[String]] = Array(repeating: Array(repeating: "1", count: 2), count: 461)
    @State var row_ctr = 0
    @State var fontSize: [Int] = Array(repeating: 13, count: 461)
    
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic, Color.black, Color.red]
    
    //******************************************************************
    
    var body: some View {
        
        
        ScrollView() {
            
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
                            InfoSheetCarView()
                        }
                    }
                    
                }
            }  //VStack
            
            VStack {
                VStack {
                    HStack(alignment: .top) {      // image, button, sliders
                        
                        VStack(alignment: .center) {     //  picker, image, button
                            
                            Picker(selection: $db.sSelectedMode, label: Text("Mode:")) {
                                Text("basicMode").tag("basicMode")
                                Text("detailMode").tag("detailMode")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 165)
                            .offset(x:20, y:0)
                            
                            Image(db.photoNum)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .offset(x: 5, y: 0)
                            
                            Button(action: {
                                isPartUpdateViewShowing = true
                            }) {
                                Text("coins \(db.sMult[11][1])")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                    .frame(minWidth: 100, minHeight: 30, alignment: .center)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(Color.white)
                                    .background(Color.colours.backgrd_blue)
                            }
                            .offset(x: 0, y: 5)
                            
                        }
                        
                        if (db.sSelectedMode == "detailMode") {
                            VStack(alignment: .trailing, spacing: 5) {      //slder text

                                Text ("speed")
                                    .font(.system(size: 11, design: .monospaced))
                                    .frame(maxWidth: 150, alignment: .trailing)
                                    .padding(.bottom, 40)
                                Text ("cornering")
                                    .font(.system(size: 11, design: .monospaced))
                                    .padding(.bottom, 40)
                                Text ("powerUnit")
                                    .font(.system(size: 11, design: .monospaced))
                                    .padding(.bottom, 40)
                                Text ("reliability")
                                    .font(.system(size: 11, design: .monospaced))
                                    .padding(.bottom, 20)
                            }
                            .offset(x: -5, y:40)
                            
                            VStack(alignment: .leading) {          //sliders
                                HStack {
                                    Text("+")
                                        .font(.system(size: 11, design: .monospaced))
                                        .frame(maxWidth: 30, alignment: .leading)
                                    Text("-")
                                        .font(.system(size: 11, design: .monospaced))
                                        .frame(maxWidth: 30, alignment: .trailing)
                                        .offset(x:15, y: 0)
                                }
                                .offset(x: 0, y: 10)
                                Slider(value: $multSpeed, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multSpeed))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multCorner, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multCorner))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multPowerUnit, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multPowerUnit))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multReliability, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multReliability))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                            }  //VStack of sliders
                            .offset(x:-5, y:10)
                        }
                        
                    }  //HStack
                }    //VStack title and images/sliders- all upto drivers
                
                Spacer(minLength: 20)
                
                // start of parts
                
                ZStack {   // parts with opaque button on top
                    
                    VStack{   //  parts
                        
                        
                        Group{
                            
                            VStack(alignment: .leading) {
                                Text("brakes")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 0, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 33, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 66, stop: 1, PDisplay: PartDisplay)
                            }
                            Spacer(minLength: 15)
                        }
                        Group{
                            VStack(alignment: .leading) {
                                Text("suspension")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 77, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 110, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 143, stop: 1, PDisplay: PartDisplay)
                            }
                            Spacer(minLength: 15)
                        }
                        Group{
                            VStack(alignment: .leading) {
                                Text("frontwing")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 154, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 187, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 220, stop: 1, PDisplay: PartDisplay)
                            }
                            Spacer(minLength: 15)
                        }
                        Group{
                            VStack(alignment: .leading) {
                                Text("rearwing")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 231, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 264, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 297, stop: 1, PDisplay: PartDisplay)
                            }
                            Spacer(minLength: 15)
                        }
                        Group{
                            VStack(alignment: .leading) {
                                Text("gearbox")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 308, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 341, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 374, stop: 1, PDisplay: PartDisplay)
                            }
                            Spacer(minLength: 15)
                        }
                        Group{
                            VStack(alignment: .leading) {
                                Text("engine")
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                Spacer(minLength: 10)
                                CarSubView(ctr: 385, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 418, stop: 32, PDisplay: PartDisplay)
                                CarSubView(ctr: 451, stop: 1, PDisplay: PartDisplay)
                            }
                        }
                        
                        
                        
                        
                    }  //VStack of parts
                    Button(action: {
                        isPartUpdateViewShowing = true
                    }) {
                        Text("OnTopButton")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.white)
                            .opacity(0)
                    }
                    
                }   //ZStack
                
            }   //end of ScrollView
            .clipped()
            .alert(errMsg, isPresented: $showingAlert) {
                Button("Ok", role: .cancel) {
                    showingAlert = false
                    isPartUpdateViewShowing = false
                    isPartUpdateViewShowing = true
                }
            }
            .sheet(isPresented: $isPartUpdateViewShowing,
                   onDismiss: {
                print("Child is dismissed")
                var errCheck = true
                errMsg = ""
                if db.sMult[11][1].isEmpty {    //check for empty ACo string
                    db.sMult[11][1] = "0"
                }
                // check Coins value
                if (Int(db.sMult[11][1].replacingOccurrences(of: ",", with: ""))! < 0 || Int(db.sMult[11][1].replacingOccurrences(of: ",", with: ""))! > 99999999) {
                    errCheck = false
                    errMsg = "Coins must be between 0 and 99,999,999"
                    showingAlert = true
                }
                
                // check levels value
                for ctr in stride(from: 0, to: 461, by: 11) {
                    if (!((0...Int(db.sPart[ctr][29])! ~= Int(db.sPart[ctr][15]) ?? .min))) {     // check if Level is > 0 and < maxLevel and Cards > 0  and < 99,999,999
                        errCheck = false
                        errMsg = "Levels must be between 0 and \(db.sPart[ctr][29]) for \(db.sPart[ctr][1])"
                        showingAlert = true
                    }
                }
                
                //check cards value
                for ctr1 in stride(from: 0, to: 461, by: 11) {
                    if (!((0...99999 ~= Int(db.sPart[ctr1][20]) ?? .min))) {     // check if Level is > 0 and < maxLevel and Cards > 0  and < 99,999,999
                        errCheck = false
                        errMsg = "Cards must be between 0 and 9,999 for \(db.sPart[ctr1][1])"
                    }
                }
                // check for 1+ parts/category
                   
                for ctr2 in stride(from: 0, to: 461, by: 77) {   // in each category, check for at least 1 part with proper CL
                    var iErrTest = 0
                    for ctr1 in stride(from: 0, to: 76, by: 11) {     //inside each category- 7 parts
                        if (Int(db.sPart[ctr1 + ctr2][15]) ?? 0 > 0) {     // check if Level is > 0 and < maxLevel and Cards > 0  and < 99,999,999
                            iErrTest = 1
                        }
                    }
                    if (iErrTest < 1) {
                        errCheck = false
                        errMsg = "Each category must have at least one component with have CL > 0"
                    }
                }
                   
                   if (errCheck) {
                       print("Good")
                       isPartUpdateViewShowing = false
                    var sMultStripped = db.sMult[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
                    for ctr in stride(from: 0, to: 461, by: 11) {
                        if (db.sPart[ctr][15] == db.sPart[ctr][17]) {   // CL=PL so set [31 and [32] to same
                            //print("!!379 \(db.sPart[0][15]) \(db.sDriver[0][31])")
                            db.sPart[ctr][31] = db.sPart[ctr][17]
                            db.sPart[ctr][32] = db.sPart[ctr][18]
                        } else if ((db.sPart[ctr][15] < db.sPart[ctr][17]) &&          // PR[18]
                                    (Double(sMultStripped)! > Double(db.sPart[ctr][22])!)) {   // CL<PL and ACo > NCo
                            db.sPart[ctr][31] = db.sPart[ctr][17]
                            db.sPart[ctr][32] = db.sPart[ctr][18]
                        } else {      //  CL<PL but there aren't enough cards to get to PL, so figure out if a lower PL can br reachewd
                            //print("!! blah")
                        }   // else
                    }   //  ctr
                    start()
                       
                } else {
                    print("Bad level, cards or coins input")
                    showingAlert = true
                }
            })    // sheet
            {
                PartUpdateView(isPartUpdateViewShowing: $isPartUpdateViewShowing, sDriver: $db.sDriver, sPart: $db.sPart, sMult: $db.sMult, sCard: $db.sCard)
                    .environmentObject(db)
            }
            .onAppear(perform: start)
        }   // end of ScrollView
        .clipped()
    }
    
    
    
    
    func start() {
        
        print("CV start()...")
        multSpeed = Double(db.sMult[0][1])!
        multCorner = Double(db.sMult[1][1])!
        multPowerUnit = Double(db.sMult[2][1])!
        multReliability = Double(db.sMult[3][1])!
        
        db.sPart = db.sPartCalc(sPart: db.sPart, sMult: db.sMult, sCard: db.sCard)      //update calculations
        do {
            db.sPart = try db.updatePart(sPart: db.sPart)
            try db.updateMult()
        } catch {
            print("\nPartUpdate: db.updatePart and/or db.updateMult failed")
        }
        
        row_ctr = 0
        while row_ctr <= 461 {    // build the first row strings for each driver- change to 60 when ready
            let result = displayPart(a_ctr: row_ctr)      // get the formatted string
            PartDisplay[row_ctr][0] = result.0    //put it in, [0] is the string, [1] is the font size depending on [0].length
            fontSize[row_ctr] = result.1
            row_ctr = row_ctr + 11
        }
        PartDisplay.forEach{print($0)}
        
    }
    
    
    func displayPart(a_ctr: Int)  -> (String, Int) {
        //print("dc= ",row_ctr)
        var built = ""
        let Space = "              "
        if (db.sPart[row_ctr][15].count + db.sPart[row_ctr][20].count + db.sPart[row_ctr][21].count + db.sPart[row_ctr][17].count) <= 10 {
            fontSize[row_ctr] = 13
            built = db.sPart[row_ctr][15] + Space.prefix(6 - db.sPart[row_ctr][15].count - db.sPart[row_ctr][20].count) + db.sPart[row_ctr][20] + "/" + db.sPart[row_ctr][21] + Space.prefix(7 - db.sPart[row_ctr][21].count - db.sPart[row_ctr][17].count) + db.sPart[row_ctr][17]
        } else {
            fontSize[row_ctr] = 11
            built = db.sPart[row_ctr][15] + Space.prefix(8 - db.sPart[row_ctr][15].count - db.sPart[row_ctr][20].count) + db.sPart[row_ctr][20] + "/" + db.sPart[row_ctr][21] + Space.prefix(8 - db.sPart[row_ctr][21].count - db.sPart[row_ctr][17].count) + db.sPart[row_ctr][17]
        }
        return (built, fontSize[row_ctr])
    }
    
    
    func sliderCalc() {
        //print("Slider works: ", multPower, multAero)
        db.sMult[0][1] = String(format: "%.0f", multSpeed)
        db.sMult[1][1] = String(format: "%.0f", multCorner)
        db.sMult[2][1] = String(format: "%.0f", multPowerUnit)
        db.sMult[3][1] = String(format: "%.0f", multReliability)
        do {
            try db.updateMult()
            db.sPart = try db.sPartCalc(sPart: db.sPart, sMult: db.sMult, sCard: db.sCard)
        } catch {
            print("CarView: db.updateMult and/or db.sPartCalc failed")
        }
    }
    
}   //struct

struct InfoSheetCarView: View {
    var body: some View {
        VStack {
            Text("componentsScreen")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 300)
            }
            .frame(maxWidth: .infinity, maxHeight: 50) // 1
            .accentColor(Color.black)
            .background(Color.colours.backgrd_blue)
            .padding(.bottom, 20)
        VStack {
            Text("info_contents_part")
                .font(.system(size: 14))
                .frame(width: 300)
            }
    }
}

struct CarView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
    }
}

