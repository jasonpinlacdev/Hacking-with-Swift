//
//  ViewController.swift
//  Project7 Whitehouse Petitions
//
//  Created by Jason Pinlac on 11/12/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//


// JSON - Javascript object notation - a way of describing data. compact and easy to parse for computers making it popular where bandwidth is at a premium

// UITabBarController manages an array of ViewControllers a user can choose from

// The easiest way to render complex content from the web is almost always WKWebView in a DetailViewController

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavBarButtons()
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                title = "\(self.filteredPetitions.count) Petitions"
                return
            }
        }
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    
    @objc func filter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            if let text = ac.textFields?[0].text {
                self.filteredPetitions.removeAll(keepingCapacity: true)
                for petition in self.petitions {
                    if petition.title.contains(text) || petition.body.contains(text) {
                        self.filteredPetitions.append(petition)
                    }
                }
                self.tableView.reloadData()
                self.title = "\(self.filteredPetitions.count) Petitions"
            }
        }
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    @objc func clear() {
        filteredPetitions = petitions
        tableView.reloadData()
        title = "\(self.filteredPetitions.count) Petitions"
    }
    
    @objc func credits() {
        let ac = UIAlertController(title: "Credits", message: "\"We The People\"\nAPI of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredPetitions[indexPath.row].title
        cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func setupNavBarButtons() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear)), UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

