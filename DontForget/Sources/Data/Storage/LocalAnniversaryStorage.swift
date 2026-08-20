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

    public enum StorageError: Error {
        case encodingFailed
        case decodingFailed
        case notFound
        case saveFailed
    }

    public func save(anniversary: AnniversaryDetailDTO) throws {
        var anniversaries = try loadAll()

        if let index = anniversaries.firstIndex(where: { $0.anniversaryId == anniversary.anniversaryId }) {
            anniversaries[index] = anniversary
        } else {
            anniversaries.append(anniversary)
        }

        let encoder = JSONEncoder()
        let encoded = try encoder.encode(anniversaries)
        userDefaults.set(encoded, forKey: anniversariesKey)
    }

    public func loadAll() throws -> [AnniversaryDetailDTO] {
        guard let data = userDefaults.data(forKey: anniversariesKey) else {
            return []
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode([AnniversaryDetailDTO].self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }

    public func load(id: Int) throws -> AnniversaryDetailDTO {
        let anniversaries = try loadAll()
        guard let anniversary = anniversaries.first(where: { $0.anniversaryId == id }) else {
            throw StorageError.notFound
        }
        return anniversary
    }

    public func delete(id: Int) throws {
        var anniversaries = try loadAll()
        anniversaries.removeAll { $0.anniversaryId == id }

        let encoder = JSONEncoder()
        let encoded = try encoder.encode(anniversaries)
        userDefaults.set(encoded, forKey: anniversariesKey)
    }

    public func deleteAll() {
        userDefaults.removeObject(forKey: anniversariesKey)
    }
}
