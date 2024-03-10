//
//  Font+Extension.swift
//  DontForget
//
//  Created by 제나 on 3/1/24.
//

import SwiftUI

extension Font {
    enum Pretendard {
        case black
        case bold
        case extraLight
        case extraBold
        case light
        case medium
        case regular
        case semiBold
        case thin
        
        var value: String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .bold:
                return "Pretendard-Bold"
            case .extraLight:
                return "Pretendard-ExtraLight"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .thin:
                return "Pretendard-Thin"
            default:
                return ""
            }
        }
    }
    
    static func pretendard(_ type: Pretendard = .medium, size: CGFloat = 17) -> Font {
        return .custom(type.value, size: size)
    }
}
