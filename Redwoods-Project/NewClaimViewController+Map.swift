//
//  NewClaimViewController+Map.swift
//  Redwoods Project
//
//  Created by Kevin Poorman on 11/29/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import UIKit
import MapKit

extension NewClaimViewController {

	func initMapViewExtension() {
		//CoreLocation setup
		locationManager.desiredAccuracy = kCLLocationAccuracyBest

		if checkLocationAuthorizationStatus() == true, let userLocation = locationManager.location {
			centerMap(on: userLocation)
		}

		//mapView setup
		mapView.delegate = self
		mapView.mapType = .standard
		mapView.isZoomEnabled = true
		mapView.isScrollEnabled = true
		
		mapView.clipsToBounds = true
		mapView.layer.cornerRadius = 6
	}

	func geocode(_ location: CLLocation) {
        // Only one reverse geocoding can be in progress at a time, hence we need
        // to cancel any existing ones if we are getting location updates.
		geoCoder.cancelGeocode()
		geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
			//This next line is useless, but included so the app will compile out of the box. You must refactor this line.
			let address = ""
			//these two lines are provided for you
			self.addressLabel.text = address
			self.geoCodedAddressText = address
		}
	}

    private func centerMap(on location: CLLocation) {
			let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
			mapView.setRegion(coordinateRegion, animated: true)
		geocode(location)
    }

    func checkLocationAuthorizationStatus() -> Bool? {
			if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
				locationManager.startUpdatingLocation()
				return true
			} else {
				locationManager.requestWhenInUseAuthorization()
				return nil
			}
    }
}

extension NewClaimViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
		geocode(location)
	}
}
