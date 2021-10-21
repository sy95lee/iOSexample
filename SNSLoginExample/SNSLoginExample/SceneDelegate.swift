//
//  SceneDelegate.swift
//  SNSLoginExample
//
//  Created by twim on 2021/10/20.
//

import Foundation
import FBSDKCoreKit


func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else {
        return
    }

    ApplicationDelegate.shared.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: [UIApplication.OpenURLOptionsKey.annotation]
    )
}
