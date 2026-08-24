//
//  ErrorResponse.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

public enum ServiceError: Error {
    case serverError(ErrorResponse)
    case unknownError(Error)
}

public struct ErrorResponse: Decodable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}
