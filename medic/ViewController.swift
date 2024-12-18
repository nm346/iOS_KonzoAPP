//
//  ViewController.swift
//  medic
//
//  Created by Nathan May on 09/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {
    
    @IBAction func firstButtonView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
               let vc = storyboard.instantiateViewController(identifier: "WaitLoginVC") ; // MySecondSecreen the storyboard ID
               self.present(vc, animated: true, completion: nil);
               print("Logged 1 in")
        
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .userFriends, .email],
            viewController: self
        )
       
    }

    @IBAction func secondButtonView(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        print("Google Clicked");
         let storyboard = UIStoryboard(name: "Main", bundle: nil);
         let vc = storyboard.instantiateViewController(identifier: "WaitLoginVC") ; // MySecondSecreen the storyboard ID
         self.present(vc, animated: true, completion: nil);
         print("Logged 1 in")
    }
    
    @IBAction func thirdButtonView(_ sender: Any) {
        print("email Clicked");
    }
    
    
    @IBAction func Continue(_ sender: Any) {
        print("Continue");
        if AccessToken.current != nil {
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil);
            let vc = storyboard.instantiateViewController(identifier: "HomePageVC") ; // MySecondSecreen the storyboard ID
            self.present(vc, animated: true, completion: nil);
            print("login via continue")
        }
        else if(GIDSignIn.sharedInstance()?.currentUser != nil){
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil);
            let vc = storyboard.instantiateViewController(identifier: "HomePageVC") ; // MySecondSecreen the storyboard ID
            self.present(vc, animated: true, completion: nil);
           
        }
        else {
         let storyboard = UIStoryboard(name: "Main", bundle: nil);
         let vc = storyboard.instantiateViewController(identifier: "LoginVC") ; // MySecondSecreen the storyboard ID
         self.present(vc, animated: true, completion: nil);
            
        }
      
    }
    
    
//    @IBAction func Signout(_ sender: Any) {
//                print("Signing out");
//                GIDSignIn.sharedInstance()?.signOut()
//                let loginManager = LoginManager()
//                       loginManager.logOut()
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil);
//                           let vc = storyboard.instantiateViewController(identifier: "LoginVC") ; // MySecondSecreen the storyboard ID
//                           self.present(vc, animated: true, completion: nil);
//                           print("Logged in")
  //          }
    
    
    
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        // Do any additional setup after loading the view.
      GIDSignIn.sharedInstance()?.presentingViewController = self
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
//        if let accessToken = AccessToken.current {
//
//            let storyboard = UIStoryboard(name: "HomePage", bundle: nil);
//            let vc = storyboard.instantiateViewController(identifier: "HomePageVC") ; // MySecondSecreen the storyboard ID
//            self.present(vc, animated: true, completion: nil);
//            print("Logged 1 in")
//
//        }
      // ...
    }
    
    //sign out of google
    @objc func signOut(_ sender: UIButton) {
        print("Signing out");
        GIDSignIn.sharedInstance()?.signOut()
        let loginManager = LoginManager()
               loginManager.logOut()
        
    }
    //sign out of facebook
    @IBAction private func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()

//        let alertController = UIAlertController(
//            nibName: "Logout",
//            bundle?,: "Logged out."
//        )
//        present(alertController, animated: true, completion: nil)
    }
    
    
}

