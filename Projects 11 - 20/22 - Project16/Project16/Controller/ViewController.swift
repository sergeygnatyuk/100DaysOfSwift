//
//  ViewController.swift
//  Project16
//
//  Created by Гнатюк Сергей on 12.05.2021.
//

import UIKit
import MapKit
import Contacts

class ViewController: UIViewController, MKMapViewDelegate {
    
    // UI
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let london = Capital(title: "London",
                             coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                             info: "Home to the 2012 Summer Olympics",
                             wikipediaUrl: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo",
                           coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
                           info: "Founded over a thousand years ago",
                           wikipediaUrl: "https://ru.wikipedia.org/wiki/%D0%9E%D1%81%D0%BB%D0%BE")
        let paris = Capital(title: "Paris",
                            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
                            info: "Often called the City of Light",
                            wikipediaUrl: "https://ru.wikipedia.org/wiki/%D0%9F%D0%B0%D1%80%D0%B8%D0%B6")
        let rome = Capital(title: "Rome",
                           coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
                           info: "Has a whole country inside it",
                           wikipediaUrl: "https://ru.wikipedia.org/wiki/%D0%A0%D0%B8%D0%BC")
        let washington = Capital(title: "Washington",
                                 coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
                                 info: "Named after George himself",
                                 wikipediaUrl:"https://ru.wikipedia.org/wiki/%D0%92%D0%B0%D1%88%D0%B8%D0%BD%D0%B3%D1%82%D0%BE%D0%BD")
        let coords = CLLocationCoordinate2DMake(51.5083, -0.1384)
        let address = [CNPostalAddressStreetKey: "181 Piccadilly, St. James's", CNPostalAddressCityKey: "London", CNPostalAddressPostalCodeKey: "W1A 1ER", CNPostalAddressISOCountryCodeKey: "GB"]
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
        mapView.addAnnotations([london, oslo, paris, rome, washington, place])
        // project 16 challenge 2
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Style", style: .plain, target: self, action: #selector(editMap))
    }
    
    // MARK: - MapView
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let identifier = "Capital"
        // project 16 challenge 1
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        // project 16 challenge 1
        annotationView?.pinTintColor = .cyan
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        let alertController = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        // // project 16 challenge 3
        alertController.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { [weak self] _ in
            self?.openWikipediaWebsite(url: capital.wikipediaUrl)
        }))
        present(alertController, animated: true)
    }
    
    //MARK: - Private
    // // project 16 challenge 3
    private func openWikipediaWebsite(url: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.website = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - @objc methods
    // // project 16 challenge 2
    @objc private func editMap() {
        let alertController = UIAlertController(title: "Edit Map Style", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Standard", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Muted Standard", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Satellite", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: editMapStyle))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }
    // project 16 challenge 2
    @objc private func editMapStyle(action: UIAlertAction) {
        switch action.title {
        case "Standard":
            mapView.mapType = .standard
        case "Hybrid":
            mapView.mapType = .hybrid
        case "Hybrid Flyover":
            mapView.mapType = .hybridFlyover
        case "Muted Standard":
            mapView.mapType = .mutedStandard
        case "Satellite":
            mapView.mapType = .satellite
        case "Satellite Flyover":
            mapView.mapType = .satelliteFlyover
        default:
            return
        }
    }
}

