//
//  CvMainVC.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/10/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

enum Tabs {
    case Volumes
    case Issues
}

class CvMainVC: UIViewController {

    private var dependencyProvider: CoordinatorDependencyProviderProtocol!

    init(dependencyProvider: CoordinatorDependencyProviderProtocol) {

        self.dependencyProvider = dependencyProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var adapter: PageViewControllerSegmentedAdapter!

    lazy var pageController: UIPageViewController = {

        return UIPageViewController(transitionStyle: .scroll,
                                    navigationOrientation: .horizontal,
                                    options: nil)
    }()

    lazy var segmentedControl: UISegmentedControl = {

        let items = ["\(Tabs.Volumes)",
                     "\(Tabs.Issues)"]
        let sc_ = UISegmentedControl(items: items)

        return sc_
    }()

    lazy var pageVCs: [UIViewController] = {

        let vc1 = self.dependencyProvider.cvPopularItemsVC(tab: .Volumes)
        let vc2 = self.dependencyProvider.cvPopularItemsVC(tab: .Issues)

        return [vc1, vc2]
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(dependencyProvider != nil, "You must set a dependencyProvider before presenting this view controller.")

        title = "Comic Vine Popular Items"

        view.backgroundColor = .systemBackground

        view.addSubview(segmentedControl)
        self.addChild(pageController)
        view.addSubview(pageController.view)

        adapter = PageViewControllerSegmentedAdapter(pageViewController: pageController,
                                                     segmentControl: segmentedControl,
                                                     pageVCs: pageVCs)
        setupLayouts()

        numberOfPages = pageVCs.count
    }

    // MARK: - pagination with arrow keys
    var currentPage = 0
    var numberOfPages = 0

    open func goTo(_ page: Int, animated: Bool = true) {

        guard page >= 0 && page < numberOfPages else {
            return
        }

        adapter.moveTo(page)
        currentPage = page
    }

    open func next(_ animated: Bool = true) {

        goTo(currentPage + 1, animated: animated)
    }
    
    open func previous(_ animated: Bool = true) {

        goTo(currentPage - 1, animated: animated)
    }

    open override func pressesBegan(_ presses: Set<UIPress>,
                                    with event: UIPressesEvent?) {

        var didHandleEvent = false

        for press in presses {
            guard let key = press.key else { continue }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                previous()
                didHandleEvent = true
            }
            if key.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                next()
                didHandleEvent = true
            }
        }

        if didHandleEvent == false {
            // Didn't handle this key press, so pass the event to the next responder.
            super.pressesBegan(presses, with: event)
        }
    }

    private func setupLayouts() {

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            pageController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            pageController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            pageController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
