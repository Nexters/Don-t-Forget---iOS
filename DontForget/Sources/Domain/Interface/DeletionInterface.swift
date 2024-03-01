//
//  DeletionInterface.swift
//  DontForget
//
//  Created by 제나 on 2/27/24.
//

import Foundation

protocol DeletionInterface {
    func deleteAnniversary(query: AnniversaryDetailQuery) async throws
}
