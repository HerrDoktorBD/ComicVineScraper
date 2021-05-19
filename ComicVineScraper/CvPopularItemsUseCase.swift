//
//  CvPopularItemsUseCase.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

protocol CvPopularItemsUseCaseProtocol {

    /// loads the cover for the given item
    func loadImage(for cvItem: CvPopularItem) -> AnyPublisher<UIImage?, Never>

    /// get popular volumes
    func cvPopularVolumes() -> AnyPublisher<Result<[CvPopularItem], Error>, Never>

    /// get popular issues
    func cvPopularIssues() -> AnyPublisher<Result<[CvPopularItem], Error>, Never>
}

final class CvPopularItemsUseCase: CvPopularItemsUseCaseProtocol {

    private let networkService: NetworkServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol

    init(networkService: NetworkServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol) {

        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }

    func loadImage(for cvItem: CvPopularItem) -> AnyPublisher<UIImage?, Never> {

        guard let imgsrc = cvItem.imgsrc else { return .just(nil) }

        let url = URL(string: imgsrc)!
        return imageLoaderService.loadImage(from: url,
                                            placeholder: imageFrom(color: .gray))
    }

    func imageFrom(color: UIColor) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    func cvPopularVolumes() -> AnyPublisher<Result<[CvPopularItem], Error>, Never> {

        return networkService
            .load(Resource<[CvPopularItem]>.cvPopularVolumes())
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[CvPopularItem], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func cvPopularIssues() -> AnyPublisher<Result<[CvPopularItem], Error>, Never> {

        return networkService
            .load(Resource<[CvPopularItem]>.cvPopularIssues())
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[CvPopularItem], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
