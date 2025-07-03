//
//  ServiceCell.swift
//  Zyvo
//
//  Created by ravi on 20/02/25.
//

import UIKit

class ServiceCell: UICollectionViewCell {

    @IBOutlet weak var lbl_serviceName: UILabel!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        mainV.layer.cornerRadius = 10
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
