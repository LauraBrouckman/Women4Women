//
//  AccordionMenuTableViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/8/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

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
    }
    
    func buttonAction(_ sender: UIButton!) {
        performSegue(withIdentifier: "showLifelines", sender: nil)
    }
    

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
            print("Segue id: \(id)")
            if id == "showLifelines" {
                if let destinationVC = segue.destination as? ContainerViewController {
                    print("Correct type of VC")
                    destinationVC.lifeline = true
                }
            }
        }
    }
 

}
