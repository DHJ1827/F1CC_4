//
//  DHJColour.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import Foundation
import SwiftUI

extension Color  {
    static let colours = DHJColourPicker()
}

struct DHJColourPicker {
    let rare = Color("Rare")
    let epic = Color("Epic")
    let common = Color("Common")
    let backgrd_blue = Color("Backgrd_blue")
}
