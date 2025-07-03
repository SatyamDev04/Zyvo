//
//  HomeDataFilterViewModel.swift
//  Zyvo
//
//  Created by ravi on 6/03/25.
//

import Combine
import Foundation
import UIKit

class HomeDataFilterViewModel:NSObject {
   
    @Published  var allowsPets: String = ""
    @Published  var selfCheckIn: String = ""
    @Published  var activities: [String] = []
    @Published  var language: [String] = []
    @Published  var amenities: [String] = []
    @Published var instantbooking: String = ""
    @Published var bathroom: String = ""
    @Published var bedroom: String = ""
    @Published var propertysize: String = ""
    @Published var peoplecount: String = ""
    @Published var timess: Int = 0
    @Published var datess: String = ""
    @Published var locationss: String = ""
    @Published  var maximumprice: String = ""
    @Published var minimumprice: String = ""
    @Published var placetype: String = ""
    
    @Published var isProfileValid: Bool = false
    
    @Published var getDataHomeFilterResult:Result<BaseResponse<[HomeDataModel]>,Error>? = nil
    
    @Published var minMaxResult:Result<BaseResponse<MinMaxRangeModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension HomeDataFilterViewModel {
    
    func apiForFilterHomeData(){
        var para = [String:Any]()
       
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.placetype] = self.placetype
        para[APIKeys.minimumprice] = self.minimumprice
        para[APIKeys.maximumprice] = self.maximumprice
        para[APIKeys.location] = self.locationss
        para[APIKeys.date] = self.datess
        para[APIKeys.time] = self.timess
        para[APIKeys.peoplecount] = self.peoplecount
        para[APIKeys.propertysize] = self.propertysize
        para[APIKeys.bedroom] = self.bedroom
        para[APIKeys.bathroom] = self.bathroom
        para[APIKeys.instantbooking] = self.instantbooking
        para[APIKeys.amenities] = self.amenities
        para[APIKeys.activities] = self.activities
        para[APIKeys.selfCheckIn] = self.selfCheckIn
        para[APIKeys.allowsPets] = self.allowsPets
        para[APIKeys.languages] = self.language
        
       
        APIServices<[HomeDataModel]>().post(endpoint: .set_home_data_filter, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getDataHomeFilterResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getDataHomeFilterResult = .success(response)
                }else {
                    self.getDataHomeFilterResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiforMinMaxRange(){
        var para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<MinMaxRangeModel>().get(endpoint: .get_property_price_range, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.minMaxResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.minMaxResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
}

