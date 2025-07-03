//
//  EmailLoginViewModel.swift
//  Zyvo
//
//  Created by ravi on 22/01/25.
//

import Combine
import Foundation
import UIKit

class EmailLoginViewModel {
    
    @Published var email: String = ""
    @Published var Password: String = ""
   // @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignUpValid: Bool = false
    @Published var emailLoginResult:Result<BaseResponse<EmailLoginModel>,Error>? = nil
    
    @Published var socialsignUpResult:Result<BaseResponse<SocialSignUpModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest( $email, $Password)
            .map { email, newPassword in
                return self.validate( email: email, Password: newPassword)
            }
            .assign(to: \.isSignUpValid, on: self)
            .store(in: &cancellables)
    }
    
    
    private func validate( email: String, Password: String) -> Bool {
       
        if email.isEmpty {
            errorMessage = "Email can’t be empty."
            return false
        }
        guard validateEmail(email) else{return false}
        
        if Password.isEmpty {
            errorMessage = "Password can't be empty."
            return false
        }
        
        if !Password.isPasswordValid() {
            errorMessage = "Password must have at least one Uppercase, one Lowercase alphabet, one special character, and one numeric character."
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Email can't be empty."
            return false
        } else if email.isNumeric {
            if !email.isValidPhone() {
                errorMessage = "Please enter a valid phone number."
                return false
            }
        } else if !email.isValidEmail() {
            errorMessage = "Please enter a valid email."
            return false
        }
        errorMessage = "Password can't be empty."
        return true
    }
}

extension EmailLoginViewModel {
   
    func loginByEmailApi(){
        var para : [String:Any] = [:]
        para[APIKeys.email] = self.email
        para[APIKeys.password] = self.Password
        
        para[APIKeys.device_type] = "ios"
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token: \(fcmToken)")
            para[APIKeys.fcmToken] = "\(fcmToken)"
          
        } else {
            print("No FCM Token found")
        }
       
        APIServices<EmailLoginModel>().post(endpoint: .loginByEmail, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.emailLoginResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.emailLoginResult = .success(response)
                }else{
                   // self.emailLoginResult = .success(response)
                    guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                                            return
                                        }
                    topViewController.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
//    func signUpApiforget(name:String,Email:String,password:String){
//        var para : [String:Any] = [:]
//        para[APIKeys.email] = Email
//        para[APIKeys.name] = name
//        para[APIKeys.password] = password
//
//        APIServices<SignUpData>().post(endpoint: .usersignup, parameters: para)
//            .receive(on: DispatchQueue.main)
//            .sink { complition in
//                switch complition {
//
//                case .finished:
//                    print("Request Completed")
//                case .failure(let error):
//                    self.signUpResult = .failure(error)
//                    print("Error: \(error.localizedDescription)")
//                }
//
//            } receiveValue: { response in
//                if response.success ?? false {
//                    self.signUpResult = .success(response)
//
//                }else{
//
//                    topViewController?.showAlert(for: response.message ?? "")
//                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
//
//                }
//            }.store(in: &cancellables)
//
//    }
//
//
//    func apiforSocialLogin(name:String,Email:String,socialID:String){
//
//         var para : [String:Any] = [:]
//        let delegate = AppDelegate.shared
//              let token = delegate.deviceToken
//
//        // print(token,"TOKEN")
//        para["fcm_token"] = token
//        para["device_type"] = "ios"
//         para[APIKeys.email] = Email
//         para[APIKeys.name] = name
//         para[APIKeys.social_id] = socialID
//
//         APIServices<SocialSignUpModel>().post(endpoint: .usersociallogin, parameters: para)
//             .receive(on: DispatchQueue.main)
//             .sink { complition in
//                 switch complition {
//
//                 case .finished:
//                     print("Request Completed")
//                 case .failure(let error):
//                     self.socialsignUpResult = .failure(error)
//                     print("Error: \(error.localizedDescription)")
//                 }
//
//             } receiveValue: { response in
//                 if response.success ?? false {
//                     self.socialsignUpResult = .success(response)
//
//                 }else{
//                    // topViewController?.showAlert(for: response.message ?? "")
//                     topViewController?.topmostViewController().showAlert(for: response.message ?? "")
//                     //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
//
//                 }
//             }.store(in: &cancellables)

     }


