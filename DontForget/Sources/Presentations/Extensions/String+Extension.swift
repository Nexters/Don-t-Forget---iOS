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
