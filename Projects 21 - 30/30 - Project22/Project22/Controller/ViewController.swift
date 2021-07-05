//
//  ViewController.swift
//  Project22
//
//  Created by Гнатюк Сергей on 27.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // UI
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circleView: UIView!
    
    // Properties
    let uuidStringIdentifier = "5A4BCFCE-174E-4BAC-A814-092E77F687E5"
    let beaconIdentifier = "MyBeacon"
    var isFirstBeaconDetected = false
    
    // Dependencies
    var locationManager: CLLocationManager?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .white
        circleView.backgroundColor = .cyan
        circleView.layer.cornerRadius = 128
        
    }
}

