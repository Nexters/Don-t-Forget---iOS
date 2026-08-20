//
//  AnniversaryIdGenerator.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

class AnniversaryIdGenerator {
    static let shared = AnniversaryIdGenerator()
    private let userDefaults = UserDefaults.standard
    private let idCounterKey = "anniversaryIdCounter"
    private let queue = DispatchQueue(label: "com.dontforget.idgenerator", attributes: .concurrent)

    func generateId() -> Int {
        var newId = 0
        queue.sync {
            let current = userDefaults.integer(forKey: idCounterKey)
            newId = current + 1
            queue.async(flags: .barrier) {
                self.userDefaults.set(newId, forKey: self.idCounterKey)
            }
        }
        return newId
    }

    func reset() {
        queue.async(flags: .barrier) {
            self.userDefaults.removeObject(forKey: self.idCounterKey)
        }
    }
}
