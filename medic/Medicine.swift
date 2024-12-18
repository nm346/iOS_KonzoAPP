//
//  Medicine.swift
//  medic
//
//  Created by Nathan May on 17/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import UserNotifications
class Medicine: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var textFieldMilligram: UITextField!
    @IBOutlet var medicineName: UILabel!
    @IBOutlet var tableVIewMedicine: UITableView!
    @IBOutlet var textFieldQuantity: UITextField!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    @IBOutlet var medicineDescTextView: UITextView!
    let content = UNMutableNotificationContent()
    let datePicker = UIDatePicker()
    var finalMed = ""
    var finalDesc = ""
    var username = ""
    var reminderSetTime = "00:00:00"
    var alreadyAdded = Bool()
    var alarmsList = [[String:String]]()
    var medicationList = [MedicationModel]()
    var pendingNotificationRequests = [String]()
    //@IBOutlet var mgDosageTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet var duplicateWarningLabel: UILabel!
    
    @IBOutlet var reminderSetOutlet: UISwitch!
    
    func setReminderButton(medname: String) {
        let timeArray = reminderSetTime.components(separatedBy: ":")
        print("Real nigga hour: \(reminderSetTime)")
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
            components.second = Int(timeArray[2])
            }
            else{
                print("Time array Error")
            }
            let newDate = calendar.date(from: components)!
            let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: newDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            print("DATERR: \(dateComponents)")
         //   let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: "\(medname)+\(reminderSetTime)", content: content, trigger: trigger)
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
                print("subtitle: \(request.content.subtitle)")
                print("target: \(request.content.targetContentIdentifier)")
                print("body: \(request.content.body)")
                print("catName: \(request.content.categoryIdentifier)")
            if(!self.pendingNotificationRequests.contains(request.identifier)){
                   self.pendingNotificationRequests.append(request.identifier)
            }
                print("NEW LINE______")
            }
            if let nextTriggerDate = nextTriggerDates.min() {
                print("NTD: \(nextTriggerDate)")
            }
        }
    }
    
    var db: OpaquePointer?
    var myIndex = 0
    
    func createDatePicker(){
   //     dateTextField.textAlignment = .center
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //ba button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        //assign tooBar
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en_US");
        datePicker.addTarget(self, action: #selector(donePressed), for: UIControl.Event.valueChanged)
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm:ss"
        dateTextField.text = formatter.string(from: datePicker.date)
        reminderSetTime = dateTextField.text!
        let timeArray = dateTextField.text!.components(separatedBy: ":")
        reminderSetTime = "\(timeArray[0]):\(timeArray[1]):00"
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let medicationModel: MedicationModel
        medicationModel = medicationList[indexPath.row]
        cell.textLabel?.text = medicationModel.medicationName
        return cell
    }
    
    
    
    @IBAction func ClickOK(_ sender: Any) {
        let medicationName = finalMed
        duplicateWarningLabel.text = ""
        let milligram = textFieldMilligram.text?.trimmingCharacters(in: .whitespacesAndNewlines).filter("0123456789.".contains)
        let quanitity = textFieldQuantity.text?.trimmingCharacters(in: .whitespacesAndNewlines).filter("0123456789.".contains)
        var reminderOn = String()
        let reminderTime = dateTextField.text
        let descriptionDB = finalDesc
       // if(reminderSetOutlet.isOn &&
            if(!dateTextField.text!.isEmpty){
            setReminderButton(medname: medicationName)
            alarmsList.append([medicationName:reminderTime!])
            reminderOn = "true"
        }
        else{
            reminderSetOutlet.isOn = false
            reminderOn = "false"
        }
        if(!medicationList.isEmpty){
            checkIfExists(medicineToCheck: medicineName.text!)
//        for MedicationModel in medicationList{
//
//            if(medicationName.isEmpty || MedicationModel.medicationName == medicineName.text!){
//                if(MedicationModel.medicationName == medicineName.text!){
//                    duplicateWarningLabel.text = "\(medicineName.text!) has already been added to your list."
//                return
//                }
//                else{
//                    print("Medication is empty")
//                               return
//                }
//            }
//        }
        }
        if(!alreadyAdded){
        if(medicationName.isEmpty){
            print("medication name is empty")
            return
        }
        if(milligram?.isEmpty)!{
            print("milligram is empty")
            return
        }
        if(quanitity?.isEmpty)!{
            print("quanitity is empty")
            return
        }
        if(descriptionDB.isEmpty){
            print("description is empty")
            return
        }
        if(reminderOn.isEmpty){
            print("time not set")
            return
        }
        if(reminderTime?.isEmpty)!{
            print("reminder time is empty")
           // return
        }
        
        var stmt: OpaquePointer?
        let insertQuery = "INSERT INTO MedicationTable (medicationName, milligram, quanitity, descriptionDB, reminderOn, reminderTime) VALUES (?,?,?,?,?,?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("Error binding query")
        }
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, 1, medicationName, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error binding medication name")
        }
        if sqlite3_bind_int(stmt, 2, (milligram! as NSString).intValue) != SQLITE_OK{
            print("Error binding milligram count")
        }
        if sqlite3_bind_int(stmt, 3, (quanitity! as NSString).intValue) != SQLITE_OK{
            print("Error binding quanitity count")
        }
        if sqlite3_bind_text(stmt, 4, descriptionDB, -1, nil) != SQLITE_OK{
            print("Error binding medication description")
        }
        if sqlite3_bind_text(stmt, 5, String(reminderOn), -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error binding reminderOn name")
        }
        if sqlite3_bind_text(stmt, 6, reminderTime, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            print("Error binding reminderTime name")
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            print("MedicationTable saved successfully")
        }
         print("MedicationTable saved successfully")
        }
        readValues()
        notifications()
        self.tableVIewMedicine.reloadData()
        }
        
    
    func readValues(){
           //first empty the list of heroes
           medicationList.removeAll()
    
           //this is our select query
           let queryString = "SELECT * FROM MedicationTable"
    
           //statement pointer
           var stmt:OpaquePointer?
    
           //preparing the query
           if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return
           }
    
           //traversing through all the records
           while(sqlite3_step(stmt) == SQLITE_ROW){
               let id = sqlite3_column_int(stmt, 0)
               let medicationName = String(cString: sqlite3_column_text(stmt, 1))
               let milligram = sqlite3_column_int(stmt, 2)
               let quanitity = sqlite3_column_int(stmt, 3)
               let descriptionDB = String(cString: sqlite3_column_text(stmt, 4))
               let reminderOn = String(cString: sqlite3_column_text(stmt, 5))
               let reminderTime = String(cString: sqlite3_column_text(stmt, 6))
               //adding values to list
               medicationList.append(MedicationModel(id: Int(id),
                                                     medicationName: String(describing: medicationName),
                                                     milligram: Int(milligram),
                                                     quanitity: Int(quanitity),
                                                     descriptionDB: String(describing: descriptionDB),
                                                     reminderOn: String(describing: reminderOn),
                                                     reminderTime: String(describing: reminderTime)
               ))
           
           }

            // self.tableVIewMedicine.reloadData()
       }
    
    func addColon(input: String) -> String{
        var to_return = "000000"
        let array = Array(input)
        if(input.count == 6){
            to_return = "\(array[0])\(array[1]):\(array[2])\(array[3]):\(array[4])\(array[5])"
        }
        return to_return
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        medicineName.text = medicationList[myIndex].medicationName
        finalMed = medicineName.text!
        textFieldMilligram.text = "\(String(medicationList[myIndex].milligram))mg"
        textFieldQuantity.text = "\(String(medicationList[myIndex].quanitity))x" //descriptionDB
        medicineDescTextView.text = medicationList[myIndex].descriptionDB
        dateTextField.text = addColon(input: medicationList[myIndex].reminderTime!)
        print("P1 \(medicationList[myIndex].reminderTime!)")
        print(alreadyAdded)
        print("P2 \(addColon(input: medicationList[myIndex].reminderTime!))")
        if(medicationList[myIndex].reminderOn == "true"){
        reminderSetOutlet.isOn = true
        }
        else{
            reminderSetOutlet.isOn = false
        }
    }
//    @IBAction func medicationReminders(_ sender: Any) {
//         performSegue(withIdentifier: "reminderSegue", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var vc = segue.destination as! ReminderViewController
//        vc.medicationList = self.medicationList
//        vc.username = self.username
//        vc.pendingNotificationRequests = self.pendingNotificationRequests
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            let vc = segue.destination as! MedicineViewController
            vc.username = self.username
        } else if segue.identifier == "reminderSegue" {
            let vc = segue.destination as! ReminderViewController
            vc.medicationList = self.medicationList
            vc.username = self.username
            vc.pendingNotificationRequests = self.pendingNotificationRequests
        }
    }
    
    func checkIfExists(medicineToCheck: String){
        let milligram = Int((textFieldMilligram.text?.trimmingCharacters(in: .whitespacesAndNewlines).filter("0123456789.".contains))!)
        let quanitity = Int((textFieldQuantity.text?.trimmingCharacters(in: .whitespacesAndNewlines).filter("0123456789.".contains))!)
        let reminderOn = String(reminderSetOutlet.isOn)
        let reminderTime = dateTextField.text
        let medicationName = medicineName.text
        let descriptionDB = medicineDescTextView.text
                for MedicationModel in medicationList{
                    if(medicineToCheck.isEmpty || MedicationModel.medicationName == medicineToCheck){
                        if(MedicationModel.milligram == milligram && MedicationModel.quanitity == quanitity && MedicationModel.reminderOn == reminderOn && MedicationModel.reminderTime == reminderTime){
                            duplicateWarningLabel.text = "\(medicineToCheck) has already been added to your list."
                                alreadyAdded = true
                            }
                       else if(MedicationModel.milligram != milligram || MedicationModel.quanitity != quanitity || MedicationModel.reminderOn != reminderOn || MedicationModel.reminderTime != reminderTime){
                            MedicationModel.milligram = milligram!
                            MedicationModel.quanitity = quanitity!
                            MedicationModel.reminderOn = reminderOn
                            reminderSetOutlet.isOn = Bool(reminderOn)!
                            MedicationModel.reminderTime = reminderTime
                            duplicateWarningLabel.text = "Your \(medicineToCheck) has been updated."
                            //FIX REMINDER TIME
                            let updateTableQuery = "UPDATE MedicationTable SET milligram = \(milligram ?? 0), quanitity = \(quanitity ?? 0), reminderOn = \(reminderOn), reminderTime = \(reminderTime?.replacingOccurrences(of: ":", with: "") ?? "Error") WHERE id = \(MedicationModel.id);"
                            if sqlite3_exec(db, updateTableQuery,nil,nil,nil) != SQLITE_OK{
                                print("Error updating table")
                                /*                         let updateTableQuery = "UPDATE MedicationTable SET medicationName = \(medicationName), milligram = \(milligram ?? 0), quanitity = \(quanitity ?? 0), reminderOn = \(reminderOn), reminderTime = \(reminderTime?.replacingOccurrences(of: ":", with: "") ?? "Error") WHERE id = \(MedicationModel.id);"*/
                            
                                alreadyAdded = true
                            }
                        }
                        else{
                            print("Medication is empty")
                        }
                    }
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications()
        medicineName.text = finalMed
        medicineDescTextView.text = finalDesc
        createDatePicker()
        //notifications()
        content.badge = 0
        //textViewHC.constant = self.medicineDescTextView.contentSize.height
            let fileURL = try!
                FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MedicationDatabase.sqlite")
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
                print("Error opening database")
                return
            }
            
            let createTableQuery = "CREATE TABLE IF NOT EXISTS MedicationTable (id INTEGER PRIMARY KEY AUTOINCREMENT, medicationName TEXT, milligram INTEGER, quanitity INTEGER, descriptionDB TEXT, reminderOn TEXT, reminderTime TEXT)"
            let deleteTableQuery = "DROP TABLE IF EXISTS MedicationTable"
            if sqlite3_exec(db, createTableQuery,nil,nil,nil) != SQLITE_OK{
                print("Error creating table")
                return
            }
            readValues()
            print("Everything is fine")
        textFieldMilligram.resignFirstResponder()
    }
    
    //hidekeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let deleteRowQuery = "DELETE FROM MedicationTable WHERE id = \(medicationList[myIndex].id)"
            if sqlite3_exec(db, deleteRowQuery,nil,nil,nil) != SQLITE_OK{
                          print("Error deleting row")
                          return
                      }
            medicationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
        }
    }
}
class MedicationModel {
 
    var id: Int
    var medicationName: String?
    var milligram: Int
    var quanitity: Int
    var descriptionDB: String?
    var reminderOn: String?
    var reminderTime: String?
    init(id: Int, medicationName: String?, milligram: Int,quanitity: Int, descriptionDB: String?, reminderOn: String?,reminderTime: String?){ //reminderTime: String?
        self.id = id
        self.medicationName = medicationName
        self.milligram = milligram
        self.quanitity = quanitity
        self.descriptionDB = descriptionDB
        self.reminderOn = reminderOn
        self.reminderTime = reminderTime
        
    }

}

