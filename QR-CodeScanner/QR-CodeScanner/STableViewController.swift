//
//  STableViewController.swift
//  QR-CodeScanner
//
//  Created by Yunlu18 on 2019/1/11.
//  Copyright © 2019 QRteam. All rights reserved.
//

import UIKit
import StoreKit
import Localize_Swift

class STableViewController: UITableViewController {
    
    
    @IBOutlet weak var changLlabel: UILabel!
    
    @IBOutlet weak var creditsLabel: UILabel!
    
    @IBOutlet weak var rateusLabel: UILabel!
    
    @IBOutlet weak var dLabel1: UILabel!
    
    @IBOutlet weak var dLabel2: UILabel!
    
    
    @IBOutlet weak var dLabel3: UILabel!
    
    let availableLanguages = ["en","zh-Hans","ja","zh-HK","de","fr"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setText()
        //print(availableLanguages)
    }

    @objc func setText(){
        rateusLabel.text = "Rate us".localized()
        creditsLabel.text = "Credits".localized()
        changLlabel.text = "Change Language".localized()
        
        
    }
    

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myindex = indexPath.row
        if myindex == 0{
            
          self.tableView.deselectRow(at: indexPath, animated: true)
          SKStoreReviewController.requestReview()
            
            
        }else if myindex == 1{
            self.tableView.deselectRow(at: indexPath, animated: true)
            if let parent = self.parent as? ViewControllerSettings{
                parent.showCreditView()}
            
        }else {
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            for language in availableLanguages {
                let displayName = Localize.displayNameForLanguage(language)
                let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                })
                actionSheet.addAction(languageAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alert: UIAlertAction) -> Void in
            })
            actionSheet.addAction(cancelAction)
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                if actionSheet.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    actionSheet.popoverPresentationController?.sourceView = self.view
                    actionSheet.popoverPresentationController?.sourceRect = self.tableView.cellForRow(at: indexPath)!.frame

                }
            }
            self.present(actionSheet, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
