//
//  Resource+Cv.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Foundation

extension Resource {

    static func cvPopularVolumes() -> Resource<[CvPopularItem]> {

        let url = URL(string: ApiConstants.cvBaseUrl)!.appendingPathComponent("/volumes/")
        let parameters: [String : CustomStringConvertible] = [:]

        return Resource<[CvPopularItem]>(url: url,
                                  parameters: parameters)
    }

    static func cvPopularIssues() -> Resource<[CvPopularItem]> {

        let url = URL(string: ApiConstants.cvBaseUrl)!.appendingPathComponent("/issues/")
        let parameters: [String : CustomStringConvertible] = [:]

        return Resource<[CvPopularItem]>(url: url,
                                  parameters: parameters)
    }
}
