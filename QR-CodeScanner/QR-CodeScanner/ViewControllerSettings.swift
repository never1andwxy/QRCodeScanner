//
//  ViewControllerSettings.swift
//  QR-CodeScanner
//
//  Created by Yunlu18 on 2018/12/15.
//  Copyright © 2018 QRteam. All rights reserved.
//

import UIKit
import Localize_Swift

class ViewControllerSettings: UIViewController{

    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var creditView: UIView!
    
    
    @IBOutlet weak var cvExitButton: UIButton!
    
    @IBOutlet weak var gotositeButton: UIButton!
    
    @IBOutlet weak var privacypolicyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      creditView.layer.cornerRadius = 30
      creditView.isHidden = true
      creditView.alpha = 0
      creditView.backgroundColor = UIColor(white: 0, alpha: 0)
        
        gotositeButton.layer.cornerRadius = 5
        privacypolicyButton.layer.cornerRadius = 5
        gotositeButton.titleLabel?.textAlignment = .center
        gotositeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        privacypolicyButton.titleLabel?.textAlignment = .center
        privacypolicyButton.titleLabel?.adjustsFontSizeToFitWidth = true

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
        setText()
    }
    @objc func setText(){
        gotositeButton.titleLabel?.text = "Go to our website".localized()
        privacypolicyButton.titleLabel?.text = "Privacy Policy".localized();
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect.init(x: 0, y: 0, width: creditView.frame.size.width , height: creditView.frame.size.height);
        creditView.insertSubview(blurEffectView, belowSubview: cvExitButton)
        
        creditView.clipsToBounds = true
       blurEffectView.frame = CGRect.init(x: 0, y: 0, width: creditView.frame.size.width , height: creditView.frame.size.height);
        
        
        
    }
    
    
    
    @IBAction func privacypolicyButtonClicked(_ sender: Any) {
        
          UIApplication.shared.open(URL(string: "https://yunlu18.net/innovation/QRCodeProject/privacy.html")!, options: [:], completionHandler: nil)
        
        
    }
    @IBAction func gotositeButtonClicked(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "https://yunlu18.net/innovation/QRCodeProject/index.html")!, options: [:], completionHandler: nil)
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
