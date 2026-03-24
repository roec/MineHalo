import AVFoundation
import Foundation

final class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    func play(effect name: String, completion: (() -> Void)? = nil) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            completion?()
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            completion?()
        } catch {
            Logger.debug("Audio play failed: \(error)")
            completion?()
        }
    }
}
