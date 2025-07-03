//
//  ChatCell.swift
//  Zyvo
//
//  Created by ravi on 22/11/24.
//

import UIKit
import TwilioConversationsClient

class ChatCell: UITableViewCell {

  
    @IBOutlet weak var lbl_msg: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setUser(user:String!,imgArr:Media?,messageBody:TCHMessage,user_id:String) {
        print(messageBody,"messageBody")
        
        lbl_msg.text = messageBody.body
       
        img.makeCircular()
        img.contentMode = .scaleAspectFill
       
        lbl_time.text = self.updateLastMsgTime(messageBody.dateUpdated ?? "")
//        if let image = imgArr?.image {
//            self.img.image = image
//        }else {
//            img.image = UIImage(named: "usericon")
//        }
        let conversationsManager = QuickstartConversationsManager.shared.self
        if let conversation = conversationsManager.conversation {
            let s = conversation.participants()
            s.forEach { (per) in
                let identity = per.identity ?? ""
                if identity != "\(user_id)" {
                    let lastReadMessageIndex = per.lastReadMessageIndex as? Int ?? -1
                    let index = messageBody.index as? Int ?? 0
                }
            }
        }
    }
    
    func updateLastMsgTime(_ time:String) -> String{
        print(time)
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
           
            let theFirstDate = Date()
            
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: theSecondDate, to: theFirstDate)
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            }else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            }else if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            }else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            }else if let theNumbe = theComponents.minute, theNumbe > 0 {
               
                if theNumbe >= 1 {
                    return "\(theNumbe)m ago"
                }else{
                    return "now"
                }
            }
        }
        return  "now"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
