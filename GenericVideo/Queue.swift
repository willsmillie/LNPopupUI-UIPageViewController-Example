import Combine
import UIKit
import SwiftUI

class QueueManager: ObservableObject {
  @Published var activeIndex = 0
  @Published var items: [Video] = []
  @Published var openPlayer = false
  @Published var currentVideo: Video? = nil
  private var cancellables = Set<AnyCancellable>()

  init() {
    $activeIndex
      .sink { [weak self] index in
        self?.setCurrentVideo(for: index)
      }
      .store(in: &cancellables)
  }

  private func setCurrentVideo(for index: Int) {
    guard items.count > index else {
      currentVideo = nil
      return
    }
    currentVideo = items[index]
  }
  
  func play(video: Video) {
    if let index = items.firstIndex(of: video) {
      activeIndex = index
    } else {
      items.append(video)
      activeIndex = items.count - 1
    }
    setPlayerOpen()
  }

  private func setPlayerOpen() {
    DispatchQueue.main.async {
      self.openPlayer = true
    }
  }
}
