//
//  CvPopularItemVMBuilder.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

struct CvPopularItemVMBuilder {

    static func viewModel(from cvPopularItem: CvPopularItem,
                          imageLoader: (CvPopularItem) -> AnyPublisher<UIImage?, Never>) -> CvPopularItemVM {

        let titleLabelText = cvPopularItem.title ?? ""

        var publisherLabelText = cvPopularItem.publisher ?? ""
        if let startYear_ = cvPopularItem.date {
            if !publisherLabelText.isEmpty {
                publisherLabelText.append(" ")
            }
            publisherLabelText.append("(")
            publisherLabelText.append(startYear_)
            publisherLabelText.append(")")
        }

        let bookCountLabelText = cvPopularItem.countOfIssues ?? ""

        let worldImageName = "global_portrait"
        var viewOnComicvineLabelAttributedText = NSAttributedString()
        if let urlStr_ = cvPopularItem.siteDetailUrl {
            viewOnComicvineLabelAttributedText = iOSUtils().makeAttribText(for: "View on Comicvine",
                                                                           urlStr: urlStr_)
        }

        return CvPopularItemVM(titleLabelText: titleLabelText,
                               publisherLabelText: publisherLabelText,
                               bookCountLabelText: bookCountLabelText,
                               viewOnComicvineLabelAttributedText: viewOnComicvineLabelAttributedText,

                               coverImage: imageLoader(cvPopularItem),
                               worldImageName: worldImageName)
    }
}
