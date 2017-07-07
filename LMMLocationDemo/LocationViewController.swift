//
//  ViewController.swift
//  LMMLocationDemo
//
//  Created by liumingming on 2016/12/22.
//  Copyright © 2016年 liumingming. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class LocationViewController: UIViewController, CLLocationManagerDelegate
{

    @IBOutlet weak var mLngText: UITextField!
    
    @IBOutlet weak var mLatText: UITextField!
    
    @IBOutlet weak var mAltText: UITextField!
    
    @IBOutlet weak var mAddressInfoLabel: UILabel!
    
    var mLocationManager: CLLocationManager?
    
    var mCurrentLocation: CLLocation?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        mLocationManager?.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        mLocationManager?.stopUpdatingLocation()
    }
    
    func setupLocationManager()
    {
        mLocationManager = CLLocationManager()
        mLocationManager?.delegate = self
        mLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager?.distanceFilter = 1000.0
        mLocationManager?.requestWhenInUseAuthorization()
        mLocationManager?.requestAlwaysAuthorization()
    }
    
    
    @IBAction func onShowInfoClick(_ sender: Any)
    {
        guard let location = mCurrentLocation else
        {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let marks = placemarks else
            {
                return
            }
            if marks.count > 0
            {
                let placemark = marks[0]
                guard let addressDic = placemark.addressDictionary else
                {
                    return
                }
                let street = addressDic[CNPostalAddressStreetKey]
                print(street)
                print(addressDic)
                var addressString: String = ""
                if let country = placemark.country
                {
                    addressString += country
                    print(country)
                }
                if let administrativeArea = placemark.administrativeArea
                {
                    addressString += administrativeArea
                    print(administrativeArea)
                }
                
                if let subAdministrativeArea = placemark.subAdministrativeArea
                {
                    addressString += subAdministrativeArea
                    print(subAdministrativeArea)
                }

                if let locality = placemark.locality
                {
                    addressString += locality
                    print(locality)
                }
                
                if let subLocality = placemark.subLocality
                {
                    addressString += subLocality
                    print(subLocality)
                }
                
                if let thoroughfare = placemark.thoroughfare
                {
                    addressString += thoroughfare
                    print(addressString)
                }
                if let subThoroughfare = placemark.subThoroughfare
                {
                    addressString += subThoroughfare
                    print(subThoroughfare)
                }
                self?.mAddressInfoLabel.text = addressString
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let currentLocation = locations.last else
        {
            return
        }
        mCurrentLocation = currentLocation
        mLatText.text = String(format: "%3.5f", arguments: [currentLocation.coordinate.latitude])
        mLngText.text = String(format: "%3.5f", arguments: [currentLocation.coordinate.longitude])
        mAltText.text = String(format: "%3.5f", arguments: [currentLocation.altitude])
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .authorizedAlways:
            print("Authorized")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .denied:
            print("Denied")
        case .restricted:
            print("受限")
        case .notDetermined:
            print("用户未确定")
        }
    }
}

