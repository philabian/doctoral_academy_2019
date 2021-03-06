//
//  HourlyWeatherTableViewController.swift
//  Networking App
//
//  Created by Philabian Lindo on 5/30/19.
//  Copyright © 2019 Philabian Lindo. All rights reserved.
//

import UIKit

class DayWeatherTableViewCell: UITableViewCell{
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weatherStatusIcon: UIImageView!
    
}

class HourlyWeatherTableViewController: UITableViewController {
    var zip = ""
    var allWeatherList = [Any]()
    var date = ""
    var count = 0
    var fiveDayWeatherList = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        Repository().getFiveDayHourlyWeatherData(cityZip: zip){ hourlyWeatherData in
            if let weatherList = hourlyWeatherData["list"] as? [Any] {
                self.allWeatherList = weatherList
                var i = 0
                for forecastData in weatherList {
                    var data = forecastData as? [String: Any]
                    if let tempDate = data!["dt_txt"] as? String {
                        let dateStr = self.formatDate(dateIn: tempDate, isUI: false)
                        
                        if(self.date != dateStr){
                            self.date = dateStr
                            self.count = self.count + 1
                            i = i + 1
                        }else{
                            self.allWeatherList.remove(at: i)
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allWeatherList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayWeatherCell", for: indexPath) as! DayWeatherTableViewCell
        
        let mainData = self.allWeatherList[indexPath.row] as? [String: Any]
        let main = mainData!["main"] as? [String: Double]
        let weather = mainData!["weather"] as? [Any]
        let weahterData = weather?.first as? [String: Any]
        
        if let weatherStatusIcon = weahterData!["icon"] as? String {
            Repository().getWeatherImg(imgStr: weatherStatusIcon){ imgData in
                let img = UIImage(data: imgData)
                cell.weatherStatusIcon.image = img
            }
        }
        
        if let date = mainData!["dt_txt"] as? String {
            let dateStr = self.formatDate(dateIn: date, isUI: true)
            cell.date.text = dateStr
        }
        cell.dayTemp.text = String(format:"%.0f", main!["temp"]!)
        
        
        return cell
    }
    
    func formatDate(dateIn: String, isUI: Bool) -> String{
        var dateStr = ""
        let dateFormatter = DateFormatter()
        //incoming format "2017-08-08 20:47:37"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let exp_date = dateFormatter.date(from: dateIn)
        if (exp_date != nil) {
            if(isUI){
                dateFormatter.dateFormat = "E MMM d"
            }else{
                dateFormatter.dateFormat = "yyyy-MM-dd"
            }
            dateStr = dateFormatter.string(from:exp_date!)
        }
        
        return dateStr
    }

}
