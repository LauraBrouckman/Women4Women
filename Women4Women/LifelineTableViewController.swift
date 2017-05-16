//
//  LifelineTableViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/10/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import CoreData

class LifelineTableViewController: CoreDataTableViewController {

    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func updateUI() {
        print("UPDATE UI")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NearbyUser")
        request.sortDescriptors = [NSSortDescriptor(key: "first_name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("dequeueing cell for \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "lifelineCell", for: indexPath)
        
        if let user = fetchedResultsController?.object(at: indexPath) as? NearbyUser {
            var first_name: String?
            var last_name: String?
            var photo_filename: String?
            user.managedObjectContext?.performAndWait {
//                first_name = user.first_name
//                last_name = user.last_name
//                photo_filename = user.photo_filename
            }
            cell.textLabel?.text = first_name! + " " + last_name!
        }
        
        return cell
    }

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
