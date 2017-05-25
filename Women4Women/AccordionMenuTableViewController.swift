//
//  AccordionMenuTableViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/8/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import MapKit

class AccordionMenuTableViewController: AccordionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timeToComeHome: String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"

        if let time = UserDefaults.getHomeTime() {
            timeToComeHome = dateFormatter.string(from: time)
        } else {
            let time = Date(timeIntervalSinceNow: TimeInterval(7200))
            timeToComeHome = dateFormatter.string(from: time)
        }
        
        let item1 = Parent(state: .collapsed, childs: ["Set the time here"], title: "Time", subtitle: timeToComeHome)
        let item2 = Parent(state: .collapsed, childs: ["553 Mayfield Avenue"], title: "Home address", subtitle: UserDefaults.getHomeStreet() + ", " + UserDefaults.getHomeCity())
        let item3 = Parent(state: .collapsed, childs: ["Bryan Powell"], title: "Emergency Contact", subtitle: UserDefaults.getEmergencyContactFirstName() + " " + UserDefaults.getEmergencyContactLastName())
        
        dataSource = [item1, item2, item3]
        numberOfCellsExpanded = .several
        total = dataSource.count
        
        //make custom view to go at the bottom of the table
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        customView.backgroundColor = Colors.lightBlue
        let button = UIButton(frame: CGRect(x: 50, y: 12, width: 100, height: 26))
        button.setTitle("Plan Outing", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(Colors.lightBlue, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        customView.addSubview(button)
        self.tableView.tableFooterView = customView
        
        // for region monitoring
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    //Plan button pressed
    func buttonAction(_ sender: UIButton!) {
        //SMSMessaging.sendSMSText()
        beginRegionMonitoring()
        performSegue(withIdentifier: "showLifelines", sender: nil)
    }
    
    
    //Begins region monitoring - so that if the user enters their home region at any point an SMS message can be sent
    let locationManager = CLLocationManager()
    
    func beginRegionMonitoring() {
        // Define the region around the users home location
        print("BEGIN MONITORING REGION")
        let (lat, lon) = UserDefaults.getHomeLocation()!
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: 30, identifier: "home")
        print("REGION \(region)")
        // 2
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        
        locationManager.startMonitoring(for: region)
        
    }
    
    // Show alert
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Sends an SMS message to the emergency contact letting them know their friends plan

    
    
    
    // Send text message when the plan night button is pressed
    

//    override func didReceiveMemoryWarning() {
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id == "showLifelines" {
                if let destinationVC = segue.destination as? ContainerViewController {
                    destinationVC.lifeline = true
                }
            }
        }
    }
 

}


extension AccordionTableViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
}
