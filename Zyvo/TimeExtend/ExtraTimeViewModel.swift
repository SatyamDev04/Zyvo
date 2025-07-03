//
//  ExtraTimeViewModel.swift
//  Zyvo
//
//  Created by ravi on 4/03/25.
//


import Combine
import Foundation
import UIKit

class ExtraTimeViewModel:NSObject {
    @Published var errorMessage: String?
   
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    
    @Published var extension_time: Int = 0
    
    @Published var cardID: String = ""
    
    @Published var service_fee: String = ""
    @Published var discount_amount: String = ""
    @Published var tax: String = ""
    @Published var customer_id: String = ""
    @Published var extension_total_amount: String = ""
    @Published var extension_booking_amount: String = ""
    @Published var cleaning_fee: String = ""
   
    
    
    @Published var isProfileValid: Bool = false
    
    @Published var getExtratimeResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension ExtraTimeViewModel {
    
    func apiForGetExtraTime(BookingID:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.extension_time] = extension_time
        para[APIKeys.service_fee] = self.service_fee
        para[APIKeys.tax] = self.tax
        para[APIKeys.cleaning_fee] = self.cleaning_fee
        para[APIKeys.bookingid] = BookingID
        para[APIKeys.discount_amount] = self.discount_amount
        para[APIKeys.extension_total_amount] = self.extension_total_amount
        para[APIKeys.extension_booking_amount] = self.extension_booking_amount
       
        para[APIKeys.cardID] = self.cardID
       
        para[APIKeys.customerid] = self.customer_id
        
     
        APIServices<EmptyModel>().post(endpoint: .get_booking_extension_time_amount, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getExtratimeResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getExtratimeResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
}

