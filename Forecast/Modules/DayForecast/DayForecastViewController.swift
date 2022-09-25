//
//  DayForecastViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 19.09.2022.
//

import UIKit

class DayForecastViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case dates
        case main
    }

    var datesData: [DailyModel] = [
        DailyModel(time: 1663275600, temperatureMin: 8.5, temperatureMax: 14.4, weathercode: 63),
        DailyModel(time: 1663448400, temperatureMin: 9.3, temperatureMax: 15.6, weathercode: 61),
        DailyModel(time: 1663362000, temperatureMin: 9.1, temperatureMax: 15.5, weathercode: 3),
        DailyModel(time: 1663534800, temperatureMin: 10.6, temperatureMax: 14.9, weathercode: 95),
        DailyModel(time: 1663621200, temperatureMin: 8.7, temperatureMax: 13.7, weathercode: 80),
        DailyModel(time: 1663707600, temperatureMin: 7.9, temperatureMax: 13.7, weathercode: 80),
        DailyModel(time: 1663794000, temperatureMin: 6.7, temperatureMax: 12.2, weathercode: 45)
    ]
    
    var mainData: [DailyModel] = [
        DailyModel(time: 1_663_215_600, temperatureMin: 12.3, temperatureMax: 13.3, weathercode: 63)
    ]

    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    private let model: DailyModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(DateForecastCell.self, forCellWithReuseIdentifier: DateForecastCell.reusedId)
        collectionView.register(MainForecastCell.self, forCellWithReuseIdentifier: MainForecastCell.reusedId)

        return collectionView
    }()

    init(model: DailyModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        title = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.time)))

        setupView()
        createDataSource()
        reloadData()
    }

    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(collectionView)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind.")
            }

            switch section {
            case .dates:
                return self.createDatesLayoutSection()
            case .main:
                return self.createMainLayoutSection()
            }
        }

        return layout
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.dates, .main])
        snapshot.appendItems(datesData, toSection: .dates)
        snapshot.appendItems(mainData, toSection: .main)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Datasource
extension DayForecastViewController {

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind.")
                }

                switch section {
                case .dates:
                    return self.configure(collectionView: collectionView, cellType: DateForecastCell.self, with: model, for: indexPath)
                case .main:
                    return self.configure(collectionView: collectionView, cellType: MainForecastCell.self, with: model, for: indexPath)
                }
            })
    }
}

// MARK: - Setup layout
extension DayForecastViewController {
    private func createDatesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(50))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 20, bottom: 20, trailing: 20)

        return layoutSection
    }

    private func createMainLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20)

        return section
    }
}
