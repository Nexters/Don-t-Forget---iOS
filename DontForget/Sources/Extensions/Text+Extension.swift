//
//  Text+Extension.swift
//  DontForget
//
//  Created by 최지철 on 1/23/24.
//

import SwiftUI

extension Text {
    static func coloredText(_ text: String, coloredPart: String, color: Color) -> Text { /// 텍스트 생성 시, 일부분만 다른 색으로 처리하는 함수입니다
        let fullRange = (text as NSString).range(of: text)
        let rangeOfColoredPart = (text as NSString).range(of: coloredPart)
        
        if fullRange.location != NSNotFound, rangeOfColoredPart.location != NSNotFound {
            let before = String(text[..<text.index(text.startIndex, offsetBy: rangeOfColoredPart.location)])
            let colored = String(text[text.index(text.startIndex, offsetBy: rangeOfColoredPart.location)...text.index(text.startIndex, offsetBy: rangeOfColoredPart.location + rangeOfColoredPart.length - 1)])
            let after = String(text[text.index(text.startIndex, offsetBy: rangeOfColoredPart.location + rangeOfColoredPart.length)...])
            
            return Text(before) + Text(colored).foregroundColor(color) + Text(after)
        } else {
            return Text(text)
        }
    }
}

