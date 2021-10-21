//
//  AppDelegate.swift
//  SNSLoginExample
//
//  Created by twim on 2021/10/12.
//

//import Foundation

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import FBSDKCoreKit

// AppDelegate : App이 해야할 일(Background 진입, 외부에서의 요청 등)을 대신 구현함
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        FBSDKCoreKit.Settings.shared.appID = "301618131490272"
        // 구글
        //let signInConfig = GIDConfiguration.init(clientID: "476449241976-s4bq3pvmntjtshl4dn9fojn4ebqhu17a.apps.googleusercontent.com")
        
        // 카카오
        //KakaoSDKCommon.initSDK(appKey: "39cf7484ef6d15bf0b0c21ce9a6796da", loggingEnable:false)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        // 구글
//        if (GIDSignIn.sharedInstance.handle(url,
//                                            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                            annotation: options[UIApplication.OpenURLOptionsKey.annotation])) {
//            return true
//        }
        
        // 구글
        if (GIDSignIn.sharedInstance.handle(url)) {
            return true
        }
        
        // 카카오
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
               return AuthController.handleOpenUrl(url: url, options: options)
           }
        
           return false
       }

}
