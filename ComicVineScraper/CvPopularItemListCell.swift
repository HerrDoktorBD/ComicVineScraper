//
//  CvPopularItemListCell.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

// Declare a custom key for a custom `item` property.
fileprivate extension UIConfigurationStateCustomKey {

    static let viewModel = UIConfigurationStateCustomKey("com.tonymontes.CvPopularItemListCell.cvItemVM")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {

    var viewModel: CvPopularItemVM? {
        set { self[.viewModel] = newValue }
        get { return self[.viewModel] as? CvPopularItemVM }
    }
}

// This list cell subclass is an abstract class with a property that holds the item the cell is displaying,
// which is added to the cell's configuration state for subclasses to use when updating their configuration.
class CvPopularItemListCell_: UICollectionViewListCell {

    var viewModel: CvPopularItemVM? = nil

    func updateWithItem(_ newViewModel: CvPopularItemVM) {

        guard viewModel != newViewModel else { return }

        viewModel = newViewModel
        setNeedsUpdateConfiguration()
    }

    override var configurationState: UICellConfigurationState {

        var state = super.configurationState
        state.viewModel = self.viewModel
        return state
    }
}

class CvPopularItemListCell: CvPopularItemListCell_ {

    override func updateConfiguration(using state: UICellConfigurationState) {

        if let viewModel_ = viewModel {

            // Create a new background configuration so that
            // the cell must always have systemBackground background color
            // This will remove the gray background when cell is selected
            var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
            newBgConfiguration.backgroundColor = .systemBackground
            backgroundConfiguration = newBgConfiguration

            // create a new configuration object and update it based on state
            var content = CvPopularItemContentConfiguration().updated(for: state)

            // update any configuration parameters related to data item
            content.titleLabelText = viewModel_.titleLabelText
            content.publisherLabelText = viewModel_.publisherLabelText
            content.bookCountLabelText = viewModel_.bookCountLabelText
            content.viewOnComicvineLabelAttributedText = viewModel_.viewOnComicvineLabelAttributedText

            content.coverImage = viewModel_.coverImage
            content.worldImage = viewModel_.worldImage

            // Set content configuration in order to update custom content view
            contentConfiguration = content
        }
    }
}
