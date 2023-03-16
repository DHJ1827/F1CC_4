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

    var body: some View {
        ScrollView() {

                VStack {
                Text("Update part stats")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                HStack {
                    Text("Coins:")
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(width: 75)
                    TextField("Coins",text: $sMult[11][1])
                    
                }   //HStack
                
                HStack {
                    Text("Level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-20, y:0)
                    Text("Cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:-45, y:0)
                    
                    Text("Level")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:50, y:0)
                    Text("Cards")
                        .font(.system(size: 9, design: .monospaced))
                        .fontWeight(.regular)
                        .frame(width: 50)
                        .offset(x:25, y:0)
                    
                }
                .offset(x:45, y:0)   //HStack

                    ForEach(Array(stride(from: 0, to: 461, by: 22)), id: \.self) { index_v in
                        
                        HStack{
                            ForEach(Array(stride(from: 0, to: 12, by: 11)), id: \.self) { index_h in     // 2 columns wide
                                
                                VStack {
                                    let ctr: Int = index_v + index_h
                                    
                                    HStack {
                                        Text(sPart[ctr][1])
                                            .font(.system(size: 12, design: .monospaced))
                                            .fontWeight(.semibold)
                                            .frame(width: 100)
                                            .background(cmode[Int(sPart[ctr][13])!])
                                        TextField("Level",text: $sPart[ctr][15])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 20)
                                        TextField("Cards",text: $sPart[ctr][20])
                                            .font(.system(size: 12, design: .monospaced))
                                            .frame(width: 45, alignment: .center)
                                            .offset(x:-5,y:0)
                                    }  // HStack
                                    .offset(x:15, y:0)
                                }  //VStack
                                .padding(.bottom,5)
                            }  // ForEach
                             
                        } // HStack
                    }  // ForEach
            
        }     //VStack
        }     //ScrollView
        
            VStack {
                Button("Update/Ok", action: {
                    isPartUpdateViewShowing = false   // returns child view
                    print("DUV Update button done")
                })
            }   //VStack

    }   //View
    
}   // struct()




struct PartUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PartUpdateView(isPartUpdateViewShowing: .constant(true), sDriver: .constant([["0", "Zhou", "1", "12", "7", "11", "9", "5", "3", "1000", "1000", "", "", "1", "0", "10", "", "", "", "", "6789", "", "", "", "", "", "", "", "", "11", ""]]),sPart: .constant([["Brakes", "The Clog", "1", "1", "3", "2", "6", "1", "0", "1000", "1000", "", "", "1", "0", "1", "", "", "", "", "8", "", "", "", "", "", "", "", "", "11", ""]]),sMult: .constant([["iPowerMult", "100"]]),sCard: .constant([["1", "4", "4"]]))
    }
}


