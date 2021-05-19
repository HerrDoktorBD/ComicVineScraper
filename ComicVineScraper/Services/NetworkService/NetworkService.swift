//
//  NetworkService.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}

/// Defines the Network service errors.
enum NetworkError: Error {

    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
}

final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {

        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {

        guard let request = resource.request else {

            return .fail(NetworkError.invalidRequest)
        }

        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
//            .print()
            .flatMap { data, response -> AnyPublisher<T, Error> in

                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.invalidResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    return .fail(NetworkError.dataLoadingError(statusCode: response.statusCode, data: data))
                }

                let html = String(data: data, encoding: .utf8)!

                let cvItems = iOSUtils().parseHTML(html: html,
                                                   cvUrlStr: ApiConstants.cvBaseUrl)
                return .just(cvItems as! T)
            }
            .eraseToAnyPublisher()
    }
}
