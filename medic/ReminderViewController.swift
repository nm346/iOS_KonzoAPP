//
//  ReminderViewController.swift
//  medic
//
//  Created by Nathan May on 27/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import SwiftSoup
class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   // var alarmsList = [[String:String]]()
    let content = UNMutableNotificationContent()
    var medicationList = [MedicationModel]()
    var ReminderStatusList = [ReminderStatus]()
    var pendingNotificationRequests = [String]()
    @IBOutlet var tableView: UITableView!
    var username = ""
    var indexRow = 0
    var db: OpaquePointer?
    @IBAction func showReminders(_ sender: Any) {
    }
    
    @IBOutlet var mainTableView: UITableView!
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderStatusList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")

        if(!ReminderStatusList.isEmpty){
        let reminderStatus = ReminderStatusList[indexPath.row]
        print("pimp: \(reminderStatus.identifier)")
        let time = splitID(identifier: reminderStatus.identifier!)[1]
        let medName = splitID(identifier: reminderStatus.identifier!)[0]
            print("Excx:\(reminderStatus.identifier!)")
        
        indexRow = indexPath.row
        let switchObj = UISwitch(frame: .zero)
        let setOnBool: Bool
            if(reminderStatus.status == 1){
                setOnBool = true
            }
            else{
               setOnBool = false
            }
        print("ON or OFF:\(reminderStatus.status))")
        switchObj.setOn(setOnBool, animated: true)
        switchObj.tag = indexPath.row
        switchObj.addTarget(self, action: #selector(self.switchValueDidChange(_:)), for: .valueChanged)
        let timeArray = time.components(separatedBy: ":")
        cell.textLabel?.text = "\(timeArray[0]):\(timeArray[1])"
        cell.detailTextLabel?.text = medName
        cell.detailTextLabel?.isHidden = false
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = switchObj
        cell.accessibilityIdentifier = "\(medName)+\(time)"
        switchObj.accessibilityIdentifier = "\(medName)+\(time)"
        }
        return cell
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        let center = UNUserNotificationCenter.current()
        let identifier = sender.accessibilityIdentifier!
        let senderStatus: Int
        var reminderStatus: ReminderStatus
        if (sender.isOn == true){
            let array = sender.accessibilityIdentifier!.components(separatedBy: "+")
            let requestID = sender.accessibilityIdentifier!
            senderStatus = 1
            print("on ")
            if(!pendingNotificationRequests.contains(requestID)){
            setReminder(medname: array[0],time: array[1])
            }
            for status in ReminderStatusList{
                 if status.identifier == identifier{
                    print("KK:\(String(sender.isOn))")
                     reminderStatus = status
                    let updateTableQuery = "UPDATE ReminderStatus SET status = \(senderStatus) WHERE id = \(reminderStatus.id);"
                                          if sqlite3_exec(db, updateTableQuery,nil,nil,nil) != SQLITE_OK{
                                              print("Error updating table")
                 }
             }
             }
            print(pendingNotificationRequests)
        }
        else{
            senderStatus = 0
            print("off")
            print(pendingNotificationRequests)
            for status in ReminderStatusList{
                if status.identifier == identifier{
                     print("KK:\(String(sender.isOn))")
                    reminderStatus = status
                    let updateTableQuery = "UPDATE ReminderStatus SET status = \(senderStatus) WHERE id = \(reminderStatus.id);"
                                         if sqlite3_exec(db, updateTableQuery,nil,nil,nil) != SQLITE_OK{
                                             print("Error updating table")
                }
            }
            }
                
            center.removePendingNotificationRequests(withIdentifiers: [sender.accessibilityIdentifier!])
            if let index = pendingNotificationRequests.firstIndex(of: sender.accessibilityIdentifier!) {
                sender.isOn = false
            }
            print(pendingNotificationRequests)
            notifications()
        }
    }
    
    func splitID(identifier: String) -> Array<String> {
        let array = identifier.components(separatedBy: "+")
        return array
    }
    
    func setReminder(medname: String, time: String) {
         let timeArray = time.components(separatedBy: ":")
             content.title = "Konzo medication reminder!!"
             content.body = "\(username), please don't forget to take your \(medname) medication within the next hour"
             content.sound = UNNotificationSound.default
             content.badge = 1
             let calendar = Calendar.current
             var components = DateComponents()
             components.day = calendar.component(.day, from: Date())
             components.month = calendar.component(.month, from: Date())
             components.year = calendar.component(.year, from: Date())
             if(timeArray.count == 3){
             components.hour = Int(timeArray[0])
             components.minute = Int(timeArray[1])
             components.second = 00
             }
             else{
                 print("Time array Error")
             }
             let newDate = calendar.date(from: components)!
             let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: newDate)
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
             let request = UNNotificationRequest(identifier: "\(medname)+\(time)", content: content, trigger: trigger)
                if(!pendingNotificationRequests.contains(request.identifier)){
                pendingNotificationRequests.append(request.identifier)
             }
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
         }
    
    func notifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            (requests) in
            var nextTriggerDates: [Date] = []
            
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                    let triggerDate = trigger.nextTriggerDate(){
                    nextTriggerDates.append(triggerDate)
                }
                print("title: \(request.content.title)")
                print("body: \(request.content.body)")
                print("iD: \(request.identifier)")
                if(!self.pendingNotificationRequests.contains(request.identifier)){
                   self.pendingNotificationRequests.append(request.identifier)
                }
                print("pnr: \(self.pendingNotificationRequests)")
                print("NEW LINE______")
            }
            if let nextTriggerDate = nextTriggerDates.min() {
                print(nextTriggerDate)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let center = UNUserNotificationCenter.current()
        let cell = tableView.cellForRow(at: indexPath)
        let array = cell!.accessibilityIdentifier!.components(separatedBy: "+")
        
        if editingStyle == .delete{
            let name = array[0]
            let time = array[1]
            let identifier = "\(name)+\(time)"
            
            for reminderStatus in ReminderStatusList{
                if(reminderStatus.identifier==identifier){
                    print("describing:\(identifier)")
                        let deleteRowQuery = "DELETE FROM ReminderStatus WHERE id = \(reminderStatus.id)"
                        if sqlite3_exec(db, deleteRowQuery,nil,nil,nil) != SQLITE_OK{
                                      print("Error deleting row")
                                      return
                                  }
                    center.removePendingNotificationRequests(withIdentifiers: [identifier])
                    print("RemindB:\(ReminderStatusList)")
                    print("pB:\(pendingNotificationRequests)")
                    pendingNotificationRequests.remove(at: indexPath.row)
                    ReminderStatusList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .bottom)
                    print("RemindA:\(ReminderStatusList)")
                    print("pA:\(pendingNotificationRequests)")
                }
                
            }
//            center.removePendingNotificationRequests(withIdentifiers: [identifier])
//            print("RemindB:\(ReminderStatusList)")
//            print("pB:\(pendingNotificationRequests)")
//            pendingNotificationRequests.remove(at: indexPath.row)
//            ReminderStatusList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//            print("RemindA:\(ReminderStatusList)")
//            print("pA:\(pendingNotificationRequests)")
        }
    }
    
    func addColon(input: String) -> String{
        var to_return = "000000"
        print(input)
        let array = Array(input)
        if(input.count == 6){
            to_return = "\(array[0])\(array[1]):\(array[2])\(array[3]):\(array[4])\(array[5])"
        }
        return to_return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ReminderStatus.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening reminder database")
            return
        }
        let center = UNUserNotificationCenter.current()
        let createTableQuery = "CREATE TABLE IF NOT EXISTS ReminderStatus (id INTEGER PRIMARY KEY AUTOINCREMENT, identifier TEXT, status INTEGER)"
        //center.removeAllPendingNotificationRequests()
        let deleteTableQuery = "DROP TABLE IF EXISTS ReminderStatus"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating reminder status table")
            return
        }
        
        print("everything is fine for reminder table")
       // notifications()
       // print("RR\(ReminderStatusList)")
        for request in pendingNotificationRequests{
            print("NIGZ\(request)")
            loadData(identifier: request, status: 1)
        }
        print("DDD1: \(pendingNotificationRequests)")
        readValues()
        print("DDD2: \(pendingNotificationRequests)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
           print("Dismissal")
           performSegue(withIdentifier: "medSegue", sender: self)
        }
    }
    
//    @IBAction func medicationReminders(_ sender: Any) {
//         performSegue(withIdentifier: "medSegue", sender: self)
//    }
    @IBAction func backToMedication(_ sender: Any) {
        performSegue(withIdentifier: "medSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! Medicine
        vc.medicationList = self.medicationList
        vc.username = self.username
        vc.pendingNotificationRequests = self.pendingNotificationRequests
        ReminderStatusList.removeAll()
    }
    
    func loadData(identifier: String, status: Int){
        let statusString = String(status)
        
        if(identifier.isEmpty){
            print("identifier name is empty")
            return
        }
        if(statusString.isEmpty){
            print("status is empty")
            return
        }
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let insertQuery = "INSERT INTO ReminderStatus (identifier, status) VALUES (?, ?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("Error binding reminder query")
        }
        
        if sqlite3_bind_text(stmt, 1, identifier, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error binding identifier")
        }
        
        if sqlite3_bind_int(stmt, 2, (statusString as NSString).intValue) != SQLITE_OK{
              print("Error binding status")
          }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            print("Reminder table successfully saved!")
        }
    }
    
    func readValues(){
        pendingNotificationRequests.removeAll()
              ReminderStatusList.removeAll()
              let queryString = "SELECT * FROM ReminderStatus"
              var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
             let id = sqlite3_column_int(stmt, 0)
             let identifier = String(cString: sqlite3_column_text(stmt, 1))
             let status = sqlite3_column_int(stmt, 2)
                if(!pendingNotificationRequests.contains(identifier)){
                pendingNotificationRequests.append("\(identifier)")
                ReminderStatusList.append(ReminderStatus(id: Int(id), identifier: String(describing: identifier), status: Int(status)))
            }
        }
        if(!ReminderStatusList.isEmpty){
        print("rsl: \(ReminderStatusList[0].id)")
        print("ur bool: \(ReminderStatusList[0].status)")
        print("ur id: \(ReminderStatusList[0].identifier ?? "L")")
        }
        self.tableView.reloadData()
        
    }
    
}

class ReminderStatus {
    var id: Int
    var identifier: String?
    var status: Int
    init(id: Int, identifier: String?,status: Int){ //reminderTime: String?
        self.id = id
        self.identifier = identifier
        self.status = status
        
    }

}
