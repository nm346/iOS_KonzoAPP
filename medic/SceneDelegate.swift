//
//  SceneDelegate.swift
//  medic
//
//  Created by Nathan May on 09/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        let loginManager = LoginManager()
//               loginManager.logIn(
//                   permissions: [.publicProfile, .userFriends]
//               )
//        if let accessToken = AccessToken.current {
//
//            let storyboard = UIStoryboard(name: "HomePage", bundle: nil);
//            let vc = storyboard.instantiateViewController(identifier: "HomePageVC") ; // MySecondSecreen the storyboard ID
//            let rootNC = UINavigationController(rootViewController: vc)
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
//            print("Logged xhfdg1 in")
//        }
//        else{
//        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
//                   self.window = UIWindow(windowScene: windowScene)
//                   //self.window =  UIWindow(frame: UIScreen.main.bounds)
//                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let rootVC = storyboard.instantiateViewController(identifier: "LoginVC") as? ViewController else {
//                       print("ViewController not found")
//                       return
//                   }
//                   let rootNC = UINavigationController(rootViewController: rootVC)
//                   self.window?.rootViewController = rootNC
//                   self.window?.makeKeyAndVisible()
//            print("Logsdgss1 in")
//            }
//
//        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

