//
//  ViewController.swift
//  QR-CodeScanner
//
//  Created by WangXinyin,ZhangYun on 2018/11/28.
//  Copyright © 2018年 QRteam. All rights reserved.
//



import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate ,
    UITextFieldDelegate {
    
    
    //MARK:properties
    @IBOutlet weak var camBackGround: UIView!
    
    @IBOutlet weak var ubBackGround: UIView!
    
    @IBOutlet weak var cword: UITextField!
    
    @IBOutlet weak var qrImage: UIImageView!
    
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
    var qrCodeFrameView: UIView?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    //1:Picture 2:Camera 3:Create 4:History 5:Setting
    var appStatus = 2
    var qrcodeImage: CIImage!
    
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
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            
        }else{
            print("读取相册错误")
        }
        self.addChild(imagePicker)
        imagePicker.navigationBar.isHidden = true
       // camBackGround.insetsLayoutMarginsFromSafeArea = false
       // camBackGround.clipsToBounds = true
        
       
        
        startScanningQRCode()
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
    
    private func startScanningQRCode() {
        // 1.创建捕捉会话
        let session = AVCaptureSession()
        // 2.设置输入(摄像头)
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device ) else {
            return
        }
        session.addInput(input)
        // 3.设置输出(Metadata)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
        // 设置output的输出的类型(该类型的设置必须在添加到session之后)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // 设置扫描的区域
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        output.rectOfInterest = CGRect(x: 0, y: 0, width: screenH, height: screenW)
        
        // 4.添加预览图层(可以没有)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        videoPreviewLayer?.frame = camBackGround.frame
        //previewLayer.masksToBounds = true
        
        camBackGround.layer.insertSublayer(videoPreviewLayer!, at: 0)
        // 5.开始扫描
        session.startRunning()
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
            qrCodeFrameView.layer.borderWidth = 3
            qrCodeFrameView.layer.cornerRadius = 5
            camBackGround.addSubview(qrCodeFrameView)
            camBackGround.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    
    @IBAction func pictureButtonClick(_ sender: UIButton) {
        if appStatus != 1{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.activeIndicator.center.x = self.pictureButton.center.x
                self.pBackGround.transform = .identity
                
                self.hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                
            })
            
            let cardView = UIView(frame: CGRect(x: 5, y: 5, width: pBackGround.frame.size.width - 10, height: pBackGround.frame.size.height))
            
            cardView.layer.cornerRadius = 25
            cardView.backgroundColor = UIColor(white: 1, alpha: 1)
            cardView.clipsToBounds = true
            
            
            imagePicker.view.frame = CGRect.init(x: 0, y: 0, width: cardView.frame.size.width , height: cardView.frame.size.height - 80);
            
            cardView.addSubview(imagePicker.view)
            self.pBackGround.addSubview(cardView)
            appStatus = 1
        }
        
    }
    
    @IBAction func cwordChange(_ sender: Any) {
        
        
        
            if cword.text == "" {
                qrImage.image = nil
                return
            }
            
            let data = cword.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            let scaleX = qrImage.frame.size.width / qrcodeImage.extent.width
            let scaleY = qrImage.frame.size.height / qrcodeImage.extent.height
            
            let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            qrImage.image = UIImage(ciImage: transformedImage)
        
    
        
        
        
    }
    
    
    @IBAction func endEdit(_ sender: Any) {
        cword.resignFirstResponder()
        //按return可以关闭键盘
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //按屏幕其他地方可以关闭键盘
    }
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //拿到选择完的照片
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        
        {
            return

        }
        //设置photo的照片
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context:nil, options: nil)
        
        guard let ciImage = CIImage(image: selectedImage) else {
            return
        }
        let features = detector?.features(in: ciImage)
        var qrCodemsg=""
        for feature in features as! [CIQRCodeFeature] {
            qrCodemsg += feature.messageString!
        }
        if qrCodemsg=="" {
            print("nothing")
            let alert = UIAlertController(title: " ", message: "Unable to detect Qr Code" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style: .default, handler:nil ))
            self.present(alert, animated: true , completion: nil)
        }else{
            print(qrCodemsg)
            
            UIView.animate(withDuration: 0.3, animations: {

            self.activeIndicator.center.x = self.cameraButton.center.x
            
            self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            
            self.hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            })
            appStatus = 2
            
            
            let alertNormal = UIAlertController(title: "", message: qrCodemsg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
                print("OK is clicked")
            }
            alertNormal.addAction(cancelAction);
            alertNormal.addAction(sureAction);
            self.present(alertNormal, animated: true)
            
            
            
            
        }
            
        
    }
    
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        if appStatus != 2{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.activeIndicator.center.x = self.cameraButton.center.x
                
                self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                
                self.hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                
            })
            appStatus = 2
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
    
   
    @IBAction func historyButtonClick(_ sender: UIButton) {
        if appStatus != 4{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.activeIndicator.center.x = self.historyButton.center.x
                
                self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                
                self.hBackGround.transform = .identity
                
            })
            appStatus = 4
        }

    }
    
    
    @IBAction func settingsButtonClick(_ sender: UIButton) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let secondVC = sb.instantiateViewController(withIdentifier: "SettingsVC") as? ViewControllerSettings{
                self.present(secondVC, animated: true, completion: nil)
                
            }
        
    }
    


func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
    let oldOrigin = view.frame.origin
    view.layer.anchorPoint = anchorPoint
    let newOrigin = view.frame.origin
    
    let transition = CGPoint(x: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y)
    
    view.center = CGPoint(x: view.center.x - transition.x, y: view.center.y - transition.y)
}
    
}

    extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
     
         
            func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
                // Check if the metadataObjects array is not nil and it contains at least one object.
                if metadataObjects.count == 0 {
                    qrCodeFrameView?.frame = CGRect.zero
                    print("No QR code is detected")
                    return
                }
            
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    print(metadataObj.stringValue!)
                    
                    
                    let alertNormal = UIAlertController(title: "", message: metadataObj.stringValue!, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let sureAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
                        print("OK is clicked")
                    }
                    alertNormal.addAction(cancelAction);
                    alertNormal.addAction(sureAction);
                    self.present(alertNormal, animated: true)
                }
            
            
            
                }}
        
}
    
    


