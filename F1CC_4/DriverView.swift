//
//  DriverView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI

struct DriverView: View {
    
    @EnvironmentObject var db: DBHandler
    
    @State var multOver: Double = 100
    @State var multDefend: Double = 100
    @State var multConsist: Double = 100
    @State var multFuel: Double = 100
    @State var multTire: Double = 100
    @State var multWet: Double = 100
    //@State var isDisplayed: [Bool] = Array(repeating: false, count: 661)    //661         REMOVE
    
    
    @State var showingAlert = false
    @State var alphaToShow = ""
    @State var isDriverUpdateViewShowing: Bool = false
    @State private var showingInfoSheet = false
    @State var errMsg = ""

    @State var colorFont: Color = Color.black

    var ctr = 0
    var ctr1 = 0
    @State var ctrCL: Int = 0
    @State var ctrPL: Int = 0
    @State var ctrNCo: Int = 0
    @State var startNCo: Int = 0
    @State var ctr5: Int = 0
    
    @State var DriverDisplay : [[String]] = Array(repeating: Array(repeating: "1", count: 2), count: 659)
    @State var row_ctr = 0
    @State var fontSize: [Int] = Array(repeating: 13, count: 660)
    
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
                            db.bFirstTimeLoad.toggle()
                        } label: {
                            Text("")
                                }
                        .offset(x: -40, y: 0)
                        .sheet(isPresented: $db.bFirstTimeLoad) {              // if its the first time running, show the intro view
                            FirstTimeInfoView()
                        }

                        Button {
                            print("Launch info")
                            showingInfoSheet.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                        }
                        .offset(x: -10, y: 0)
                        .sheet(isPresented: $showingInfoSheet) {
                            InfoSheetDriverView()
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
                            
                            Image(db.photoNum)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .offset(x: 5, y: 0)
                            
                            Button(action: {
                                isDriverUpdateViewShowing = true
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
                                
                                Text ("overtaking")
                                    .font(.system(size: 11, design: .monospaced))
                                    .frame(maxWidth: 150, alignment: .trailing)
                                    .padding(.bottom, 20)
                                Text ("defending")
                                    .font(.system(size: 11, design: .monospaced))
                                    .padding(.bottom, 20)
                                Text ("consistency")
                                    .font(.system(size: 11, design: .monospaced))
                                    .padding(.bottom, 22)
                                Text ("fuelManagement")
                                    .font(.system(size: 9, design: .monospaced))
                                    .padding(.bottom, 22)
                                Text ("tireManagement")
                                    .font(.system(size: 9, design: .monospaced))
                                    .padding(.bottom, 22)
                                Text ("wetWeatherAbility")
                                    .font(.system(size: 9, design: .monospaced))
                                    .padding(.bottom, 25)
                            }
                            .offset(x: -5, y:20)
                            
                            VStack(alignment: .leading) {          //sliders
                                Slider(value: $multOver, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multOver))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multDefend, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multDefend))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multConsist, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multConsist))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                
                                Slider(value: $multFuel, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multFuel))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multTire, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multTire))!))
                                    sliderCalc()
                                }) {
                                    EmptyView()
                                }
                                .accentColor(Color.colours.backgrd_blue)
                                .frame(width: 100)
                                .offset(x: -5, y: 0)
                                
                                Slider(value: $multWet, in: 0...200,step: 1,onEditingChanged: { data in
                                    self.alphaToShow = String(Character(UnicodeScalar(Int(self.multWet))!))
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
                }            //VStack title and images/sliders- all upto drivers
                Spacer(minLength: 30)
                //*******************************************************************
                //                        Fuel Management
                //                        Wet weather ability
                //                        Performance sous la pluie
                //                        Abilità in caso di pioggia
                //                        Durchschnittiliche zeit fur PS
                //                        Tempo media del pit stop
                //                        Capacidad para clima húmedo
                
                // start of driver

                ZStack {    // drivers with opaque button on top
                     
                    VStack {    //drivers
                        ForEach(Array(stride(from: 0, to: 659, by: 33)), id: \.self) { index_v in
                            HStack{

                                ForEach(Array(stride(from: 0, to: 32, by: 11)), id: \.self) { index_h in

                                    let colorInt1: Int = Int(db.sDriver[index_h + index_v][13])!
                                    let colorBack = cmode[colorInt1]      //  get the level and apply the right background colour to it
                                    let colorInt2: Int = Int(db.sDriver[index_h + index_v][30])!
                                    let colorFont = cmode[colorInt2]      //  get the level and apply the right background colour to it
                                    
                                    VStack {
                                        Text("resultsLine1")    // CL ACa/NCa PL
                                            .font(.system(size: 9))
                                            .frame(width: 120)
                                            .background(colorBack)
                                        Text(DriverDisplay[(index_h + index_v)][0])    // Stats for CL ACa/NCa PL
                                            .font(.system(size: CGFloat(fontSize[1]), design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 120, alignment: .leading)
                                            .background(colorBack)
                                        
                                        Text(db.sDriver[(index_h + index_v)][1])     // DriverName
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                                .frame(width: 120)
                                                .foregroundColor(colorFont)
                                                .background(colorBack)

                                        if (db.sSelectedMode == "detailMode") {
                                            VStack {
                                                Text("resultsLine4D")    // CR MR PR
                                                    .font(.system(size: 9))
                                                    .frame(width: 120)
                                                    .background(colorBack)
                                                Text("\(db.sDriver[index_v + index_h][16]) \(db.sDriver[index_v + index_h][19]) \(db.sDriver[index_v + index_h][18])")   // Stats for CR MR PR
                                                //Text($db.sDriver[index_v + index_h][16],$db.sDriver[index_v + index_h][19], db.sDriver[index_v + index_h][18])
                                                    .font(.system(size: 13, design: .monospaced))
                                                    .fontWeight(.semibold)
                                                    .frame(width: 120)
                                                    .foregroundColor(cmode[4])
                                                    .background(colorBack)
                                                Text("NCo")
                                                    .font(.system(size: 9, design: .monospaced))
                                                    .frame(width: 120, alignment: .center)
                                                    .background(colorBack)
                                                Text("\(db.sDriver[index_v + index_h][22])")   // Stats for NCo
                                                    .font(.system(size: 13, design: .monospaced))
                                                    .fontWeight(.semibold)
                                                    .frame(width: 120)
                                                    .foregroundColor(cmode[4])
                                                    .background(colorBack)
                                            }   //VStack
                                            .padding(.bottom, 6)
                                        } else {
                                            VStack {
                                                Text("resultsLine4B")
                                                    .font(.system(size: 9))
                                                    .frame(width: 120)
                                                    .background(colorBack)
                                                Text("\(db.sDriver[index_v + index_h][16])      \(db.sDriver[index_v + index_h][18])")
                                                    .font(.system(size: 13, design: .monospaced))
                                                    .fontWeight(.semibold)
                                                    .frame(width: 120)
                                                    .foregroundColor(cmode[4])
                                                    .background(colorBack)
                                            }   //VStack
                                            .padding(.bottom, 6)
                                        }
                                        
                                        
                                        
                                    }  //VStack
                                    
                                    
                                }   //ForEach

                            }  //HStack
                        }  //ForEach
                    }  //VStack  of drivers
                     
                    
                    
                    Button(action: {    // opaque button on top of drivers
                        isDriverUpdateViewShowing = true
                    }) {
                        Text("OnTopButton")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.white)
                            .opacity(0)
                    }
                    
                }   //ZStack driver
                
            } //VStack
        }   //end of ScrollView
        .clipped()
        .alert(errMsg, isPresented: $showingAlert) {
            Button("Ok", role: .cancel) {
                showingAlert = false
                isDriverUpdateViewShowing = false
                isDriverUpdateViewShowing = true
            }
        }
        .sheet(isPresented: $isDriverUpdateViewShowing,
               onDismiss: {
            print("Child is dismissed")
            var errCheck = true
            errMsg = ""
            if db.sMult[11][1].isEmpty {    //check for empty string
                db.sMult[11][1] = "0"
            }
            // check Coins
            if (Int(db.sMult[11][1].replacingOccurrences(of: ",", with: ""))! > 99999999) {
                errCheck = false
                errMsg = "Coins must be between 0 and 99,999,999"
                showingAlert = true
            }
                   
            // check levels
            for ctr in stride(from: 0, to: 650, by: 11) {
                if (!((0...Int(db.sDriver[ctr][29])! ~= Int(db.sDriver[ctr][15]) ?? .min))) {     // check if Level is > 0 and < maxLevel and Cards > 0  and < 99,999,999
                    errCheck = false
                    errMsg = "Levels must be between 0 and \(db.sDriver[ctr][29]) for \(db.sDriver[ctr][1])"
                    showingAlert = true
                }
            }
                    
            //check cards
            for ctr1 in stride(from: 0, to: 650, by: 11) {
                if (!((0...99999 ~= Int(db.sDriver[ctr1][20]) ?? .min))) {     // check if Level is > 0 and < maxLevel and Cards > 0  and < 99,999,999
                    errCheck = false
                    errMsg = "Cards must be between 0 and 9,999 for \(db.sDriver[ctr1][1])"
                }
            }
            if (errCheck) {
                print("Good")
                isDriverUpdateViewShowing = false
                for ctr in stride(from: 0, to: 650, by: 11) {
                    if (db.bDriverBoost[ctr]) {
                        db.sDriver[ctr][14] = "1.1"
                        db.sDriver[ctr][30] = "5"   //red
                    } else {
                        db.sDriver[ctr][14] = "1.0"
                        db.sDriver[ctr][30] = "4"  //black
                    }
                }   //  ctr
                
                //  update RecPL and RecPR when ACo > NCo. Loo pthrough all drivers, check if cl=pl or CL<PL, set [31] to PL and [32] to PR
                                
                //print("!!376 \(db.sDriver[0][15]) \(db.sDriver[0][20])")
                let sMultStripped = db.sMult[11][1].replacingOccurrences(of: ",", with: "") // remove , from string
                
                for ctr in stride(from: 0, to: 650, by: 11) {
                    if (db.sDriver[ctr][15] == db.sDriver[ctr][17]) {   // CL=PL so set [31 and [32] to same
                        //print("!!379 \(db.sDriver[0][15]) \(db.sDriver[0][31])")
                        db.sDriver[ctr][31] = db.sDriver[ctr][17]   // save PL(ACo>NCo) = PL
                        db.sDriver[ctr][32] = db.sDriver[ctr][18]   // save PR(ACo>NCo) = PR
                    } else if ((db.sDriver[ctr][15] < db.sDriver[ctr][17]) &&          // PR[18]
                                (Double(sMultStripped)! > Double(db.sDriver[ctr][22])!)) {   // CL<PL and ACo > NCo
                        //printArrRow(arrName: db.sDriver, xRow: 11)
                        db.sDriver[ctr][31] = db.sDriver[ctr][17]   // save PL(ACo>NCo) = PL
                        db.sDriver[ctr][32] = db.sDriver[ctr][18]   // save PR(ACo>NCo) = PL
                    } else {      //  CL<PL but there aren't enough coins to get to PL, so figure out if a lower PL can br reached
                        let startCL = Int(db.sDriver[ctr][15])!    // CL   2
                        ctrPL = Int(db.sDriver[ctr][17])!    // PL   6
                        ctrCL = startCL   // counter for CL      2
                        if (startCL > 1) {
                            startNCo = Int(db.sDriver[ctr + ctrCL - 2][10])!  // get the base cumul coins for starting CL
                        } else {
                            startNCo = 0   // for low CLs, starting=0
                        }
                        while (ctrCL < ctrPL) {      // CL<PL
                            // get the NCo for ctrCL. If ACo>NCo then save the PR  for that ctrCL.
                            // add +1 to ctrCL and see if it still works
                            ctrNCo = 0    //get the ctrNCo
                            if (ctrPL >= 1) {    // if PL>=1   ie. CL<>0
                                ctrNCo = Int(db.sDriver[ctr + ctrCL - 1][10])! - startNCo  // and subtract the CL cumul coins already spent
                            }
                            //print("!! Row: \(ctr). Start NCo= \(startNCo). To upgrade from \(startCL) to CL= \(ctrCL + 1) to PL= \(ctrPL); NCo= \(ctrNCo) and ACo= \(sMultStripped)")
                            
                            if (Int(Double(sMultStripped)!) >= ctrNCo ) {
                                db.sDriver[ctr][31] = String(ctrCL + 1)   // save PL(ACo>NCo)
                                db.sDriver[ctr][32] = db.sDriver[ctr + ctrCL - 1][12]   // save PR(ACo>NCo)
                                print("!!DV419 Saving PR(ACo>NCo) with PL= \(ctrCL + 1) and PR= \(db.sDriver[ctr + ctrCL][12])")
                            }

                            ctrCL = ctrCL + 1   // next CL
                        }
                    }
                }   //  ctr
                print("!!DV420")
                //printArrRow(arrName: db.sDriver, xRow: 11)
                start()
                
            } else {
                print("Bad level, cards or coins input")
                showingAlert = true
            }
        })    // sheet
        {
            DriverUpdateView(isDriverUpdateViewShowing: $isDriverUpdateViewShowing)
                .environmentObject(db)
        }
            .onAppear(perform: start)
        
    }   //end of body
    
    
    func start() {

        print("!!! DV start()...")
        
        if (db.sDriver[0][29] == "1") {    // if max_lvl hasn't been set = db hasn't loaded into sDriver ie. it's the first time running
            try! db.setup()   //create db
            do {
                //read db records
                db.sCard = try db.dbReadCards()
                db.sDriver = try db.dbReadDriver()
                db.sPart = try db.dbReadPart()
                db.sMult = try db.dbReadMult()
                //print("!!! db.sDriver= \(db.sDriver)")
                
                for ctr in stride(from: 0, to: 650, by: 11) {   // set up bDriverBoost on initial run
                    if (db.sDriver[ctr][14] == "1.0") {
                        db.bDriverBoost[ctr] = false
                    } else {
                        db.bDriverBoost[ctr] = true
                    }
                }
            } catch {
                print("dbRead failed")
            }
            multOver = Double(db.sMult[5][1])!
            multDefend = Double(db.sMult[6][1])!
            multConsist = Double(db.sMult[7][1])!
            multFuel = Double(db.sMult[8][1])!
            multTire = Double(db.sMult[9][1])!
            multWet = Double(db.sMult[10][1])!
            print("db setup completed")
        }

        db.sDriver = db.sDriverCalc(sDriver: db.sDriver, sMult: db.sMult, sCard: db.sCard, bDriverBoost: db.bDriverBoost)      //make changes based on new levels, cards and 10%
        db.sPart = db.sPartCalc(sPart: db.sPart, sMult: db.sMult, sCard: db.sCard)      //update calculations- first time though needed to prevent errors
        db.sDriver[0][0] = "2"    // set so that next run will not create new db.

        do {
            db.sDriver = try db.updateDriver(sDriver: db.sDriver)  //update db with any calc changed
            try db.updateMult()

        } catch {
            print("\nDriverUpdateView: db.updateDriver and/or db.updateMult failed")
        }

        row_ctr = 0
        while row_ctr <= 659 {    // build the first row strings for each driver
            let result = displayCalc(a_ctr: row_ctr)      // get the formatted string
            DriverDisplay[row_ctr][0] = result.0    //put it in, [0] is the string, [1] is the font size depending on [0].length
            fontSize[row_ctr] = result.1
            row_ctr = row_ctr + 11
        }
        //print("!! Start bFirstTimeLoad= \(db.bFirstTimeLoad)")
        if (db.bFirstTimeLoad) {   //when loading, if its the first time then show the info sheet
            FirstTimeInfoView()
        }
        
    }  // end of start
    

    func displayCalc(a_ctr: Int)  -> (String, Int) {
        //print("dc= ",row_ctr)
        var built = ""
        let Space = "              "
        if (db.sDriver[row_ctr][15].count + db.sDriver[row_ctr][20].count + db.sDriver[row_ctr][21].count + db.sDriver[row_ctr ][17].count) <= 10 {
            fontSize[row_ctr] = 13
            built = db.sDriver[row_ctr ][15] + Space.prefix(7 - db.sDriver[row_ctr ][15].count - db.sDriver[row_ctr ][20].count) + db.sDriver[row_ctr ][20] + "/" + db.sDriver[row_ctr ][21] + Space.prefix(6 - db.sDriver[row_ctr ][21].count - db.sDriver[row_ctr ][17].count) + db.sDriver[row_ctr ][17]
        } else {
            fontSize[row_ctr] = 11
            built = db.sDriver[row_ctr ][15] + Space.prefix(8 - db.sDriver[row_ctr][15].count - db.sDriver[row_ctr][20].count) + db.sDriver[row_ctr][20] + "/" + db.sDriver[row_ctr][21] + Space.prefix(8 - db.sDriver[row_ctr][21].count - db.sDriver[row_ctr][17].count) + db.sDriver[row_ctr][17]
        }
        
        return (built, fontSize[row_ctr])
    }
    
    
    func sliderCalc() {
        //print("Slider works: ", multOver, multDefend)
        db.sMult[5][1] = String(format: "%.0f", multOver)
        db.sMult[6][1] = String(format: "%.0f", multDefend)
        db.sMult[7][1] = String(format: "%.0f", multConsist)
        db.sMult[8][1] = String(format: "%.0f", multFuel)
        db.sMult[9][1] = String(format: "%.0f", multTire)
        db.sMult[10][1] = String(format: "%.0f", multWet)
        do {
            try db.updateMult()
            db.sDriver = try db.sDriverCalc(sDriver: db.sDriver, sMult: db.sMult, sCard: db.sCard, bDriverBoost: db.bDriverBoost)
        } catch {
            print("DriverView: db.updateMult and/or db.sDriverCalc failed")
        }
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
   
 
}   //struct

struct InfoSheetDriverView: View {
    var body: some View {
        ScrollView() {
            Text("info_contents_driver")
            .font(.system(size: 12))
            .frame(width: 300)
            .padding()
        }
    }
}

struct FirstTimeInfoView: View {
    var body: some View {
        ScrollView() {
            Text("intro")
            .font(.system(size: 12))
            .frame(width: 300)
            .padding()
        }
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
//        DriverView(sDriver: .constant([["0", "Zhou", "1", "12", "7", "11", "9", "5", "3", "1000", "1000", "", "", "1", "0", "10", "", "", "", "", "6789", "", "", "", "", "", "", "", "", "11", ""]]),sPart: .constant([["Brakes", "The Clog", "1", "1", "3", "2", "6", "1", "0", "1000", "1000", "", "", "1", "0", "1", "", "", "", "", "8", "", "", "", "", "", "", "", "", "11", ""]]),sMult: .constant([["iPowerMult", "100"]]),sCard: .constant([["1", "4", "4"]]), bDriverBoost: .constant([false]), sSelectedMode: .constant("Basic"))
        Text("Hello preview")
    }
}

