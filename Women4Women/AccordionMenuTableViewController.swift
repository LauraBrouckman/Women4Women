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
        
        
        let item1 = Parent(state: .collapsed, childs: ["Set the time here"], title: "Time", subtitle: "12:00 am")
        let item2 = Parent(state: .collapsed, childs: ["553 Mayfield Avenue"], title: "Home", subtitle: "553 Mayfield Avenue")
        let item3 = Parent(state: .collapsed, childs: ["Bryan Powell"], title: "Emergency Contact", subtitle: "Bryan Powell")
        
        dataSource = [item1, item2, item3]
        numberOfCellsExpanded = .several
        total = dataSource.count
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
