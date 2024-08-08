import SwiftUI

@main
struct GenericVideoApp: App {
  @StateObject var queue = QueueManager()

  // View based binding to prevent undefined behavior
  var popupBinding: Binding<Bool> {
    .init { queue.openPlayer } set: { newValue in
      DispatchQueue.main.async { queue.openPlayer = newValue }
    }
  }

  // Paging player content to display within the popup bar
  var playerContent: some View {
    PlayerFeed()
      .popupTitle(verbatim: queue.currentVideo?.title ?? "No Video",  subtitle: "\(queue.items.count) Videos")
      .popupInteractionContainer() // this line right here to enable dragging
      .edgesIgnoringSafeArea(.all)
      .background { Color.black.ignoresSafeArea(.all) }
  }

  // Main app View
  var body: some Scene {
    WindowGroup {
      VideoList(videos: mockVideos)
        .popup(isBarPresented: .constant(true), isPopupOpen: popupBinding) {
          playerContent
        }
    }.environmentObject(queue)
  }
}
