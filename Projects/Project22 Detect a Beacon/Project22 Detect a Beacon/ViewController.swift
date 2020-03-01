//
//  ViewController.swift
//  Project22 Detect a Beacon
//
//  Created by Jason Pinlac on 2/29/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReadingLabel: UILabel!
    @IBOutlet var monitoringLabel: UILabel!
    @IBOutlet var detectingRangeLabel: UILabel!
    @IBOutlet var beaconNameLabel: UILabel!
    @IBOutlet var graphicDistanceFromBeacon: UIView!
    
    var locationManager: CLLocationManager?
    var alreadyDetected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        view.backgroundColor = .gray
        graphicDistanceFromBeacon.layer.cornerRadius = 128
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                monitoringLabel.text = "Monitoring: on"
                monitoringLabel.textColor = UIColor.systemGreen
                if CLLocationManager.isRangingAvailable() {
                    detectingRangeLabel.text = "Detecting Range: on"
                    detectingRangeLabel.textColor = UIColor.systemGreen
                    // monitoring ok and ranging ok lets start scanning for beacons
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning() { // setup which beacons you want to monitor and range on
        let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion1 = CLBeaconRegion(uuid: uuid1, major: 1, minor: 2, identifier: "1")
        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion2 = CLBeaconRegion(uuid: uuid2, major: 3, minor: 4, identifier: "2")
        let uuid3 = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!
        let beaconRegion3 = CLBeaconRegion(uuid: uuid3, major: 5, minor: 6, identifier: "3")
        
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startRangingBeacons(satisfying: beaconRegion1.beaconIdentityConstraint)
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(satisfying: beaconRegion2.beaconIdentityConstraint)
        locationManager?.startMonitoring(for: beaconRegion3)
        locationManager?.startRangingBeacons(satisfying: beaconRegion3.beaconIdentityConstraint)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(beaconUUID: beacon.uuid.uuidString, distance: beacon.proximity)
            if !alreadyDetected {
                showDetectionAlert()
            }
        } else {
            update(beaconUUID: "N/A", distance: .unknown)
        }
    }
    
    
    func update(beaconUUID: String ,distance: CLProximity) {
        UIView.animate(withDuration: 1) { [weak self] in
            switch distance {
            case CLProximity.unknown:
                self?.view.backgroundColor = .gray
                self?.distanceReadingLabel.text = "UNKNOWN"
                self?.graphicDistanceFromBeacon.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case CLProximity.immediate:
                self?.view.backgroundColor = .red
                self?.distanceReadingLabel.text = "IMMEDIATE"
                self?.graphicDistanceFromBeacon.transform = CGAffineTransform(scaleX: 1, y: 1)
            case CLProximity.near:
                self?.view.backgroundColor = .orange
                self?.distanceReadingLabel.text = "NEAR"
                self?.graphicDistanceFromBeacon.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            case CLProximity.far:
                self?.view.backgroundColor = .blue
                self?.distanceReadingLabel.text = "FAR"
                self?.graphicDistanceFromBeacon.transform = CGAffineTransform(scaleX: 0.5, y: 0.2)
            default:
                break
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.beaconNameLabel.text = "Beacon: \(beaconUUID)"
        }
        
    }
    
    
    func showDetectionAlert() {
        alreadyDetected = true
        let ac = UIAlertController(title: "Beacon Detected", message: "Your device has detected a beacon.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
        
    }
}

