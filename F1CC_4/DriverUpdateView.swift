//
//  DriverUpdateView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI


struct DriverUpdateView: View {
    
    @EnvironmentObject var db: DBHandler
    
    @Binding var isDriverUpdateViewShowing: Bool
    
    @State var testToggle: Bool = false
    @State var index_v = 0
    @State var index_h = 0
    
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic]    // colour backgroiunds for text

    
    var body: some View {
        ScrollView() {

                VStack {
                Text("Update driver stats")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                HStack {
                    Text("Coins:")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(width: 75)
                    TextField("Coins",text: $db.sMult[11][1])
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                        if let textField = obj.object as? UITextField {
                                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                                        }
                                    }
                    
                }   //HStack
                
                HStack {
                    Text("Level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                    Text("Cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-20, y:0)
                    Text("25%")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-40, y:0)
                    Text("Level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:20, y:0)
                    Text("Cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:5, y:0)
                    Text("25%")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-20, y:0)
                }
                .offset(x:45, y:0)   //HStack

                    ForEach(Array(stride(from: 0, to: 640, by: 22)), id: \.self) { index_v in
                        
                        HStack{
                            ForEach(Array(stride(from: 0, to: 12, by: 11)), id: \.self) { index_h in     // 2 columns wide
                                VStack {
                                    var ctr: Int = index_v + index_h
                                            
                                    HStack {
                                        Text(db.sDriver[ctr][1])
                                            .font(.system(size: 12, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 80)
                                            .background(cmode[Int(db.sDriver[ctr][13])!])
                                        TextField("Level",text: $db.sDriver[ctr][15])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 20)
                                        TextField("Cards",text: $db.sDriver[ctr][20])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 45, alignment: .center)
                                            .offset(x:-5,y:0)
                                        Toggle("", isOn: $db.bDriverBoost[ctr])
                                            .onChange(of: db.bDriverBoost[ctr]) { value in     //when toggle changes update 25% multiplier and font colour
                                                
                                               // toggle on/off driver at common/rare/epic as well
                                                var currDrBoost = db.bDriverBoost[ctr]
                                                var ctr1 = ctr
                                                if (ctr >= 440) {
                                                    ctr1 = ctr - 440
                                                } else if (ctr >= 220) {
                                                    ctr1 = ctr - 220
                                                }
                                                print ("!!ctr changed: ",ctr, db.bDriverBoost[ctr], ctr1)
                                                db.bDriverBoost[ctr1] = currDrBoost
                                                db.bDriverBoost[ctr1 + 220] = currDrBoost
                                                db.bDriverBoost[ctr1 + 440] = currDrBoost
                                               
                                                if (db.bDriverBoost[ctr] && db.sDriver[0][0] == "2") {       // don't change bDriverBoost on initial set-up ie. [0][0] =0
                                                    db.sDriver[ctr1][14] = "1.25"    //boost
                                                    db.sDriver[ctr1][30] = "5"   //red
                                                    db.sDriver[ctr1 + 220][14] = "1.25"    // change all same drivers in common, rare and epic
                                                    db.sDriver[ctr1 + 220][30] = "5"   //red
                                                    db.sDriver[ctr1 + 440][14] = "1.25"    // change all same drivers in common, rare and epic
                                                    db.sDriver[ctr1 + 440][30] = "5"   //red
                                               } else {
                                                   db.sDriver[ctr1][14] = "1.0"   // no boost
                                                   db.sDriver[ctr1][30] = "4"   //black
                                                   db.sDriver[ctr1 + 220][14] = "1.0"    // change all same drivers in common, rare and epic
                                                   db.sDriver[ctr1 + 220][30] = "4"   //black
                                                   db.sDriver[ctr1 + 440][14] = "1.0"    // change all same drivers in common, rare and epic
                                                   db.sDriver[ctr1 + 440][30] = "4"   //black
                                               }
                                           }
                                           .offset(x:-15,y:0)
                                           .toggleStyle(CheckboxStyleNew())
                                        
                                    }  // HStack
                                }  //VStack
                                .padding(.bottom,5)
                            }  // ForEach
                             
                        } // HStack
                    }  // ForEach
            
        }     //VStack
        }     //ScrollView
        
            VStack {
                Button("Update/Ok", action: {
                    isDriverUpdateViewShowing = false   // returns child view
                    print("DUV Update button done")
                })
            }   //VStack

    }   //View
    
    
    func start() {
        //print("bDriverBoost: \(index_v) \(index_h) \(bDriverBoost[0]) \(bDriverBoost[11]) \(bDriverBoost[22])")
        //print("toggled= ",bDriverBoost[1])
        //print((index_v + index_h)/11)
    }

}   // struct()

struct CheckboxStyleNew: ToggleStyle {      // custom toggle to look like checkbox
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack {
            
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(configuration.isOn ? .black : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        
    }
}

struct DriverUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
    }
    
}   // struct()


