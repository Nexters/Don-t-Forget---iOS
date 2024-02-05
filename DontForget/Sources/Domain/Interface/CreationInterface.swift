//
//  CreationInterface.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

protocol CreationInterface { /// 인터페이스를 통해 레포지와 유스케이스 연결 (의존성 주입) Domain계층에 속함
    func registerAnniversary(
        title: String,
        date: String,
        content: String,
        calendarType: String,
        cardType: String,
        alarmSchedule: [String]
    ) async throws -> CreationResponse
}
