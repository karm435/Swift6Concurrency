import Foundation

public struct AdvertisedStart: Codable, Sendable {
    public let seconds: Double
    
    public init(seconds: Double) {
        self.seconds = seconds
    }
}

extension AdvertisedStart: Comparable {
    public static func < (lhs: AdvertisedStart, rhs: AdvertisedStart) -> Bool {
        lhs.toDate() < rhs.toDate()
    }
}

extension AdvertisedStart {
    
    public var isOneMinutePassedStartTime: Bool {
        let oneMinFromNow = Calendar.current.date(byAdding: .minute, value: -1, to: .now)!
        return  seconds <= oneMinFromNow.timeIntervalSince1970
    }
    
    public var isPassedStartTime: Bool {
        return  seconds < Date.now.timeIntervalSince1970
    }
    
    public var since: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: toDate(), relativeTo: .now)
    }
    
    public func toDate() -> Date {
        // Convert timestamp to utc date
        return Date(timeIntervalSince1970: TimeInterval(self.seconds))
    }
}
