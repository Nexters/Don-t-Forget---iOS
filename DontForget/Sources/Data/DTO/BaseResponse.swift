//
//  BaseResponse.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct Empty: Decodable {}

struct CreationResponse: Decodable {
//    let anniversaryId: Int
}

struct AnniversariesResponse: Decodable {
    let anniversaries: [AnniversaryDTO]
}

struct AnniversaryDetailResponse: Decodable {
    let anniversaryDetail: AnniversaryDetailDTO
}

struct TestResponse: Decodable {
    let code: String
}
