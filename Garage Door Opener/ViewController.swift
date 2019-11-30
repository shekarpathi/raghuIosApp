//
//  ViewController.swift
//  Garage Door Opener
//
//  Created by Shekar on 7/11/19.
//  Copyright © 2019 EshaPathi Inc. All rights reserved.
//

import UIKit
//import WebKit
import AVFoundation

class ViewController: UIViewController {
    
    var password: String = ""
    var door1url: String = ""
    var door2url: String = ""
    var videoUrl: String = ""
    var toggle: String = ""
    var buttonLabel1: String = ""
    var timer = Timer()

    //@IBOutlet weak var garageCamera: WKWebView!
//    @IBOutlet weak var door1Button: MyButton!
    @IBOutlet weak var door1Button: MyButton!
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }

    @objc func appMovedToForeground() {
        print("App moved to foreground!")
//        updateTLLabel()
        //let url = URL(string: self.videoUrl)!
        //garageCamera.load(URLRequest(url: url))
        updateDisplayFromDefaults()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.door1Button.backgroundColor = UIColor.interColor
        self.door1Button.setTitle("Single", for: .normal)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        registerSettingsBundle()
        updateDisplayFromDefaults()
        
        //let url = URL(string: self.videoUrl)!
        //garageCamera.load(URLRequest(url: url))
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.door1Button.backgroundColor = UIColor.lightGray
            self.door1Button.setTitle("Working...", for: .normal)
            pressSwitch1()
        }
    }

//    func pressSwitch(_sender: UIButton!) {
    func pressSwitch1() {
        var request = URLRequest(url: URL(string: door1url + "/press/single")!)
        print(door1url + "/press/single")
        request.httpMethod = "POST"
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 10
        let session = URLSession(configuration: urlconfig)//URLSession.shared

//        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(password, forHTTPHeaderField: "secretHeader")
        print("1")
        session.dataTask(with: request) {data, response, error in
            print("2")
            // check for any errors
            guard error == nil else {
                print("error calling " + self.door1url + "/press/single")
//                print(error!)
                DispatchQueue.main.async {
                    self.door1Button.backgroundColor = UIColor.interColor
                    self.door1Button.setTitle("Single", for: .normal)
                }
                return
            }
            print("4")
            // make sure we got data
            guard let response = data else {
              print("Error: did not receive data")
              return
            }
            print(response)
        }.resume()

//            print(String(data: data!, encoding: String.Encoding.utf8)!)
//        }.resume()
        print("5")
        //let url = URL(string: self.videoUrl)!
        //garageCamera.load(URLRequest(url: url))
    }

    func updateDisplayFromDefaults(){
        
        //Get the defaults
        let defaults = UserDefaults.standard
        
        password = defaults.string(forKey: "SwitchPassword") ?? "password"
        print(password)
        
        door1url = defaults.string(forKey: "door1url") ?? "https://www.door1url.com"
        print(door1url)
        
        door2url = defaults.string(forKey: "door2url") ?? "https://www.door2url.com"
        print(door2url)

        videoUrl = defaults.string(forKey: "videoUrl") ?? "https://news.google.com"
        print(videoUrl)
    }
}
