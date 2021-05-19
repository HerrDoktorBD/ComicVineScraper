//
//  CvMainCoordinator.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/10/21.
//  Copyright © 2021 Dougly. All rights reserved.
//

import UIKit

class CvMainCoordinator: BaseCoordinator {

    fileprivate var navVC: UINavigationController?
    fileprivate let dependencyProvider: CoordinatorDependencyProviderProtocol

    init(navVC: UINavigationController,
         dependencyProvider: CoordinatorDependencyProviderProtocol) {

        self.navVC = navVC
        self.dependencyProvider = dependencyProvider
    }

    override func start() {

        let vc = self.dependencyProvider.cvMainVC()
        navVC?.pushViewController(vc, animated: true)
    }
}
