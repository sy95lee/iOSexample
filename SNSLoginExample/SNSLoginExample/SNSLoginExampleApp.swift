//
//  SNSLoginExampleApp.swift
//  SNSLoginExample
//
//  Created by twim on 2021/10/12.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import FBSDKCoreKit

@main
struct SNSLoginExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // 카카오 SDK 초기화
        KakaoSDKCommon.initSDK(appKey: "39cf7484ef6d15bf0b0c21ce9a6796da", loggingEnable:false)
        //ApplicationDelegate.initializeSDK(<#T##self: ApplicationDelegate##ApplicationDelegate#>)
        FBSDKCoreKit.Settings.shared.appID = "301618131490272"
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
            //ios가 버전이 올라감에 따라 sceneDelegate를 더이상 사용하지 않게되었다
            //그래서 로그인을 한후 리턴값을 인식을 하여야하는데 해당 코드를 적어주지않으면 리턴값을 인식되지않는다
            //swiftUI로 바뀌면서 가장큰 차이점이다.
            .onOpenURL(perform: { url in
                // 카카오
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
                // 구글
                GIDSignIn.sharedInstance.handle(url)
                // 페이스북
                ApplicationDelegate.shared.application(
                          UIApplication.shared,
                          open: url,
                          sourceApplication: nil,
                          annotation: [UIApplication.OpenURLOptionsKey.annotation]
                      )
                
                
            })
        }
    }

}
