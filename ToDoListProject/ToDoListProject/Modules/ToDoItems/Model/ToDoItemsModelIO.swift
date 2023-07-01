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
    func addingItem(item: TodoItem)
}

// MARK: - Place ModuleOutput

protocol ToDoItemsModelOutput: AnyObject {
    func didRecieveData(items: [TodoItem])
}
