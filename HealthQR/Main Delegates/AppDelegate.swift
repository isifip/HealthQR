//
//  AppDelegate.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    fileprivate func setupNavigationAppearance() {
        // Override point for customization after application launch.
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = Theme.Colors.navigationBarBackgorundColor()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            let appearance = UINavigationBar.appearance()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.barTintColor = Theme.Colors.navigationBarBackgorundColor()
            
        }
    }
    
    func setupDatabase() {
        DatabaseManager.shared().checkAndloadDB(dbFileName: "db.db")
    }
    
    func testHarness() {
        let shc = Constants.SMART_HEALTH_CARD_TEST
        let shcnum = shc.replacingOccurrences(of: "shc:/", with: "").transformFromNumericMode(every: 2)
        print(shcnum)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        testHarness()
        setupNavigationAppearance()
        setupDatabase()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

