//
//  ViewController.swift
//  Networking App
//
//  Created by Philabian Lindo on 5/22/19.
//  Copyright © 2019 Philabian Lindo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var datalabel: UILabel!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var weatherStatusImg: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    var finalZip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submitButtonAction(_ sender: Any) {
       
        if let zip = zipCodeTextField.text {
            finalZip = zip
            Repository().getWeatherData(cityZip: zip){weatherData in
                
                let weatherRoot = weatherData["weather"] as? [Any]
                let main = weatherData["main"] as? [String: Double]
                let weather = weatherRoot?.first as? [String: Any]
                
                self.datalabel.text = String(format:"%.0f", main!["temp"]!)
                
                self.weatherDescription.text = weather!["description"] as? String
                
                self.highTemp.text = String(format:"%.0f", main!["temp_max"]!)
                self.lowTemp.text = String(format:"%.0f", main!["temp_min"]!)
                
                if let weatherStatusIcon = weather!["icon"] as? String {
                    Repository().getWeatherImg(imgStr: weatherStatusIcon){ imgData in
                        let img = UIImage(data: imgData)
                        
                        self.weatherStatusImg.image = img
                    }
                }
            }
        }
    }
    
    @IBAction func navToFiveDayForecast(_ sender: Any) {
        self.performSegue(withIdentifier: "showHourlyWeatherVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showHourlyWeatherVC"){
            let hourlyVC = segue.destination as! HourlyWeatherTableViewController
            hourlyVC.zip = finalZip
        }
    }
}

