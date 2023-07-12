//
//  ToDoItemsModel.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 30.06.2023.
//

import Foundation

protocol ToDoItemsModelInput: AnyObject {
    func loadToDoItems()
    func deleteItem(id: String)
    func editingItem(item: TodoItem)
    func reloadToDoItems(items: [TodoItem]) -> Bool
    func addingNewItem(item: TodoItem)
}

// MARK: - Place ModuleOutput

protocol ToDoItemsModelOutput: AnyObject {
    func didRecieveData(items: [TodoItem])
    func saveItemsToFile()
    func reloadToDoItems()
    var isDirty: Bool { get set }
}
