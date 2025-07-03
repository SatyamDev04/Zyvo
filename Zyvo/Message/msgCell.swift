//
//  msgCell.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit

class msgCell: UITableViewCell {

    @IBOutlet weak var lbl_PropertyTitle: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var view_online: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var mainV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        img.makeCircular()
        img.contentMode = .scaleAspectFill
        
        mainV.layer.cornerRadius = 10
        mainV.layer.borderWidth = 1
        mainV.layer.borderColor = UIColor.lightGray.cgColor
        
        img.layer.cornerRadius = img.layer.frame.height / 2
      
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 4
        view_Photo.layer.borderColor = UIColor.init(red: 234/255, green: 239/255, blue: 244/255, alpha: 0.9).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        lbl_time.text = ""
//        lbl_message.text = ""
//        userName.text = ""
//    }
}
