import SwiftUI

// Model for Video
struct Video: Equatable, Identifiable {
  let id: UUID
  let title: String
  let creator: String
  let color: UIColor
}

let allColors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan]

let mockVideos: [Video] = allColors.enumerated().map { index, color in
  Video(
    id: UUID(),
    title: "Video Title \(index + 1)",
    creator: "Creator \(index + 1)",
    color: color
  )
}

func bundleUrl( _ file: String, ext: String) -> URL {
  guard let path = Bundle.main.path(forResource: file, ofType: ext) else {
    fatalError("\(file).\(ext) not found")
  }
  return URL(fileURLWithPath: path)
}
