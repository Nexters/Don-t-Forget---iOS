//
//  String+Extension.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import Foundation

// MARK: - Localizing Methods
extension String {
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        String(format: self.localized(comment: comment), argument)
    }
}

// MARK: - Localized Strings
extension String {
    /* App */
    static let app = "app".localized()
}

// MARK: - Constants
extension String {
    /* Image */
    static let splashBackground = "splashBackground"
    
    static let homeBackgroundFull = "homeBackgroundFull"
    static let homeBackgroundHalf = "homeBackgroundHalf"
    static let cardBackground1 = "Card_BG_1"
    static let cardBackground2 = "Card_BG_2"
    static let cardBackground3 = "Card_BG_3"
    static let cardBackground4 = "Card_BG_4"
    static let cardBackground5 = "Card_BG_5"
    
    static let backIcon = "backIcon"
    static let deleteIcon = "deleteIcon"
    static let editIcon = "editIcon"
    static let calendarAddOnIcon = "anniversary_add"
    static let calendarDeleteIcon = "anniversary_delete"
    
    /* SF Symbols */
    static let chevronBackward = "chevron.backward"
    
    /* Lottie */
    static let splashLottie = "splash_lottie"
    
    /* UserDefaults key*/
    static let fcmToken = "fcmToken"
}
