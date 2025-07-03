//
//  AppDelegate.swift
//  RPG
//
//  Created by Satyam on 07/02/24.
//


import Alamofire
import Combine
import SwiftyJSON
import Lottie

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case encode
    case decode
    case invalidResponse
}

 let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController()
var animationContainerView: UIView?
struct EmptyModel: Decodable {}
typealias DefaultAPIService = APIServices<EmptyModel>
protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?,costumUrl:String?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)?,loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
}

final class APIServices<T: Decodable>: APIServiceProtocol {
    
    func postModel< Parameter: Encodable>(
           endpoint: AppURL.Endpoint,
           parameters: Parameter,
           loader: Bool? = true
       ) -> AnyPublisher<BaseResponse<T>, Error> {
           return Future<BaseResponse<T>, Error> { promise in
               guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                   .windows.first?.rootViewController?.topmostViewController() else {
                   let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                   promise(.failure(error))
                   return
               }
               
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                   "Content-Type": "application/json"
               ]
               
               if loader ?? false {
                   GameLoaderView.show(in: topViewController.view)
               }
               
               print("==========================URL=====================")
               print(endpoint.path)
               print("\n==========================Parameters=====================\n")
               let encoder = JSONEncoder()
               encoder.outputFormatting = .prettyPrinted
               
               do {
                   let jsonData = try encoder.encode(parameters)
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print(jsonString)
                       
                   }
               } catch {
                   print("Error encoding intervals to JSON: \(error)")
                   
               }
               
               print("\n==========================Header=====================\n")
               print(headers)
               AF.request(endpoint.path,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: BaseResponse<T>.self) { response in
                   GameLoaderView.hide(from: topViewController.view)
                   
                   print("\n==========================Response=======================\n")
                   
                   if let data = response.data {
                       print(JSON(data))
                   }
                   print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                   
                   if (response.response?.statusCode ?? 0) == 401 {
                       APIServices<T>.logout()
                   }
                   switch response.result {
                   case .success(let value):
                       promise(.success(value))
                   case .failure(let error):
                       print("==========================failure=====================")
                       print(error)
                       promise(.failure(error))
                   }
               }
           }
           .eraseToAnyPublisher()
       }
    
    func putModel<Parameter: Encodable>(
        endpoint: AppURL.Endpoint,
        parameters: Parameter,
        loader: Bool? = true
    ) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Content-Type": "application/json"
            ]

            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }

            print("==========================URL=====================")
            print(endpoint.path)
            print("\n==========================Parameters=====================\n")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            do {
                let jsonData = try encoder.encode(parameters)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Error encoding parameters to JSON: \(error)")
            }

            print("\n==========================Header=====================\n")
            print(headers)

            AF.request(endpoint.path,
                       method: .put,  // Changed from .post to .put
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)

                print("\n==========================Response=======================\n")
                if let data = response.data {
                    print(JSON(data))
                }
                print(response.response?.statusCode ?? 0, "STATUS CODE ON API RUN")

                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout()
                }

                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool? = true,costumUrl:String? = "") -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
           
            
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json"
                    ]
            if loader ?? false {
                // Call the extension method in another class
            
                GameLoaderView.show(in: topViewController.view)
            }
            
            
          var str =  ""
            if (costumUrl ?? "").isEmpty {
                str = endpoint.path
            }else{
                str = costumUrl ?? ""
            }
            
            AF.request(str, method: .get, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
                  //  LoaderHelper.stopLottieLoader(topViewController.view as! LottieAnimationView)
                  GameLoaderView.hide(from: topViewController.view)
                print("==========================URL=====================")
                    
                    print(str)
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout()
                    }
                    
                    if let data = response.data {
                        print(JSON(data))
                    }
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func postWithOutToken(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               //"Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               //"Accept": "application/json"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout()
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    func postWithoutAutherization(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                       // APIServices<T>.logout()
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func post(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json"
                    ]
            if loader ?? false {
                GameLoaderView.show(in:  topViewController.view)
            }
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseDecodable(of: BaseResponse<T>.self) { response in
//
                    GameLoaderView.hide(from: topViewController.view)
                    
            print("\n==========================Parameters=====================\n")
                    print(parameters)
            print("\n==========================Header=====================\n")
                    print(headers)
            print("\n==========================Response=======================\n")
                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                    if (response.response?.statusCode ?? 0) == 401 {
                        APIServices<T>.logout()
                    }
                    if let data = response.data {
                        print(JSON(data))
                    }
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        print("==========================failure=====================")
                        print(error)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
        return Future<BaseResponse<T>, Error> { promise in

            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
               "Accept": "application/json"
                    ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                // Add parameters
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                // Add images
                let name = Date.getCurrentDateForName()
                var i = 0
                if let images = images {
        print("==========================ImageParameters=====================")
                    for (key, imageData) in images {
                        multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                        print("data ==>", imageData, "withName ==>", key, "fileName==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
                        i += 1
                    }
                }
            }, to: endpoint.path, headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
               
                progressHandler?(progress.fractionCompleted)
            }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
             
                print("\n==========================Parameters=====================\n")
                print(parameters)
                print("\n==========================Header=====================\n")
                print(headers)
                print("\n==========================Response=======================\n")
                
                print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                
                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout()
                }
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func SendAnyThing(endpoint: AppURL.Endpoint, parameters: [String: Any],images: [String: Data]?,progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
         return Future<BaseResponse<T>, Error> { promise in
             guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                 let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                 promise(.failure(error))
                 return
             }
             let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json"
            ]
             if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
             }
             AF.upload(multipartFormData: { multipartFormData in
                 for (key, value) in parameters {
                     if let arrayValue = value as? [Any] {
                         arrayValue.forEach { value in
                             if let data = "\(value)".data(using: .utf8) {
                                 multipartFormData.append(data, withName: key)
                             }
                         }
                     } else if let stringValue = "\(value)".data(using: .utf8) {
                         multipartFormData.append(stringValue, withName: key)
                     }
                 }
                 // Add images
                 let name = Date.getCurrentDateForName()
                 var i = 0
                 if let images = images {
         print("==========================ImageParameters=====================")
                     for (key, imageData) in images {
                             multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
                      
         print("data ==>",imageData,"withName ==>",key,"fileName==>","\(name)\(i).jpeg","mimeType ==>" ,"image/jpeg")
                         i += 1
                     }
                 }
             }, to: endpoint.path,headers: headers)
             .uploadProgress { progress in
             print("Upload Progress: \(progress.fractionCompleted)")
                 GameLoaderView.show(in: topViewController.view)
                 progressHandler?(progress.fractionCompleted)
              }
             .validate(statusCode: 200..<300)
             .responseDecodable(of: BaseResponse<T>.self) { response in
                 GameLoaderView.hide(from: topViewController.view)
                 print("==========================URL=====================")
                 print(endpoint.path)
                print("\n==========================Parameters=====================\n")
                 for (key, value) in parameters {
                     print("\(key): \(value)")
                 }
                 print("\n==========================Header=====================\n")
                             print(headers )
                print("\n==========================Response=======================\n")
        
                 print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
                 
                 if (response.response?.statusCode ?? 0) == 401 {
                     APIServices<T>.logout()
                 }
                 if let data = response.data {
                     print(JSON(data))
                 }

                 switch response.result {
                 case .success(let value):
                     promise(.success(value))
                 case .failure(let error):
                     print("==========================failure=====================")
                     print(error.localizedDescription)
                     promise(.failure(error))
                 }
             }
         }
         .eraseToAnyPublisher()
     }
    
    func postMultipart(
        endpoint: AppURL.Endpoint,
        parameters: [String: Any],
        files: [(data: Data, fileName: String, mimeType: String, key: String)],
        loader: Bool? = true
    ) -> AnyPublisher<BaseResponse<T>, Error> {
        
        return Future<BaseResponse<T>, Error> { promise in
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.rootViewController?.topmostViewController() else {
                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                promise(.failure(error))
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
                "Accept": "application/json"
            ]
            
            if loader ?? false {
                GameLoaderView.show(in: topViewController.view)
            }
            
            print("==========================URL=====================")
            print(endpoint.path)
            
            AF.upload(multipartFormData: { multipartFormData in
                // Add parameters
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        multipartFormData.append(Data(stringValue.utf8), withName: key)
                    } else if let intValue = value as? Int {
                        multipartFormData.append(Data("\(intValue)".utf8), withName: key)
                    } else if let boolValue = value as? Bool {
                        multipartFormData.append(Data("\(boolValue)".utf8), withName: key)
                    } else if let arrayValue = value as? [String] {
                        for item in arrayValue {
                            multipartFormData.append(Data(item.utf8), withName: "\(key)[]") // ✅ Handles array parameters (like dob[])
                        }
                    }
                }

                
                // Add files (images, PDFs, etc.)
                for file in files {
                    multipartFormData.append(file.data, withName: file.key, fileName: file.fileName, mimeType: file.mimeType)
                }
                
            }, to: endpoint.path, method: .post, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: BaseResponse<T>.self) { response in
                GameLoaderView.hide(from: topViewController.view)
                
                print("\n==========================Parameters=====================\n")
                print(parameters)
                print("\n==========================Headers=====================\n")
                print(headers)
                print("\n==========================Response=======================\n")
                print(response.response?.statusCode ?? 0, "STATUS CODE ON API RUN")
                
                if (response.response?.statusCode ?? 0) == 401 {
                    APIServices<T>.logout()
                }
                
                if let data = response.data {
                    print(JSON(data))
                }
                
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("==========================Failure=====================")
                    print(error)
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static private func logout(){
           guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                          let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                          return
                      }
           topViewController.showOkAlertWithHandler("Unauthorized") {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
               UserDetail.shared.setUserId("")
               UserDetail.shared.removeTokenWith()
               topViewController.hidesBottomBarWhenPushed = true
               topViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
               topViewController.navigationController?.pushViewController(newViewController, animated: true)
           }
       }
}

//extension UIViewController {
//    func topmostViewController() -> UIViewController {
//        if let presentedViewController = presentedViewController {
//            return presentedViewController.topmostViewController()
//        }
//        if let navigationController = self as? UINavigationController {
//            return navigationController.visibleViewController?.topmostViewController() ?? navigationController
//        }
//        if let tabBarController = self as? UITabBarController {
//            return tabBarController.selectedViewController?.topmostViewController() ?? tabBarController
//        }
//        return self
//    }
//}

extension UIViewController {
    
    func topmostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topmostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topmostViewController() ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topmostViewController() ?? tabBarController
        }
        return self
    }

func safePresent(alertController: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
       let topVC = topmostViewController()

      // Check if an alert is already presented
      if topVC is UIAlertController {
          print("An alert is already being presented.")
          return
      }

      topVC.present(alertController, animated: animated, completion: completion)
  }
}

extension Result {
    func handle(success: @escaping (Success) -> Void) {
        switch self {
        case .success(let value):
            success(value)
           case .failure(let error):
            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
                _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
                return
                }
            topViewController.AlertControllerOnr(title: "", message: "\(error.localizedDescription)")
        }
    }
}



////
////  AppDelegate.swift
////  RPG
////
////  Created by Satyam on 07/02/24.
////
//
//
//import Alamofire
//import Combine
//import SwiftyJSON
//import Lottie
//
//enum ServiceError: Error {
//    case url(URLError)
//    case urlRequest
//    case encode
//    case decode
//    case invalidResponse
//}
//
// let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController()
//var animationContainerView: UIView?
//struct EmptyModel: Decodable {}
//typealias DefaultAPIService = APIServices<EmptyModel>
//protocol APIServiceProtocol {
//    associatedtype Model: Decodable
//    
//    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
//    func post(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
//    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)?,loader:Bool?) -> AnyPublisher<BaseResponse<Model>, Error>
//}
//
//final class APIServices<T: Decodable>: APIServiceProtocol {
//    
//    func get(endpoint: AppURL.Endpoint, parameters: [String: Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
//        return Future<BaseResponse<T>, Error> { promise in
//            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                promise(.failure(error))
//                return
//            }
//            print("==========================URL=====================")
//            
//            print(endpoint.path)
//            
//            let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
//               "Accept": "application/json"
//                    ]
//            if loader ?? false {
//                // Call the extension method in another class
//            
//                GameLoaderView.show(in: topViewController.view)
//            }
//            AF.request(endpoint.path, method: .get, parameters: parameters, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseDecodable(of: BaseResponse<T>.self) { response in
//                  //  LoaderHelper.stopLottieLoader(topViewController.view as! LottieAnimationView)
//                  GameLoaderView.hide(from: topViewController.view)
//                    
//            print("\n==========================Parameters=====================\n")
//                    print(parameters)
//            print("\n==========================Header=====================\n")
//                    print(headers)
//            print("\n==========================Response=======================\n")
//                    
//                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
//                    
//                    if (response.response?.statusCode ?? 0) == 401 {
//                        APIServices<T>.logout()
//                    }
//                    
//                    if let data = response.data {
//                        print(JSON(data))
//                    }
//                    
//                    switch response.result {
//                    case .success(let value):
//                        promise(.success(value))
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        promise(.failure(error))
//                    }
//                }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    func post(endpoint: AppURL.Endpoint, parameters: [String:Any],loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
//        return Future<BaseResponse<T>, Error> { promise in
//            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                promise(.failure(error))
//                return
//            }
//            let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
//               "Accept": "application/json"
//                    ]
//            if loader ?? false {
//                GameLoaderView.show(in:  topViewController.view)
//            }
//            print("==========================URL=====================")
//            print(endpoint.path)
//            
//            AF.request(endpoint.path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseDecodable(of: BaseResponse<T>.self) { response in
////
//                    GameLoaderView.hide(from: topViewController.view)
//                    
//            print("\n==========================Parameters=====================\n")
//                    print(parameters)
//            print("\n==========================Header=====================\n")
//                    print(headers)
//            print("\n==========================Response=======================\n")
//                    print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
//                    if (response.response?.statusCode ?? 0) == 401 {
//                        APIServices<T>.logout()
//                    }
//                    if let data = response.data {
//                        print(JSON(data))
//                    }
//                    switch response.result {
//                    case .success(let value):
//                        promise(.success(value))
//                    case .failure(let error):
//                        print("==========================failure=====================")
//                        print(error)
//                        promise(.failure(error))
//                    }
//                }
//        }
//        .eraseToAnyPublisher()
//    }
//
//    func post(endpoint: AppURL.Endpoint, parameters: [String: Any], images: [String: Data]?, progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
//        return Future<BaseResponse<T>, Error> { promise in
//
//            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                promise(.failure(error))
//                return
//            }
//            
//            let headers: HTTPHeaders = [
//               "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
//               "Accept": "application/json"
//                    ]
//            
//            if loader ?? false {
//                GameLoaderView.show(in: topViewController.view)
//            }
//            
//            AF.upload(multipartFormData: { multipartFormData in
//                // Add parameters
//                for (key, value) in parameters {
//                    if let data = "\(value)".data(using: .utf8) {
//                        multipartFormData.append(data, withName: key)
//                    }
//                }
//                
//                // Add images
//                let name = Date.getCurrentDateForName()
//                var i = 0
//                if let images = images {
//        print("==========================ImageParameters=====================")
//                    for (key, imageData) in images {
//                        multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
//                        print("data ==>", imageData, "withName ==>", key, "fileName==>", "\(name)\(i).jpeg", "mimeType ==>", "image/jpeg")
//                        i += 1
//                    }
//                }
//            }, to: endpoint.path, headers: headers)
//            .uploadProgress { progress in
//                print("Upload Progress: \(progress.fractionCompleted)")
//               
//                progressHandler?(progress.fractionCompleted)
//            }
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: BaseResponse<T>.self) { response in
//                GameLoaderView.hide(from: topViewController.view)
//             
//                print("\n==========================Parameters=====================\n")
//                print(parameters)
//                print("\n==========================Header=====================\n")
//                print(headers)
//                print("\n==========================Response=======================\n")
//                
//                print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
//                
//                if (response.response?.statusCode ?? 0) == 401 {
//                    APIServices<T>.logout()
//                }
//                
//                if let data = response.data {
//                    print(JSON(data))
//                }
//                
//                switch response.result {
//                case .success(let value):
//                    promise(.success(value))
//                case .failure(let error):
//                    print("==========================failure=====================")
//                    print(error)
//                    promise(.failure(error))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    func postMultipart(
//        endpoint: AppURL.Endpoint,
//        parameters: [String: Any],
//        files: [(data: Data, fileName: String, mimeType: String, key: String)],
//        loader: Bool? = true
//    ) -> AnyPublisher<BaseResponse<T>, Error> {
//        
//        return Future<BaseResponse<T>, Error> { promise in
//            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
//                .windows.first?.rootViewController?.topmostViewController() else {
//                let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                promise(.failure(error))
//                return
//            }
//            
//            let headers: HTTPHeaders = [
//                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
//                "Accept": "application/json"
//            ]
//            
//            if loader ?? false {
//                GameLoaderView.show(in: topViewController.view)
//            }
//            
//            print("==========================URL=====================")
//            print(endpoint.path)
//            
//            AF.upload(multipartFormData: { multipartFormData in
//                // Add parameters
//                for (key, value) in parameters {
//                    if let stringValue = value as? String {
//                        multipartFormData.append(Data(stringValue.utf8), withName: key)
//                    } else if let intValue = value as? Int {
//                        multipartFormData.append(Data("\(intValue)".utf8), withName: key)
//                    } else if let boolValue = value as? Bool {
//                        multipartFormData.append(Data("\(boolValue)".utf8), withName: key)
//                    } else if let arrayValue = value as? [String] {
//                        for item in arrayValue {
//                            multipartFormData.append(Data(item.utf8), withName: "\(key)[]") // ✅ Handles array parameters (like dob[])
//                        }
//                    }
//                }
//
//                
//                // Add files (images, PDFs, etc.)
//                for file in files {
//                    multipartFormData.append(file.data, withName: file.key, fileName: file.fileName, mimeType: file.mimeType)
//                }
//                
//            }, to: endpoint.path, method: .post, headers: headers)
//            .validate(statusCode: 200..<600)
//            .responseDecodable(of: BaseResponse<T>.self) { response in
//                GameLoaderView.hide(from: topViewController.view)
//                
//                print("\n==========================Parameters=====================\n")
//                print(parameters)
//                print("\n==========================Headers=====================\n")
//                print(headers)
//                print("\n==========================Response=======================\n")
//                print(response.response?.statusCode ?? 0, "STATUS CODE ON API RUN")
//                
//                if (response.response?.statusCode ?? 0) == 401 {
//                    APIServices<T>.logout()
//                }
//                
//                if let data = response.data {
//                    print(JSON(data))
//                }
//                
//                switch response.result {
//                case .success(let value):
//                    promise(.success(value))
//                case .failure(let error):
//                    print("==========================Failure=====================")
//                    print(error)
//                    promise(.failure(error))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    func SendAnyThing(endpoint: AppURL.Endpoint, parameters: [String: Any],images: [String: Data]?,progressHandler: ((Double) -> Void)? = nil,loader:Bool? = true) -> AnyPublisher<BaseResponse<T>, Error> {
//         return Future<BaseResponse<T>, Error> { promise in
//             guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                 let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                 promise(.failure(error))
//                 return
//             }
//             let headers: HTTPHeaders = [
//                "Authorization": "Bearer \(UserDetail.shared.getTokenWith())",
//                "Accept": "application/json"
//                     ]
//             if loader ?? false {
//                GameLoaderView.show(in: topViewController.view)
//             }
//             AF.upload(multipartFormData: { multipartFormData in
//                 for (key, value) in parameters {
//                     if let arrayValue = value as? [Any] {
//                         arrayValue.forEach { value in
//                             if let data = "\(value)".data(using: .utf8) {
//                                 multipartFormData.append(data, withName: key)
//                             }
//                         }
//                     } else if let stringValue = "\(value)".data(using: .utf8) {
//                         multipartFormData.append(stringValue, withName: key)
//                     }
//                 }
//                 // Add images
//                 let name = Date.getCurrentDateForName()
//                 var i = 0
//                 if let images = images {
//         print("==========================ImageParameters=====================")
//                     for (key, imageData) in images {
//                             multipartFormData.append(imageData, withName: key, fileName: "\(name).jpeg", mimeType: "image/jpeg")
//                      
//         print("data ==>",imageData,"withName ==>",key,"fileName==>","\(name)\(i).jpeg","mimeType ==>" ,"image/jpeg")
//                         i += 1
//                     }
//                 }
//             }, to: endpoint.path,headers: headers)
//             .uploadProgress { progress in
//             print("Upload Progress: \(progress.fractionCompleted)")
//                 GameLoaderView.show(in: topViewController.view)
//                 progressHandler?(progress.fractionCompleted)
//              }
//             .validate(statusCode: 200..<300)
//             .responseDecodable(of: BaseResponse<T>.self) { response in
//                 GameLoaderView.hide(from: topViewController.view)
//                 print("==========================URL=====================")
//                 print(endpoint.path)
//                print("\n==========================Parameters=====================\n")
//                 for (key, value) in parameters {
//                     print("\(key): \(value)")
//                 }
//                 print("\n==========================Header=====================\n")
//                             print(headers )
//                print("\n==========================Response=======================\n")
//        
//                 print(response.response?.statusCode ?? 0,"STATUS CODE ON API RUN")
//                 
//                 if (response.response?.statusCode ?? 0) == 401 {
//                     APIServices<T>.logout()
//                 }
//                 if let data = response.data {
//                     print(JSON(data))
//                 }
//
//                 switch response.result {
//                 case .success(let value):
//                     promise(.success(value))
//                 case .failure(let error):
//                     print("==========================failure=====================")
//                     print(error.localizedDescription)
//                     promise(.failure(error))
//                 }
//             }
//         }
//         .eraseToAnyPublisher()
//     }
//    
//    static private func logout(){
//           guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                          let error = NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                          return
//                      }
//           topViewController.showOkAlertWithHandler("Unauthorized") {
//               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//               let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//               UserDetail.shared.setUserId("")
//               UserDetail.shared.removeTokenWith()
//               topViewController.hidesBottomBarWhenPushed = true
//               topViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//               topViewController.navigationController?.pushViewController(newViewController, animated: true)
//           }
//       }
//}
//
////extension UIViewController {
////    func topmostViewController() -> UIViewController {
////        if let presentedViewController = presentedViewController {
////            return presentedViewController.topmostViewController()
////        }
////        if let navigationController = self as? UINavigationController {
////            return navigationController.visibleViewController?.topmostViewController() ?? navigationController
////        }
////        if let tabBarController = self as? UITabBarController {
////            return tabBarController.selectedViewController?.topmostViewController() ?? tabBarController
////        }
////        return self
////    }
////}
//
//extension UIViewController {
//    func topmostViewController() -> UIViewController {
//        if let presentedViewController = presentedViewController {
//            return presentedViewController.topmostViewController()
//        }
//        if let navigationController = self as? UINavigationController {
//            return navigationController.visibleViewController?.topmostViewController() ?? navigationController
//        }
//        if let tabBarController = self as? UITabBarController {
//            return tabBarController.selectedViewController?.topmostViewController() ?? tabBarController
//        }
//        return self
//    }
//
//func safePresent(alertController: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
//       let topVC = topmostViewController()
//
//      // Check if an alert is already presented
//      if topVC is UIAlertController {
//          print("An alert is already being presented.")
//          return
//      }
//
//      topVC.present(alertController, animated: animated, completion: completion)
//  }
//}
//
//extension Result {
//    func handle(success: @escaping (Success) -> Void) {
//        switch self {
//        case .success(let value):
//            success(value)
//           case .failure(let error):
//            guard let topViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.topmostViewController() else {
//                _ = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to find topmost view controller"])
//                return
//                }
//            topViewController.AlertControllerOnr(title: "", message: "\(error.localizedDescription)")
//        }
//    }
//}
//
