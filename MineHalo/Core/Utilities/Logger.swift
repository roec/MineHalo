import Foundation

enum Logger {
    static func debug(_ message: @autoclosure () -> String) {
#if DEBUG
        print("[MineHalo] \(message())")
#endif
    }
}
