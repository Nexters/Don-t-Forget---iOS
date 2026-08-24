//
//  LocalAnniversaryService.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

import KoreanLunarSolarConverter

/// 기준 날짜(baseDate, baseType)로부터 다가오는 기념일의 양력/음력 날짜를 계산합니다.
/// 서버가 내려주던 값을 로컬에서 대신 만들기 위한 계산기입니다.
struct AnniversaryDateCalculator {

    private let calendar = Calendar.current
    private let solarConverter = KoreanLunarToSolarConverter()
    private let lunarConverter = KoreanSolarToLunarConverter()
    private let lunarRangeChecker = KoreanLunarDateRangeChecker()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    /// - Parameters:
    ///   - baseDate: 사용자가 입력한 기념일 날짜 ("yyyy-MM-dd")
    ///   - baseType: 입력한 날짜의 기준 ("SOLAR" 또는 "LUNAR")
    ///   - referenceDate: 오늘로 간주할 날짜
    /// - Returns: 다가오는 기념일의 양력/음력 날짜. 변환할 수 없으면 입력한 날짜를 그대로 돌려줍니다.
    func upcomingDates(
        baseDate: String,
        baseType: String,
        from referenceDate: Date = Date()
    ) -> (solar: String, lunar: String) {
        guard let base = formatter.date(from: baseDate) else {
            return (solar: baseDate, lunar: baseDate)
        }

        let today = calendar.startOfDay(for: referenceDate)
        let month = calendar.component(.month, from: base)
        let day = calendar.component(.day, from: base)
        let currentYear = calendar.component(.year, from: today)
        /// 음력 12월 날짜는 다음 해 양력 1~2월에 오기 때문에 앞뒤 해까지 후보로 둡니다.
        let candidateYears = [currentYear - 1, currentYear, currentYear + 1]

        let candidates = candidateYears.compactMap { year in
            candidate(year: year, month: month, day: day, baseType: baseType)
        }

        guard let upcoming = candidates
            .filter({ $0.solar >= today })
            .min(by: { $0.solar < $1.solar }) ?? candidates.last else {
            return (solar: baseDate, lunar: baseDate)
        }

        return (
            solar: formatter.string(from: upcoming.solar),
            lunar: formatter.string(from: upcoming.lunar)
        )
    }

    /// 다가오는 기념일을 이른 순서로 count개 돌려줍니다.
    /// 음력 기념일은 해마다 양력 날짜가 달라지므로 매번 다시 계산합니다.
    func upcomingSolarDates(
        baseDate: String,
        baseType: String,
        from referenceDate: Date = Date(),
        count: Int
    ) -> [Date] {
        var results: [Date] = []
        var cursor = referenceDate

        for _ in 0..<count {
            let dates = upcomingDates(baseDate: baseDate, baseType: baseType, from: cursor)
            guard let solar = formatter.date(from: dates.solar) else { break }
            /// 같은 날짜가 반복되면(변환 실패 등) 더 진행하지 않습니다.
            if let last = results.last, solar <= last { break }
            results.append(solar)
            guard let next = calendar.date(byAdding: .day, value: 1, to: solar) else { break }
            cursor = next
        }

        return results
    }

    /// 특정 연도의 기념일 후보를 양력/음력 쌍으로 만듭니다.
    private func candidate(year: Int, month: Int, day: Int, baseType: String) -> (solar: Date, lunar: Date)? {
        if baseType == ConvertDate.lunar.title {
            /// 음력 기준이면 후보 자체가 음력 날짜이므로 양력으로 변환합니다.
            guard let lunar = lunarDate(year: year, month: month, day: day),
                  let converted = try? solarConverter.solarDate(fromLunar: lunar) else { return nil }
            return (solar: calendar.startOfDay(for: converted.date), lunar: lunar)
        } else {
            guard let solar = solarDate(year: year, month: month, day: day),
                  let converted = try? lunarConverter.lunarDate(fromSolar: solar) else { return nil }
            return (solar: solar, lunar: converted.date)
        }
    }

    /// 그 해에 없는 날짜(평년의 2월 29일)는 해당 월의 말일로 맞춥니다.
    /// 「민법」상 해당일이 없는 달은 말일을 기준일로 보기 때문에 3월 1일이 아니라 2월 28일이 됩니다.
    private func solarDate(year: Int, month: Int, day: Int) -> Date? {
        guard let firstDayOfMonth = date(year: year, month: month, day: 1),
              let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count else {
            return nil
        }
        return date(year: year, month: month, day: min(day, daysInMonth))
    }

    /// 음력은 달마다 29일 또는 30일이라, 그 달에 없는 날짜(29일까지인 달의 30일)는 말일로 맞춥니다.
    private func lunarDate(year: Int, month: Int, day: Int) -> Date? {
        for candidateDay in [day, day - 1] where candidateDay > 0 {
            guard let date = date(year: year, month: month, day: candidateDay) else { continue }
            if lunarRangeChecker.isValidDate(lunarDate: date) { return date }
        }
        return nil
    }

    private func date(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        guard let date = calendar.date(from: components) else { return nil }
        return calendar.startOfDay(for: date)
    }
}

public class LocalAnniversaryService: AnniversaryServiceProtocol {
    public static let shared = LocalAnniversaryService()
    private let storage = LocalAnniversaryStorage.shared
    private let idGenerator = AnniversaryIdGenerator.shared
    private let dateCalculator = AnniversaryDateCalculator()

    public func registerAnniversary(parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        let newId = idGenerator.generateId()
        try storage.save(anniversary: makeDetail(id: newId, parameters: parameters))
        await LocalNotificationService.shared.rescheduleAll()
        return CreationResponse()
    }

    public func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        try storage.save(anniversary: makeDetail(id: id, parameters: parameters))
        await LocalNotificationService.shared.rescheduleAll()
        return CreationResponse()
    }

    public func fetchAnniversaries() async throws -> AnniversariesResponse {
        let details = try storage.loadAll()
        let dtos = details.map { detail -> AnniversaryDTO in
            let dates = upcomingDates(of: detail)
            return AnniversaryDTO(
                anniversaryId: detail.anniversaryId,
                title: detail.title,
                lunarDate: dates.lunar,
                solarDate: dates.solar,
                cardType: detail.cardType
            )
        }
        return AnniversariesResponse(anniversaries: dtos)
    }

    public func fetchAnniversaryDetail(anniversaryId: Int) async throws -> AnniversaryDetailResponse {
        let detail = try storage.load(id: anniversaryId)
        return AnniversaryDetailResponse(anniversaryDetail: refreshed(detail))
    }

    public func deleteAnniversary(anniversaryId: Int) async throws {
        try storage.delete(id: anniversaryId)
        await LocalNotificationService.shared.rescheduleAll()
    }

    public func changePushState(status: String) async throws -> Int {
        return 200
    }

    public func fcmTest() async throws -> Int {
        return 200
    }

    // MARK: - Private

    private func makeDetail(id: Int, parameters: RegisterAnniversaryRequest) -> AnniversaryDetailDTO {
        let dates = dateCalculator.upcomingDates(
            baseDate: parameters.date,
            baseType: parameters.calendarType
        )
        return AnniversaryDetailDTO(
            anniversaryId: id,
            title: parameters.title,
            lunarDate: dates.lunar,
            solarDate: dates.solar,
            alarmSchedule: parameters.alarmSchedule,
            content: parameters.content,
            deviceId: Constants.uuid,
            cardType: parameters.cardType,
            baseDate: parameters.date,
            baseType: parameters.calendarType
        )
    }

    /// 저장된 날짜는 저장 시점의 "다가오는 기념일"이라 시간이 지나면 지나간 날짜가 됩니다.
    /// 그래서 조회할 때마다 baseDate를 기준으로 다시 계산합니다.
    private func upcomingDates(of detail: AnniversaryDetailDTO) -> (solar: String, lunar: String) {
        dateCalculator.upcomingDates(baseDate: detail.baseDate, baseType: detail.baseType)
    }

    private func refreshed(_ detail: AnniversaryDetailDTO) -> AnniversaryDetailDTO {
        let dates = upcomingDates(of: detail)
        return AnniversaryDetailDTO(
            anniversaryId: detail.anniversaryId,
            title: detail.title,
            lunarDate: dates.lunar,
            solarDate: dates.solar,
            alarmSchedule: detail.alarmSchedule,
            content: detail.content,
            deviceId: detail.deviceId,
            cardType: detail.cardType,
            baseDate: detail.baseDate,
            baseType: detail.baseType
        )
    }
}
