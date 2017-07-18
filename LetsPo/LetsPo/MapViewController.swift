//
//  MapViewController.swift
//  LetsPo
//
//  Created by 溫芷榆 on 2017/7/18.
//  Copyright © 2017年 Walker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class MapViewController:  UIViewController ,CLLocationManagerDelegate,MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var places:[SpotAnnotation]!
    var zoomLevel = CLLocationDegrees()
    var region = CLCircularRegion()
    var reUpdate = NSLock()
    var shouldReUpdate = Bool()
    var near = [[String:Any]]()
    var titleName:String = ""
    
    
   
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 可以選擇永遠定位或者使用時定位
        locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.authorizationStatus() == .authorizedAlways{
//            locationManager.requestAlwaysAuthorization()
//        }
//        else {
//            locationManager.requestWhenInUseAuthorization()
//        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            // 防止秒數內再度觸發方法
            self.doUnlock()
            self.locationManager.startUpdatingLocation()
        }
        
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        
        places = spot()
        filterAnnotations(paramPlaces: places)
        
        // 回到當前位置
        let locationButton = UIButton(type: .custom)
        let x = UIScreen.main.bounds.size.width * 0.76
        let y = UIScreen.main.bounds.size.height * 0.8
        locationButton.frame = CGRect(x: x, y: y, width: 100, height: 100)
        locationButton.addTarget(self, action: #selector(zoomToUserLocation), for: .touchUpInside)
        let btnImage = UIImage(named: "rightBtn.png")
        locationButton.imageView?.contentMode = .center
        locationButton.setImage(btnImage, for: .normal)
        
        self.view.addSubview(locationButton)
        
        
        
    }
    
    func zoomToUserLocation(){
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = self.mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.01
        mapRegion.span.longitudeDelta = 0.01
        
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func filterAnnotations(paramPlaces:[SpotAnnotation]){
        let latDelta = self.mapView.region.span.latitudeDelta / 15
        let lonDelta = self.mapView.region.span.longitudeDelta / 15
        
        for p:SpotAnnotation in paramPlaces {
            p.cleanPlaces()
        }
        var spotsToShow = [SpotAnnotation]()
        
        for i in 0...places.count - 1  {
            
            let currentObject = paramPlaces[i]
            let lat = currentObject.coordinate.latitude
            let lon = currentObject.coordinate.longitude
            
            var found = false
            
            for tempAnnotation:SpotAnnotation in spotsToShow {
                let tempLat = tempAnnotation.coordinate.latitude - lat
                let tempLon = tempAnnotation.coordinate.longitude - lon
                if fabs(tempLat) < latDelta && fabs(tempLon) < lonDelta {
                    
                    self.mapView.removeAnnotation(currentObject)
                    found = true
                    tempAnnotation.addPlasce(place: currentObject)
                    
                    break
                }
            }
            if !found {
                spotsToShow.append(currentObject)
                mapView.addAnnotation(currentObject)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if zoomLevel != mapView.region.span.longitudeDelta {
            
            for ano:Any in mapView.selectedAnnotations {
                mapView .deselectAnnotation(ano as? MKAnnotation, animated: false)
                
            }
            filterAnnotations(paramPlaces: places)
            zoomLevel = mapView.region.span.longitudeDelta
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        let PinIdentifier = "PinIdentifier"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: PinIdentifier) as? MKPinAnnotationView
        if (pin == nil){
            pin = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: PinIdentifier)
        }else {
            
            pin?.annotation = annotation
        }
        let rightBtn = UIButton(type: .detailDisclosure)
        rightBtn.setImage(UIImage(named: "rightBtn.png"), for: .normal)
        pin?.rightCalloutAccessoryView = rightBtn
        
        let myAnnotation = annotation as! SpotAnnotation
        let detailImage = UIImageView.init(image: myAnnotation.image)
        
        // Detail view 的 Constraint
        let widthConstraint = NSLayoutConstraint(item: detailImage,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 100)
        
        let heightConstraint = NSLayoutConstraint(item: detailImage,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 100)
        detailImage.addConstraint(widthConstraint)
        detailImage.addConstraint(heightConstraint)
        detailImage.contentMode = .scaleAspectFill
        pin?.detailCalloutAccessoryView = detailImage
        pin?.canShowCallout = true
        pin?.isEnabled = true
        
        return pin
    }
    func doUnlock(){
        reUpdate.unlock()
        if shouldReUpdate{
            shouldReUpdate = false
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if reUpdate.try() == false {
            shouldReUpdate = true
            return
        }
        locationManager.stopUpdatingLocation()
        monitorRegion()
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("CREATED REGION: \(region.identifier) - \(locationManager.monitoredRegions.count)")
        
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter \(region.identifier)")
        mutableNotificationContent(title: "You Did Enter My Monitoring Area", body: "CLLocationManager did enter region:\(region.identifier)", indentifier: "DidEnterRegion")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit \(region.identifier)")
        mutableNotificationContent(title: "You Did Exit My Monitoring Area", body: "CLLocationManager did Exit region:\(region.identifier)", indentifier: "DidExitRegion")
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        //        print("monitoringDidFailForRegion \(String(describing: region)) \(error)")
        
    }
    func mutableNotificationContent(title:String, body:String, indentifier:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest.init(identifier: indentifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("UserNotificationCenter Fail:\(String(describing: error))")
            }
        }
    }
    func monitorRegion(){
        let userLocation = mapView.userLocation.location
        let dic = getLocations()
        var distance = CLLocationDistance()
        for value in dic {
            let strName = value["friendName"] as! String
            
            //let time = value["lastUpdateDateTime"] as! String
            
            var lat = Double()
            if let latt = Double(value["lat"] as! String) {
                lat = latt
            }
            var lon = Double()
            if let lonn = Double(value["lon"] as! String) {
                lon = lonn
            }
            
            let pins = CLLocation.init(latitude: lat, longitude: lon)
            distance = pins.distance(from: userLocation!) * 1.09361
            // 距離小於 2500 則存回 near
            if distance <  2500 {
                //                print("\(distance) - \(strName)")
                near = [["name":strName,"lat":lat, "lon":lon, "distance":distance]]
                
                //                near.sort { ($0["distance"] as! String) < ($1["distance"] as! String) }
                //                let sortedArray = near.sorted(by: { (dictOne, dictTwo) -> Bool in
                //                    let d1 = dictOne["distance"]! as! Double
                //                    let d2 = dictTwo["distance"]! as! Double
                //
                //                    return d1 < d2
                //                })
                
                
                startMonitoring()
                
            }
            
        }
    }
    struct nearBy {
        var titleName: String
        var lat: Double
        var lon: Double
        var distance: Double
        
    }
    
    func startMonitoring(){
        for value in near {
            
            let name = value["name"] as! String
            let lat = value["lat"] as! Double
            let lon = value["lon"] as! Double
            let distance = value["distance"] as! Double
            //        var nearArray = [nearBy]()
            //        nearArray.append(nearBy(
            //            titleName : name,
            //            lat : lat,
            //            lon: lon,
            //            distance : distance))
            //        let sortNearArray = nearArray.sorted(by: { image1, image2 in return image1.distance < image2.distance })
            //
            
            //        print(sortNearArray.count)
            //            print(near)
            
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                region = CLCircularRegion.init(center: coordinate, radius: 150, identifier: name)
                //            print("name:\(name) lat:\(lat) lon:\(lon) dis:\(distance)")
                // near 內的定位開始 Monitoring
                locationManager.startMonitoring(for: region)
                locationManager.requestState(for: region)
                
                // 超過 2300 則停止 Monitoring
                if distance > 2300 {
                    locationManager.stopMonitoring(for: region)
                    print("stop \(name)")
                }
                
            }
        }
    }
    
    func spot() -> [SpotAnnotation] {
        var result = [SpotAnnotation]()
        
        let dic = getLocations()
        for value in dic {
            let strName = value["friendName"] as! String
            
            //            let time = value["lastUpdateDateTime"] as! String
            
            var lat = CLLocationDegrees()
            if let latt = Double(value["lat"] as! String) {
                lat = latt
            }
            var lon = CLLocationDegrees()
            if let lonn = Double(value["lon"] as! String) {
                lon = lonn
            }
            //            let ID = Int(value["id"] as! String)
            
            let annotation = SpotAnnotation(atitle: strName, lat: lat, lon: lon, imageName: UIImage(named: "deer.jpg")!)
            
            result.append(annotation)
        }
        
        return result
    }
    func getLocations() -> [[String:Any]] {
        var friends = [[String:Any]]()
        
        let UrlString = "http://class.softarts.cc/FindMyFriends/queryFriendLocations.php?GroupName=bp102"
        let myUrl = NSURL(string: UrlString)
        let optData = try? Data(contentsOf: myUrl! as URL)
        guard let data = optData else {
            return friends
        }
        if let jsonArray = try? JSONSerialization.jsonObject(with: data, options:[])  as? [String:AnyObject] {
            friends = (jsonArray?["friends"] as? [[String:Any]])!
        }
        
        return friends
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let myAnnotation = view.annotation as! SpotAnnotation
        let placeCount = myAnnotation.placesCount()
        
        if placeCount <= 0 {return}
        
        if placeCount == 1 {
            titleName = myAnnotation.currentTitle
            if (control as? UIButton)?.buttonType == .detailDisclosure {
                performSegue(withIdentifier:"getDetail", sender: self)
            }
            print("Press one callout view")
        }else {
            print("Press many callout view")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getDetail" {
            
            let vc = segue.destination as! MapDetailViewController
            vc.navigationItem.title = titleName
        }
    }

}
