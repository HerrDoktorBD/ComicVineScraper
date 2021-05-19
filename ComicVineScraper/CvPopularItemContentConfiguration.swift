//
//  CvPopularItemContentConfiguration.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

struct CvPopularItemContentConfiguration: UIContentConfiguration, Hashable {

    var titleLabelText: String?
    var publisherLabelText: String?
    var bookCountLabelText: String?
    var viewOnComicvineLabelAttributedText: NSAttributedString?

    var coverImage: AnyPublisher<UIImage?, Never>?
    var worldImage: UIImage? = nil

    var symbolColor: UIColor?
    var symbolWeight: UIImage.SymbolWeight?

    func makeContentView() -> UIView & UIContentView {

        return CvPopularItemContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {

        // Make sure we are dealing with instance of UICellConfigurationState
        guard let state = state as? UICellConfigurationState else { return self }

        var updatedConfig = self

        if state.isSelected || state.isHighlighted {

            // Selected state
//            updatedConfig.symbolColor = .systemPink
//            updatedConfig.symbolWeight = .heavy
        }
        else {
            // Other states
            updatedConfig.symbolColor = UIColor(named: "tintColor")
            updatedConfig.symbolWeight = .regular
        }

        return updatedConfig
    }

    static func == (lhs: CvPopularItemContentConfiguration,
                    rhs: CvPopularItemContentConfiguration) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    private let identifier = UUID()
}
