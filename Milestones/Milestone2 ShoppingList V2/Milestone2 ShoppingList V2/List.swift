//
//  List.swift
//  Milestone2 ShoppingList V2
//
//  Created by Jason Pinlac on 1/17/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import Foundation

class List: Codable {
    var items = [Item]()
    
    init() {
        load()
    }
    
    func addItem(description: String) {
        items.insert(Item(description: description, isCompleted: false), at: 0)
        save()
    }
    
    func toggleCompletion(row: Int) {
        items[row].isCompleted.toggle()
        save()
    }
    
    func removeItem(row: Int) {
        items.remove(at: row)
        save()
    }
    
    func deleteItems() {
        items.removeAll()
        save()
    }
    
    func save() {
        DispatchQueue.global(qos: .userInteractive).async {
            let encoder = JSONEncoder()
            if let saveData = try? encoder.encode(self.items) {
                let defaults = UserDefaults.standard
                defaults.setValue(saveData, forKey: "items")
            }
        }
    }
    
    func load() { // ASYNC
        DispatchQueue.global(qos: .userInteractive).async {
            let defaults = UserDefaults.standard
            if let savedData = defaults.object(forKey: "items") as? Data {
                let decoder = JSONDecoder()
                do {
                    self.items = try decoder.decode([Item].self, from: savedData)
                } catch {
                    print("Failed to load.")
                }
            }
        }
    }

}
