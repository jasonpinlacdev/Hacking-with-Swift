//
//  ViewController.swift
//  Milestone2 ShoppingList V2
//
//  Created by Jason Pinlac on 1/17/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = List()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        title = "Shopping List"
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteList))
        trashButton.tintColor = UIColor.systemRed
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationItem.leftBarButtonItem = trashButton
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "Eggs, Bread, Milk, Butter, etc."
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak ac, weak self] _ in
            guard let text = ac?.textFields?[0].text else { return }
            if text.isEmpty { return }
            self?.shoppingList.addItem(description: text)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        guard !shoppingList.items.isEmpty else {
            let ac = UIAlertController(title: "Nothing to share", message: "Your list is currently empty.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(ac, animated: true)
            return
        }
        var strList = "---List---\nDate: \(Date().description.components(separatedBy: " ")[0])\n"
        let _ = shoppingList.items.map({
            if $0.isCompleted {
                strList += "Completed: \($0.description)\n"
            } else {
                strList += "\($0.description)\n"
            }
        })
        let vc = UIActivityViewController(activityItems: [strList], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @objc func deleteList() {
        let ac = UIAlertController(title: "Delete List?", message: "Are you sure you want to delete your current list?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Confirm", style: .default) {
            [weak self] _ in
            self?.shoppingList.deleteItems()
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: - tableView functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        let item = shoppingList.items[indexPath.row]
        
        if !item.isCompleted {
            cell.accessoryType = .none
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: item.description)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.accessoryType = .checkmark
            let attributeString = NSMutableAttributedString(string: item.description)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingList.toggleCompletion(row: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.removeItem(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

