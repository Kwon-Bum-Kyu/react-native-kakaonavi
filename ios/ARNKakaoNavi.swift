//
//  ARNKakaoNavi.swift
//  ARNKakaoNavi
//
//  Created by Suhan Moon on 2020/08/30.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKNavi
import SafariServices
import CoreLocation
import UserNotifications

@objc(ARNKakaoNavi)
public class ARNKakaoNavi: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
	var destinationString = "목적지";

    @objc
    static func requiresMainQueueSetup() -> Bool {
      return true
    }
    
    public override init() {
        super.init()
        var appKey: String? = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String
        KakaoSDKCommon.initSDK(appKey: appKey!)

        print("카카오 내비 연동 성공111")
        // locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        if #available(iOS 9, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }

        requestNotificationAuthorization() // 알림을 위한 준비
    }

    @objc func isInstalled(_ resolve: @escaping RCTPromiseResolveBlock,
               rejector reject: @escaping RCTPromiseRejectBlock) -> Void {
		DispatchQueue.main.async {
		    let kakaonavi = "kakaonavi://"
    	    let kakaonaviURL = URL(string: kakaonavi)
    	    if UIApplication.shared.canOpenURL(kakaonaviURL!) {
		    	resolve(true)
    	    }
    	    else {
		    	resolve(false)
    	    }
        }
	}
    
    
    @objc(share:options:viaList:resolver:rejector:)
    func share(_ location: [String: String], options: [String: Any], viaList: NSArray,
               resolver resolve: @escaping RCTPromiseResolveBlock,
               rejector reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        let destination = NaviLocation(
            name: location["name"] as! String,
            x: location["x"] as! String,
            y: location["y"] as! String
        )
        
        var _viaList: [NaviLocation] = [];
        for object in viaList {
            if let object = object as? NSDictionary {
                let viaDest = NaviLocation(
                    name: object["name"] as! String,
                    x: object["x"] as! String,
                    y: object["y"] as! String
                )
                _viaList.append(viaDest)
            }
        }
        
        let _option: NaviOption = NaviOption(
            coordType: options["coordType"] == nil ? nil : CoordType.init(rawValue: options["coordType"] as! String),
            vehicleType: options["vehicleType"] == nil ? nil : VehicleType.init(rawValue: options["vehicleType"] as! Int),
            rpOption: options["rpOption"] == nil ? nil : RpOption.init(rawValue: options["rpOption"] as! Int),
            routeInfo: options["routeInfo"] == nil ? nil : options["routeInfo"] as! Bool,
            startX: options["startX"] == nil ? nil : options["startX"] as! String,
            startY: options["startY"] == nil ? nil : options["startY"] as! String,
            startAngle: options["startAngle"] == nil ? nil : options["startAngle"] as! Int,
            returnUri: options["returnUri"] == nil ? nil : URL(string: (options["returnUri"] as! String))
        )

        guard let shareUrl = NaviApi.shared.shareUrl(destination: destination, option: _option, viaList: _viaList) else {
            reject("ARNKakaoNavi", "", nil)
            return
        }

        resolve([
            "share_url": shareUrl.absoluteString,
        ])
        
    }
    
    @objc(navigate:options:viaList:resolver:rejector:)
    func navigate(_ location: NSDictionary,
                  options: NSDictionary,
                  viaList: NSArray,
                  resolver resolve: @escaping RCTPromiseResolveBlock,
                  rejector reject: @escaping RCTPromiseRejectBlock) -> Void {
        
        let destination = NaviLocation(
            name: location["name"] as! String,
            x: location["x"] as! String,
            y: location["y"] as! String
        )
        
        var _viaList: [NaviLocation] = [];
        for object in viaList {
            if let object = object as? NSDictionary {
                let viaDest = NaviLocation(
                    name: object["name"] as! String,
                    x: object["x"] as! String,
                    y: object["y"] as! String
                )
                _viaList.append(viaDest)
            }
        }
        
        let _option: NaviOption = NaviOption(
            coordType: options["coordType"] == nil ? nil : CoordType.init(rawValue: options["coordType"] as! String),
            vehicleType: options["vehicleType"] == nil ? nil : VehicleType.init(rawValue: options["vehicleType"] as! Int),
            rpOption: options["rpOption"] == nil ? nil : RpOption.init(rawValue: options["rpOption"] as! Int),
            routeInfo: options["routeInfo"] == nil ? nil : options["routeInfo"] as! Bool,
            startX: options["startX"] == nil ? nil : options["startX"] as! String,
            startY: options["startY"] == nil ? nil : options["startY"] as! String,
            startAngle: options["startAngle"] == nil ? nil : options["startAngle"] as! Int,
            returnUri: options["returnUri"] == nil ? nil : URL(string: (options["returnUri"] as! String))
        )

        guard let navigateUrl = NaviApi.shared.navigateUrl(destination: destination, option: _option, viaList: _viaList) else {
            reject("ARNKakaoNavi", "", nil)
            return
        }

        var url = NaviApi.shared.webNavigateUrl(destination: destination, option: _option, viaList: _viaList)!
        
        DispatchQueue.main.async {

            self.destinationString = location["name"] as! String
            self.locationManager.startUpdatingLocation() // 백그라운드에서 로케이션 받아오기
            UIApplication.shared.open(navigateUrl, options: [:]) { success in
                resolve([
                    "success": success,
                    "web_navigate_url": url.absoluteString,
                ])
            }
        }
        
        
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("카카오 locationManager 11111 ")
        if status == .authorizedAlways {
            print("카카오 you're good to go!")
        } else {
            print("카카오 you're not good to go!")
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("카카오 locationManager 22222 ")
        let lastLocation = locations.last
        let latitude = (lastLocation?.coordinate.latitude)!
        let longitude = (lastLocation?.coordinate.longitude)!
        print("카카오 locationManager latitude is \(latitude), longitude is \(longitude)")
        
        // let returnValue = getDistance(lat1: latitude, lon1: longitude, lat2: 37.3750148, lon2: 126.9482640, unit: "kilometer")
        // let returnValue = getDistance(lat1: latitude, lon1: longitude, lat2: 37.374947, lon2: 126.948363, unit: "kilometer")
        let returnValue = getDistance(lat1: latitude, lon1: longitude, lat2: 37.37497407, lon2: 126.94821053, unit: "kilometer")
        // let returnValue = getDistance(lat1: latitude, lon1: longitude, lat2: 37.66691694768919, lon2: 126.74212196988091, unit: "kilometer")
        print("카카오 locationManager returnValue \(returnValue)")
        // if (returnValue < 0.08) { // 키로미터 단위
        //     print("카카오 locationManager in destination")
        //     self.locationManager.stopUpdatingLocation() // 백그라운드에서의 위치 탐색 중지
        //     self.sendNotification(seconds: 3) // 10초 뒤에 알림 띄우기
        // }
        // if (returnValue < 0.08) { // 키로미터 단위
        //     print("카카오 locationManager in destination")
        //     self.locationManager.stopUpdatingLocation() // 백그라운드에서의 위치 탐색 중지
        //     var mTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)

        //     // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
        //     //     print("카카오 locationManager in destination 1111")
        //     //     self.sendNotification(seconds: 3) // 3초 뒤에 알림 띄우기
        //     //     DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // Change `2.0` to the desired number of seconds.
        //     //         print("카카오 locationManager in destination 2222")
        //     //         self.sendNotification(seconds: 3) // 3초 뒤에 알림 띄우기
        //     //         DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { // Change `2.0` to the desired number of seconds.
        //     //             print("카카오 locationManager in destination 3333")
        //     //             self.sendNotification(seconds: 3) // 3초 뒤에 알림 띄우기
        //     //         }
        //     //     }
        //     // }
        // }

        if (returnValue <= 0.1 && returnValue > 0.05) { // 키로미터 단위,
            print("카카오 locationManager in destination")
            self.sendNotification(seconds: 1) // 1초 뒤에 알림 띄우기
        } else if (returnValue <= 0.05) {
            print("카카오 locationManager in destination")
            self.locationManager.stopUpdatingLocation() // 백그라운드에서의 위치 탐색 중지
            self.sendNotification(seconds: 1) // 1초 뒤에 알림 띄우기
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("카카오 GPS Error => \(error.localizedDescription)")
    }

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("카카오 Error: \(error)")
            }
        }
    }

    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }

    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }

    func getDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, unit: String) -> Double {

        let theta = lon1 - lon2;
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
        
        dist = acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;

        if (unit == "kilometer") {
           dist = dist * 1.609344;
        } else if(unit == "meter"){
            dist = dist * 1609.344;
        }

        return dist
    }

    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "목적지 도착 : \(destinationString)"
        notificationContent.body = "알림을 클릭하여 워치마일을 실행해주세요."

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("카카오 Notification Error: ", error)
            } else {
                print("카카오 Notification success")
            }
        }
    }
    
}
