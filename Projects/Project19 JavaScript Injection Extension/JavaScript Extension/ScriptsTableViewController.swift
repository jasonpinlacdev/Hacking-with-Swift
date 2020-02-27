//
//  ScriptsTableViewController.swift
//  JavaScript Extension
//
//  Created by Jason Pinlac on 2/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ScriptsTableViewController: UITableViewController {
    
    var scripts: [String]!
    var script: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "script")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "script")
        }
        cell.textLabel?.text = scripts[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        script.text = scripts[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
    
    
}
