//
//  ViewController.swift
//  GPS
//
//  Created by apple on 2021/02/09.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var logLabel: UILabel!
    @IBOutlet var tfUserId: UITextField!
    @IBOutlet var tfUserName: UITextField!
    @IBOutlet var tfUserCat1: UITextField!
    @IBOutlet var tfUserCat2: UITextField!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBAction func onClick(sender: AnyObject) {
        
        switch sender.tag
        {
        case 1: clickStartButton()
                break
        case 2: clickEndButton()
                break
        default: print("???? why!!")
        }
        
        
    }
    
    func clickStartButton(){
        var userId: String = tfUserId.text!
        var userName: String = tfUserName.text!
        var userCat1: String = tfUserCat1.text!
        var userCat2: String = tfUserCat2.text!
        
        var sUrl: String = "http://secuwatcher.com:8082/?"
        var sParam: String = "userId=\(userId)&userName=\(userName)&cat1=\(userCat1)&cat2=\(userCat2)"
        
        sendUrl(sUrl: sUrl, sParam: sParam)
        
        // print(UserDefaults.standard.string(forKey: "userId")!)
        
        // 값 저장
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userCat1, forKey: "userCat1")
        UserDefaults.standard.set(userCat2, forKey: "userCat2")
        
        manager?.startUpdatingLocation()
        
        tfUserId.isEnabled = false
        tfUserId.isUserInteractionEnabled = false
        tfUserId.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        tfUserName.isEnabled = false
        tfUserName.isUserInteractionEnabled = false
        tfUserName.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        tfUserCat1.isEnabled = false
        tfUserCat1.isUserInteractionEnabled = false
        tfUserCat1.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        tfUserCat2.isEnabled = false
        tfUserCat2.isUserInteractionEnabled = false
        tfUserCat2.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        // startButton.isEnabled = false
        // startButton.isUserInteractionEnabled = false
        // startButton.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        startButton.isHidden = true
        endButton.isHidden = false
    }
    func clickEndButton(){
        manager?.stopUpdatingLocation()
        tfUserId.isEnabled = true
        tfUserId.isUserInteractionEnabled = true
        tfUserId.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tfUserName.isEnabled = true
        tfUserName.isUserInteractionEnabled = true
        tfUserName.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tfUserCat1.isEnabled = true
        tfUserCat1.isUserInteractionEnabled = true
        tfUserCat1.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tfUserCat2.isEnabled = true
        tfUserCat2.isUserInteractionEnabled = true
        tfUserCat2.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        endButton.isHidden = true
        startButton.isHidden = false
    }
    
    var manager: CLLocationManager?
    var isRun: Bool = false;

    func sendUrl(sUrl: String, sParam: String){
        let sParam_utf = sParam.data(using: .utf8)
        let url = URL(string: sUrl)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = sParam_utf
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(sParam_utf!.count), forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let e = error {
                NSLog("error : \(e.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async() {
                let sResult = String(data: data!, encoding: String.Encoding.utf8)
                print("result : Success")
                // isRun.toggle()
                
                
                
            }
        }
        
        task.resume()
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        startButton.tag = 1
        endButton.tag = 2
        // Do any additional setup after loading the view.
        // label.text = "ready"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.allowsBackgroundLocationUpdates = true
        manager?.requestWhenInUseAuthorization()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        
        // label.text = "\(first.coordinate.longitude) | \(first.coordinate.latitude)"
        // label.text = "test"
        print("lon : \(first.coordinate.longitude), lat: \(first.coordinate.latitude)")
        
        let userId: String? = UserDefaults.standard.string(forKey: "userId")
        
        if userId != nil {
            var date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            var sUrl: String = "http://secuwatcher.com:8082/?"
            var sParam: String = "userId=\(userId!)&latitude=\(first.coordinate.latitude)&longitude=\(first.coordinate.longitude)&currentTime=\(dateFormatter.string(from: date))"
            sendUrl(sUrl: sUrl, sParam: sParam)
        }
    }
    
    func initView(){
        let userId: String? = UserDefaults.standard.string(forKey: "userId")
        let userName: String? = UserDefaults.standard.string(forKey: "userName")
        let userCat1: String? = UserDefaults.standard.string(forKey: "userCat1")
        let userCat2: String? = UserDefaults.standard.string(forKey: "userCat2")
        
        if userId != nil {
            tfUserId.text = userId
            tfUserName.text = userName
            tfUserCat1.text = userCat1
            tfUserCat2.text = userCat2
        }
    }


}

