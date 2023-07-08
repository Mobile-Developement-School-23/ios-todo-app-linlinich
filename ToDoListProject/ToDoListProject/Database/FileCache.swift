import Foundation

protocol FileCacheProtocol {
    func readJSON(path: String)
}

class FileCache: FileCacheProtocol {
    static let shared = FileCache()
    static var isDirty: Bool = false
    var collectionOfToDoItems = [TodoItem]()
    
    init(collectionOfToDoItems: [TodoItem] = [TodoItem]()) {
        self.collectionOfToDoItems = collectionOfToDoItems
    }
    
    func readJSON(path: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(path).json")

        var file: Data?
        do {
            file = try Data(contentsOf: fileURL)
        } catch {
            print("Ошибка при получении Data: \(error.localizedDescription)")
        }
        
        guard let json = file else {
            print("Ошибка при распаковке Data")
            return
        }
        
        var dict: [String: Any] = [:]
        do {
            guard let dictJson = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                print("Ошибка при парсинге")
                return
            }
            dict = dictJson
        } catch {
            print("Ошибка при парсинге JSON")
        }
        
        guard let collectionOfToDoItemsJson = dict["list"] as? [[String: Any]] else {
            print("Ошибка! в файле нет ToDoItem")
            return
        }
        
        for item in collectionOfToDoItemsJson {
            let optionalToDoItem = TodoItem.parse(json: item)
            if let toDoItem = optionalToDoItem {
                addingNewItem(item: toDoItem)
            }
        }
        
        
    }

    func writeJSON(path: String?) {
        var savePath: String
        if let str = path {
            savePath = str
        } else {
            savePath = "newfile"
        }

        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(savePath).json")
        var array: [Any] = []

        for item in collectionOfToDoItems {
            array.append(item.json)
        }

        do {
            let dict: [String: Any] = ["list": array]
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            try data.write(to: fileURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func addingNewItem(item: TodoItem) {
        if let index = collectionOfToDoItems.firstIndex(where: {item.id == $0.id}) {
            collectionOfToDoItems[index] = item
        } else {
            collectionOfToDoItems.append(item)
        }
    }
    
    func deleteItem(id: String) {
        if let index = collectionOfToDoItems.map({$0.id}).firstIndex(of: id) {
            collectionOfToDoItems.remove(at: index)
        }
    }
}
