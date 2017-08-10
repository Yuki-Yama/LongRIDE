//
//  ConditionViewController.swift
//  LongRIDE
//
//  Created by Yuki on 2017/08/07.
//  Copyright © 2017年 Yuki. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire

class ElevationViewController : UIViewController{
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            self.getElevation(latitude: Double((locationManager.location?.coordinate.latitude)!), longitude:  Double((locationManager.location?.coordinate.longitude)!))
        }
    }
    
    func getElevation(latitude : Double, longitude : Double) {
        let ElevationURL = "https://maps.googleapis.com/maps/api/elevation/json?locations=\(latitude),\(longitude)&key=AIzaSyBID9g_vQdN94eriteL_6Gjy62cBhDWhrk"
        Alamofire.request(ElevationURL).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
//        GoogleMaps.request(apiToContact).validate().responseJSON() { response in
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    
//                    // Do what you need to with JSON here!
//                    // The rest is all boiler plate code you'll use for API requests
//                    
//                    
//                }
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
    }
    
    
}

extension ElevationViewController : CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        locationManager.stopUpdatingLocation()
    }
}
