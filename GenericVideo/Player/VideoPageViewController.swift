import UIKit
import AVKit
import SwiftUI
import Combine

class VideoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  var viewControllersList: [UIViewController] = []
  var queue: QueueManager
  private var cancellables = Set<AnyCancellable>()

  init(queue: QueueManager) {
    self.queue = queue
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.dataSource = self
    self.delegate = self
    setupInitialViewControllers()
    observeQueueManager()
  }

  private func scrollToPage(index: Int, animated: Bool = false) {
    guard index >= 0 && index < viewControllersList.count else { return }

    let direction: UIPageViewController.NavigationDirection = index > queue.activeIndex ? .forward : .reverse
    setViewControllers([viewControllersList[index]], direction: direction, animated: animated, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func observeQueueManager() {
    queue.$items
      .dropFirst() // Skip the initial load
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.appendNewViewControllers()
      }
      .store(in: &cancellables)

    queue.$activeIndex
      .receive(on: DispatchQueue.main)
      .sink { [weak self] newIndex in
        self?.scrollToPage(index: newIndex)
      }
      .store(in: &cancellables)
  }

  private func setupInitialViewControllers() {
    viewControllersList = queue.items.enumerated().map { index, video in
      let rootView = Color(uiColor: video.color).edgesIgnoringSafeArea(.all)
      let controller = UIHostingController(rootView: rootView)
      return controller
    }

    if let firstViewController = viewControllersList.first {
      setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
  }

  private func appendNewViewControllers() {
    let currentCount = viewControllersList.count
    let newCount = queue.items.count

    guard newCount > currentCount else { return }

    for index in currentCount..<newCount {
      let rootView = Color(uiColor: queue.items[index].color).edgesIgnoringSafeArea(.all)
      let controller = UIHostingController(rootView: rootView)
      viewControllersList.append(controller)
    }

    // Ensure UIPageViewController recognizes the new view controllers
    self.dataSource = nil
    self.dataSource = self
  }

  // MARK: - UIPageViewDelegate & UIPageViewDataSource

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController), index > 0 else { return nil }
    return viewControllersList[index - 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController), index < (viewControllersList.count - 1) else { return nil }
    return viewControllersList[index + 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let _ = pendingViewControllers.first as? UIHostingController<VideoPlayer<EmptyView>> else { return }
    // viewController.rootView.viewModel.player.play()
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let _ = previousViewControllers.first as? UIHostingController<VideoPlayer<EmptyView>> else { return }
    // if completed { viewController.rootView.viewModel.player.pause() }
  }
}

extension UIPageViewController {
  var scrollView: UIScrollView? {
    return view.subviews.compactMap { $0 as? UIScrollView }.first
  }
}
