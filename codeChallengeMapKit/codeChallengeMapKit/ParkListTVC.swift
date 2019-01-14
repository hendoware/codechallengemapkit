//
//  ViewController.swift
//  mapKit
//
//  Created by Sean Hendrix on 1/14/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import UIKit
import MapKit

class ParkListTVC: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var parkList: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorizationStatus()
        setupLocationManager()
    }
    
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // do what we want with location
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        locationManager.distanceFilter = 1000
        
        locationManager.startUpdatingLocation()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath)
        let park = parkList[indexPath.row]
        
        
        cell.textLabel?.text = park.name
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        
        searchForParks(aroundLocation: latestLocation)
    }
    
    func searchForParks(aroundLocation location: CLLocation) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Park"
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let error = error {
                print("Error searching: \(error)")
            }
            
            guard let response = response else { return }
            
            var locationList: [MKMapItem] = []
            
            for mapItem in response.mapItems {
                locationList.append(mapItem)
            }
            
            let first5 = Array(locationList.prefix(5))
            
            self.parkList = first5
            self.tableView.reloadData()
            
            print(self.parkList)
        }
        
    }
}
