//
//  ViewController.swift
//  QR-CodeScanner
//
//  Created by WangXinyin on 2018/11/28.
//  Copyright © 2018年 QRteam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func Clickmethod(_ sender: Any) {let alertController = UIAlertController(title: "iOScreator", message: "Hello, world!", preferredStyle: UIAlertController.Style.alert); alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil)); self.present(alertController, animated: true, completion: nil) }
    
}

