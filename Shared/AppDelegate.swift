//
//  yolov3DemoApp.swift
//  Shared
//
//  Created by zouhao on 2020/12/29.
//

import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let sb = UIStoryboard(name: "main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "main")
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
}
