//
//  ViewController.swift
//  Lab8Networking
//
//Submitted by Kiran Padinhare Kunnoth , Student Id:8940891
//
//  Created by IS on 2023-11-17.
//

import UIKit

class ViewController: UIViewController 
{
    
    
    @IBOutlet weak var areaLabel: UILabel!
    
    
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    @IBOutlet weak var currentTemperature: UILabel!
    
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var windSpeed: UILabel!
    
    
    
    let apiKey = "6a450b730898eca3caa74b052f39a6a1"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    override func viewDidLoad() 
    {
        super.viewDidLoad()
       
            let latitude = 43.4643
        let longitude = -80.5204
        getWeatherData(latitude: latitude, longitude: longitude)
    }

    func getWeatherData(latitude: Double, longitude: Double) 
    {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.modifyUI(with: weatherData)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                         print("Error fetching data: \(error)")
                }
            }.resume()
        }
    }

    
     
    func modifyUI(with weatherData: WeatherData) {
         areaLabel.text = weatherData.name
         weatherConditionLabel.text = weatherData.weather.first?.description
        
        if let icon = weatherData.weather.first?.icon {
             let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon).png")
            weatherIcon.load(url: iconURL)
         }
           currentTemperature.text = ("\(Int(weatherData.main.temp-273.15)) °C")
        humidityLabel.text = "Humidity : \(weatherData.main.humidity)%"
            windSpeed.text = "Wind Speed : \(weatherData.wind.speed) m/s"
    }
}


              extension UIImageView {
        func load(url: URL?) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                }
                  }
                     }
                 }


struct WeatherData: Codable {
    let name: String
      let weather: [Weather]
    let main: Main
      let wind: Wind
}
  
         struct Weather: Codable {
      let description: String
    let icon: String
}

    struct Main: Codable {
           let temp: Double
    let humidity: Double
}
 
        struct Wind: Codable {
    let speed: Double
}

