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
    
    func withinRange(diningHall: DiningHall) -> Bool {
        guard let location = currentLocation else {
            state = .error
            return false
        }
        if location.distance(from: CLLocation(latitude: diningHall.lat, longitude: diningHall.lon)) < 50 {
            return true
        } else {
            return false
        }
    }
    
    func collect(diningHall: DiningHall) {
        guard let location = currentLocation else {
            state = .error
            return
        }
        
        if collected.contains(diningHall.id) || state != .collect { return }
        
        if withinRange(diningHall: diningHall){
            collected.insert(diningHall.id)
            state = .running
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
            let xAccel = motion.userAcceleration.x
            let yAccel = motion.userAcceleration.y
            let zAccel = motion.userAcceleration.z
            
            let acceleration = sqrt(xAccel * xAccel + yAccel * yAccel + zAccel * zAccel)
                    
            let shakeThreshold = 1.5 // Experiment with different values (1.5–3.0 works well)

            if acceleration > shakeThreshold {
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
        
    func isCollected(dhall: DiningHall) -> Bool {
        return collected.contains(dhall.id)
    }
    
    var uncollectedHalls: [DiningHall] {
        DiningHall.diningHalls.filter { !isCollected(dhall: $0)}
    }
    
    var collectedHalls: [DiningHall] {
        DiningHall.diningHalls.filter { isCollected(dhall: $0) }
    }
    
        
}
