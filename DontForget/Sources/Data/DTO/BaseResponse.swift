//
//  BaseResponse.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

public struct Empty: Decodable {}

public struct CreationResponse: Decodable {
//    let anniversaryId: Int
}

public struct AnniversariesResponse: Decodable {
    public let anniversaries: [AnniversaryDTO]

    public init(anniversaries: [AnniversaryDTO]) {
        self.anniversaries = anniversaries
    }
}

public struct AnniversaryDetailResponse: Decodable {
    public let anniversaryDetail: AnniversaryDetailDTO

    public init(anniversaryDetail: AnniversaryDetailDTO) {
        self.anniversaryDetail = anniversaryDetail
    }
}
