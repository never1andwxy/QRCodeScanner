//
//  ViewControllerSettings.swift
//  QR-CodeScanner
//
//  Created by Yunlu18 on 2018/12/15.
//  Copyright © 2018 QRteam. All rights reserved.
//

import UIKit

class ViewControllerSettings: UIViewController{

    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var creditView: UIView!
    
    
    @IBOutlet weak var cvExitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      creditView.layer.cornerRadius = 30
      creditView.isHidden = true
      creditView.alpha = 0
      creditView.backgroundColor = UIColor(white: 0, alpha: 0)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect.init(x: 0, y: 0, width: creditView.frame.size.width , height: creditView.frame.size.height);
        creditView.insertSubview(blurEffectView, belowSubview: cvExitButton)
        
        creditView.clipsToBounds = true

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
    
    
    
    @IBAction func cvExitButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            
             self.creditView.alpha = 0
           
           
            
        })
         self.creditView.isHidden = false
        
    }
    
    func showCreditView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.creditView.isHidden = false
            self.creditView.alpha = 1
            
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
