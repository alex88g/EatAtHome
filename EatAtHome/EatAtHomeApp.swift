//
//  EatAtHomeExpressApp.swift
//  EatAtHomeExpress
//
//  Created by Alexander Gallorini on 2023-01-12.
//

import SwiftUI
import Firebase
import FirebaseAuth


@main
struct EatAtHomeApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
         
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .accentColor(.red)
        }
    }
}
// Initializing Firebase
class AppDelegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
