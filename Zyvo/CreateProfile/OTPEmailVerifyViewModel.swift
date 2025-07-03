//
//  OTPEmailVerifyViewModel.swift
//  Zyvo
//
//  Created by ravi on 24/01/25.
//


import Combine
import Foundation

class OTPEmailVerifyViewModel {
   
    @Published var otpCode: String = ""
    var userID : String = ""
   
    @Published var errorMessage: String?
    @Published var isOtpValid: Bool = false
    @Published var canResend: Bool = true
    @Published var timerText: String = "02:00"
  
    @Published var emailVerifiedResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var emailUpdateVerifiedResult:Result<BaseResponse<EmptyModel>,Error>? = nil
  
    private var cancellables = Set<AnyCancellable>()
    private var runCount = 60
    private var timer: Timer?
    
    var email = ""
    var comesFrom = ""
    var Otp = ""
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $otpCode
            .map { $0.count == 4 }
            .assign(to: \.isOtpValid, on: self)
            .store(in: &cancellables)
    }
    
    func validateOtp() -> Bool {
        print(Otp,"Otp")
        print(otpCode,"otpCode")
        print(otpCode.count,"otpCode.count")
        if otpCode.count != 4 {
            print(otpCode)
            print(otpCode.count)
            errorMessage = "Enter Verification Code"
          topViewController?.AlertControllerOnr(title: "Alert!", message: errorMessage)
            return false
        }
//        else if otpCode != Otp {
//            errorMessage = "OTP is Incorrect!"
//            topViewController?.AlertControllerOnr(title: "Alert!", message: errorMessage)
//            return false
//        }
        return true
    }
    
    func updateOTPText(_ newText: String) {
        otpCode = newText
        
    }
    
    func startResendTimer() {
        canResend = false
        runCount = 60
        var time1 = 60
        timerText = "01:59"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.runCount -= 1
            if self.runCount >= 10 {
                self.timerText = "01:\(String(self.runCount))"
            } else if self.runCount >= 0 {
                self.timerText = "01:0\(String(self.runCount))"
            }
            
            if self.runCount == 0 {
                
                timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    time1 -= 1
                    if time1 <= 60 {
                        self.timerText = "00:\(String(time1))"
                    }
                    if time1 >= 10 {
                        self.timerText = "00:0\(String(time1))"
                    }
                    
                    if time1 == 1 {
                        
                        timer.invalidate()
                        self.canResend = true
                        self.timerText = "00:00"
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension OTPEmailVerifyViewModel{
    
    func verifyEmailOtp(){
        var para = [String:Any]()
        para[APIKeys.userID] = userID
        para[APIKeys.Otp] = otpCode
        APIServices<EmptyModel>().post(endpoint: .otpverifyemailverification, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.emailVerifiedResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.emailVerifiedResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: "Invalid OTP")
                   // topViewController?.AlertControllerOnr(title: "Alert!", message: "Invalid OTP")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    func verifyEmailUpdateOtp(){
        var para = [String:Any]()
        para[APIKeys.userID] = userID
        para[APIKeys.Otp] = otpCode
        APIServices<EmptyModel>().post(endpoint: .otp_verify_update_email, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.emailUpdateVerifiedResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.emailUpdateVerifiedResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: "Invalid OTP")
                   // topViewController?.AlertControllerOnr(title: "Alert!", message: "Invalid OTP")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    
    
   
    
}
