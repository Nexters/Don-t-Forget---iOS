//
//  Color+Extension.swift
//  DontForget
//
//  Created by 제나 on 1/18/24.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    static let neutral1 = Color(hex: 0xFBFAF1)
    
    static let primary1 = Color(hex: 0xEB5234)
    static let primary2 = Color(hex: 0xD93720)
}
