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

    /* DEPRECATED */
    static let neutral1 = Color(hex: 0xFBFAF1)
    static let neutral2 = Color(hex: 0xD0B874)
    
    static let primary1 = Color(hex: 0xEB5234)
    static let primary2 = Color(hex: 0xD93720)
    /* DEPRECATED */
    
    static let gray50 = Color(hex: 0xF8F9FA)
    static let gray100 = Color(hex: 0xF1F3F5)
    static let gray200 = Color(hex: 0xE9ECEf)
    static let gray300 = Color(hex: 0xDEE2E6)
    static let gray400 = Color(hex: 0xCED4DA)
    static let gray500 = Color(hex: 0xADB5BD)
    static let gray600 = Color(hex: 0x868E96)
    static let gray700 = Color(hex: 0x495057)
    static let gray800 = Color(hex: 0x343A40)
    static let gray900 = Color(hex: 0x212529)
    
    static let red500 = Color(hex: 0xFF5C26)
    static let pink500 = Color(hex: 0xEF83AB)
    static let yellow500 = Color(hex: 0xFFCD00)
    
    static let primary500 = Color(hex: 0x3D82F6)
    static let primary600 = Color(hex: 0x2B62D4)
    static let primary700 = Color(hex: 0x1E48B1)
}
