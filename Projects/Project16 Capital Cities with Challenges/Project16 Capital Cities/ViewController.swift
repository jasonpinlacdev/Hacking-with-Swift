//
//  ViewController.swift
//  Project16 Capital Cities
//
//  Created by Jason Pinlac on 1/23/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapTypeButton.layer.borderWidth = 2
        mapTypeButton.layer.borderColor = UIColor.black.cgColor
        mapTypeButton.layer.cornerRadius = 5
        mapTypeButton.clipsToBounds = true
        mapTypeButton.setTitle("standard", for: .normal)
        
        let london = Capital(title: "London", info: "Home to the 2012 Summer Olympics", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
        
        let oslo = Capital(title: "Oslo", info: "It was founded over a thousand years ago" , coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75))
        
        let paris = Capital(title: "Paris", info: "Often called the city of light", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508))
        
        let rome = Capital(title: "Rome", info: "Has a whole country inside of it", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5))
        
        let washington = Capital(title: "Washington DC", info: "Named after George himself", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667))
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .systemPurple
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
            annotationView?.pinTintColor = .systemPurple
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        
        let vc = DetailViewController()
        vc.selectedCapital = placeName
        present(vc, animated: true)
    }
    
    @IBAction func mapTitleTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Select a map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "standard", style: .default, handler: mapTypeTapped))
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: mapTypeTapped))
        ac.addAction(UIAlertAction(title: "hybridFlyover", style: .default, handler: mapTypeTapped))
        ac.addAction(UIAlertAction(title: "satellite", style: .default, handler: mapTypeTapped))
        ac.addAction(UIAlertAction(title: "satelliteFlyover", style: .default, handler: mapTypeTapped))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func mapTypeTapped(action: UIAlertAction) {
        guard let mapTypeTitle = action.title else { return }
        var mapTypeValue = UInt(0)
        
        switch mapTypeTitle {
        case "satellite":
            mapTypeValue = UInt(1)
            mapTypeButton.setTitle("satellite", for: .normal)
        case "hybrid":
            mapTypeValue = UInt(2)
            mapTypeButton.setTitle("hybrid", for: .normal)
        case "satelliteFlyover":
            mapTypeValue = UInt(3)
            mapTypeButton.setTitle("satelliteFlyover", for: .normal)
        case "hybridFlyover":
            mapTypeValue = UInt(4)
            mapTypeButton.setTitle("hybridFlyover", for: .normal)
        default:
            mapTypeValue = UInt(0)
            mapTypeButton.setTitle("standard", for: .normal)
        }
        
        if let mapType = MKMapType(rawValue: mapTypeValue) {
            mapView.mapType = mapType
        }
        
    }
    
}

