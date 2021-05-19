//
//  CvPopularItemsVM.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

final class CvPopularItemsVM: CvPopularItemsVMProtocol {

    private var cancellables: [AnyCancellable] = []
    private let tab: Tabs
    private let useCase: CvPopularItemsUseCaseProtocol

    init(tab: Tabs,
         useCase: CvPopularItemsUseCaseProtocol) {

        self.tab = tab
        self.useCase = useCase
    }

    func transform(input: CvPopularItemsVMInput) -> CvPopularItemsVMOutput {

        let cvItems = input.appear

            .flatMap({ [unowned self] _ in

                (tab == .Volumes) ? self.useCase.cvPopularVolumes() : self.useCase.cvPopularIssues()
            })
            .map({ result -> CvPopularItemsState in

                switch result {
                    case .success(let cvItems) where cvItems.isEmpty: return .noResults
                    case .success(let cvItems): return .success(self.viewModels(from: cvItems))
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()

        let loading: CvPopularItemsVMOutput = input.appear.map({ _ in

            .loading
        })
        .eraseToAnyPublisher()

        return Publishers
            .Merge(loading, cvItems)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private func viewModels(from cvItems: [CvPopularItem]) -> [CvPopularItemVM] {

        return cvItems.map({ [unowned self] cvItem in

            return CvPopularItemVMBuilder.viewModel(from: cvItem,
                                             imageLoader: { [unowned self] cvItem in
                // load the cover
                self.useCase.loadImage(for: cvItem)
            })
        })
    }
}
