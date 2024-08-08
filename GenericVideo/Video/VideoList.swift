import SwiftUI
import LNPopupUI

// ContentView displaying the grid of videos
struct VideoList: View {
  let videos: [Video]
  let columns = [GridItem(.flexible(minimum: 180, maximum: 350)), GridItem(.flexible(minimum: 180, maximum: 350))]

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(videos, id: \.id) { video in
            VideoCell(video: video)
          }
        }.padding(.horizontal)
      }.navigationTitle("Videos")
    }
  }
}

// Example Usage
#Preview {
  VideoList(videos: mockVideos)
}
