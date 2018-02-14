//
//  ViewController.swift
//  Geofencing
//
//  Created by Aakash on 13/02/18.
//  Copyright © 2018 Aakash. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications  // To get notification

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()  //User Location
    
    
    override func viewDidLoad() {
        super.viewDidLoad()  //Called after the controller's view is loaded into memory.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // best accuracy
       // locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()  //updating user location
        }

    @IBAction func addRegion(_ sender: Any) {
        print("ADD REGION")
        guard let longPress = sender as? UILongPressGestureRecognizer  //LongPressGesture in Mapview
        else {
            return
        }
        let touchLocation = longPress.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView) // we convert touchlocation into coordinate
        let region = CLCircularRegion(center: coordinate, radius: 300, identifier: "GeoFenc")
        mapView.removeOverlays((mapView.overlays)) // in this we are removing several regions before creating one
        locationManager.startMonitoring(for: region)  // this will start monitoring
        let circle = MKCircle(center: coordinate, radius: region.radius)  // now we are creating the circle in our mapview
        mapView.add(circle) // this is how we add the circle in our mapview
    }
    
    func showAlert(title : String, message:String) {   // We created an ALERT function
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // this is use to make a pop up notification
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action) // passing our action
        present(alert, animated: true, completion: nil)
    }
    
    func showNotification(title: String, message: String){    // for notification
        let content = UNMutableNotificationContent() // editable content
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "notify" , content : content, trigger: nil)// trigger itself)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) //Trigger the notification
    }
}

extension ViewController : CLLocationManagerDelegate {  //// The methods that you use to receive events from an associated location manager object.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation() //this will stop updating your location to save battery of the user
        mapView.showsUserLocation = true // Once it stop updating the user location, this will show the best user location
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "You entered the region"  // should work in background
        let message = "You're near to the location"
        showAlert(title: title, message: message)  //Pop-up message when you enter the region
        showNotification(title: title, message: message) // call the notification
        
}
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the region" //should work in background
        let message = "Bye Bye"
        showAlert(title: title, message: message)  // Pop -up message when you exit the region
        showNotification(title: title, message: message) // call the notification
    }
    

    }


extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer { //drawing circle on the screen MKCIRCLE
        guard let circleOverlay = overlay as? MKCircle
            else {
             return MKOverlayRenderer()
        }
        let circleRender = MKCircleRenderer(circle: circleOverlay) //draw
        circleRender.strokeColor = .red //color red circle
        circleRender.fillColor = .red
        circleRender.alpha = 0.5
        return circleRender
    }
}
