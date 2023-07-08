//
//  ToDoItemsModel.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 30.06.2023.
//

import Foundation

protocol ToDoItemsModelInput: AnyObject {
    func loadToDoItems() async throws
    func deleteItem(id: String)
    func addingItem(item: TodoItem)
    func reloadToDoItems(items: [TodoItem]) -> Bool
}

// MARK: - Place ModuleOutput

protocol ToDoItemsModelOutput: AnyObject {
    func didRecieveData(items: [TodoItem])
    func saveItemsToFile()
    func reloadToDoItems()
}
