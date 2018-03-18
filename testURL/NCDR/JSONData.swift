//
//  JSONData.swift
//  testURL
//
//  Created by HsuKaiChieh on 09/02/2018.
//  Copyright © 2018 KaiChieh. All rights reserved.
//
import Foundation

// TODO: add protocol AlertJson:didFinish load:
// TODO: save to UserDefaults.standar

class AlertJson: NSObject {
    var urlJson: URL?
    var alertFeeds: AlertFeeds?

    init?(URLString: String) {
        super.init()
//        alertFeeds = AlertFeeds(idString: <#T##String?#>, title: <#T##String?#>, entries: <#T##[Entry]?#>)
        urlJson = URL(string: URLString)
        alertFeeds = AlertFeeds()
        if !(self.getDataFromInternet(URLString: URLString)) {
            return nil
        }
    }
    
    func getDataFromInternet(URLString: String) -> Bool {

        if let url = URL(string: URLString) {
            DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response , error) in
                                               //check url really we want
                    if let data = data, url == self?.urlJson {
                        guard let jsonDicObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                             return
                        }
                        
                        //root
                        if let title = jsonDicObj!["title"] as? String {
                            self?.alertFeeds?.title = title
                            print("Root title= \(title)")
                        }
                        // one tntry
                        if let entry = jsonDicObj!["entry"] as? [String : Any] {
                            var entryTemp = Entry()
                            //id
                            if let idString = entry["id"] as? String {
                                entryTemp.idString = idString
                                print("ID= \(idString)")
                            }
                            //title
                            if let title = entry["title"] as? String {
                                entryTemp.title = title
                                print("Title= \(title)")
                            }
                            //updated
                            if let updated = entry["updated"] as? String {
                                entryTemp.updated = updated
                                print("Updated= \(updated)")
                            }
                            // author
                            if let author = entry["author"] as? [String : String] {
                                entryTemp.author = author["name"]
                            }
                            // summary
                            if let summary = entry["summary"] as? [String : String] {
                                entryTemp.summary = summary["#text"]
                                print("Summary= \(String(describing: summary["#text"]))")
                            }
                            // category
                            if let category = entry["category"] as? [String : String] {
                                entryTemp.category = category["@term"]
                            }
                            self?.alertFeeds?.entries?.append(entryTemp)
                        }
                        
                        // entris
                        if let entries = jsonDicObj!["entry"] as? [[String : Any]] {
                            
                            for entry in entries {
                                //id
                                if let idString = entry["id"] as? String {
//                                    self?.idString?.append(idString)
                                    print("ID= \(idString)")
                                }
                                //title
                                if let title = entry["title"] as? String {
//                                    self?.title?.append(title)
                                    print("Title= \(title)")
                                }
                                //summary
                                if let summary = entry["summary"] as? [String : String] {
//                                    self?.summary?.append(summary["#text"]!)
        //                            print("Summary= \(summary["#text"])")
                                }
                                //updated
                                if let updated = entry["updated"] as? String {
//                                    self?.updated?.append(updated)
        //                            print("Updated= \(updated)")
                                }
        //                        print("-----------------------------------------")
                                
                            }
                        }
                    } else {
                        print("Error...")
                    }
                }//end URLSession.shared.dataTask
                task.resume()
            }
        } else {//end if let url = URL
            return false
        }
        return true
    }
}
struct AlertFeeds {
//    CustomDebugStringConvertible
//    var debugDescription: String
    init() {
        entries = [Entry]()
    }
    var idString: String?
    var title: String?
    var entries: [Entry]?
}
struct Entry {
    init() {
        print("Entry init")
    }
    var idString: String?
    var title: String?
    var updated: String?
    var author: String?
    var summary: String?
    var category: String?
}

