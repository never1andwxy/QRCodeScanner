//
//  ViewController.swift
//  QR-CodeScanner
//
//  Created by WangXinyin,ZhangYun on 2018/11/28.
//  Copyright © 2018年 QRteam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:properties
    
    @IBOutlet weak var ubBackGround: UIView!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var cBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ubBackGround.layer.cornerRadius = 30
        createButton.layer.cornerRadius = createButton.frame.size.width / 2
        
        cBackground.layer.cornerRadius = 30
        cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    
    @IBAction func createButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
        if self.cBackground.transform == .identity
        {
            //opened
            self.createButton.transform = .identity
            self.createButton.backgroundColor = UIColor(red: 1, green: 0.1765, blue: 0.1059, alpha: 1.0)
            self.cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
        else{
            //closed
            self.cBackground.transform = .identity
            self.createButton.transform = CGAffineTransform(rotationAngle: 45 * ( .pi / 180) )
            self.createButton.backgroundColor = UIColor(red: 0.6863, green: 0.0902, blue: 0, alpha: 1.0)
        }
        
        })
    }
    
    @IBAction func Clickmethod(_ sender: Any) {let alertController = UIAlertController(title: "iOScreator", message: "Hello, world!", preferredStyle: UIAlertController.Style.alert); alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil)); self.present(alertController, animated: true, completion: nil) }
    
}

