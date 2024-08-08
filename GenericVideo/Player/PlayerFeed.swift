import SwiftUI

struct PlayerFeed: View {
  @EnvironmentObject private var queue: QueueManager

  var body: some View {
    VStack {
      if !queue.items.isEmpty {
        VideoPagingView()
      } else {
        Text("No videos...").foregroundColor(.white)
      }
    }
    .edgesIgnoringSafeArea(.all)
    .background(Color.black.ignoresSafeArea(.all))
  }
}
