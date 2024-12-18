//
//  MedicineViewController.swift
//  medic
//
//  Created by Nathan May on 15/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import SwiftSoup
class MedicineViewController: UIViewController, UISearchBarDelegate{
   
    @IBOutlet var searchBar: UISearchBar!
    var searchURL = String()
    @IBOutlet var definitionTextView: UITextView!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    var username = ""
    var searchedMed = ""
    var definitionText = ""
    
//    @IBAction func medicationButton(_ sender: Any) {
//        searchedMed = searchBar.text!
//        definitionText = definitionTextView.text
//        performSegue(withIdentifier: "medicineDetails", sender: self)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var vc = segue.destination as! Medicine
//        vc.finalMed = self.searchedMed
//        vc.finalDesc = self.definitionText
//        vc.username = self.username
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchedMed = searchBar.text!
        definitionText = definitionTextView.text
        if segue.identifier == "medicineDetails" {
            var vc = segue.destination as! Medicine
            vc.finalMed = self.searchedMed
            vc.finalDesc = self.definitionText
            vc.username = self.username
        } else if segue.identifier == "homeSegue" {
            let vc = segue.destination as! HomepageViewController
            vc.username = self.username
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        titleLabel.text = ""
        definitionTextView.text = ""
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: " ")
        var searchURL = "https://openmd.com/search?q=\(finalKeywords!)"
        getWebData(searchURL: searchURL)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.becomeFirstResponder()
   //     callAlzamo(url: searchURL)
      //  getWebData()
    }
    
    func textFieldShouldReturn(_ searchBar: UISearchBar) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getWebData(searchURL : String){
        
        let myURLString = searchURL
        var myHTMLString = ""
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }

        do {
            myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
       //    print("HTML : \(myHTMLString)")
        } catch let error {
            print("Error: \(error)")
        }
        //<div class="def--short">
        
        
        do {
                   let html = myHTMLString
                   var description:String = ""
                   let doc: Document = try SwiftSoup.parse(html)
                   let p: Element = try doc.select("title").first()!
                   let title = try p.text().split{$0 == " "}.map(String.init)
                   let definition = try doc.text().split{$0 == " "}.map(String.init)
                    for index in 1..<definition.count {
                        if(definition[index] == "Thesaurus" && definition[index+1] == "more"){
                           // toString+=
                            for i in index..<definition.count{
                                if(definition[i] == "NCI"){ break}
                                else if(definition[i] != "Thesaurus" && definition[i+1] != "more"){
                                    if(definition[i] != "more" && definition[i-1] != "Thesaurus" ){
                                        description += (definition[i]+" ")}
                                }
                            }
                            print(title[0])
                            titleLabel.text = title[0]
                            print(description)
                            definitionTextView.text = description
                          //  textViewHC.constant = self.definitionTextView.contentSize.height
                        }
                        }
           
                    //print(try p.text())
                  //  print(fullNameArr)
                   
               } catch Exception.Error(type: let type, Message: let message) {
                   print(type)
                   print(message)
               }
               catch{
                   print("")
               }
        
    }
    
    
}
