//
//  ServicesProvider.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Foundation

class ServicesProvider {

    let networkService: NetworkServiceProtocol
    let imageLoader: ImageLoaderServiceProtocol

    static func defaultProvider() -> ServicesProvider {

        let networkService = NetworkService()
        let imageLoader = ImageLoaderService()

        return ServicesProvider(networkService: networkService,
                                imageLoader: imageLoader)
    }

    init(networkService: NetworkServiceProtocol,
         imageLoader: ImageLoaderServiceProtocol) {

        self.networkService = networkService
        self.imageLoader = imageLoader
    }
}
