//
//  Resource.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Foundation

struct Resource<T> {

    let url: URL
    let parameters: [String: CustomStringConvertible]

    var request: URLRequest? {

        guard var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in

            URLQueryItem(name: key,
                         value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }

        return URLRequest(url: url)
    }

    init(url: URL,
         parameters: [String: CustomStringConvertible] = [:]) {

        self.url = url
        self.parameters = parameters
    }
}
