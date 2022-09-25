//
//  CurrentViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 15.09.2022.
//

import CoreLocation
import UIKit

class CurrentViewController: UIViewController {

    var locationManager = CLLocationManager()
    var location: CLLocation?

    let currentLocation: CurrentLocation

    enum Section: Int, CaseIterable {
        case current
        case hourly
        case daily

        func description() -> String {
            switch self {
            case .current: return "Сейчас"
            case .hourly: return "Прогноз на 7 часов"
            case .daily: return "Ежедневный прогноз"
            }
        }
    }

    var currentData: [CurrentModel] = []
    var hourlyData: [HourlyModel] = []
    var dailyData: [DailyModel] = []

    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        collectionView.register(CurrentCell.self, forCellWithReuseIdentifier: CurrentCell.reusedId)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reusedId)
        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.reusedId)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(currentLocation: CurrentLocation) {
        self.currentLocation = currentLocation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(location: currentLocation.location)
        setupView()
        createDataSource()
        //        reloadData()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - LoadData
    func loadData(location: CLLocation) {
        NetworkManager.share.fetchWeather(location: location) { [weak self] weather in
            guard let self = self else { return }

            self.currentData = self.prepareCurrentData(weather)
            self.hourlyData = self.prepareHourlyData(weather)
            self.dailyData = self.prepareDailyData(weather)

            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }

    private func getGeocoding(location: CLLocation) {
        GeocodingManager.shared.fetchGeolocation(location: location) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.title = result
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
                return self.createCurrentLayoutSection()
            case .hourly:
                return self.createHourlyLayoutSection()
            case .daily:
                return self.createDailyLayoutSection()
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
}

// MARK: - Datasource
extension CurrentViewController {

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind.")
                }

                switch section {
                case .current:
                    return self.configure(collectionView: collectionView, cellType: CurrentCell.self, with: model, for: indexPath)
                case .hourly:
                    return self.configure(collectionView: collectionView, cellType: HourlyCell.self, with: model, for: indexPath)
                case .daily:
                    return self.configure(collectionView: collectionView, cellType: DailyCell.self, with: model, for: indexPath)
                }
            })

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath)
                    as? SectionHeader
            else { return nil }

            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }

            sectionHeader.configure(title: section.description(), section.rawValue)
            sectionHeader.didTapButtonCallback = { [unowned self] in
                if section.rawValue == 1 {
                    let vc = HourlyDetailViewController()
                    navigationController?.pushViewController(vc, animated: true)
                } else if section.rawValue == 2 {
                    // 7 или 25 суток
                }
            }
            return sectionHeader
        }
    }
}

// MARK: - Setup layout
extension CurrentViewController {
    private func createHeaderLayoutSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))

        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return layoutSectionHeader
    }

    private func createCurrentLayoutSection() -> NSCollectionLayoutSection {
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

        return layoutSection
    }

    private func createHourlyLayoutSection() -> NSCollectionLayoutSection {
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
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 20, bottom: 20, trailing: 20)

        let header = createHeaderLayoutSection()
        layoutSection.boundarySupplementaryItems = [header]

        return layoutSection
    }

    private func createDailyLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20)

        let header = createHeaderLayoutSection()
        section.boundarySupplementaryItems = [header]

        return section
    }
}

// MARK: - UICollectionViewDelegate
extension CurrentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.dataSource?.itemIdentifier(for: indexPath) as? DailyModel else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .daily:
            let vc = DayForecastViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
        default: return
        }
    }
}

// MARK: - Location
extension CurrentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        getGeocoding(location: location)
        loadData(location: location)
    }
}
