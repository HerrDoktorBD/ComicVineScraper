//
//  CvPopularItemsVC.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit
import Combine

class CvPopularItemsVC: UIViewController {

    var refreshControl = UIRefreshControl()

    private var cancellables: [AnyCancellable] = []
    private let viewModel: CvPopularItemsVMProtocol

    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()

    fileprivate var dataSource: UICollectionViewDiffableDataSource<CvSection, CvPopularItemVM>! = nil

    private let collectionView: UICollectionView = {

        // MARK: create layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        // MARK: configure collection view
        let cv = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()

    init(viewModel: CvPopularItemsVMProtocol) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInternalViews()
        setupConstraints()
        configureDataSource()

        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if dataSource.snapshot().numberOfItems == 0 {

            getItems()
        }
    }

    func setupInternalViews() {

        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.delegate = self

        // set up UIRefreshControl
        refreshControl.addTarget(self,
                                 action: #selector(getItems),
                                 for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc func getItems() {

        appear.send()
        refreshControl.beginRefreshing()
    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bind(to viewModel: CvPopularItemsVMProtocol) {

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = CvPopularItemsVMInput(appear: appear.eraseToAnyPublisher(),
                                          search: search.eraseToAnyPublisher(),
                                          selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: { [unowned self] state in

            self.render(state)
        })
        .store(in: &cancellables)
    }

    private func render(_ state: CvPopularItemsState) {

        refreshControl.endRefreshing()

        switch state {
            case .noResults:
                fallthrough
            case .idle:
                fallthrough
            case .loading:
                fallthrough
            case .failure:
                update(with: [], animate: true)

            case .success(let cvItems):
                update(with: cvItems, animate: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CvPopularItemsVC {

    /// - Tag: CellRegistration
    func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<CvPopularItemListCell, CvPopularItemVM> {

            (cell, indexPath, item: CvPopularItemVM) in

            cell.updateWithItem(item)

            cell.contentView.layoutMargins = .zero
            cell.contentView.preservesSuperviewLayoutMargins = true
        }

        dataSource = UICollectionViewDiffableDataSource<CvSection, CvPopularItemVM>(collectionView: collectionView) {

            (collectionView, indexPath, item: CvPopularItemVM) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        }
    }

    func update(with cvItems: [CvPopularItemVM],
                animate: Bool = true) {

        DispatchQueue.main.async {

            var snapshot = NSDiffableDataSourceSectionSnapshot<CvPopularItemVM>()

            snapshot.append(cvItems,
                            to: nil)

            self.dataSource.apply(snapshot,
                                  to: .main,
                                  animatingDifferences: animate)
        }
    }
}

extension CvPopularItemsVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

//        print(indexPath.row + 1)
    }
}

private extension CvPopularItemsVC {

    enum CvSection: Hashable {
        case main
    }
}
