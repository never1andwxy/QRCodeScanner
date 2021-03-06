//
//  ViewController.swift
//  QR-CodeScanner
//
//  Created by WangXinyin,ZhangYun on 2018/11/28.
//  Copyright © 2018年 QRteam. All rights reserved.
//



import UIKit
import AVFoundation
import SafariServices
import SQLite
import Localize_Swift
import CircularRevealKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate ,
UITextFieldDelegate  ,UITableViewDataSource, UITableViewDelegate {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as UITableViewCell
        let historyitem : HistoryItem
        historyitem = historyItemList[indexPath.row]
        cell.textLabel?.text = historyitem.content
        cell.detailTextLabel?.text = historyitem.date
        if(verifyUrl(str: historyitem.content!))
        {cell.imageView?.image = #imageLiteral(resourceName: "link")}else{cell.imageView?.image = #imageLiteral(resourceName: "text")}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.historyTableView.deselectRow(at: indexPath, animated: true)
        self.dBackGround.isHidden = false
        self.resultLabel.text = historyItemList[indexPath.row].content
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.dBackGround.alpha = 1
        })
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            do{
                let deleteitem = self.historyTable.filter(id == self.historyItemList[indexPath.row].id)
                print(historyItemList[indexPath.row].id)
                print(indexPath.row)
                if try self.database.run(deleteitem.delete()) > 0 {
                    print("deleted ")
                } else {
                    print("not found")
                }
                
                
                
                
            }catch{print("error")}
            
            self.historyItemList.remove(at: indexPath.row)
            historyTableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            
        }
    }
    
    
  
    
    //MARK:properties
    @IBOutlet weak var camBackGround: UIView!
    
    @IBOutlet weak var ubBackGround: UIView!
    
    @IBOutlet weak var cword: UITextField!
    
    @IBOutlet weak var qrImage: UIImageView!
    
    @IBOutlet weak var cqrShareButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activeIndicator: UIButton!
    
    @IBOutlet weak var hBackGround: UIView!
    @IBOutlet weak var pBackGround: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var gbkExitButton: UIButton!
    
    @IBOutlet weak var dqrShareButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var cBackground: UIView!
    
    @IBOutlet weak var dBackGround: UIView!
    
    @IBOutlet weak var dqrSafariButton: UIButton!
    
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var Generatelabel: UILabel!
    @IBOutlet weak var Resultlabel: UILabel!
    
    var imagePicker:UIImagePickerController!
    var qrCodeFrameView: UIView?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    //1:Picture 2:Camera 3:Create 4:History 5:Setting
    var appStatus = 2
    var qrcodeImage: CIImage!
    
    var database : Connection!
    let historyTable = Table("history")
    let id = Expression<Int>("id")
    let content = Expression<String>("content")
    let scantime = Expression<String>("scantime")
    
    var historyItemList = [HistoryItem]()
    
    var lastesttime = CACurrentMediaTime()
    var lastresult = ""
    var UndetectString = "Unable to detect Qr Code"
    var SearchString = "https://www.google.com/search?q="
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       dBackGround.isHidden = true
        dBackGround.alpha = 0
        dBackGround.backgroundColor = UIColor(white: 0.9, alpha: 0.95)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        dBackGround.layer.cornerRadius = 30
        
        ubBackGround.layer.cornerRadius = 30
        createButton.layer.cornerRadius = createButton.frame.size.width / 2
        dqrShareButton.layer.cornerRadius = dqrShareButton.frame.size.width / 2
        dqrSafariButton.layer.cornerRadius = dqrSafariButton.frame.size.width / 2
        cqrShareButton.layer.cornerRadius = cqrShareButton.frame.width / 2
        
        activeIndicator.layer.cornerRadius = activeIndicator.frame.size.width / 2
        
        setText()
        cBackground.layer.cornerRadius = 30
        //cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
       // cBackground.drawAnimatedCircularMask(startFrame: CGRect(
       //     origin: cBackground.center,
       //     size: CGSize(
       //         width: 0,
       //         height: 0)), duration: 0, revealType: RevealType.unreveal)
        cBackground.isHidden = true
        
        pBackGround.layer.cornerRadius = 30
        hBackGround.layer.cornerRadius = 30
        hBackGround.clipsToBounds = true
        //cBackground.alpha = 0
        cqrShareButton.isEnabled = false
        cqrShareButton.alpha = 0.2
        cword.font = .systemFont(ofSize: 20)
        
        
        pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        hBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
       
        
        
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
        
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("history").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }catch{
            print(error)
        }
        
        
        let createTable = self.historyTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.content)
            table.column(self.scantime)
        }
        
        do{
            try self.database.run(createTable)
            print("Created")
        }catch{
            print(error)
        }
        
       readValues()
       startScanningQRCode()
        
        lastesttime = CACurrentMediaTime()
    }
    
    func readValues(){
        historyItemList.removeAll()
        
        
        do{
            let historyResult = try self.database.prepare(self.historyTable.order(id.desc))
            
            for record in historyResult {
                
                
                historyItemList.append(HistoryItem(id: record[id],content: record[content],date: record[scantime]))

                
            }
        }catch{
            print(error)
        }
        
        
        self.historyTableView.reloadData()
    }
    
    
    
    
    @IBAction func gbkExitButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            
            
            self.dBackGround.alpha = 0
        })
        dBackGround.isHidden = true
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setAnchorPoint(anchorPoint: CGPoint(x:0.5, y:1),view: pBackGround)
        setAnchorPoint(anchorPoint: CGPoint(x:0.5, y:1),view: hBackGround)
        
        pBackGround.center.y = self.view.frame.size.height - 50
        hBackGround.center.y = self.view.frame.size.height - 50
        
        
        
        
    }
    
    @objc func setText(){
       Generatelabel.text = "Generate QR Code".localized()
        cword.placeholder = "Please enter text here".localized()
    UndetectString = "Unable to detect Qr Code".localized()
        SearchString = "https://www.google.com/search?q=".localized()
        Resultlabel.text = "Detected Result".localized()
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
            
            camBackGround.insertSubview(qrCodeFrameView, belowSubview: pBackGround)
            
        }
    }
    
    
    
    @IBAction func cqrShareButtonClick(_ sender: Any) {
        
        let scaleX = 512 / qrcodeImage.extent.width
        let scaleY = 512 / qrcodeImage.extent.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(transformedImage, from: transformedImage.extent) else {return }
        
        let items : [Any] = [ UIImage(cgImage: cgImage)]
       
        print("1")
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if ac.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                ac.popoverPresentationController?.sourceView = self.view
                ac.popoverPresentationController?.sourceRect = cqrShareButton.frame
            }
        }
        present(ac, animated: true)
        
        
    }
    
    
  
    
    @IBAction func dqrShareButtonClicked(_ sender: Any) {
        
        
        
        if verifyUrl(str: resultLabel.text!)
        {
            let url = NSURL(string: resultLabel.text!)
            let items : [Any] = [url!]
            
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                if ac.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    ac.popoverPresentationController?.sourceView = self.view
                    ac.popoverPresentationController?.sourceRect = dqrShareButton.frame
                }
            }
            present(ac, animated: true)
            
            
        }else
        {
       
        
        
        
        let items : [Any] = [ resultLabel.text!]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                if ac.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    ac.popoverPresentationController?.sourceView = self.view
                    ac.popoverPresentationController?.sourceRect = dqrShareButton.frame
                }
            }
        present(ac, animated: true)
        
        }
    }
    
    
    @IBAction func dqrSafariButtonClicked(_ sender: Any) {
       
        
        
        
        if verifyUrl(str: resultLabel.text!)
        {
            let url = NSURL(string: resultLabel.text!)
            let svc = SFSafariViewController(url: url! as URL)
            present(svc, animated: true, completion: nil)
            
            
        }else
        {
            let sanitize = resultLabel.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            


            let urlori = SearchString + sanitize!
            
            let url = NSURL(string: urlori)
            let svc = SFSafariViewController(url: url! as URL)
            present(svc, animated: true, completion: nil)
            
        }
    }
    
    private func verifyUrl(str:String) -> Bool {
        //创建NSURL实例
        if let url = NSURL(string: str) {
            //检测应用是否能打开这个NSURL实例
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
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
                qrImage.image = UIImage(named:"placeholder")!
                cqrShareButton.isEnabled = false
                cqrShareButton.alpha = 0.2
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
           cqrShareButton.isEnabled = true
         cqrShareButton.alpha = 1
        
    
        
        
        
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
            let alert = UIAlertController(title: UndetectString, message: "", preferredStyle: .alert)
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
            
            
            self.dBackGround.alpha = 0
            self.dBackGround.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.dBackGround.alpha = 1
            })
            
            self.resultLabel.text = qrCodemsg
            
            //图片扫码并显示弹窗
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let timeString = formatter.string(from: Date())
            
            print(timeString)
            
            let insertHistory = self.historyTable.insert(self.content <- qrCodemsg, self.scantime <- timeString)
            
            do{
                try self.database.run(insertHistory)
                print("Inserted")
            }catch{
                print("error")
            }
            
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
        
               // if self.cBackground.transform == .identity
             if self.cBackground.isHidden == false
                {
                    UIView.animate(withDuration: 0.5, animations: {
                    //opened
                    self.createButton.transform = .identity
                    self.createButton.backgroundColor = UIColor(red: 1, green: 0.1765, blue: 0.1059, alpha: 1.0)
                    //self.cBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                   // self.cBackground.alpha = 0
                        
                        
                        
                    
                    })
                    let rect = CGRect(
                        origin: CGPoint(
                            x: cBackground.frame.width/2-createButton.frame.width/2,
                            y: cBackground.frame.height/2-createButton.frame.height/2),
                        size: CGSize(
                            width: createButton.frame.width,
                            height: createButton.frame.height))
                    
                    self.cBackground.drawAnimatedCircularMask(startFrame:
                    rect, duration: 0.6, revealType: RevealType.unreveal){ [weak self] in
                        self?.cBackground.isHidden = true
                    }
                    
                    
                }
                else{
                
                let rect2 = CGRect(
                    origin: CGPoint(
                        x: cBackground.frame.width/2-createButton.frame.width/2,
                        y: cBackground.frame.height/2-createButton.frame.height/2),
                    size: CGSize(
                        width: createButton.frame.width,
                        height: createButton.frame.height))
                
                
                self.cBackground.isHidden = false
                self.cBackground.drawAnimatedCircularMask(startFrame: rect2, duration: 0.6, revealType: RevealType.reveal)
                print(self.createButton.center.x)
                print(self.createButton.center.y)
                print(UIScreen.main.bounds.height)
                
                
                        UIView.animate(withDuration: 0.5, animations: {
                    //closed
                   // self.cBackground.transform = .identity
                    self.createButton.transform = CGAffineTransform(rotationAngle: 45 * ( .pi / 180) )
                    self.createButton.backgroundColor = UIColor.gray
                    //self.cBackground.alpha = 1
                           
                        }, completion:  { finished in
                            self.cword.becomeFirstResponder()} )
                }
                
           
        
    }
    
   
    @IBAction func historyButtonClick(_ sender: UIButton) {
        if appStatus != 4{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.activeIndicator.center.x = self.historyButton.center.x
                
                self.pBackGround.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                
                self.hBackGround.transform = .identity
                
            })
            appStatus = 4
            
           
                readValues()
                
            
        
        }}

    
    
    
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
                  
                    
                    
                    self.dBackGround.isHidden = false
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.dBackGround.alpha = 1
                    })
                    
                    self.resultLabel.text = metadataObj.stringValue!
                    
                    //相机扫码并显示弹窗
                    
                    let elapsed = CACurrentMediaTime() - lastesttime
                    
                    if(elapsed>5 || lastresult != metadataObj.stringValue!)
                    
                    {
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    let timeString = formatter.string(from: Date())
                    print(metadataObj.stringValue!)
                    print(timeString)
                    
                    let insertHistory = self.historyTable.insert(self.content <- metadataObj.stringValue!, self.scantime <- timeString)
                    
                    do{
                        try self.database.run(insertHistory)
                        print("Inserted")
                    }catch{
                        print("error")
                    }
                
                    
                    
                    }
                    
                    lastesttime = CACurrentMediaTime()
                    lastresult = metadataObj.stringValue!
                    
                    
                    
                    
                    
                }
                
            
            
                }}
        
}
    
    
