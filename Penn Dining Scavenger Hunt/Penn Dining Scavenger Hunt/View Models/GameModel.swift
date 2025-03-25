//
//  GameModel.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/24/25.
//
import Foundation
import SwiftUI
import CoreLocation
import CoreMotion
import MapKit
import Observation

@Observable
class GameModel : NSObject, CLLocationManagerDelegate {
    var state = GameState.notRunning
    
    var score  = 0
    var collected = Set<String>() // set of ids where each id is a string
    var isRequestingLocation = false
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    
    var currentLocation: CLLocation?
    var currentDiningHall: DiningHall?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func beginGame() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1 / 50
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                if let self {
                    if let motion {
                        handleMotion(motion)
                    } else if let error {
                        print("Failed to receive motion update: \(error)")
                        state = .error
                        motionManager.stopDeviceMotionUpdates()
                    }
                }
            }
        }
    }
    
    func collect(diningHall: DiningHall) {
        requestLocation()
        if collected.contains(diningHall.id) { return }
        if let location = currentLocation {
            if location.distance(from: CLLocation(latitude: diningHall.lat, longitude: diningHall.lon)) < 50 {
                if let index = DiningHall.diningHalls.firstIndex(where: { $0.id == diningHall.id }) {
                    DiningHall.diningHalls[index].collected = true
                    collected.insert(diningHall.id)
                }
            }
        } else {
            state = GameState.error
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            state = GameState.error
        default:
            break
        }
    }
    
    func requestLocation() {
        if !isRequestingLocation {
            isRequestingLocation = true
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        isRequestingLocation = false
    }
        
    func handleMotion(_ motion: CMDeviceMotion) {
        switch state {
        case .collect:
            let xRot = motion.rotationRate.x
            let yRot = motion.rotationRate.y
            let zRot = motion.rotationRate.z
            
            let rotRate = sqrt(xRot * xRot + yRot * yRot + zRot * zRot)
            
            if rotRate > 20 {
                if let diningHall = currentDiningHall {
                    collect(diningHall: diningHall)
                } else {
                    // do nothing
                    return
                }
            }
            
        default:
            // Do nothing
            break
        }
    }
    /*
     let request = MKLocalPointsOfInterestRequest(center: location.coordinate, radius: 2000)
     request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant, .foodMarket, .bakery, .cafe])
     
     let search = MKLocalSearch(request: request)
     fetchPlaces(search: search)
     */
    
        
    func isCollected(dhall: DiningHall) -> Bool {
        return collected.contains(dhall.id)
    }
    
    func collect(dhall: DiningHall) {
        collected.insert(dhall.id)
    }
    
    var uncollectedHalls: [DiningHall] {
        DiningHall.diningHalls.filter { !isCollected(dhall: $0)}
    }
    
    var collectedHalls: [DiningHall] {
        DiningHall.diningHalls.filter { isCollected(dhall: $0) }
    }
    
        
}
