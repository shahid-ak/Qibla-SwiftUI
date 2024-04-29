//
//  QiblaCompassViewModel.swift
//  Qibla
//
//  Created by shahid on 25/03/24.
//

import MapKit
import SwiftUI

enum Mode {
    case ahead, right, left, slightlyRight, slightlyLeft
    
    var directionVerb: String {
        switch self {
        case .ahead:
            return "facing"
        case .right, .left:
            return "to your"
        case .slightlyRight, .slightlyLeft:
            return "slight to"
        }
    }
    
    var directionString: String {
        switch self {
        case .ahead:
            return "Qibla"
        case .right, .slightlyRight:
            return "right"
        case .left, .slightlyLeft:
            return "left"
        }
    }
    
    var isApproxQibla: Bool {
        switch self {
        case .ahead, .slightlyRight, .slightlyLeft:
            return true
        case .right, .left:
            return false
        }
    }
}

class QiblaViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let latOfKabah = 21.4225
    let lngOfKabah = 39.8262
    
    var location: CLLocation?
    var locationManager = CLLocationManager()
    
    var bearingOfKabah = Double()
    
    @Published var currentLocation: String = "Fetching....."
    
    @Published var directionOfKabah = Angle() {
        didSet {
            var theDirectionOfKabah = directionOfKabah.degrees
            while theDirectionOfKabah < 0 {
                theDirectionOfKabah += 360
            }
            directionOfKabahTo360Format = theDirectionOfKabah
            if (directionOfKabahTo360Format > 335 && directionOfKabahTo360Format < 360)  || (directionOfKabahTo360Format >= 0 && directionOfKabahTo360Format < 25) {
                if Int(directionOfKabahTo360Format) == 0 {
                    withAnimation {
                        mode = .ahead
                    }
                #if os(watchOS)
                    //WKInterfaceDevice.current().play(.success)
                #else
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        impactMed.impactOccurred()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        impactMed.impactOccurred()
                    }
                #endif
                } else if directionOfKabahTo360Format < 180{
                    withAnimation {
                        mode = .slightlyRight
                    }
                } else {
                    withAnimation {
                        mode = .slightlyLeft
                    }
                }
            } else {
                if directionOfKabahTo360Format < 180 {
                    withAnimation {
                        mode = .right
                    }
                } else {
                    withAnimation {
                        mode = .left
                    }
                }
            }
        }
    }
    
    @Published var directionOfKabahTo360Format = 0.0
    @Published var mode = Mode.ahead
    
    func checkIfLocationServicesIsEnabled(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    private func checkLocationAuthorization(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your lcaotion is restricted")
        case .denied:
            print("You have denied location permission to the app, change settings")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        bearingOfKabah = getBearingBetweenTwoPoints1(location!, latitudeOfKabah: self.latOfKabah, longitudeOfKabah: self.lngOfKabah)
        if currentLocation == "Fetching....." {
            location?.placemark { [weak self] placemark, error in
                guard let placemark = placemark else {
                    self?.currentLocation = "Unknown..."
                    return
                }
                self?.currentLocation = placemark.neighborhood ?? "Unknown..."
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        let north = -1 * heading.magneticHeading * Double.pi/180
        directionOfKabah = Angle(radians: bearingOfKabah * Double.pi/180 + north)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
    func getBearingBetweenTwoPoints1(_ point1 : CLLocation, latitudeOfKabah : Double , longitudeOfKabah :Double) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(latitudeOfKabah);
        let lon2 = degreesToRadians(longitudeOfKabah);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        var radiansBearing = atan2(y, x);
        if(radiansBearing < 0.0){
            
            radiansBearing += 2 * Double.pi;
            
        }
        
        return radiansToDegrees(radiansBearing)
    }
}
