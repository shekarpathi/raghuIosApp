//
//  ViewController.swift
//  Switch
//
//  Created by Shekar on 6/12/19.
//  Copyright © 2019 Shekar. All rights reserved.
//  https://github.com/shekarpathi/iotSwitchIosApp.git
// cd /Users/shekar/Documents/Switch
// switch1 top tubeight
// switch2 bottom fan

import UIKit
import WebKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: WKWebView!
    var password1: String = ""
    var httpProtocol: String = ""
    var host1: String = ""
    var relayOnPath: String = ""
    var relayOffPath: String = ""
    var relayStatusPath: String = ""
    var tlSwitchStatus: String = "a"
    var videoUrl: String = ""

    var host2: String = ""
    var fanSwitchStatus: String = "a"

    @IBOutlet weak var switch1: MyButton!
    @IBOutlet weak var switch2: MyButton!
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    @IBAction func FanSwitchPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            print("Inside FanSwitchPressed began")

            self.switch2.backgroundColor = UIColor.interColor
            
            if (fanSwitchStatus == "0") {
                self.switch2.setTitle("Wait... Turning On", for: .normal)
                turnOnFan()
            }
            if (fanSwitchStatus == "1") {
                self.switch2.setTitle("Wait... Turning Off", for: .normal)
                turnOffFan()
            }
        }
    }
    
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

            print("Inside Tubelight Switch Pressed began")
            self.switch1.backgroundColor = UIColor.interColor

            if (tlSwitchStatus == "0") {
                self.switch1.setTitle("Wait... Turning On", for: .normal)
                turnOnTubeLight()
            }
            if (tlSwitchStatus == "1") {
                self.switch1.setTitle("Wait... Turning Off", for: .normal)
                turnOffTubeLight()
            }
        }
    }
    
    func turnOnTubeLight() {
        var request = URLRequest(url: URL(string: httpProtocol + "://" + host1 + "/" + relayOnPath)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(password1, forHTTPHeaderField: "secret")
        session.dataTask(with: request) {data, response, err in
            
            if let data = data {
                DispatchQueue.main.async { // Correct
                    self.tlSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                    print(self.tlSwitchStatus)
                    if (self.tlSwitchStatus == "Relay Turned On. Current State >> 1") {
                        self.tlSwitchStatus = "1"
                        self.switch1.cornerRadius = 20
                        self.switch1.backgroundColor = UIColor.onColor
                        self.switch1.setTitle("Tubelight", for: .normal)
                    }
                }
            }
            }.resume()
    }
    
    func turnOnFan() {
        var request = URLRequest(url: URL(string: httpProtocol + "://" + host2 + "/" + relayOnPath)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(password1, forHTTPHeaderField: "secret")
        session.dataTask(with: request) {data, response, err in
            
            if let data = data {
                DispatchQueue.main.async { // Correct
                    self.fanSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                    print(self.fanSwitchStatus)
                    if (self.fanSwitchStatus == "Relay Turned On. Current State >> 1") {
                        self.fanSwitchStatus = "1"
                        self.switch2.cornerRadius = 20
                        self.switch2.backgroundColor = UIColor.onColor
                        self.switch2.setTitle("Fan", for: .normal)
                    }
                }
            }
            }.resume()
    }
    
    func turnOffTubeLight() {
        var request = URLRequest(url: URL(string: httpProtocol + "://" + host1 + "/" + relayOffPath)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(password1, forHTTPHeaderField: "secret")
        session.dataTask(with: request) {data, response, err in
            if let data = data {
                DispatchQueue.main.async { // Correct
                    self.tlSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                    print(self.tlSwitchStatus)
                    if (self.tlSwitchStatus == "Relay Turned Off. Current State >> 0") {
                        self.tlSwitchStatus = "0"
                        self.switch1.cornerRadius = 10
                        self.switch1.backgroundColor = UIColor.offColor
                        self.switch1.setTitle("Tubelight", for: .normal)
                    }
                }
            }
            }.resume()
    }
    
    func turnOffFan() {
        var request = URLRequest(url: URL(string: httpProtocol + "://" + host2 + "/" + relayOffPath)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        request.setValue(password1, forHTTPHeaderField: "secret")
        session.dataTask(with: request) {data, response, err in
            if let data = data {
                DispatchQueue.main.async { // Correct
                    self.fanSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                    print(self.fanSwitchStatus)
                    if (self.fanSwitchStatus == "Relay Turned Off. Current State >> 0") {
                        self.fanSwitchStatus = "0"
                        self.switch2.cornerRadius = 10
                        self.switch2.backgroundColor = UIColor.offColor
                        self.switch2.setTitle("Fan", for: .normal)
                    }
                }
            }
        }.resume()
    }
    
    func updateTLLabel() {
        DispatchQueue.main.async { // Correct
            self.switch1.setTitle("Updating ..", for: .normal)
        }
        let url: String = httpProtocol + "://" + host1 + "/" + relayStatusPath
        
        print("********************")
        print(password1)
        print(url)
        print("********************")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 30.0
        var session = URLSession.shared
        session = URLSession(configuration: sessionConfig)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.setValue(password1, forHTTPHeaderField: "secret")
        
        session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async { // Correct
                if let error = error {
                    print("error")
                    print(error)
                    self.tlSwitchStatus = "--"
                    self.switch1.cornerRadius = 10
                    self.switch1.backgroundColor = UIColor.interColor
                    self.switch1.setTitle("Error...", for: .normal)
                } // end error
                else if let data = data {
                    let response = response as? HTTPURLResponse
                    if (response?.statusCode == 200) {
                        self.tlSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                        print(self.tlSwitchStatus)
                        if (self.tlSwitchStatus == "0") {
                            self.switch1.cornerRadius = 10
                            self.switch1.backgroundColor = UIColor.offColor
                            self.switch1.setTitle("Tubelight", for: .normal)
                        }
                        if (self.tlSwitchStatus == "1") {
                            self.switch1.cornerRadius = 20
                            self.switch1.backgroundColor = UIColor.onColor
                            self.switch1.setTitle("Tubelight", for: .normal)
                        }
                    } // end response code 200
                    else {
                        self.tlSwitchStatus = "--"
                        print ("eeeeeeee")
                        self.switch1.cornerRadius = 20
                        self.switch1.backgroundColor = UIColor.interColor
                        self.switch1.setTitle("Http error", for: .normal)
                        
                    }
                } // end data
            } // end DispatchQueue
            }.resume()
    }
    
    func updateFanLabel() {
        DispatchQueue.main.async { // Correct
            self.switch2.setTitle("Updating ..", for: .normal)
        }
        let url: String = httpProtocol + "://" + host2 + "/" + relayStatusPath
        
        print("********************")
        print(password1)
        print(url)
        print("********************")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 30.0
        var session = URLSession.shared
        session = URLSession(configuration: sessionConfig)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.setValue(password1, forHTTPHeaderField: "secret")
        
        session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async { // Correct
                if let error = error {
                    print("error")
                    print(error)
                    self.fanSwitchStatus = "--"
                    self.switch2.cornerRadius = 10
                    self.switch2.backgroundColor = UIColor.interColor
                    self.switch2.setTitle("Error...", for: .normal)
                } // end error
                else if let data = data {
                    let response = response as? HTTPURLResponse
                    if (response?.statusCode == 200) {
                        self.fanSwitchStatus = String(data: data, encoding: String.Encoding.utf8)!
                        print(self.fanSwitchStatus)
                        if (self.fanSwitchStatus == "0") {
                            self.switch2.cornerRadius = 10
                            self.switch2.backgroundColor = UIColor.offColor
                            self.switch2.setTitle("Fan", for: .normal)
                        }
                        if (self.fanSwitchStatus == "1") {
                            self.switch2.cornerRadius = 20
                            self.switch2.backgroundColor = UIColor.onColor
                            self.switch2.setTitle("Fan", for: .normal)
                        }
                    } // end response code 200
                    else {  // any other response code besides 200
                        self.fanSwitchStatus = "--"
                        print ("eeeeeeee")
                        self.switch2.cornerRadius = 20
                        self.switch2.backgroundColor = UIColor.interColor
                        self.switch2.setTitle("Http error", for: .normal)
                    }
                } // end data
            } // end DispatchQueue
            }.resume()
    }
    
    func updateDisplayFromDefaults(){
        
//        let mySwitch = UISwitch()
//        mySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        //Get the defaults
        let defaults = UserDefaults.standard

        password1 = defaults.string(forKey: "SwitchPassword") ?? "change_me"
        print(password1)

        httpProtocol = defaults.string(forKey: "httpProtocol") ?? "http"
        print(httpProtocol)
        
        host1 = defaults.string(forKey: "HostName1") ?? "change_me"
        print(host1)
        
        host2 = defaults.string(forKey: "HostName2") ?? "change_me"
        print(host2)
        
        relayOnPath = defaults.string(forKey: "RelayOnPath") ?? "relayOn"
        print(relayOnPath)

        relayOffPath = defaults.string(forKey: "RelayOffPath") ?? "relayOff"
        print(relayOffPath)

        relayStatusPath = defaults.string(forKey: "RelayStatus") ?? "getRelayStatus"
        print(relayStatusPath)
        
        videoUrl = defaults.string(forKey: "VideoUrl") ?? "https://www.apple.com"
        print(videoUrl)
        
// --------------------------------------
        
        host2 = defaults.string(forKey: "HostName2") ?? "change_me"
        print(host2)
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        updateDisplayFromDefaults()
        updateTLLabel()
        updateFanLabel()
        let url = URL(string: videoUrl)!
        cameraView.load(URLRequest(url: url))
    }

    override func viewDidLoad() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)


        self.switch1.backgroundColor = UIColor.interColor
        self.switch1.setTitle("Updating.....", for: .normal)

        registerSettingsBundle()
        updateDisplayFromDefaults()
        updateTLLabel()
        updateFanLabel()

        // Do any additional setup after loading the view.
        let url = URL(string: videoUrl)!
        cameraView.load(URLRequest(url: url))
    }
}
