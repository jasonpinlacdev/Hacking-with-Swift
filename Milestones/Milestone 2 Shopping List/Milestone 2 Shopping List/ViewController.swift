//
//  ViewController.swift
//  Milestone 2 Shopping List
//
//  Created by Jason Pinlac on 11/12/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        setupNavigation()
        
    }
    
    @objc func addItemToList() {
        let ac = UIAlertController(title: "Add item to list...", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            if let item = ac?.textFields?[0].text {
                self?.submit(item)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        // to insert ontop of list
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // To insert on bottom of list
        //        shoppingList.append(item)
        //        let indexPath = IndexPath(row: shoppingList.count - 1, section: 0)
        //        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    @objc func shareList() {
        var stringList = shoppingList.joined(separator: "\n- ")
        stringList.insert(" ", at: stringList.startIndex)
        stringList.insert(" ", at: stringList.startIndex)
        let vc = UIActivityViewController(activityItems: [stringList], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemToList))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [shareButton, addButton]
    }
    
}

