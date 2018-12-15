//
//  ViewController.swift
//  QR-CodeScanner
//
//  Created by WangXinyin,ZhangYun on 2018/11/28.
//  Copyright © 2018年 QRteam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //MARK:properties
    
    @IBOutlet weak var ubBackGround: UIView!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activeIndicator: UIButton!
    
    @IBOutlet weak var hBackGround: UIView!
    @IBOutlet weak var pBackGround: UIView!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var cBackground: UIView!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ubBackGround.layer.cornerRadius = 30
        createButton.layer.cornerRadius = createButton.frame.size.width / 2
        
        activeIndicator.layer.cornerRadius = activeIndicator.frame.size.width / 2
        
        cBackground.layer.cornerRadius = 30
        cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        pBackGround.layer.cornerRadius = 30
        hBackGround.layer.cornerRadius = 30
       cBackground.alpha = 0
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setAnchorPoint(anchorPoint: CGPoint(x:0.5, y:1),view: pBackGround)
        setAnchorPoint(anchorPoint: CGPoint(x:0.5, y:1),view: hBackGround)
        pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        pBackGround.center.y = self.view.frame.size.height - 50
        hBackGround.center.y = self.view.frame.size.height - 50
        
        
        
    }
    
    
    
    @IBAction func settingsButtonClick(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let secondVC = sb.instantiateViewController(withIdentifier: "SettingsVC") as? ViewControllerSettings{
            self.present(secondVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func createButtonClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
        if self.cBackground.transform == .identity
        {
            //opened
            self.createButton.transform = .identity
            self.createButton.backgroundColor = UIColor(red: 1, green: 0.1765, blue: 0.1059, alpha: 1.0)
            self.cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.cBackground.alpha = 0
        }
        else{
            //closed
            self.cBackground.transform = .identity
            self.createButton.transform = CGAffineTransform(rotationAngle: 45 * ( .pi / 180) )
            self.createButton.backgroundColor = UIColor.gray
            self.cBackground.alpha = 1
        }
        
        })
    }
    
    @IBAction func pictureButtonClick(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            
        }else{
            print("读取相册错误")
        }
        self.addChild(imagePicker)
        self.pBackGround.addSubview(imagePicker.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            
          self.activeIndicator.center.x = self.pictureButton.center.x
            self.pBackGround.transform = .identity
            
            self.hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            
        })
    }
    
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.activeIndicator.center.x = self.cameraButton.center.x
            
            self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            
            self.hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            
        })
        
    }
    
   
    @IBAction func historyButtonClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.activeIndicator.center.x = self.historyButton.center.x
            
            self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            
            self.hBackGround.transform = .identity
            
        })
        
    }
    
    

    


func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
    let oldOrigin = view.frame.origin
    view.layer.anchorPoint = anchorPoint
    let newOrigin = view.frame.origin
    
    let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
    
    view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
}

}
