//
//  HomeViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 25.09.2022.
//

import CoreLocation
import UIKit

class HomeViewController: UIPageViewController {

    var currentViewControllers: [CurrentLocation] = []

    let pageControl = UIPageControl()

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

    private lazy var arrayCurrentControllers: [CurrentViewController] = {
        var controllers: [CurrentViewController] = []

        for vc in currentViewControllers {
            controllers.append(CurrentViewController(currentLocation: vc))
        }
        return controllers
    }()

    override init(
        transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let one = CurrentLocation(city: "Москва", location: CLLocation(latitude: 55.751244, longitude: 37.618423))
        let two = CurrentLocation(city: "Санкт-Петербург", location: CLLocation(latitude: 59.937500, longitude: 30.308611))

        currentViewControllers.append(one)
        currentViewControllers.append(two)

        configure()
        setupView()
    }

    private func configure() {
        dataSource = self
        delegate = self

        setViewControllers([arrayCurrentControllers[0]], direction: .forward, animated: true)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = currentViewControllers.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
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

    @objc
    private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([arrayCurrentControllers[sender.currentPage]], direction: .forward, animated: true)
        setupTitle(sender.currentPage)
    }

    private func setupView() {
        setupTitle(0)

        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = locationButton

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }

    private func setupTitle(_ index: Int) {
        navigationItem.title = currentViewControllers[index].city
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? CurrentViewController else { return nil }

        if let index = arrayCurrentControllers.firstIndex(of: vc) {
            if index > 0 {
                return arrayCurrentControllers[index - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? CurrentViewController else { return nil }

        if let index = arrayCurrentControllers.firstIndex(of: vc) {
            if index < currentViewControllers.count - 1 {
                return arrayCurrentControllers[index + 1]
            }
        }
        return nil
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = arrayCurrentControllers.firstIndex(of: viewControllers[0] as! CurrentViewController) else { return }

        setupTitle(currentIndex)
        pageControl.currentPage = currentIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
