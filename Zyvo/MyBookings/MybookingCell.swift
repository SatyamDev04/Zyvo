//
//  MybookingCell.swift
//  Zyvo
//
//  Created by ravi on 18/11/24.
//

import UIKit

class MybookingCell: UITableViewCell {

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var btnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var btn_title: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.layer.cornerRadius = 15
        btn_title.layer.cornerRadius = btn_title.layer.frame.height / 2
        
        view_Main.layer.cornerRadius = 10
        view_Main.layer.borderWidth = 1
        view_Main.layer.borderColor = UIColor.lightGray.cgColor
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
