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
        let dict: [String: Any] = ["list": array]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        Task {
            do {
                let (data, responseStatusCode) = try await RequestProcessor.requestToTheServer(url: url, method: .patch, body: data)
                guard let (revision, _) = parseSingleItem(data: data) else { return }
                RequestProcessor.revision = revision
                output?.isDirty = false
            } catch {
                output?.isDirty = true
                output?.saveItemsToFile()
            }
            
        }
        return false
    }
    
    func editingItem(item: TodoItem) {
        if output?.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl(id: item.id)
        var dict: [String: Any] = ["element": item.json]

        let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        Task {
            do {
                let (data, responseStatusCode) = try await RequestProcessor.requestToTheServer(url: url!, method: .put, body: data)
                guard let (revision, _) = parseSingleItem(data: data) else { return }
                RequestProcessor.revision = revision
            } catch {
                output?.isDirty = true
                output?.saveItemsToFile()
            }
            
        }
    }
    
    func addingNewItem(item: TodoItem) {
        if output?.isDirty == true {
            output?.reloadToDoItems()
        }

        let url = try? RequestProcessor.makeUrl()
        var dict: [String: Any] = ["element": item.json]
        let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        Task {
            do {
                let (data, responseStatusCode) = try await RequestProcessor.requestToTheServer(url: url!, method: .post, body: data)
                guard let (revision, _) = parseSingleItem(data: data) else { return }
                RequestProcessor.revision = revision
            } catch {
                output?.isDirty = true
                output?.saveItemsToFile()
            }
        }
    }
    
    func deleteItem(id: String) {
        if output?.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl(id: id)
        Task {
            do {
                let (data, responseStatusCode) = try await RequestProcessor.requestToTheServer(url: url!, method: .delete)
                guard let (revision, _) = parseSingleItem(data: data) else { return }
                RequestProcessor.revision = revision
            } catch {
                output?.isDirty = true
                output?.saveItemsToFile()
            }
        }
    }
    
    func loadToDoItems() {
        if output?.isDirty == true {
            output?.reloadToDoItems()
        }
        let url = try? RequestProcessor.makeUrl()

        Task {
            do {
                let (data, responseStatusCode) = try await RequestProcessor.requestToTheServer(url: url!, method: .get)
                guard let (revision, items) = parseToDoItems(data: data) else { return }
                RequestProcessor.revision = revision
                output?.didRecieveData(items: items)
                output?.isDirty = false
            } catch {
                self.service.readJSON()
                output?.didRecieveData(items: self.service.collectionOfToDoItems)
                output?.isDirty = true
                output?.saveItemsToFile()
            }
        }
    }
    
    private func parseToDoItems(data: Data) -> (Int32, [TodoItem])? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            print("Ошибка при парсинге")
            return nil
        }
        guard let collectionOfToDoItemsJson = json["list"] as? [[String: Any]],
              let revisionJson = json["revision"] as? Int32
        else {
            print("Ошибка! в файле нет ToDoItem")
            return nil
        }

        var collectionToDoitem = [TodoItem]()
        for item in collectionOfToDoItemsJson {
            let optionalToDoItem = TodoItem.parse(json: item)
            if let toDoItem = optionalToDoItem {
                collectionToDoitem.append(toDoItem)
            }
        }
        return (revisionJson, collectionToDoitem)
    }
    
    private func parseSingleItem(data: Data) -> (Int32, TodoItem)? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        
        guard
            let itemjson = json["element"] as? [String: Any],
            let revisionJson = json["revision"] as? Int32,
            let item = TodoItem.parse(json: itemjson)
        else { return nil }
         return (revisionJson, item)
    }
}
