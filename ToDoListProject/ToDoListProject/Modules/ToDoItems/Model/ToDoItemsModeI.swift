//
//  ToDoItemsModelIO.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 30.06.2023.
//

import Foundation
import UIKit

final class ToDoItemsModel {
    weak var output: ToDoItemsModelOutput?
    private let service = FileCache.shared
}

extension ToDoItemsModel: ToDoItemsModelInput {
    func addingItem(item: TodoItem) {
        service.addingNewItem(item: item)
        service.writeJSON(path: "newFile")
        output?.didRecieveData(items: service.collectionOfToDoItems)
    }
    
    func deleteItem(id: String) {
        service.deleteItem(id: id)
        service.writeJSON(path: "newFile")
        output?.didRecieveData(items: service.collectionOfToDoItems)
    }
    
    func loadToDoItems() {
        service.readJSON(path: "newFile")
        output?.didRecieveData(items: service.collectionOfToDoItems)
    }
}
