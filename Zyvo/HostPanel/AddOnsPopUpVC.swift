//
//  AddOnsPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 1/01/25.
//

import UIKit

class AddOnsPopUpVC: UIViewController {
    var reason : String = ""
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtOthers: UITextField!
    @IBOutlet weak var viewOthers: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var viewPrice: UIView!
    var backAction: (_ title: String,_ price: String) -> () = {_,_ in}
    var arrTitle = ["Computer Screen","Studio Lights","Projectors","Speakers","Microphones","Sounds Systems","DJ Equipment","Tables","Chairs","Stage PlaMorms","Art Supplies (Paint, brushes)","Art Supplies (Paint, brushes)","Allow Alcohol","Onsite Food Prep (Event)","Extra Person above Max Capacity","Photographer (Per Hour)","Videographer (Per Hour)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add target to observe text field changes
        txtPrice.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Add target to observe text field changes
        txtOthers.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        tblV.register(UINib(nibName: "reasonCell", bundle: nil), forCellReuseIdentifier: "reasonCell")
        tblV.delegate = self
        tblV.dataSource = self
        viewPrice.applyRoundedStyle(cornerRadius: 10)
        viewOthers.applyRoundedStyle(cornerRadius: 10)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtOthers {
            reason = txtOthers.text ?? ""
            print("Current TextField Value: \(reason)")
        }
    }
    
    @IBAction func btnAdd_Tap(_ sender: UIButton) {
        // self.reason = self.txtOthers.text ?? ""
        if reason == ""  || txtPrice.text == ""{
          //  print("Hello Write here")
            
            let alertController = UIAlertController(title: "Alert!",message: "Please enter a valid price and reason.",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            // Present the alert
            self.present(alertController, animated: true)
            
        } else {
            backAction(reason,self.txtPrice.text ?? "")
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
}

extension AddOnsPopUpVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "reasonCell", for: indexPath) as! reasonCell
        cell.lbl_title.text = arrTitle[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reason = arrTitle[indexPath.row]
        self.txtOthers.text = reason
    }
}
