//
//  AnniversariesInterface.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

protocol AnniversariesInterface {
    func fetchAnniversaries(query: AnniversaryQuery) async throws -> AnniversariesResponse
}
