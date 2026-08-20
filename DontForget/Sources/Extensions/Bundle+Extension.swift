//
//  Bundle+Extension.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}
