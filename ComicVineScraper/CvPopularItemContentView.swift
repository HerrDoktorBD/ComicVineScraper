//
//  CvPopularItemContentView.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

class CvPopularItemContentView: UIView, UIContentView, UITextViewDelegate {

    private var cancellable: AnyCancellable?

    private let coverWidth: CGFloat = 105
    private let coverHeight: CGFloat = 160
    private let cellHeight: CGFloat = 160

    init(configuration: CvPopularItemContentConfiguration) {
        super.init(frame: .zero)

        setupInternalViews()
        setupConstraints()

        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? CvPopularItemContentConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }

    lazy var cellStackView: UIStackView = {

        let arrangedViews = [coverImageView, vStackView]
        let stack = UIStackView(arrangedSubviews: arrangedViews)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 5
        stack.backgroundColor = .systemBackground

        return stack
    }()

    lazy var coverImageView: UIImageView = {

        let iv = UIImageView()

        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit

        let widthConstraint = iv.widthAnchor.constraint(equalToConstant: coverWidth)
        widthConstraint.isActive = true
        widthConstraint.priority = UILayoutPriority(1000)

        let heightConstraint = iv.heightAnchor.constraint(equalToConstant: coverHeight)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority(1000)

        return iv
    }()

    lazy var vStackView: UIStackView = {

        let arrangedViews = [titleLabel, publisherLabel, bookCountLabel, viewOnComicvineStackView]
        let stack = UIStackView(arrangedSubviews: arrangedViews)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()

    lazy var titleLabel: UILabel = {

        let lbl = UILabel()

        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.textColor = .label
        lbl.numberOfLines = 0

        return lbl
    }()

    lazy var publisherLabel: UILabel = {

        let lbl = UILabel()

        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 0

        return lbl
    }()

    lazy var bookCountLabel: UILabel = {

        let lbl = UILabel()

        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 0

        return lbl
    }()

    lazy var viewOnComicvineStackView: UIStackView = {

        let arrangedViews = [worldImageView, viewOnComicvineLabel]
        let stack = UIStackView(arrangedSubviews: arrangedViews)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5

        return stack
    }()

    lazy var worldImageView: UIImageView = {

        let iv = UIImageView()

        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit

        let widthConstraint = iv.widthAnchor.constraint(equalToConstant: 20)
        widthConstraint.isActive = true
        widthConstraint.priority = UILayoutPriority(1000)

//        let heightConstraint = iv.heightAnchor.constraint(equalToConstant: 20)
//        heightConstraint.isActive = true
//        heightConstraint.priority = UILayoutPriority(1000)

        return iv
    }()

    lazy var viewOnComicvineLabel: UITextView = {

        let tv = UITextView()

        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isUserInteractionEnabled = true
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.delegate = self
        tv.tintColor = UIColor(named: "tintColor")

        // "center" text vertically
        // https://www.hackingwithswift.com/example-code/uikit/how-to-pad-a-uitextview-by-setting-its-text-container-inset
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return tv
    }()
    
    // https://stackoverflow.com/questions/36198299/uitextview-disable-selection-allow-links/49443814#49443814
    func textViewDidChangeSelection(_ tv: UITextView) {

        if tv == viewOnComicvineLabel && tv.selectedTextRange != nil {

            // `selectable` is required for tappable links but we do not want
            // regular text selection, so clear the selection immediately.
            tv.delegate = nil // Disable delegate while we update the selectedTextRange otherwise this method will get called again, circularly, on some architectures (e.g. iPhone7 sim)
            tv.selectedTextRange = nil // clear selection, will happen before copy/paste/etc GUI renders
            tv.delegate = self // Re-enable delegate
        }
    }

    private func setupInternalViews() {

        addSubview(cellStackView)
    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStackView.heightAnchor.constraint(equalToConstant: cellHeight),
            cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }

    private var currentConfiguration: CvPopularItemContentConfiguration!

    private func apply(configuration: CvPopularItemContentConfiguration) {

        // Only apply configuration if new configuration and current configuration are not the same
        guard currentConfiguration != configuration else { return }

        // Replace current configuration with new configuration
        currentConfiguration = configuration

        // Set data to UI elements
        cancelImageLoading()

        cancellable = configuration.coverImage?
            .receive(on: DispatchQueue.main)
            .assign(to: \.coverImageView.image, on: self)

        titleLabel.text = configuration.titleLabelText
        publisherLabel.text = configuration.publisherLabelText
        bookCountLabel.text = configuration.bookCountLabelText
        viewOnComicvineLabel.attributedText = configuration.viewOnComicvineLabelAttributedText

        // color & weight
        if
            let symbolColor = configuration.symbolColor,
            let symbolWeight = configuration.symbolWeight {

            let imageWeightConfig = UIImage.SymbolConfiguration(weight: symbolWeight)

            var worldImage = configuration.worldImage?.withConfiguration(imageWeightConfig)
            worldImage = worldImage?.withTintColor(symbolColor, renderingMode: .alwaysOriginal)
            worldImageView.image = worldImage
        }
    }

    private func cancelImageLoading() {

        coverImageView.image = nil
        cancellable?.cancel()
    }
}
