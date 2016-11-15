//
//  DeviceTokenRegistrator.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 15/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import Foundation

class DeviceTokenRegistrator {
    private let REGISTRATION_URL = "https://famas.herokuapp.com/register-device-token/"
    
    func registerDevice(withToken token: String){
        let requestURL = URL(string: REGISTRATION_URL.appending(token).appending("/"))!
        let urlRequest = URLRequest(url: requestURL)
        
        print("Registering device token \(token) at \(REGISTRATION_URL.appending(token).appending("/")).")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            
            if (httpResponse?.statusCode == 200) {
                print("Successfully registered device token \(token).")
            }
            else {
                print("Failed to register device token \(httpResponse?.statusCode).")
            }
        }
        
        task.resume()
    }
}
