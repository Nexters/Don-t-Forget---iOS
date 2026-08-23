//
//  AnniversaryQuery.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

public struct AnniversaryQuery: Equatable {
    public let query: String

    public init(query: String) {
        self.query = query
    }
}

public struct AnniversaryDetailQuery: Equatable {
    public let queryId: Int

    public init(queryId: Int) {
        self.queryId = queryId
    }
}
