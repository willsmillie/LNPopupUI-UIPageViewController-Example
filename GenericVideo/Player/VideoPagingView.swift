import SwiftUI

struct VideoPagingView: UIViewControllerRepresentable {
  @EnvironmentObject private var queue: QueueManager

  func makeUIViewController(context: Context) -> VideoPageViewController {
    return VideoPageViewController(queue: queue)
  }

  func updateUIViewController(_ uiViewController: VideoPageViewController, context: Context) {
    // No-op
  }
}
