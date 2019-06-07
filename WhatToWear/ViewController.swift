//
//  ViewController.swift
//  WhatToWear
//
//  Created by Hidekazu Shidara on 6/6/19.
//  Copyright © 2019 Custom Media Apps. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var home = ""
    var commute = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if didRetrieveValues() {
            print("displaying weather")
            print(home)
            print(commute)
            displayWeather()
        }
        else{
            print("querying user")
            queryUser()
        }
    }
    
    func didRetrieveValues() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                home = data.value(forKey: "home") as! String
                commute = data.value(forKey: "commute") as! String
            }
            if (home == "" && commute == ""){
                return false
            }
            return true
        } catch {
            return false
        }
    }
    
    func queryUser() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let QueryViewController = storyBoard.instantiateViewController(withIdentifier: "QueryViewController") as! QueryViewController
        self.present(QueryViewController, animated:true, completion:nil)
    }
    
    func displayWeather() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        self.present(WeatherViewController, animated:true, completion:nil)
    }
}

