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
    
    static let homeBackground = "homeBackground"
    static let homeBackgroundHalf = "homeBackgroundHalf"
    static let moonIcon = "moon"
    static let starInGrid1 = "StarInGrid1"
    static let starInGrid2 = "StarInGrid2"
    static let cardType1Background = "cardType1Background"
    static let cardType3Background = "cardType3Background"
    
    /* SF Symbols */
    static let calendarAddOn = "calendarAddOn"
}
