//
//  PageViewControllerSegmentedAdapter.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/10/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//
// https://gist.github.com/dchohfi/12d3ea0d9c0a17e2bd9d453865d226bf#file-pageviewcontrollersegmentedadapter-swift

import UIKit

final class PageViewControllerSegmentedAdapter: NSObject {

    private let pageViewController: UIPageViewController
    fileprivate let segmentedControl: UISegmentedControl
    fileprivate let pageVCs: [UIViewController]
    fileprivate var currentIndex: Int = 0

    init(pageViewController: UIPageViewController,
         segmentControl: UISegmentedControl,
         pageVCs: [UIViewController]) {

        if segmentControl.numberOfSegments != pageVCs.count {

            fatalError("Number of segments in UISegmentControl should be equal to the number of UIViewControllers.")
        }

        self.pageViewController = pageViewController
        self.segmentedControl = segmentControl
        self.pageVCs = pageVCs

        super.init()

        pageViewController.delegate = self
        pageViewController.dataSource = self

        segmentedControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self,
                                 action: #selector(segmentedControlTapped),
                                 for: .valueChanged)

        if let firstVC = pageVCs.first {

            pageViewController.setViewControllers([firstVC],
                                                  direction: .forward,
                                                  animated: false)
        }
    }

    @objc private func segmentedControlTapped() {

        moveTo(self.segmentedControl.selectedSegmentIndex)
    }

    public func moveTo(_ newIndex: Int) {

        let currentIndex = self.currentIndex

        if newIndex > currentIndex {

            let nextIndex = currentIndex + 1
            for index in nextIndex...newIndex {

                self.setViewController(atIndex: index,
                                       direction: .forward)
            }
        }
        else if newIndex < currentIndex {

            let previousIndex = currentIndex - 1
            for index in (newIndex...previousIndex).reversed() {

                self.setViewController(atIndex: index,
                                       direction: .reverse)
            }
        }
    }

    private func setViewController(atIndex index: Int,
                                   direction: UIPageViewController.NavigationDirection) {

        self.pageViewController.setViewControllers([self.pageVCs[index]],
                                                   direction: direction,
                                                   animated: true) { [weak self] completed in
            guard let me = self else {
                return
            }
            if completed {
                me.currentIndex = index
                me.segmentedControl.selectedSegmentIndex = index
            }
        }
    }
}

extension PageViewControllerSegmentedAdapter: UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore vc: UIViewController) -> UIViewController? {

        guard let index = self.pageVCs.firstIndex(of: vc),
            index > 0 else {
                return nil
        }
        return self.pageVCs[index-1]
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter vc: UIViewController) -> UIViewController? {

        guard var index = self.pageVCs.firstIndex(of: vc) else {
            return nil
        }
        index = index + 1
        if index == self.pageVCs.count {
            return nil
        }
        return self.pageVCs[index]
    }
}

extension PageViewControllerSegmentedAdapter: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers,
            let lastViewController = viewControllers.last,
            let index = self.pageVCs.firstIndex(of: lastViewController) else {
                return
        }

        if finished && completed {
            self.currentIndex = index
            self.segmentedControl.selectedSegmentIndex = index
        }
    }
}
