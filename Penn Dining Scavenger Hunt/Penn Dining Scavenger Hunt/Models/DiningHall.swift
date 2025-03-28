//
//  DiningHall.swift
//  Penn Dining Scavenger Hunt
//
//  Created by user268994 on 3/24/25.
//
import Foundation
import SwiftUI
import CoreLocation

struct DiningHall : Identifiable, Hashable {
    var id: String { name }
    let name: String
    let lon: Double
    let lat: Double
}

extension DiningHall {
    static var diningHalls : [DiningHall] = [
        DiningHall(name: "1920 Commons", lon: CLLocationCoordinate2D.commons.longitude, lat: CLLocationCoordinate2D.commons.latitude),
        DiningHall(name: "Accenture Cafe", lon: CLLocationCoordinate2D.accenture.longitude, lat: CLLocationCoordinate2D.accenture.latitude),
        DiningHall(name: "Falk Kosher Dining", lon: CLLocationCoordinate2D.falk.longitude, lat: CLLocationCoordinate2D.falk.latitude),
        DiningHall(name: "Hill Dining", lon: CLLocationCoordinate2D.hill.longitude, lat: CLLocationCoordinate2D.hill.latitude),
        DiningHall(name: "Houston Market", lon: CLLocationCoordinate2D.houston.longitude, lat: CLLocationCoordinate2D.houston.latitude),
        DiningHall(name: "Kings Court English House", lon: CLLocationCoordinate2D.kceh.longitude, lat: CLLocationCoordinate2D.kceh.latitude),
        DiningHall(name: "Lauder College House", lon: CLLocationCoordinate2D.lauder.longitude, lat: CLLocationCoordinate2D.lauder.latitude),
        DiningHall(name: "McClelland Express", lon: CLLocationCoordinate2D.mcclelland.longitude, lat: CLLocationCoordinate2D.mcclelland.latitude),
        DiningHall(name: "Pret A Manger", lon: CLLocationCoordinate2D.pret.longitude, lat: CLLocationCoordinate2D.pret.latitude),
        DiningHall(name: "Quaker Kitchen", lon: CLLocationCoordinate2D.quaker.longitude, lat: CLLocationCoordinate2D.quaker.latitude)
    ]
}
