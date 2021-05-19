//
//  CvPopularItemVM.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

struct CvPopularItemVM: Hashable {

    let titleLabelText: String
    let publisherLabelText: String?
    let bookCountLabelText: String?
    var viewOnComicvineLabelAttributedText: NSAttributedString?

    var coverImage: AnyPublisher<UIImage?, Never>?
    var worldImage: UIImage?
    var statusImage: UIImage?

    var comicvineID: Int?

    init(titleLabelText: String? = nil,
         publisherLabelText: String? = nil,
         bookCountLabelText: String? = nil,
         viewOnComicvineLabelAttributedText: NSAttributedString? = nil,

         coverImage: AnyPublisher<UIImage?, Never>? = nil,
         worldImageName: String? = nil,
         statusImageName: String? = nil,

         comicvineID: Int? = nil) {

        self.titleLabelText = titleLabelText ?? ""
        self.publisherLabelText = publisherLabelText ?? ""
        self.bookCountLabelText = bookCountLabelText ?? ""
        self.viewOnComicvineLabelAttributedText = viewOnComicvineLabelAttributedText

        self.coverImage = coverImage
        if let imageName = worldImageName {
            self.worldImage = UIImage(named: imageName)
        }
        if let imageName = statusImageName {
            self.statusImage = UIImage(named: imageName)
        }
        self.comicvineID = comicvineID
    }

    static func == (lhs: CvPopularItemVM,
                    rhs: CvPopularItemVM) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    private let identifier = UUID()
}

