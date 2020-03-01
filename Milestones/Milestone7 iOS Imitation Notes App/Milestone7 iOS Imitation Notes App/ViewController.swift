//
//  ViewController.swift
//  Milestone7 iOS Imitation Notes App
//
//  Created by Jason Pinlac on 2/28/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNoteTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, newNoteButton]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveNotes()
        tableView.reloadData()
    }
    
    
    @objc func newNoteTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Note") as? NoteViewController else { return }
        let newNote = Note(title: "title", body: "body")
        notes.insert(newNote, at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
        vc.selectedNote = newNote
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func saveNotes() {
        guard let data = try? JSONEncoder().encode(notes) else { print("Failed to save notes"); return }
        UserDefaults.standard.set(data, forKey: "notes")
        print("Notes saved")
    }
    
    func loadNotes() {
        if let data = UserDefaults.standard.object(forKey: "notes") as? Data {
            do {
                notes = try JSONDecoder().decode([Note].self, from: data)
                print("Notes loaded")
            } catch {
                print("Failed to load notes")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].date + " " + notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Note") as? NoteViewController else { return }
        vc.selectedNote = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveNotes()
        }
    }
}

