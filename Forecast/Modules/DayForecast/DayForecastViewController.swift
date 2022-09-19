//
//  DayForecastViewController.swift
//  Forecast
//
//  Created by Dima Skvortsov on 19.09.2022.
//

import UIKit

class DayForecastViewController: UIViewController {
    
    let model: DailyModel
    
    init(model: DailyModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        title = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.time)))
    }
}
