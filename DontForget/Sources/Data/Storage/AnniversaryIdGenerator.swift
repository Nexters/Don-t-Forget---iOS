//
//  AnniversaryIdGenerator.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

public class AnniversaryIdGenerator {
    public static let shared = AnniversaryIdGenerator()
    private let userDefaults = UserDefaults.standard
    private let idCounterKey = "anniversaryIdCounter"
    private let queue = DispatchQueue(label: "com.dontforget.idgenerator")

    public func generateId() -> Int {
        /// 읽기와 쓰기를 하나의 임계 영역에서 처리해야 동시 호출 시에도 ID가 중복되지 않습니다.
        return queue.sync { () -> Int in
            let newId = userDefaults.integer(forKey: idCounterKey) + 1
            userDefaults.set(newId, forKey: idCounterKey)
            return newId
        }
    }

    public func reset() {
        queue.sync {
            userDefaults.removeObject(forKey: idCounterKey)
        }
    }
}
