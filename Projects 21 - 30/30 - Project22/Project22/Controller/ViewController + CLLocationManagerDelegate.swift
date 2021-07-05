//
//  ViewController + CLLocationManagerDelegate.swift
//  Project22
//
//  Created by Гнатюк Сергей on 27.05.2021.
//

import UIKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !isFirstBeaconDetected {
                isFirstBeaconDetected = true
                showFirstBeaconDetectAlert()
            }
            print("Becon detected: \(beacon.proximityUUID.uuidString) -\(region.identifier)")
            update(distance: beacon.proximity)
        }
    }
    
    private  func startScanning() {
        let uuid = UUID(uuidString: uuidStringIdentifier)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: beaconIdentifier)
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    private func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .immediate:
                self.circleView.backgroundColor = UIColor.red
                self.circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.distanceReading.text = "RIGHT HERE"
            case .near:
                self.circleView.backgroundColor = UIColor.orange
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.distanceReading.text = "NEAR"
            case .far:
                self.circleView.backgroundColor = UIColor.blue
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.distanceReading.text = "FAR"
            default:
                self.circleView.backgroundColor = UIColor.gray
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    
    func showFirstBeaconDetectAlert() {
        let ac = UIAlertController(title: "Alert", message: "Beacon detected!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

