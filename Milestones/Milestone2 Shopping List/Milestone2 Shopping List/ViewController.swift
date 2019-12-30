//
//  ViewController.swift
//  Milestone2 Shopping List
//
//  Created by Jason Pinlac on 12/21/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        start()
    }
    
    func setup() {
        title = "Shopping List"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(start))
    }
    
    @objc func start() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func share() {
        var list = shoppingList.joined(separator: "\n")
        list = "--Shopping list--\n" + list
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            if let item = ac?.textFields?[0].text {
                self?.submit(item)
            }
            
        }
        ac.addAction(submit)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        shoppingList.append(item)
        let indexPath = IndexPath(row: shoppingList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
}

