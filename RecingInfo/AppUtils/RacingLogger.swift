// I would probably create a separate package for this. But for simplicity for this exercise I am putting it in here.
// This is for local testing, would probably use a server side logger for this.
import Foundation
import os

public enum RacingLogger {
    public static let errorLogger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.entain.programmingExercise.RacingInfo",
        category: "Error"
    )
    
    public static let infoLogger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.entain.programmingExercise.RacingInfo",
        category: "Info"
    )
}
