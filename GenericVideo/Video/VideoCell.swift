import SwiftUI

// VideoCell view to display individual video in the grid
struct VideoCell: View {
  @EnvironmentObject private var queue: QueueManager
  let video: Video

  // placeholder for while loading thumbnail
  var thumbnailView: some View {
    Color(uiColor: video.color)
      .aspectRatio(16/9, contentMode: .fill)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  // Video Cell
  var body: some View {
    Button(action: play) {
      VStack {
        thumbnailView

        Text(video.title)
          .font(.headline)
          .fontWeight(.medium)
          .lineLimit(2)
          .padding(.horizontal, 4)

        Text(video.creator)
          .font(.caption)
          .foregroundColor(.gray)
      }
    }
  }

  func play(){
    queue.play(video: video)
  }
}
