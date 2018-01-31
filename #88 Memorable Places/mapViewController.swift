//
//  mapViewController.swift
//  #88 Memorable Places
//
//  Created by Leo on 17/01/2018.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiLongPress = UILongPressGestureRecognizer(target: self, action: #selector(longpress))
        
        uiLongPress.minimumPressDuration = 2
        
        map.addGestureRecognizer(uiLongPress)
        
        
        // 顯示“新增“的地圖位置
        if activePlace == -1 {
            
            locationManager.delegate = self  //委派給ViewController
            locationManager.desiredAccuracy = kCLLocationAccuracyBest  //設定為最佳精度
            locationManager.requestWhenInUseAuthorization()  //user授權
            locationManager.startUpdatingLocation()  //開始update位置
        
        } else {
           
            // 顯示“row”的地圖位置
            if places.count > activePlace {
                
                //check place有項目才可顯示activeplace
                
                if let name = places[activePlace]["name"] {
                    
                    if let lat = places[activePlace]["lat"] {
                        
                        if let lon = places[activePlace]["lon"] {
                            
                            if let latitube = Double(lat) {
                                
                                if let longtitube = Double(lon) {
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: latitube, longitude: longtitube)
                                    
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.coordinate = coordinate
                                    
                                    annotation.title = name
                                    
                                    self.map.addAnnotation(annotation)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
    
        
        // Do any additional setup after loading the view.
    }

    //長按出現選單加入標注點
    //func (:)接受參數
    @objc func longpress(gestureRecognizer : UIGestureRecognizer) {
        
        //確認有收到“手勢”而執行動作
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            let newCoordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var addressName = ""
            
            //將地圖經緯度轉換成地址
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    //the geocoder actually returns CLPlacemark objects, which contain both the coordinate and the original information that you provided.
                    if let placemarks = placemarks?[0] {
                        
                        //The street address associated with the placemark.
                        if placemarks.subThoroughfare != nil {
                            
                            addressName += placemarks.subThoroughfare! + ""
                            
                        }
                    
                        //The street address associated with the placemark.
                        if placemarks.thoroughfare != nil {
                            
                            addressName += placemarks.thoroughfare!
                            
                        }
                        
                    }
                }
                
                if addressName == "" {
                    
                    addressName = "Add \(NSDate())"
                    
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = addressName
                
                self.map.addAnnotation(annotation)
                
                places.append(["name" : addressName, "lat" : String(newCoordinate.latitude), "lon" : String(newCoordinate.longitude)])
                
                UserDefaults.standard.set(places, forKey: "places")
                
                
            })
            
            
            /*
             選單
            let alert = UIAlertController(title: "Annotation new place", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textfield) in
                
                textfield.placeholder = "Title"
                
            }
            
            alert.addTextField { (textfield) in
                
                textfield.placeholder = "Subtitle"
                
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                //
            })
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                
                let title = alert.textFields![0] as UITextField
                
                let subtitle = alert.textFields![1] as UITextField
                
                annotation.title = title.text!
                
                annotation.subtitle = subtitle.text!
                
            })
 
            self.present(alert, animated: true, completion: nil)
             */
            
        }
        
       
    }

    //開啟update位置後 startUpdatingLocation()，觸發func locationManager, [CLLocation]會取得所有定位點，[0]為最新點
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

