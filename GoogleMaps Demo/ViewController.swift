//
//  ViewController.swift
//  GoogleMaps Demo
//
//  Created by Michael Gerasimov on 9/2/16.
//  Copyright © 2016 Michael Gerasimov. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit


class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    
    let sydneyCoordinates = CLLocationCoordinate2DMake(-33.86, 151.20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let marker = GMSMarker()
        marker.position = sydneyCoordinates
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = googleMapView
        
        let pin = CustomAnnotation()
        pin.coordinate = sydneyCoordinates
        pin.title = "Sydney"
        pin.subtitle = "Australia"
        
        appleMapView.addAnnotation(pin)
        // To specify span we can use MKCoordinateRegionMakeWithDistance, providing data in meters
        appleMapView.region = MKCoordinateRegionMake(sydneyCoordinates, MKCoordinateSpanMake(10, 10))
        
        view.addSubview(googleMapView)
        view.addSubview(appleMapView)
        view.addSubview(searchLocationAppleTextField)
        view.addSubview(searchLocationGoogleTextField)
        
        configureConstraints()
    }
    
    func configureConstraints()
    {
        searchLocationAppleTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true
        searchLocationAppleTextField.leftAnchor.constraintEqualToAnchor(view.centerXAnchor, constant:50 ).active = true
        searchLocationAppleTextField.widthAnchor.constraintEqualToConstant(200).active = true
        
        searchLocationGoogleTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50).active = true
        searchLocationGoogleTextField.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 50).active = true
        searchLocationGoogleTextField.widthAnchor.constraintEqualToConstant(200).active = true
        
        appleMapView.leftAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        appleMapView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        appleMapView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        appleMapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        googleMapView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        googleMapView.rightAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        googleMapView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        googleMapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }
    
    let googleMapView:GMSMapView = {
        GMSServices.provideAPIKey("AIzaSyCEA1lfK8eDwtbTjW22MDDMe3e-0-itjKc")
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,longitude: 151.20, zoom: 6)
        let map = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        map.mapType = kGMSTypeHybrid
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var appleMapView:MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .Hybrid
        map.showsUserLocation = true
        map.rotateEnabled = true
        map.delegate = self
        return map
    }()
    
    lazy var searchLocationAppleTextField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "apple maps"
        searchField.textAlignment = .Natural
        searchField.delegate = self
        searchField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        searchField.borderStyle = .RoundedRect
        return searchField
    }()
    
    lazy var searchLocationGoogleTextField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "google maps"
        searchField.textAlignment = .Natural
        searchField.delegate = self
        searchField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        searchField.borderStyle = .RoundedRect
        return searchField
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""
        {
            performSearchOfLocationWithQuery(textField.text!)
        }
        return true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        
        print("configureView")
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as? CustomAnnotationView
        
        if annotationView == nil{
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier:"CustomAnnotation")
            annotationView?.addObserver(self, forKeyPath: "annotation", options: .New, context: nil)
        }
        return annotationView
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "annotation"{
         print("Changed Location")
            if let view = object as? CustomAnnotationView
            {
                view.frame = CGRectMake(ASC.center.x, ASC.height, 0, 0)
                UIView.animateWithDuration(1, delay: 0, options: .CurveLinear, animations: {
                    view.frame = CGRectMake(0, 0, ASC.width, ASC.height)
                    }, completion: nil)
                print("Sender location is \(view.annotation?.coordinate)")
            }
        }
    }
    
    
    func performSearchOfLocationWithQuery(query:String)
    {
      let request = MKLocalSearchRequest()
      request.naturalLanguageQuery = query
        
      MKLocalSearch(request: request).startWithCompletionHandler { [unowned self] (response, error) in
        if error != nil {
            print("Can't find location, reason: \(error?.description)")
            return
        }
        
        if response != nil {
            
            self.appleMapView.removeAnnotations(self.appleMapView.annotations)
            
            var annotations = [MKAnnotation]()
            
            for item in response!.mapItems
            {
                annotations.append(item.placemark)
            }
            
            if annotations.count == 1{
                self.appleMapView.addAnnotations(annotations)
                self.appleMapView.region = MKCoordinateRegionMake(annotations.first!.coordinate, MKCoordinateSpanMake(0.5, 0.5))
            }else {
                self.appleMapView.showAnnotations(annotations, animated: true)
            }
        }
      }
    
    }
}


