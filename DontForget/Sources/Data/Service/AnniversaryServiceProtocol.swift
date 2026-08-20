//
//  AnniversaryServiceProtocol.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

public protocol AnniversaryServiceProtocol {
    func registerAnniversary(parameters: RegisterAnniversaryRequest) async throws -> CreationResponse
    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse
    func fetchAnniversaries() async throws -> AnniversariesResponse
    func fetchAnniversaryDetail(anniversaryId: Int) async throws -> AnniversaryDetailResponse
    func deleteAnniversary(anniversaryId: Int) async throws
    func changePushState(status: String) async throws -> Int
    func fcmTest() async throws -> Int
}
