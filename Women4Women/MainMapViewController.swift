//
//  MainMapViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/6/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MainMapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    let CHAT_SEGUE = "Messages"
    @IBAction func Messages(_ sender: Any) {
        performSegue(withIdentifier: "Messages", sender: self)
    }
    
    var hidePopup: Bool = true
    var showSideMenu = false

    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
        _locationManager.allowsBackgroundLocationUpdates = true // allow in background
        _locationManager.distanceFilter = 1.0
        return _locationManager
    }()
    
    let userPin = UIImage(named: "user pin")
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: SearchTextField!
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults: [MKLocalSearchCompletion] = []
    var hideSearchResults = false
    @IBOutlet weak var popupMenu: UIView!
    @IBOutlet weak var popupMenuHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        UserDefaults.setCurrentLocation(lat: 0, lon: 0)
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        super.viewDidLoad()
        configueSearchTextField()
        searchCompleter.delegate = self
        
        if showSideMenu {
            self.slideMenuController()?.openLeft()
        }
        self.hideKeyboardWhenTappedAround()

        UserDefaults.setHomeTime(nil)
        
        setUpMap()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    //Set up the map to center around the user's current location
    func setUpMap() {
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.userTrackingMode = .follow
        
        popupMenu.isHidden = hidePopup
        if hidePopup == false {
            searchTextField.text = UserDefaults.getNightOutLocationName()
            self.popupMenuHeight.constant = 280 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
            centerTitle = UserDefaults.getNightOutLocationName()
            let (lat, lon) = UserDefaults.getNightOutLocation()!
            mapCenter = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.centerMap()
        }
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
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
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

    // Locate the given address on the map, and center the MapView around that location
    // Show a pin with restaurant info and nearby user's locations
    // When this happens, it will also bring up the bottom toolbar to set time/contact/etc.
    
    var centerTitle: String?
    var mapCenter: CLLocationCoordinate2D?
    
    func locateOnMap(address: String?, title: String?) {
        var ad = address
        centerTitle = title
        if address == nil {
            //error no address
            ad = title
        }
        //Remove all the old annotations
        mapView.removeAnnotations(mapView.annotations)
        let geocoder = CLGeocoder()
        //convert the string address into coordinates
        geocoder.geocodeAddressString(ad!) {
            if let placemarks = $0 {
                let coordinate = (placemarks[0].location?.coordinate)!
                self.mapCenter = coordinate
                // Update your location remotely and in local storage
                UserDefaults.setNightOutLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                UserDefaults.setNightOutLocationName(name: title ?? ad!)
                RemoteDatabase.updateUserLocation(forUser: UserDefaults.getUsername(), locationLat: coordinate.latitude, locationLon: coordinate.longitude)
                TrackUsers.updateNearbyUserList(self.centerMap)
            } else {
                print("error \($1)")
            }
        }
    }
    
    
    var numLifelines: Int = 0
    //center the map around given coordinates and drop a pin on the coordinates
    func centerMap(){
        let center = self.mapCenter!
        let title = self.centerTitle
        let spanX = 0.005
        let spanY = 0.005
        let mapCenter = CLLocationCoordinate2D(latitude: center.latitude - 0.0009, longitude: center.longitude)
        let newRegion = MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        addAnnotations(title: title, center: center)
        openPopupMenu()
    }
    
    // Find users that are close to the "going-out" location and add annotations for them onto the map
    func addAnnotations(title: String?, center: CLLocationCoordinate2D) {
        self.managedObjectContext.perform {
            let results = NearbyUser.getAllNearbyUsers(inManagedObjectContext: self.managedObjectContext)
            self.numLifelines = (results?.count)!
            for result in results! {
                self.addAnnotation(
                    toPoint: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude),
                    withTitle: result.first_name!,
                    withSubtitle: nil,
                    selectPin: false,
                    filename: result.photo_filename
                )
            }
            //Add in the annotation for the location
            let locationAnnotation = MKPointAnnotation()
            locationAnnotation.coordinate = center
            locationAnnotation.title = (title ?? "Unknown")
            locationAnnotation.subtitle = String(self.numLifelines) + " lifelines"
            self.mapView.addAnnotation(locationAnnotation)
            self.mapView.selectAnnotation(locationAnnotation, animated: true)
            //Add a circle that goes around the annotation
            let circle = MKCircle(center: center, radius: 115)
            self.mapView.add(circle)

        }
    }
    
    
    // Resize image for the pin
//    func resizeImage(image: UIImage?, newWidth: CGFloat) -> UIImage? {
//        if image == nil {
//            return nil
//        }
//        let scale = newWidth / image!.size.width
//        let newHeight = image!.size.height * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//            image!.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        newImage.
//        return newImage
//    }
    
    // Create the view for the annotation
    func mapView(_ mapView:
        MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UserAnnotation {
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier){
                return view
            } else{
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
                //view.image = userPin
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsURL.appendingPathComponent("\(annotation.filename!)").path
                print("Looking for image at path \(filePath)")
                if FileManager.default.fileExists(atPath: filePath) {
                    print("Found image there")
                    let img = UIImage(contentsOfFile: filePath)
                    view.image = img?.circularImage(size: CGSize(width: 30, height: 30))
                    view.leftCalloutAccessoryView = UIImageView(image: img?.circularImage(size: CGSize(width: 30, height: 30)))
                } else {
                    view.image = userPin
                    view.leftCalloutAccessoryView = UIImageView(image: userPin)
                }
                view.isEnabled = true
                view.canShowCallout = true
                return view
            }
        }
        return nil
    }
    
    // Style the circle overlay that marks the nearby region to the restaurant
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.black.withAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.black
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    
    //Add an annotation (pin) to the map
    func addAnnotation(toPoint coordinate: CLLocationCoordinate2D, withTitle title: String, withSubtitle subtitle: String?, selectPin: Bool, filename: String?) {
        let annotation = UserAnnotation(name: title, center: coordinate, sub: subtitle, photo_filename: filename)
        mapView.addAnnotation(annotation)
        if selectPin {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    


    //Open up the popup menu from the bottom of the screen
    func openPopupMenu() {
        searchTextField.resignFirstResponder()
        popupMenu.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.popupMenuHeight.constant = 280 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func openSettingsDrawer(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CHAT_SEGUE {
            let controller = segue.destination as! ConversationsTableViewController
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}


// MARK: - CLLocationManagerDelegate

// To cut image into circle
extension UIImage {
    
    func circularImage(size size: CGSize?) -> UIImage {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}





extension MainMapViewController: CLLocationManagerDelegate {
    
    func isClose(a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
        if sqrt(pow(a.latitude - b.latitude, 2) + pow(a.longitude - b.longitude, 2)) <= 0.001 {
            return true
        }
        return false
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            let location = locations.last
            if location != nil
            {
                let newCoord = location?.coordinate
                var (lat, lon) = UserDefaults.getCurrentLocation() ?? (0, 0)
                let prevCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                if !isClose(a: newCoord!, b: prevCoord) {
                    RemoteDatabase.updateUserLocation(forUser: UserDefaults.getUsername(), locationLat: (newCoord?.latitude)!, locationLon: (newCoord?.longitude)!)
                    UserDefaults.setCurrentLocation(lat: (newCoord?.latitude)!, lon: (newCoord?.longitude)!)
                }

        }
        
    }
    
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
