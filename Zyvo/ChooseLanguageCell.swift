//
//  ChooseLanguageCell.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class ChooseLanguageCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbl_CountryName: UILabel!
    @IBOutlet weak var lbl_LanguageTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderWidth = 0.75
        viewMain.layer.borderColor = UIColor.lightGray.cgColor

       
    }

}
