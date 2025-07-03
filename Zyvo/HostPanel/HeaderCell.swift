//
//  HeaderCell.swift
//  DemoDatewiseData
//
//  Created by YATIN  KALRA on 25/02/25.
//

import UIKit

class HeaderCell: UICollectionViewCell {

    @IBOutlet weak var dateBgV: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet var bgImg: [UIImageView]!
    @IBOutlet var guestNameLbl: [UILabel]!
    @IBOutlet var bookingStatusLbl: [UILabel]!
    @IBOutlet var timeLbl: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
    }
    func configureSlot(at index: Int, with booking: BookingSlots) {
        guestNameLbl[index].text = booking.guestName
        bookingStatusLbl[index].text = booking.bookingStatus
        if bookingStatusLbl[index].text == "confirmed"{
            bgImg[index].image = UIImage(named: "GREENBG")
        }else{
            bgImg[index].image = UIImage(named: "ORANGEBG")
        }
        bookingStatusLbl[index].textColor = booking.bookingStatus == "confirmed" ? .green : .orange
        timeLbl[index].text = booking.bookingStartEnd
        
//            guestNameLbl[index].backgroundColor = booking.booking_status == "confirmed" ? .green : .red
       }
       
       func clearSlot(at index: Int) {
           guestNameLbl[index].text = ""
           bookingStatusLbl[index].text = ""
           timeLbl[index].text = ""
           bookingStatusLbl[index].textColor = .clear
           bgImg[index].image = UIImage(named: "Retângulo 2398")
       }
}
