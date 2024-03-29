//
//  PartUpdateView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI

struct PartUpdateView: View {
    
    @Binding var isPartUpdateViewShowing: Bool
    @Binding var sDriver: [[String]]
    @Binding var sPart: [[String]]
    @Binding var sMult: [[String]]
    @Binding var sCard: [[String]]
    
    @State var testToggle: Bool = false
    @State var index_v = 0
    @State var index_h = 0
    
    var db = DBHandler()
    
    let cmode: [Color] = [Color.white, Color.colours.common, Color.colours.rare, Color.colours.epic]    // colour backgroiunds for text
    let sCat: [String] = [NSLocalizedString("brakes", comment: ""),NSLocalizedString("gearbox", comment: ""),NSLocalizedString("rearwing", comment: ""),NSLocalizedString("frontwing", comment: ""),NSLocalizedString("suspension", comment: ""),NSLocalizedString("engine", comment: "")]
    var body: some View {
        ScrollView() {
            
            VStack {
                Text("updatePartStats")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                HStack {
                    Text("coin")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(width: 75)
                    TextField("Coins",text: $sMult[11][1])
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                    
                }   //HStack
                
                HStack {
                    Text("level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:0, y:0)
                    Text("cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-20, y:0)
                    Text("level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 55)
                        .offset(x:60, y:0)
                    Text("cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:40, y:0)
                }
                .offset(x:45, y:0)   //HStack
                
                ForEach(Array(stride(from: 66, to: 461, by: 77)), id: \.self) { index_z in    // last row is single (7th part in category)
                    Text(sCat[(index_z-66)/77])
                        .font(.system(size: 12, design: .monospaced))
                        .fontWeight(.semibold)
                        .frame(width: 150)
                        .offset(x:-130, y:0)
                    ForEach(Array(stride(from: index_z - 66, to: index_z - 10, by: 22)), id: \.self) { index_v in  // 3 rows of 2
                        HStack{
                            ForEach(Array(stride(from: 0, to: 12, by: 11)), id: \.self) { index_h in     // 2 columns wide
                                let ctr: Int = index_v + index_h
                                VStack {
                                    HStack {
                                        Text(sPart[ctr][1])
                                            .font(.system(size: 12, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 100)
                                            .background(cmode[Int(sPart[ctr][13])!])
                                        TextField("level",text: $sPart[ctr][15])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 20)
                                            .multilineTextAlignment(.trailing)
                                        TextField("cards",text: $sPart[ctr][20])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 40, alignment: .center)
                                            .multilineTextAlignment(.trailing)
                                            .offset(x:-5,y:0)
                                    }  // HStack
                                    .offset(x:15, y:0)
                                }  //VStack
                                .padding(.bottom,5)
                            }  // ForEach
                        } // HStack
                    }  // ForEach
                    VStack {
                        HStack {
                            Text(sPart[index_z][1])
                                .font(.system(size: 12, design: .monospaced))
                                .fontWeight(.semibold)
                                .frame(width: 100)
                                .background(cmode[Int(sPart[index_z][13])!])
                            TextField("level",text: $sPart[index_z][15])
                                .font(.system(size: 12, design: .monospaced))
                                .frame(width: 20)
                                .multilineTextAlignment(.trailing)
                            TextField("cards",text: $sPart[index_z][20])
                                .font(.system(size: 12, design: .monospaced))
                                .frame(width: 40, alignment: .center)
                                .multilineTextAlignment(.trailing)
                                .offset(x:-5,y:0)
                        }  // HStack
                        .offset(x:-80, y:0)
                    }  //VStack
                    .padding(.bottom,15)
                }
            }     //VStack
        }     //ScrollView
        
        VStack {
            Button("update", action: {
                isPartUpdateViewShowing = false   // returns child view
                print("DUV Update button done")
            })
        }   //VStack
        
    }   //View
    
}   // struct()




//struct PartUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        PartUpdateView(isPartUpdateViewShowing: .constant(true), sDriver: .constant([["0", "Zhou", "1", "12", "7", "11", "9", "5", "3", "1000", "1000", "", "", "1", "0", "10", "", "", "", "", "6789", "", "", "", "", "", "", "", "", "11", ""]]),sPart: .constant([["Brakes", "The Clog", "1", "1", "3", "2", "6", "1", "0", "1000", "1000", "", "", "1", "0", "1", "", "", "", "", "8", "", "", "", "", "", "", "", "", "11", ""]]),sMult: .constant([["iPowerMult", "100"]]),sCard: .constant([["1", "4", "4"]]))
//    }
//}

struct PartUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
    }
    
}   // struct()


