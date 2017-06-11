//
//  ContainerViewController.swift
//  Women4Women
//
//  Created by Laura Brouckman on 5/6/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    var lifeline = false
    var hidePopup = true
    var showSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateControllers()
    }
    
    func updateControllers() {
        print("update controllers \(showSideMenu)")
        if UserDefaults.getAppOpenedBefore() && UserDefaults.getLoggedIn() {
            if lifeline || UserDefaults.getNightOccuring() {
                self.leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "Left")
                self.mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Lifeline")
                if let lifeVC = self.mainViewController as? LifelineTableViewController {
                    lifeVC.showSideMenu = showSideMenu
                    showSideMenu = false
                }
            }
            else {
                self.leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "Left")
                self.mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                if let mainVC = self.mainViewController as? MainMapViewController {
                    mainVC.hidePopup = hidePopup
                    mainVC.showSideMenu = showSideMenu
                }
                hidePopup = true
                showSideMenu = false
            }
        }
        else {
            UserDefaults.setNightOccuring(false)
            self.mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
