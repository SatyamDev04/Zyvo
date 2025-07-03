//
//  SorryVC.swift
//  Zyvo
//
//  Created by ravi on 13/12/24.
//

import UIKit

class SorryVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
