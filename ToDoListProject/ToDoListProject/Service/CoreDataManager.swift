//
//  CoreDataManager.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 14.07.2023.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private var itemsCoreData = [Item]()
    private var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    func incertOrReplace(item: TodoItem) {
        if let index = itemsCoreData.firstIndex(where: {item.id == $0.id}) {
            if let item = item.coreData {
                itemsCoreData[index] = item
            }
        } else {
            if let item = item.coreData {
                itemsCoreData.append(item)
            }
        }
        saveContext()
    }
    
    func save(items: [TodoItem]) {
        for item in items {
            incertOrReplace(item: item)
        }
    }
    
    func delete(id: String) {
        var index: Int?
        for identifier in (0..<itemsCoreData.count) where itemsCoreData[identifier].id == id {
            index = identifier
        }
        if let index = index {
            if let context = context {
                context.delete(itemsCoreData[index])
                itemsCoreData.remove(at: index)
            }
        }
        saveContext()
    }
    
    func dropTable() {
        if let context = context {
            for item in itemsCoreData {
                context.delete(item)
            }
            
        }
    }
    
    func load() -> [TodoItem] {
        var collectionsOfToDoItems = [TodoItem]()
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            if let context = context {
                itemsCoreData = try context.fetch(request)
                for item in itemsCoreData {
                    if let convertedItem = TodoItem.makeTodoItemFromCoreData(item: item) {
                        collectionsOfToDoItems.append(convertedItem)
                    }
                }
            }
        } catch {
            print("Error loading context \(error)")
        }
        return collectionsOfToDoItems
    }
        
    private func saveContext() {
        do {
            if let context = context {
                try context.save()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
}
