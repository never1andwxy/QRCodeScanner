//
//  ViewControllerSettings.swift
//  QR-CodeScanner
//
//  Created by Yunlu18 on 2018/12/15.
//  Copyright © 2018 QRteam. All rights reserved.
//

import UIKit

class ViewControllerSettings: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
                //opened
                self.backButton.transform = CGAffineTransform(rotationAngle: -90 * ( .pi / 180) )
            
            
        }, completion: {(finished:Bool) in
            // the code you put here will be compiled once the animation finishes
            self.dismiss(animated: true, completion: nil)
            
        })
        
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
