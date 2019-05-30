//
//  Repository.swift
//  Networking App
//
//  Created by Philabian Lindo on 5/23/19.
//  Copyright © 2019 Philabian Lindo. All rights reserved.
//

import Foundation

class Repository {
    
    let apiKey = "9e74cb5c7814a14712ff9be238e3ac17"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather/"
    let imgBaseUrl = "https://openweathermap.org/img/w/"
    
    func getWeatherData(cityZip: String, completionHandler: @escaping ([String: Any]) -> ()) {
        
        let url = URL(string: baseUrl + "?zip=" + cityZip + "&units=imperial&appid=" + apiKey)!
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {
                //self.handleClientError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    //self.handleServerError(response)
                    return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                DispatchQueue.main.async {
                    completionHandler(json!)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func getWeatherImg(imgStr: String, completionHandler: @escaping (Data) -> ()){
        let url = URL(string: imgBaseUrl + imgStr + ".png")!
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {
                //self.handleClientError(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    //self.handleServerError(response)
                    return
            }
            
            do {
                DispatchQueue.main.async {
                    if let imgData = data {
                        completionHandler(imgData)
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
