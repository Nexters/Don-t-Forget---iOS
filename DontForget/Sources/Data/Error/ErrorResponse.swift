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

struct ErrorResponse: Decodable {  /// 사실 이걸 빼기도 코쓱머쓱하지만, 정석대로 하기위해서 뺐습니당
    let message: String
}
