//
//  AppDelegate.swift
//  medic
//
//  Created by Nathan May on 09/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "159954287149-6ulu9mgrsdbl750l29qvcu33r9g9ook5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //  return GIDSignIn.sharedInstance().handle(url)
        //return ApplicationDelegate.shared.application(app, open: url, options: options)
            let isFBOpenUrl = ApplicationDelegate.shared.application(app, open: url, options: options)
            let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url)
            if isFBOpenUrl { return true }
            if isGoogleOpenUrl { return true }
            return false
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
//        print(fullName)
//        print(userId)
//
//        let storyboard = UIStoryboard(name: "HomePage", bundle: nil);
//        let vc = storyboard.instantiateViewController(identifier: "HomePageVC") ;
    
        // MySecondSecreen the storyboard ID
       // present(vc, animated: true, completion: nil);
        print("Logged 1n")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
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

