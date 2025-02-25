// I would probably create a separate package for this. But for simplicity for this exercise I am putting it in the AppUtils package.
// I personally don't like the AppUtils package as it becomes a dumping ground of anything that does not fit anywhere. 

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
