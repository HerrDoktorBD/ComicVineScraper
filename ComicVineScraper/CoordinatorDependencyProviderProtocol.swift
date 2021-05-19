//
//  CoordinatorDependencyProviderProtocol.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

/// The `AppCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the AppCoordinator
protocol AppCoordinatorDependencyProviderProtocol: CoordinatorDependencyProviderProtocol {}

protocol CoordinatorDependencyProviderProtocol: AnyObject {

    // instantiate the main VC
    func cvMainVC() -> UIViewController

    // instantiate popular Comic Vine items
    func cvPopularItemsVC(tab: Tabs) -> UIViewController
}
