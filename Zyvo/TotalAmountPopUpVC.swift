//
//  TotalAmountPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit

class TotalAmountPopUpVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    var TotalAmount = ""
    @IBOutlet weak var lbl_totalAmount: UILabel!
    var backAction:(_ str1 : String,_ str2 : String ) -> () = { str1, str2 in}
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_totalAmount.text = " Your new total amout is \(TotalAmount)"
        
        btnYes.layer.cornerRadius = btnYes.layer.frame.height / 2
        
        
        btnCancel.layer.cornerRadius = btnCancel.layer.frame.height / 2
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.init(red: 74/255, green: 237/255, blue: 177/255, alpha: 1).cgColor
    }
    
    @IBAction func btnYes_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("Yes", "\(self.TotalAmount)")
                }
    }
    @IBAction func btnCancel_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("No", "")
                }
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.backAction("No", "")
                }
    }

}
