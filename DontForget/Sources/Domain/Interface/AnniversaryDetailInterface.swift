//
//  AnniversaryDetailInterface.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

protocol AnniversaryDetailInterface {
    func fetchAnniversaryDetail(query: AnniversaryDetailQuery) async throws -> AnniversaryDetailResponse
}
