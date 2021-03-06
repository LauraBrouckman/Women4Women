//
//  EditNightTableViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/30/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit

class EditNightTableViewController: UITableViewController {

    
    var sosDown = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Add in the SOS Button
        // Make sure this goes at the bottom
        self.view.clipsToBounds = false
        self.view.superview?.clipsToBounds = false
        let customView = UIView(frame: CGRect(x: 0, y: 500, width: 200, height: 80))
        let button = UIButton(frame: CGRect(x: 100, y: 12, width: 56, height: 56))
        button.setTitle("SOS", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(Colors.lightBlue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.borderColor = Colors.lightBlue.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(sosRelease), for: .touchUpInside)
        button.addTarget(self, action: #selector(sosHold), for: .touchDown)
    
        customView.addSubview(button)
        self.tableView.tableFooterView = customView
        
    }
    
    fileprivate func addSOSOverlay() {
        let screenSize: CGRect = UIScreen.main.bounds
        print(screenSize.height)
        let sosView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        sosView.backgroundColor = UIColor.red
        sosView.tag = 100
        // Add in a label possibly a countdown
        self.view.superview?.addSubview(sosView)
    }
    
    fileprivate func removeSOSOVerlay() {
        if let sosView = self.view.superview?.viewWithTag(100) {
            sosView.removeFromSuperview()
        }
    }
    
    
    fileprivate func SOS() {
        if(sosDown) {
            removeSOSOVerlay()
            // hide overlay 
            // maybe have an alert that informs them that sos was triggered
            print("it's been 5 seconds, calling for SOS")
            
            sosDown = false
        } else {
            print("they released the sos button not doin it")
        }
    }
    
    
    func sosHold() {
        // show overlay that explains what sos is
        addSOSOverlay()
        sosDown = true
        print("sos down")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.SOS()
        })
    }
    
    func sosRelease() {
        removeSOSOVerlay()
        // hide overlay
        sosDown = false
        print("sos up")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
