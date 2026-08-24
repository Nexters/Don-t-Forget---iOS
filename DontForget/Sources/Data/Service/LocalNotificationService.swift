//
//  LocalNotificationService.swift
//  DontForget
//
//  Created by 제나 on 8/24/26.
//

import Foundation
import UserNotifications

/// 기념일 알림을 기기 로컬에서 예약합니다.
/// 서버 푸시가 사라졌기 때문에 저장된 alarmSchedule을 UNUserNotificationCenter에 직접 등록합니다.
final class LocalNotificationService {

    static let shared = LocalNotificationService()

    /// iOS가 앱당 유지하는 예약 알림 개수 제한입니다.
    private static let pendingLimit = 64
    /// 기념일마다 미리 잡아둘 연차입니다. 앱을 열지 않아도 다음 해 알림이 남아 있도록 합니다.
    private static let yearsAhead = 3
    private static let notificationHour = 9
    private static let identifierPrefix = "anniversary"

    private let center = UNUserNotificationCenter.current()
    private let storage = LocalAnniversaryStorage.shared
    private let dateCalculator = AnniversaryDateCalculator()
    private let calendar = Calendar.current

    private init() {}

    // MARK: - Authorization

    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("=== DEBUG: requestAuthorization \(error)")
            return false
        }
    }

    func isAuthorized() async -> Bool {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }

    // MARK: - Scheduling

    /// 저장된 모든 기념일의 알림을 다시 예약합니다.
    /// 개수 제한이 있어 개별 추가/삭제 대신 매번 전체를 다시 계산합니다.
    func rescheduleAll(from referenceDate: Date = Date()) async {
        center.removeAllPendingNotificationRequests()

        guard await isAuthorized() else { return }

        let anniversaries: [AnniversaryDetailDTO]
        do {
            anniversaries = try storage.loadAll()
        } catch {
            print("=== DEBUG: rescheduleAll \(error)")
            return
        }

        let requests = anniversaries
            .flatMap { makeRequests(for: $0, from: referenceDate) }
            /// 가까운 알림부터 채워야 제한에 걸려도 임박한 알림이 살아남습니다.
            .sorted { $0.date < $1.date }
            .prefix(Self.pendingLimit)

        for request in requests {
            do {
                try await center.add(request.notification)
            } catch {
                print("=== DEBUG: add notification \(error)")
            }
        }
    }

    /// 알림을 모두 취소합니다.
    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }

    // MARK: - Private

    private func makeRequests(
        for anniversary: AnniversaryDetailDTO,
        from referenceDate: Date
    ) -> [(date: Date, notification: UNNotificationRequest)] {
        let occurrences = dateCalculator.upcomingSolarDates(
            baseDate: anniversary.baseDate,
            baseType: anniversary.baseType,
            from: referenceDate,
            count: Self.yearsAhead
        )
        let periods = anniversary.alarmSchedule.compactMap { AlarmPeriod(schedule: $0) }

        return occurrences.flatMap { occurrence in
            periods.compactMap { period in
                makeRequest(
                    for: anniversary,
                    occurrence: occurrence,
                    period: period,
                    from: referenceDate
                )
            }
        }
    }

    private func makeRequest(
        for anniversary: AnniversaryDetailDTO,
        occurrence: Date,
        period: AlarmPeriod,
        from referenceDate: Date
    ) -> (date: Date, notification: UNNotificationRequest)? {
        guard let offsetDate = calendar.date(byAdding: period.notificationOffset, to: occurrence),
              let fireDate = calendar.date(
                bySettingHour: Self.notificationHour,
                minute: 0,
                second: 0,
                of: offsetDate
              ),
              /// 이미 지난 시각은 등록해도 발송되지 않으므로 건너뜁니다.
              fireDate > referenceDate else {
            return nil
        }

        let content = UNMutableNotificationContent()
        content.title = anniversary.title
        content.body = "\(anniversary.title) \(period.notificationPhrase). 잊지 마세요!"
        content.sound = .default

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let request = UNNotificationRequest(
            identifier: identifier(for: anniversary, occurrence: occurrence, period: period),
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        )

        return (date: fireDate, notification: request)
    }

    /// 음력 기념일은 해마다 양력 날짜가 달라 반복 트리거를 쓸 수 없으므로
    /// 회차별로 고유한 식별자를 부여합니다.
    private func identifier(
        for anniversary: AnniversaryDetailDTO,
        occurrence: Date,
        period: AlarmPeriod
    ) -> String {
        let year = calendar.component(.year, from: occurrence)
        return "\(Self.identifierPrefix)-\(anniversary.anniversaryId)-\(year)-\(period.schedule)"
    }
}
