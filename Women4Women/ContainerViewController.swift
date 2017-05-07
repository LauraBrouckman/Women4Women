//
//  ContainerViewController.swift
//  Women4Women
//
//  Created by Elizabeth Brouckman on 5/6/17.
//  Copyright © 2017 cs194w. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "Left")
        self.mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Main")
        // Do any additional setup after loading the view.
    }
    
//    override func awakeFromNib() {
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Main") {
//            self.mainViewController = controller
//        }
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Left") {
//            self.leftViewController = controller
//        }
//        super.awakeFromNib()
//    }

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
