//
//  AppCoordinator.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {

    typealias DependencyProvider = AppCoordinatorDependencyProviderProtocol

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider

    init(window: UIWindow,
         dependencyProvider: DependencyProvider) {

        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    override func start() {

        // prepare root view
        let navVC = UINavigationController()

        let coordinator = CvMainCoordinator(navVC: navVC,
                                            dependencyProvider: self.dependencyProvider)
        // store coordinator
        self.store(coordinator: coordinator)

        coordinator.start()

        window.rootViewController = navVC
        window.makeKeyAndVisible()

        // free coordinator when done
        coordinator.isCompleted = { [weak self] in

            self?.free(coordinator: coordinator)
        }
    }
}
