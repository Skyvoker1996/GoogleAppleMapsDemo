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
    
    struct TextFieldIdentifiers {
        static let appleSearchTextField = "apple search"
        static let googleSearchTextField = "google search"
    }
    
    var searchResultVC : SearchResultTableViewController = {
        let mvc = SearchResultTableViewController()
        //mvc.tableView.contentSize = CGSizeMake(100, 200)
        return mvc
    }()
    
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
        NSLayoutConstraint.activateConstraints([
            searchLocationAppleTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50),
            searchLocationAppleTextField.leftAnchor.constraintEqualToAnchor(view.centerXAnchor, constant:50 ),
            searchLocationAppleTextField.widthAnchor.constraintEqualToConstant(200),
            
            searchLocationGoogleTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50),
            searchLocationGoogleTextField.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 50),
            searchLocationGoogleTextField.widthAnchor.constraintEqualToConstant(200),
            
            appleMapView.leftAnchor.constraintEqualToAnchor(view.centerXAnchor),
            appleMapView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            appleMapView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            appleMapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            
            googleMapView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            googleMapView.rightAnchor.constraintEqualToAnchor(view.centerXAnchor),
            googleMapView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            googleMapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)])
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
        searchField.accessibilityIdentifier = TextFieldIdentifiers.appleSearchTextField
        searchField.placeholder = "apple maps"
        searchField.textAlignment = .Natural
        searchField.delegate = self
        searchField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        searchField.borderStyle = .RoundedRect
        return searchField
    }()
    
    lazy var searchLocationGoogleTextField: UITextField = {
        let searchField = UITextField()
        searchField.accessibilityIdentifier = TextFieldIdentifiers.googleSearchTextField
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.accessibilityIdentifier == TextFieldIdentifiers.googleSearchTextField
        {
            let halfHeight = searchLocationGoogleTextField.frame.size.height / 2
            let center = searchLocationGoogleTextField.center
            
            let containerView = UIView(frame:CGRectMake(center.x,center.y + halfHeight,0,0))
            containerView.backgroundColor = UIColor.whiteColor()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            containerView.layer.cornerRadius = 10
            containerView.clipsToBounds = true
            
            NSLayoutConstraint.activateConstraints([
                containerView.topAnchor.constraintEqualToAnchor(searchLocationGoogleTextField.bottomAnchor),
                containerView.leftAnchor.constraintEqualToAnchor(searchLocationGoogleTextField.leftAnchor),
                containerView.widthAnchor.constraintEqualToAnchor(searchLocationGoogleTextField.widthAnchor)])
            
            addChildViewController(searchResultVC)
            
            containerView.addSubview(searchResultVC.view)

            NSLayoutConstraint.activateConstraints([
                searchResultVC.tableView.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor),
                searchResultVC.tableView.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor),
                searchResultVC.tableView.topAnchor.constraintEqualToAnchor(containerView.topAnchor),
                searchResultVC.tableView.heightAnchor.constraintEqualToConstant(searchResultVC.tableView.contentSize.height),
                containerView.heightAnchor.constraintEqualToAnchor(searchResultVC.tableView.heightAnchor)
                ])
            
            UIView.animateWithDuration(0.3, animations: {
                containerView.setNeedsUpdateConstraints()
                containerView.setNeedsLayout()
                containerView.layoutIfNeeded()
            })
            
            searchResultVC.didMoveToParentViewController(self)
            
            print("Started editing")
        }
    }
    
    func textField(textField: UITextField,
                     shouldChangeCharactersInRange range: NSRange,
                                                   replacementString string: String) -> Bool{
        print("did shanged charchters in text field")
     
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let currentLanguage = (textField.textInputMode?.primaryLanguage)
        if textField.text != ""
        {
            textField.accessibilityIdentifier == TextFieldIdentifiers.appleSearchTextField ?
                performSearchOfLocationWithQuery(textField.text!,language: currentLanguage!, forMaps: .AppleMaps) :
                performSearchOfLocationWithQuery(textField.text!,language: currentLanguage!, forMaps: .GoogleMaps)    
        }
        
        return true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        
        print("configureView")
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as? CustomAnnotationView
        
        if annotationView == nil{
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier:"CustomAnnotation")
            //annotationView!.bounds = CGRectZero
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
    
    enum MapsType{
        case AppleMaps
        case GoogleMaps
    }
    
    func performSearchOfLocationWithQuery(query:String, language: String, forMaps type: MapsType)
    {
        switch type{
        case .AppleMaps:
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
        case .GoogleMaps:
            AddressLocation.fetchLocationForAddress(query, language: language) { [unowned self] (addressLocations) in
                for addressLocation in addressLocations{
                    if let location = addressLocation.geometry?.location {
                        self.googleMapView.clear()
                        let position = CLLocationCoordinate2DMake(Double(location.lat!), Double(location.lng!))
                        let marker = GMSMarker(position: position)
                        marker.title = "New Location"
                        marker.map = self.googleMapView
                        self.googleMapView.animateToLocation(position)
                    }
                }
            }
        }
      
    
    }
}


