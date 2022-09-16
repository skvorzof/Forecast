//
//  HomeViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import UIKit

class HomeViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case current
        case hourly
        case daily
    }

    var currentData: [CurrentModel] = []
    var hourlyData: [HourlyModel] = []
    var dailyData: [DailyModel] = []

    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    private lazy var settingsButton = UIBarButtonItem(
        image: UIImage(systemName: "text.justify"),
        style: .plain,
        target: self,
        action: #selector(didTapSettingsButton))

    private lazy var locationButton = UIBarButtonItem(
        image: UIImage(systemName: "location"),
        style: .plain,
        target: self,
        action: #selector(didTapLocationButton))

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(CurrentCell.self, forCellWithReuseIdentifier: CurrentCell.reusedId)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reusedId)
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.reusedId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadData()
        createDataSource()
        //        reloadData()

    }

    private func setupView() {
        view.backgroundColor = .white
        title = "Санкт-Петербург"
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = locationButton

        view.addSubview(collectionView)
    }

    private func loadData() {
        // Moscow   lat: "55.7558", lon: "37.6176"

        NetworkManager.share.fetchWeather(lat: "59.9342802", lon: "30.3350986") { [weak self] weather in
            guard let self = self else { return }

            self.currentData = self.prepareCurrentData(weather)
            self.hourlyData = self.prepareHourlyData(weather)
            self.dailyData = self.prepareDailyData(weather)

            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }

    // MARK: - PrepareData
    private func prepareCurrentData(_ current: WeatherModel) -> [CurrentModel] {
        var array: [CurrentModel] = []
        let item = CurrentModel(
            time: current.current.time,
            temperature: current.current.temperature,
            windspeed: current.current.windspeed,
            weathercode: current.current.weathercode)
        array.append(item)
        return array
    }

    private func prepareHourlyData(_ hourly: WeatherModel) -> [HourlyModel] {
        var array: [HourlyModel] = []
        for i in 0...hourly.daily.time.count - 1 {
            let item = HourlyModel(
                time: hourly.hourly.time[i],
                temperature: hourly.hourly.temperature[i],
                weathercode: hourly.hourly.weathercode[i])

            array.append(item)
        }
        return array
    }

    private func prepareDailyData(_ daily: WeatherModel) -> [DailyModel] {
        var array: [DailyModel] = []
        for i in 0...daily.daily.time.count - 1 {
            let item = DailyModel(
                time: daily.daily.time[i],
                temperatureMin: daily.daily.temperatureMin[i],
                temperatureMax: daily.daily.temperatureMax[i],
                weathercode: daily.daily.weathercode[i])
            array.append(item)
        }
        return array
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind.")
            }

            switch section {
            case .current:
                return self.createCurrentWeather()
            case .hourly:
                return self.createHourlyWeather()
            case .daily:
                return self.createDailyWeather()
            }
        }
        return layout
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.current, .hourly, .daily])
        snapshot.appendItems(currentData, toSection: .current)
        snapshot.appendItems(hourlyData, toSection: .hourly)
        snapshot.appendItems(dailyData, toSection: .daily)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    @objc
    private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc
    private func didTapLocationButton() {
        let vc = OnboardingViewController()
        //        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Datasource
extension HomeViewController {

    private func configure<T: SelfConfiguringCell>(
        cellType: T.Type,
        with value: CurrentModel,
        for indexPath: IndexPath
    ) -> T {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellType.reusedId,
                for: indexPath) as? T
        else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: value)
        return cell
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind.")
                }

                switch section {
                case .current:
                    return self.configure(cellType: CurrentCell.self, with: model as! CurrentModel, for: indexPath)
                case .hourly:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reusedId, for: indexPath) as? HourlyCell
                    cell?.configureCell(with: model as! HourlyModel)
                    return cell
                case .daily:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.reusedId, for: indexPath) as? DailyCell
                    cell?.configureCell(with: model as! DailyModel)
                    return cell
                }
            })

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath)
                    as? SectionHeader
            else { return nil }

            //            guard let itemCount = self.dataSource?.snapshot().numberOfItems(inSection: .now) else {
            //                return nil
            //            }

            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension HomeViewController {
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return layoutSectionHeader
    }

    private func createCurrentWeather() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200))

        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 12, bottom: 0, trailing: 12)

        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]

        return layoutSection
    }

    private func createHourlyWeather() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .estimated(60))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 20, bottom: 20, trailing: 20)

        return layoutSection
    }

    private func createDailyWeather() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 20, bottom: 0, trailing: 20)
        return section
    }
}
