//
//  OptionsTableViewController.swift
//  Milestone10 Concentration
//
//  Created by Jason Pinlac on 4/14/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {
    
    weak var viewController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Options"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContentButtonTapped))
    }
    
    @objc func addContentButtonTapped() {
        let alertController = UIAlertController(title: "Add Content", message: "By adding content to the game, the current game will be reset.", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak alertController, weak viewController, weak self] action in
            if let content: String = alertController?.textFields?[0].text {
                guard !content.isEmpty else { return }
                viewController?.contentForCardButtons.append(content)
                viewController?.resetGame()
                self?.tableView.reloadData()
            }
        })
        
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewController.contentForCardButtons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "content")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "content")
        }
        cell.textLabel?.text = viewController.contentForCardButtons[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewController.contentForCardButtons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewController.resetGame()
        }
    }

}
