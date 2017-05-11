//
//  MainMapViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/6/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MainMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: SearchTextField!
    let locationManager = CLLocationManager()
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    var hideSearchResults = false
    @IBOutlet weak var popupMenu: UIView!
    @IBOutlet weak var popupMenuHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configueSearchTextField()
        setUpMap()
        searchCompleter.delegate = self
    }
    
    //Set up the map to center around the user's current location
    func setUpMap() {
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.userTrackingMode = .follow
        
        popupMenu.isHidden = true
    }
    
    
    // function to track movement of user
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
 
    
    //Set up the auto-complete search field so that it will sugggest places + their addresses when user starts typing
    func configueSearchTextField() {

        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = UITextBorderStyle.roundedRect
        searchTextField.comparisonOptions = [.caseInsensitive]
        searchTextField.startVisible = true
        searchTextField.theme.font = UIFont.systemFont(ofSize: 18)
        searchTextField.theme.cellHeight = 65
        searchTextField.theme.borderColor = UIColor (red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        searchTextField.theme.separatorColor = UIColor (red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        searchTextField.highlightAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)]
        
        
        searchTextField.itemSelectionHandler = {item, itemPosition in
            self.searchTextField.text = item.title
            self.locateOnMap(address: item.subtitle, title: item.title)
            self.hideSearchResults = true
            self.searchTextField.tableView?.isHidden = true //hide the options
        }
        
        searchTextField.userStoppedTypingHandler = {
            self.updateSearchResults()
        }
    }
    
 func textFieldDidChange(_ textField: UITextField) {
        hideSearchResults = false
        popupMenu.isHidden = true
    }
    
    

    
    //Searches for the query string on apply maps and updates the table of search results
    func updateSearchResults() {
        if hideSearchResults {
            self.searchTextField.tableView?.isHidden = true //hide the options
            return
        }
        
        if let criteria = self.searchTextField.text {
            if criteria.characters.count > 1 {
                
                // Show the loading indicator
                self.searchTextField.showLoadingIndicator()
                
                self.searchCompleter.queryFragment = criteria
                self.searchCompleter.region = MKCoordinateRegion(center: self.locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                
                var items: [SearchTextFieldItem] = []
                for result in self.searchResults {
                    if result.title == "" || result.subtitle == "" {
                        continue
                    }
                    items.append(SearchTextFieldItem(title: result.title, subtitle: result.subtitle, image: UIImage(named: "icon_yellow")))
                }
                
                self.searchTextField.filterItems(items)
                self.searchTextField.stopLoadingIndicator()
                
            }
        }
    }

    //Locate the given address on the map, and center the MapView around that location
    //Show a pin with restaurant info and nearby user's locations
    // When this happens, it will also bring up the bottom toolbar to set time/contact/etc.
    func locateOnMap(address: String?, title: String?) {
        var ad = address
        if address == nil {
            //error no address
            ad = title
        }
        //Remove all the old annotations
        mapView.removeAnnotations(mapView.annotations)
        let geocoder = CLGeocoder()
        //convert the strong address into coordinates
        geocoder.geocodeAddressString(ad!) {
            if let placemarks = $0 {
                self.centerMap((placemarks[0].location?.coordinate)!, title: title)
            } else {
                print("error \($1)")
            }
        }
    }
    
    //center the map around given coordinates and drop a pin on the coordinates
    func centerMap(_ center:CLLocationCoordinate2D, title: String?){
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title ?? "Unknown"
        annotation.subtitle = "7 lifelines"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        mapView.addAnnotation(annotationView.annotation!)
        mapView.selectAnnotation(annotation, animated: true)

        openPopupMenu()
    }

    //Open up the popup menu from the bottom of the screen
    func openPopupMenu() {
        searchTextField.resignFirstResponder()
        popupMenu.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.popupMenuHeight.constant = 300 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func openSettingsDrawer(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainMapViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.updateSearchResults()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
