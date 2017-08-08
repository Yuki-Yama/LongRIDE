//
//  ViewController.swift
//  LongRIDE
//
//  Created by Yuki on 2017/08/04.
//  Copyright © 2017年 Yuki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var curAddressField: UITextField!
    @IBOutlet weak var desAddressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var curLatitude : Double = 0.0
    var curLongitude : Double = 0.0
    var desLatitude : Double = 0.0
    var desLongitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.
        mapView.delegate = self
        
    }
    
    func convertCurAddress(curAddress: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(curAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let locationA = placemarks.first?.location
                else {
                    print("No location found")
                    return
            }
            
            print("curLatitude =  \(locationA.coordinate.latitude)")
            print("curLongitude = \(locationA.coordinate.longitude)")
            
            self.curLatitude = locationA.coordinate.latitude
            self.curLongitude = locationA.coordinate.longitude
        }
    }
    
    func convertDesAddress(desAddress: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(desAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let locationB = placemarks.first?.location
                else {
                    print("No LOcation Found")
                    return
            }
            
            print("desLatitude =  \(locationB.coordinate.latitude)")
            print("desLongitude = \(locationB.coordinate.longitude)")
            
            self.desLatitude = locationB.coordinate.latitude
            self.desLongitude = locationB.coordinate.longitude
        }
    }
    
    func setRoute(){
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: curLatitude, longitude: curLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: desLatitude, longitude: desLongitude)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
                // 5.
                let sourceAnnotation = MKPointAnnotation()
        
                if let location = sourcePlacemark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
        
        
                let destinationAnnotation = MKPointAnnotation()
        
                if let location = destinationPlacemark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
        
                // 6.
                self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
    }



    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
//
    
    @IBAction func searchTapped(_ sender: Any) {
        convertCurAddress(curAddress: self.curAddressField.text!)
        convertDesAddress(desAddress: self.desAddressField.text!)
        
 
        
        setRoute()
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
}
