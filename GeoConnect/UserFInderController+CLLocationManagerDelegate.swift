//
//  UserFInderController+CLLocationManagerDelegate.swift
//  GeoConnect
//
//  Created by David on 09/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

extension UserFinderController: CLLocationManagerDelegate {
    
    func determineUserLocation() {
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            let alertController = UIAlertController(title: "Location Services Disabled/Restricted", message: "Please enable location services in settings ... ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            return
        }
        
    }
    
    func getLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 15
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("Users Location Services are Disables on the Device")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            getLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0] as CLLocation
        
        let latestLattitude = userLocation.coordinate.latitude
        let latestLongitude = userLocation.coordinate.longitude
        
        print("user latitude: \(userLocation.coordinate.latitude)")
        print("user longitude: \(userLocation.coordinate.longitude)")
        
        if firstLoad {
            saveUsersLastLocation(latitude: latestLattitude, longitude: latestLongitude)
            firstLoad = false
        } else {
            checkIfLocationIsNew(newLatitude: latestLattitude, newLongitude: latestLongitude)
        }
    }
    
    private func checkIfLocationIsNew(newLatitude: CLLocationDegrees, newLongitude: CLLocationDegrees) {
        

        guard let lastStoredLat = UserDefaults.standard.value(forKey: UserDefaultsKey.latestLatitude) as? Double, let lastStoredLong = UserDefaults.standard.value(forKey: UserDefaultsKey.latestLongitude) as? Double else { return }
        
        let lastCoordinate = CLLocation(latitude: lastStoredLat, longitude: lastStoredLong)
        let newCoordinate = CLLocation(latitude: newLatitude, longitude: newLongitude)
        
        print("Database Coordinates: ")
        print("\(lastCoordinate.coordinate.latitude)")
        print("\(lastCoordinate.coordinate.longitude)")
        
        print("New Coordinates: ")
        print("\(newCoordinate.coordinate.latitude)")
        print("\(newCoordinate.coordinate.longitude)")
        
        let distanceInMetres = lastCoordinate.distance(from: newCoordinate)
        
        if distanceInMetres > 15 {
            // not the same
            saveUsersLastLocation(latitude: newLatitude, longitude: newLongitude)
        } else {
            //same so dont refetch data
        }
        
    }
    
    private func saveUsersLastLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        guard let userId = user?.id else { return }
        
        let ref = Database.database().reference()
        let locRef = ref.child("userLocation").child(userId)
        
        let values = ["latitude" : "\(latitude)", "longitude": "\(longitude)"]
        
        locRef.setValue(values) { (error, ref) in
            if let error = error {
                print("Error saving latest coordinates: \(error)")
                return
            }
            
            print("Sucess saving user location in DB")
            self.saveValuesInternally(latitude: latitude, longitude: longitude)
            
        }
    }
    
    private func saveValuesInternally(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let latAsDouble = Double(latitude)
        let longAsDouble = Double(longitude)
        
        UserDefaults.standard.set(latAsDouble, forKey: UserDefaultsKey.latestLatitude)
        UserDefaults.standard.set(longAsDouble, forKey: UserDefaultsKey.latestLongitude)
    }
    
}
