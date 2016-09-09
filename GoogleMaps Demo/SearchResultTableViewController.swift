//
//  SearchResultTableViewController.swift
//  GoogleMaps Demo
//
//  Created by Michael Gerasimov on 9/7/16.
//  Copyright © 2016 Michael Gerasimov. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchResultTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.separatorStyle = .None
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.bounces = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize"
        {
            for const in tableView.constraints
            {
                if const.firstAttribute == NSLayoutAttribute.Height
                {
                    tableView.removeConstraint(const)
                }
            }
            
            tableView.heightAnchor.constraintEqualToConstant(tableView.contentSize.height).active = true
        }
    }
    
    var suggestions = [String](){
        didSet{
           
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return suggestions.count
    }

//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = UIColor(white:0.7 ,alpha:0.6)
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor(white:0.7 ,alpha:0.6)
        cell.textLabel?.text = suggestions[indexPath.row]

        return cell
    }
     
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        completionHandler?(suggestions[indexPath.row])
    }
    
    var completionHandler :((String) -> ())?
    
    func fetchSuggestions(searchText: String)
    {
        let placesClient = GMSPlacesClient()
//        let filter = GMSAutocompleteFilter()
//        
//        filter.type = .Address
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { [unowned self] (results, error:NSError?) -> Void in
            self.suggestions.removeAll()
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            for result in results!{
                self.suggestions.append(result.attributedFullText.string)
            }
            
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade) // Moved from didSet method of suggestion array
        }
    }
}
