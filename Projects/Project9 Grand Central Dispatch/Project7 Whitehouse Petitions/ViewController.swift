//
//  ViewController.swift
//  Project7 Whitehouse Petitions
//
//  Created by Jason Pinlac on 12/22/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var originalPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            title = "Most Recent"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            title = "Top Rated"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100&sortBy=signature_count&sortOrder=desc"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            self?.showError()
        }
    }
    
    func parse(json data: Data) {
        // data is a fundamental type that holds binary data. its like String and Int
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
            originalPetitions = jsonPetitions.results
            petitions = originalPetitions
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "URL data loading error", message: "There was a problem loading the Petition's feed; Please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    
    
    
    
    func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(filter))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItems = [searchButton, resetButton]
    }
    
    @objc func filter() {
        let ac = UIAlertController(title: "Search filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] _ in
            guard let searchWord = ac?.textFields?[0].text else { return }
            self?.petitions.removeAll(keepingCapacity: true)
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                for petition in self?.originalPetitions ?? [] {
                    if petition.title.contains(searchWord) || petition.body.contains(searchWord) {
                        self?.petitions.append(petition)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
            
        }
        ac.addAction(submit)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func reset() {
        petitions = originalPetitions
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "\"We the People\"\nAPI of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = "(\(petition.signatureCount)) \(petition.title)"
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

