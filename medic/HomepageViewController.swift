//
//  HomepageViewController.swift
//  medic
//
//  Created by Nathan May on 13/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
//import UserNotifications

class HomepageViewController: UIViewController{
    
    
    @IBOutlet var TopLabel: UILabel!
    @IBOutlet var GreetingLabel: UILabel!
    @IBOutlet var SearchBar: UISearchBar!
    var username = String()
    //medicinePageSegue
//    @IBAction func medicineButton(_ sender: Any) {
//         performSegue(withIdentifier: "searchMedicineSegue", sender: self)
//    }
//
//    @IBAction func medicinePageButton(_ sender: Any) {
//         performSegue(withIdentifier: "medicinePageSegue", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let vc = segue.destination as! MedicineViewController
//        vc.username = self.username
//      //  print(vc.username)
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "searchMedicineSegue" {
            let controller = segue.destination as! MedicineViewController
            controller.username = self.username
        } else if segue.identifier == "medicinePageSegue" {
            let controller = segue.destination as! Medicine
            controller.username = self.username
        }
    }
    
    
    
//    @IBAction func Notification(_ sender: Any) {
//        let content = UNMutableNotificationContent()
//        content.title = "Konzo medication reminder!!"
//        content.body = "\(username), please don't forget to take your meds within the next hour"
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.day = calendar.component(.day, from: Date())
//        components.month = calendar.component(.month, from: Date())
//        components.year = calendar.component(.year, from: Date())
//        components.hour = 18
//        components.minute = 59
//        components.second = 0
//        var shouldRepeat = true
//        let newDate = calendar.date(from: components)!
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: shouldRepeat)
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        let dateTimeString = formatter.string(from: currentDateTime)
        print("currentDT: \(currentDateTime)")
        print("formatter: \(formatter)")
        print("datetimestring: \(dateTimeString)")
        print("Already logged in")
        if(dateTimeString.contains("PM")){
            self.GreetingLabel.text = "Good Afternoon!"
            }
        else{
            self.GreetingLabel.text = "Good Morning!"
            }
        if AccessToken.current != nil {
            fetchFacebookProfile()
        }
        else if(GIDSignIn.sharedInstance()?.currentUser != nil){
            fetchGoogleProfile()
        }
    }
    
    @IBAction func LogoutButton(_ sender: UIButton) {
                    print("Signing out !");
                    GIDSignIn.sharedInstance()?.signOut()
                    let loginManager = LoginManager()
                           loginManager.logOut()
    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                               let vc = storyboard.instantiateViewController(identifier: "LoginVC") ; // MySecondSecreen the storyboard ID
                               self.present(vc, animated: true, completion: nil);
    }
    
    func fetchFacebookProfile()
       {
        
           let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
           
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
               
               if(error == nil)
               {
                   guard let data = result as? [String:Any] else { return }
               //    let fbid = data["id"]
                   let username = data["name"]
                self.username = username as! String
                 //  let email = data["email"]
                self.TopLabel.text = (username as! String)
               }

           })
       }
    
    func fetchGoogleProfile(){
        let username = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName)
        self.TopLabel.text = (username)
        self.username = username!
    }

}
