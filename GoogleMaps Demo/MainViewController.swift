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


class MainViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    struct TextFieldIdentifiers {
        static let appleSearchTextField = "apple search"
        static let googleSearchTextField = "google search"
    }
    
    lazy var searchResultVC : SearchResultTableViewController = {
        let mvc = SearchResultTableViewController()
        mvc.completionHandler = { [unowned self] (address) in
            self.searchLocationGoogleTextField.text = address
            self.textFieldShouldReturn(self.searchLocationGoogleTextField)
        }
        return mvc
    }()
    
    let sydneyCoordinates = CLLocationCoordinate2DMake(-33.86, 151.20)
    
    lazy var containerViewRect:CGRect = { [unowned self] in
        let halfHeight = self.searchLocationGoogleTextField.frame.size.height / 2
        let center = self.searchLocationGoogleTextField.center
        return CGRectMake(center.x,center.y + halfHeight,0,0)}()
    
    lazy var containerView:UIView = { [unowned self] in
        let view = UIView(frame:self.containerViewRect)
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    func dismissAutocompletitionView()
    {
        searchResultVC.willMoveToParentViewController(nil)
        searchResultVC.view.removeFromSuperview()
        searchResultVC.removeFromParentViewController()
        UIView.animateWithDuration(0.3, animations: {
            self.containerView.frame = self.containerViewRect
            }, completion: { (value) in
                self.containerView.removeFromSuperview()
        })
    }
    
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
            searchLocationAppleTextField.widthAnchor.constraintEqualToConstant(300),
            
            searchLocationGoogleTextField.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 50),
            searchLocationGoogleTextField.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 50),
            searchLocationGoogleTextField.widthAnchor.constraintEqualToConstant(300),
            
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
        GMSServices.provideAPIKey("AIzaSyCEA1lfK8eDwtbTjW22MDDMe3e-0-itjKc") //AIzaSyCEA1lfK8eDwtbTjW22MDDMe3e-0-itjKc
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
        
        if textField.text != ""{
          textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        }
        
        if textField.accessibilityIdentifier == TextFieldIdentifiers.googleSearchTextField
        {
            view.addSubview(containerView)
            
            NSLayoutConstraint.activateConstraints([
                containerView.topAnchor.constraintEqualToAnchor(searchLocationGoogleTextField.bottomAnchor, constant: 5),
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
            
            UIView.animateWithDuration(0.3, animations: { [unowned self] in
                self.containerView.setNeedsUpdateConstraints()
                self.containerView.setNeedsLayout()
                self.containerView.layoutIfNeeded()
            })
            
            searchResultVC.didMoveToParentViewController(self)
            
            print("Started editing")
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        var text = textField.text!
        
        let startIndex = range.location
        let endIndex = startIndex + range.length
        
        if range.length > 0{
            let rangeToRemove = text.startIndex.advancedBy(startIndex)..<text.startIndex.advancedBy(endIndex)
            text.removeRange(rangeToRemove)
        } else {
            text.insertContentsOf(string.characters, at: text.startIndex.advancedBy(range.location))
        }
        
        searchResultVC.fetchSuggestions(text)
        
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let currentLanguage = (textField.textInputMode?.primaryLanguage)
        if textField.text != ""
        {
            if textField.accessibilityIdentifier == TextFieldIdentifiers.appleSearchTextField {
                performSearchOfLocationWithQuery(textField.text!,language: currentLanguage!, forMaps: .AppleMaps) }else {
                performSearchOfLocationWithQuery(textField.text!,language: currentLanguage!, forMaps: .GoogleMaps)
                dismissAutocompletitionView()
            }
        }
        
        return true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
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


