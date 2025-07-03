//
//  CellHost.swift
//  Zyvo
//
//  Created by ravi on 19/11/24.
//

import UIKit

class CellHost: UICollectionViewCell {

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainV.layer.cornerRadius = 15
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
