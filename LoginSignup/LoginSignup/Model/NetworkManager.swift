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

    // MARK: - Private API
    static private func checkingResponse(response: (DataResponse<Any>), _ completion: @escaping (Bool, String?) -> Void) {
        if let code = response.response?.statusCode {
            if code == 200 {
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
        if let error = response.result.value as? NSDictionary {
            if let element = error.value(forKey: "errors") as? [NSDictionary] {
                return (element.count > 0) ? (element[0].value(forKey: "message") as? String) : "Undefine error."
            }
        }
        return "Undefine error."
    }
    
}








