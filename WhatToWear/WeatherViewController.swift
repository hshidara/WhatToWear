//
//  WeatherViewController.swift
//  WhatToWear
//
//  Created by Hidekazu Shidara on 6/7/19.
//  Copyright © 2019 Custom Media Apps. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class WeatherViewController: UIViewController {

    // Think of this as the main function, this is the starting point for this view.
    
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var workBackgroundView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var workTempLabel: UILabel!
    @IBOutlet weak var homeCityTextField: UILabel!
    @IBOutlet weak var workCityTextField: UILabel!
    @IBOutlet weak var homeDescriptionTextLabel: UILabel!
    @IBOutlet weak var workDescriptionTextLabel: UILabel!
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    
    var home: String = "";
    var commute: String = "";

    override func viewDidLoad() {
        super.viewDidLoad();

        run(city: home, query: "home");
        run(city: commute, query: "commute");
    }
    
    func run(city: String, query: String) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q="+city+",us&units=imperial&appid=33d852344d68bafd4c35a9c41c956cc4";
        let url = URL(string: urlStr);
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject];
                        
                        if let weather = jsonResult!["weather"] as? NSArray{
                            if let description = weather[0] as? [String:AnyObject]{
                                DispatchQueue.main.async{
                                    let iconString = (description["icon"] as? String)!;
                                    let urlString = "https://openweathermap.org/img/w/" + iconString + ".png";
                                    let url = URL(string: urlString);
                                
                                    if(query=="home"){
                                        self.homeDescriptionTextLabel.text = description["description"] as? String;
                                        self.homeImage.load(url:url!);
                                    }
                                    else if(query=="commute"){
                                        self.workDescriptionTextLabel.text = description["description"] as? String;
                                        self.workImage.load(url:url!);
                                    }
                                }
                            }
                        }
                        if let main = jsonResult!["main"]  as? [String: AnyObject] {
                            let temp = main["temp"] as? Double;
                            DispatchQueue.main.async{
                                if(query=="home"){
                                    self.tempLabel.text = String(Int(round(temp!))) + "°F";
                                    self.homeCityTextField.text = city.replacingOccurrences(of: "%20", with: " ");
                                }
                                else if(query=="commute"){
                                    self.workTempLabel.text = String(Int(round(temp!))) + "°F";
                                    self.workCityTextField.text = city.replacingOccurrences(of: "%20", with: " ");
                                }
                            }
                        }
                        
                    } catch {
                       print("Json Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }
}
