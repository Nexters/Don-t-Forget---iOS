//
//  CacheManager.swift
//  DontForget
//
//  Created by 제나 on 3/17/24.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private let cacheDetails = NSCache<NSString, AnniversaryDetail>()
    
    init() {
        cacheDetails.countLimit = 20
    }
    
    func loadDetail(_ anniversaryId: Int) -> AnniversaryDetail? {
        let key = NSString(string: "\(anniversaryId)")
        if let cached = cacheDetails.object(forKey: key) {
            return cached
        }
        return nil
    }
    
    func setDetail(_ detail: AnniversaryDetail) {
        let key = NSString(string: "\(detail.dto.anniversaryId)")
        cacheDetails.setObject(detail, forKey: key)
    }
    
    func removeDetail(_ anniversaryId: Int) {
        let key = NSString(string: "\(anniversaryId)")
        cacheDetails.removeObject(forKey: key)
    }
}
