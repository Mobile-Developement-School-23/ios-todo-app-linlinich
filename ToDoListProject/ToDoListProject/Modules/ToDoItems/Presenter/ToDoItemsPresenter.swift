//
//  ToDoItemsPresenter.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 30.06.2023.
//

import Foundation

final class ToDoItemsPresenter {
    
    weak var  view: ToDoItemsViewInput?
    weak var moduleOutput: ToDoItemsModuleOutput?
    
    var toDoItems = [TodoItem]()
    private let model: ToDoItemsModelInput
    init(view: ToDoItemsViewInput, model: ToDoItemsModelInput) {
        self.view = view
        self.model = model
    }
    
    func didLoadView() {
        loadToDoItems()
    }

}

private extension ToDoItemsPresenter {
    func loadToDoItems() {
        model.loadToDoItems()
    }
    
}

extension ToDoItemsPresenter: ToDoItemsViewOutput {
    func checkIsDone(type: ToDoItemsViewController.TypeOfTableView, row: Int) -> Bool {
        if row < toDoItems.count {
            var item: TodoItem
            switch type {
            case .all:
                item = toDoItems[row]
            case .undone:
                item = toDoItems.filter { $0.didDone == false }[row]
            }
            return item.didDone
        }
        return true
    }
    
    func changeIsDone(type: ToDoItemsViewController.TypeOfTableView, row: Int) {
        if row < toDoItems.count {
            var item: TodoItem
            switch type {
            case .all:
                item = toDoItems[row]
                item.didDone = !toDoItems[row].didDone
            case .undone:
                print(row)
                item = toDoItems.filter { $0.didDone == false }[row]
                item.didDone = true
            }
            model.addingItem(item: item)
        }
    }
    
    func deleteItem(type: ToDoItemsViewController.TypeOfTableView, row: Int) {
        if row < toDoItems.count {
            switch type {
            case .all:
                let id = toDoItems[row].id
                model.deleteItem(id: id)
            case .undone:
                let id = toDoItems.filter { $0.didDone == false }[row].id
                model.deleteItem(id: id)
            }
        }
    }
    
    func countOfCompleted() -> Int {
        return toDoItems.filter { $0.didDone == true }.count
    }
    
    func displayToDoItems(row: Int, type: ToDoItemsViewController.TypeOfTableView) -> TodoItem? {
        switch type {
        case .all:
            if row < toDoItems.count {
                return toDoItems[row]
            }
        case .undone:
            if row < toDoItems.filter({ $0.didDone == false }).count {
                return toDoItems.filter { $0.didDone == false }[row]
            }
        }
        return nil
    }
    
    func getCellsCount(type: ToDoItemsViewController.TypeOfTableView) -> Int {
        switch type {
        case .all:
            return toDoItems.count
        case .undone:
            return toDoItems.filter { $0.didDone == false }.count
        }
    }
    
    
}

extension ToDoItemsPresenter: ToDoItemsModelOutput {
    func didRecieveData(items: [TodoItem]) {
        self.toDoItems = items.sorted(by: {$0.dateOfCreation > $1.dateOfCreation})
        view?.reload()
    }
}
