//
//  ViewController.swift
//  fetchTweet
//
//  Created by Owner on 2016-08-05.
//  Copyright © 2016 MohdJey. All rights reserved.
//

import UIKit





class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var people = [Array<People>]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchText: String? {
        didSet {
        //    people.removeAll()
            searchPeople()
            title = searchText
        }
    }
    
    func searchPeople() {
       
        fetchPerson { [weak weakself = self] (newPeople) in
            dispatch_async(dispatch_get_main_queue()) {
                if !newPeople.isEmpty {
                    weakself?.people.insert(newPeople, atIndex: 0)
                }
            }
        }
        
    }

//   var listArray: NSArray?
//var listArray = Array<String?>()
//var listArray:[String] = []
//    var villains: [String]? = nil
 //   var listArray: [String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "Binti"
    }
    
    //// TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath)
       let data =  people[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.subject
        return cell
    }
    
    
    ///// End TableView
    
   //  (Array<AnyObject>) -> ()
    
    func networkService (handler: (PropertyList) -> ()){
        
     //   var Local:[String] = []
        var listArray1 = Array<String>()
        var listDic = Array<NSDictionary>()
    //   let url = "http://itunes.apple.com/search?term=Frozen&media=software"
     let url = "http://localhost:5000/names.json"
        let nsurl = NSURL(string: url)
        let session = NSURLSession.sharedSession()
   //     //let request = NSURLRequest(URL: url!) if required for NSurlRequest
   //     //let task = session.dataTaskWithRequest
        let task = session.dataTaskWithURL(nsurl!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            do {
               // let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSArray // single line name only
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [NSDictionary]

              //   print(json)
                
                    for item in json {
                        if let name = item["name"] as? String, subject = item["subject"] as? String {
             
              //          self.listArray.insert(list, atIndex: 0)
                       //   listArray1.insert(item, atIndex: 0)
                            listDic.insert(item, atIndex: 0)
                        }
                    }
              //   handler(listArray1)
                 handler(listDic)
                
                 } catch {
                
            }
        }
        task.resume()
       
    }
    
    
    func fetchPerson(completionHadler: ([People]) -> Void) {
         fetch { (results) in
        //  var listArray: NSArray?
            var girls = [People]()
            
            print(results)
            
            for item in results! as! [NSDictionary] {
                let tweet = People(name: item["name"] as! String, subject: item["subject"] as! String)
                girls.append(tweet)
            }
            
            completionHadler(girls)
        }
    }
    
    
    
        typealias PropertyList = (Array<AnyObject>)
        func fetch(handler: (results: PropertyList?) -> Void) {
  //          performTwitterRequest(SLRequestMethod.GET, handler)
             networkService(handler)
    }
    
}


// public typealias PropertyList = AnyObject
//public func fetch(handler: (results: PropertyList?) -> Void) {
//    performTwitterRequest(SLRequestMethod.GET, handler)
//}

//func performTwitterRequest(request: SLRequest, handler: (PropertyList?) -> Void) {
//    if let account = twitterAccount {
//        request.account = account
//        request.performRequestWithHandler { (jsonResponse, httpResponse, _) in
//            var propertyListResponse: PropertyList?
//            if jsonResponse != nil {
//                propertyListResponse = NSJSONSerialization.JSONObjectWithData(
//                    jsonResponse,
//                    options: NSJSONReadingOptions.MutableLeaves,
//                    error: nil
//)
//







