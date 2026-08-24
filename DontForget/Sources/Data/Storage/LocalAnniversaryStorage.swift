//
//  LocalAnniversaryStorage.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

public class LocalAnniversaryStorage {
    public static let shared = LocalAnniversaryStorage()
    private let userDefaults = UserDefaults.standard
    private let anniversariesKey = "anniversaries"
    /// 저장은 읽기 -> 수정 -> 쓰기로 이루어지기 때문에 직렬 큐로 감싸 동시 저장 시 유실을 막습니다.
    private let queue = DispatchQueue(label: "com.dontforget.anniversarystorage")

    public enum StorageError: Error {
        case encodingFailed
        case decodingFailed
        case notFound
        case saveFailed
    }

    public func save(anniversary: AnniversaryDetailDTO) throws {
        try queue.sync {
            var anniversaries = try readAll()

            if let index = anniversaries.firstIndex(where: { $0.anniversaryId == anniversary.anniversaryId }) {
                anniversaries[index] = anniversary
            } else {
                anniversaries.append(anniversary)
            }

            try write(anniversaries)
        }
    }

    public func loadAll() throws -> [AnniversaryDetailDTO] {
        try queue.sync { () -> [AnniversaryDetailDTO] in
            try readAll()
        }
    }

    public func load(id: Int) throws -> AnniversaryDetailDTO {
        try queue.sync { () -> AnniversaryDetailDTO in
            guard let anniversary = try readAll().first(where: { $0.anniversaryId == id }) else {
                throw StorageError.notFound
            }
            return anniversary
        }
    }

    public func delete(id: Int) throws {
        try queue.sync {
            /// 이미 삭제된 항목을 다시 지워도 실패하지 않도록 멱등하게 처리합니다.
            var anniversaries = try readAll()
            anniversaries.removeAll { $0.anniversaryId == id }
            try write(anniversaries)
        }
    }

    public func deleteAll() {
        queue.sync {
            userDefaults.removeObject(forKey: anniversariesKey)
        }
    }

    // MARK: - Private

    /// 큐 안에서만 호출해야 합니다. (중첩 sync 방지)
    private func readAll() throws -> [AnniversaryDetailDTO] {
        guard let data = userDefaults.data(forKey: anniversariesKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([AnniversaryDetailDTO].self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }

    /// 큐 안에서만 호출해야 합니다. (중첩 sync 방지)
    private func write(_ anniversaries: [AnniversaryDetailDTO]) throws {
        do {
            let encoded = try JSONEncoder().encode(anniversaries)
            userDefaults.set(encoded, forKey: anniversariesKey)
        } catch {
            throw StorageError.encodingFailed
        }
    }
}
