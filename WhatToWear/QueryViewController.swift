//
//  QueryViewController.swift
//  WhatToWear
//
//  Created by Hidekazu Shidara on 6/7/19.
//  Copyright © 2019 Custom Media Apps. All rights reserved.
//

import UIKit
import CoreData

class QueryViewController: UIViewController {

    @IBOutlet weak var HomeTextField: UITextField!
    @IBOutlet weak var WorkTextField: UITextField!
    
    @IBAction func didPressSubmit(_ sender: UIButton) {
        if(HomeTextField.text != "" && WorkTextField.text != ""){
            setData()
        }
        displayWeather()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in queryviewcontroller")
        // Do any additional setup after loading the view.
    }
    
    func setData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let location = NSManagedObject(entity: entity!, insertInto: context)

//        location.setValue(HomeTextField.text as String, forKey: "home")
//        location.setValue(WorkTextField.text as String, forKey: "commute")

        location.setValue("Pleasant Hill, CA", forKey: "home")
        location.setValue("San Francisco, CA", forKey: "commute")

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func displayWeather(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        self.present(WeatherViewController, animated:true, completion:nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
