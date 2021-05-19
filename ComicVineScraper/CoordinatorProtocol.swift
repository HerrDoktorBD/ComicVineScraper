//
//  CoordinatorProtocol.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

protocol CoordinatorProtocol: AnyObject {

    var childCoordinators: [CoordinatorProtocol] { get set }
    func start()
}

class BaseCoordinator: CoordinatorProtocol {

    var childCoordinators: [CoordinatorProtocol] = []
    var isCompleted: (() -> ())?

    func start() {
        fatalError("children should implement `start`.")
    }
}

extension CoordinatorProtocol {

    func store(coordinator: CoordinatorProtocol) {

        childCoordinators.append(coordinator)
    }

    func free(coordinator: CoordinatorProtocol) {

        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
