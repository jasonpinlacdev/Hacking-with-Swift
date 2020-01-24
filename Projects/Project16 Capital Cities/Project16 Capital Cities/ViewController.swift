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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let info = capital.info
        
        let ac = UIAlertController(title: placeName, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
}

