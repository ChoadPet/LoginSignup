//
//  NetworkManager.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/13/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static private let baseUrl = "https://apiecho.cf"
    
    static private let login = "/api/login/"
    static private let signup = "/api/signup/"
    static private let logout = "/api/logout/"
    static private let text = "/api/get/text/"
    
    // MARK: - Public API
    static func loginMethod(forUser user: User, completion: @escaping (Bool, String?) -> Void) {
        let myUrl = "\(baseUrl)\(login)"
        let parameters = [
            "email": user.email,
            "password": user.password
        ]
        Alamofire.request(myUrl, method: .post, parameters: parameters).responseJSON { (response) in
            self.checkingResponse(response: response, completion)
        }
    }
    
    static func registrationMethod(forUser user: User, completion: @escaping (Bool, String?) -> Void) {
        let myUrl = "\(baseUrl)\(signup)"
        let parameters = [
            "name": user.name,
            "email": user.email,
            "password": user.password
        ]
        
        Alamofire.request(myUrl, method: .post, parameters: parameters).responseJSON { (response) in
            self.checkingResponse(response: response, completion)
        }
    }

    /// Error: 500, Server Error.
    
//    static func logOutMethod() {
//        if let token = UserDefaults.standard.value(forKey: "access_token") as? String {
//            let myUlr = "\(baseUrl)\(logout)"
//            let header = [
//                "Authorization" : "Bearer \(token)"
//            ]
//            Alamofire.request(myUlr, method: .post, headers: header).responseJSON { (response) in
//                print(response)
//            }
//        }
//    }
    
    static func getText(completion: @escaping (Bool, String) -> Void) {
        let myUrl = "\(baseUrl)\(text)"
        if let token = UserDefaults.standard.value(forKey: "access_token") as? String {
            let headers = [
                "Authorization" : "Bearer \(token)"
            ]
            Alamofire.request(myUrl, method: .get, headers: headers).responseJSON { (response) in
//                print(response)
                if let result = response.result.value as? [String: Any?], let success = result["success"] as? Bool,
                    let text = result["data"] as? String {
                    completion(success, text)
                } else {
                    completion(false, "")
                }
            }
        }
    }

    // MARK: - Private API
    static private func checkingResponse(response: (DataResponse<Any>), _ completion: @escaping (Bool, String?) -> Void) {
        if let code = response.response?.statusCode {
            if code == 200 {
                gettingData(response: response.result.value as? NSDictionary)
                completion(true, nil)
            } else if code == 422 {
                completion(false, outputError(response: response))
            } else if code == 418 {
                completion(false, outputError(response: response))
            } else if code > 400 {
                completion(false, "Undefine error.")
            }
        }
    }
    
    static private func outputError(response: (DataResponse<Any>)) -> String? {
        let defaultMessage = "Undefine error."
        
        if let error = response.result.value as? NSDictionary,
            let element = error.value(forKey: "errors") as? [NSDictionary] {
                return (element.count > 0) ? (element[0].value(forKey: "message") as? String) : defaultMessage
        }
        return defaultMessage
    }
    
    
    static private func gettingData(response: NSDictionary?) {
        if let data = response?.value(forKey: "data") as? [String: Any?],
            let token = data["access_token"] as? String {
                UserDefaults.standard.set(token, forKey: "access_token")
        }
    }
    
    
}








