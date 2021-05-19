//
//  AppComponentsFactory.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

/// The AppComponentsFactory creates application components and establishes dependencies between them.
final class AppComponentsFactory {

    fileprivate lazy var cvPopularItemsUseCase: CvPopularItemsUseCaseProtocol = CvPopularItemsUseCase(networkService: servicesProvider.networkService,
                                                                                                      imageLoaderService: servicesProvider.imageLoader)
    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {

        self.servicesProvider = servicesProvider
    }
}

extension AppComponentsFactory: AppCoordinatorDependencyProviderProtocol {

    func cvMainVC() -> UIViewController {

        return CvMainVC(dependencyProvider: self)
    }

    // instantiate VC, and get the popular items on viewDidAppear
    func cvPopularItemsVC(tab: Tabs) -> UIViewController {

        let vm = CvPopularItemsVM(tab: tab,
                                  useCase: cvPopularItemsUseCase)
        return CvPopularItemsVC(viewModel: vm)
    }
}
