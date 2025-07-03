//
//  HomeDataViewModel.swift
//  Zyvo
//
//  Created by ravi on 30/01/25.
//

import Combine
import Foundation
import UIKit

class HomeDataViewModel :NSObject{
    
  
    @Published var getHomeDataResult:Result<BaseResponse<[HomeDataModel]>,Error>? = nil
    
    @Published var getWishlistRemoveResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var getUserBookingResult:Result<BaseResponse<UserBookingModel>,Error>? = nil
    
    @Published var chatTokenModelResult:Result<BaseResponse<chatTokenModel>,Error>? = nil
    
   var latitude = ""
    var longitude = ""
   var  datss = ""
    var hourss = 2
    var start_time = ""
    var end_time = ""
    var activity = ""
    var locationss = ""
    
    var bookingDate = ""
    var bookingStart = ""
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension HomeDataViewModel {
    
    func apiforGetBookedPropertyTimer(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.booking_date] = self.bookingDate
        para[APIKeys.booking_start] = self.bookingStart
        
        APIServices<UserBookingModel>().postWithoutAutherization(endpoint: .getuserbookings, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getUserBookingResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getUserBookingResult = .success(response)
                }else {
                    self.getUserBookingResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    func apiforGetHomeDataWithoutLogin(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<[HomeDataModel]>().post(endpoint: .gethomedata, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getHomeDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getHomeDataResult = .success(response)
                }else {
                    
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    
    func apiforGetChatToken(role:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.role] = role
        APIServices<chatTokenModel>().postWithoutAutherization(endpoint: .chattoken, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.chatTokenModelResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.chatTokenModelResult = .success(response)
                }else {
                    self.chatTokenModelResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    func apiforGetHomeData(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.latitude] = self.latitude
        para[APIKeys.longitude] = self.longitude
        
        para[APIKeys.date] = self.datss
       //para[APIKeys.hourss] = self.hourss
        para[APIKeys.starttime] = self.start_time
        para[APIKeys.endtime] = self.end_time
        para[APIKeys.activity] = self.activity
        para[APIKeys.location] = self.locationss
        
        APIServices<[HomeDataModel]>().post(endpoint: .gethomedata, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getHomeDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getHomeDataResult = .success(response)
                }else {
                    self.getHomeDataResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
    func apiforRemoveFromWishlist(propertyID:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = propertyID
       
        APIServices<EmptyModel>().post(endpoint: .remove_item_from_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getWishlistRemoveResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getWishlistRemoveResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }

}



