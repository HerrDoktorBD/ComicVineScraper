//
//  CvItemsVMProtocol.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Combine

struct CvPopularItemsVMInput {

    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>

    /// triggered when the search query is updated
    let search: AnyPublisher<String, Never>

    /// called when the user selects an item from the list
    let selection: AnyPublisher<Int, Never>
}

enum CvPopularItemsState {

    case idle
    case loading
    case success([CvPopularItemVM])
    case noResults
    case failure(Error)
}

extension CvPopularItemsState: Equatable {

    static func == (lhs: CvPopularItemsState,
                    rhs: CvPopularItemsState) -> Bool {

        switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.loading, .loading): return true
            case (.success(let lhsCvItems), .success(let rhsCvItems)): return lhsCvItems == rhsCvItems
            case (.noResults, .noResults): return true
            case (.failure, .failure): return true
            default: return false
        }
    }
}

typealias CvPopularItemsVMOutput = AnyPublisher<CvPopularItemsState, Never>

protocol CvPopularItemsVMProtocol {

    func transform(input: CvPopularItemsVMInput) -> CvPopularItemsVMOutput
}
