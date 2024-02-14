//
//  ErrorResponse.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

enum ServiceError: Error {
    case serverError(ErrorResponse)
    case unknownError(Error)
}

struct ErrorResponse: Decodable {
    let message: String
}
