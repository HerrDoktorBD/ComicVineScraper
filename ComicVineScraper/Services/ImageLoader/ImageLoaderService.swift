//
//  ImageLoaderService.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

protocol ImageLoaderServiceProtocol: AnyObject {

    func loadImage(from url: URL,
                   placeholder: UIImage?) -> AnyPublisher<UIImage?, Never>
}

final class ImageLoaderService: ImageLoaderServiceProtocol {

    private let cache: ImageCacheType = ImageCache()

    func loadImage(from url: URL,
                   placeholder: UIImage?) -> AnyPublisher<UIImage?, Never> {

        if let image = cache.image(for: url) {
            return .just(image)
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in

                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }

                self.cache.insertImage(image, for: url)
                return image
            }
            .replaceError(with: placeholder)
            .eraseToAnyPublisher()
    }
}
