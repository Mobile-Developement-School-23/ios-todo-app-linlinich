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
    func reloadToDoItems(items: [TodoItem]) -> Bool {
        guard let url = try? RequestProcessor.makeUrl() else {
            print("wrong url")
            return true
        }
        var array: [Any] = []

        for item in items {
            array.append(item.json)
        }
        do {
            let dict: [String: Any] = ["list": array]
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            RequestProcessor.reloadList(url: url, body: data) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    let (revision, data) = result
                    
                    output?.didRecieveData(items: data)
                    RequestProcessor.revision = revision
                    FileCache.isDirty = false
                case .failure(let error):
                    print(error)
                    output?.saveItemsToFile()
                    FileCache.isDirty = true
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return FileCache.isDirty
    }
    
    func addingItem(item: TodoItem) {
        if FileCache.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl(id: item.id)
        var dict: [String: Any] = ["element": item.json]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        RequestProcessor.performMyAwesomeRequest1(url: url!, method: .put, body: data) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let (revision, _) = result
                FileCache.isDirty = false
                RequestProcessor.revision = revision
                loadToDoItems()
            case .failure(let error):
                output?.saveItemsToFile()
                FileCache.isDirty = true
                print("Ошибка при изменении элемента")
            }
        }
    }
    
    func addingNewItem(item: TodoItem) {
        if FileCache.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl()
        var dict: [String: Any] = ["element": item.json]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        RequestProcessor.performMyAwesomeRequest1(url: url!, method: .post, body: data) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let (revision, _) = result
                loadToDoItems()
                RequestProcessor.revision = revision
                FileCache.isDirty = false
            case .failure(let error):
                FileCache.isDirty = true
                output?.saveItemsToFile()
                print("Ошибка при добавлении элемента")
            }
        }
    }
    
    func deleteItem(id: String) {
        if FileCache.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl(id: id)
        RequestProcessor.performMyAwesomeRequest1(url: url!, method: .delete) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let (revision, _) = result
                
                RequestProcessor.revision = revision
                loadToDoItems()
                FileCache.isDirty = false
            case .failure(let error):
                print(error)
                FileCache.isDirty = true
                output?.saveItemsToFile()
                print("Ошибка при добавлении элемента")
            }
        }
    }
    
    func loadToDoItems() {
        if FileCache.isDirty == true {
            self.output?.didRecieveData(items: service.collectionOfToDoItems)
            return
        }
        let url = try? RequestProcessor.makeUrl()
        RequestProcessor.performMyAwesomeRequest(url: url!) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                let (revision, items) = result
                RequestProcessor.revision = revision
                
                items.forEach {
                    self.service.addingNewItem(item: $0)
                }
                
                DispatchQueue.main.async {
                    self.output?.didRecieveData(items: items)
                }
            case .failure(let error):
                print(error)
                FileCache.isDirty = true
                output?.saveItemsToFile()
                print("Ошибка при добавлении элемента")
            }
        }
        
    }
}
