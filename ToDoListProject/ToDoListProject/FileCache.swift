import Foundation

class FileCache {
    private (set) var collectionOfToDoItems: Array<TodoItem> = []
    
    init(collectionOfToDoItems: [TodoItem]) {
        self.collectionOfToDoItems = collectionOfToDoItems
    }
    
    func readJSON(path: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(path).json")
        print(fileURL)

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
            guard let dictJson = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else
            {
                print("Ошибка при парсинге")
                return
            }
            dict = dictJson
        } catch {
            print("Ошибка при парсинге JSON")
        }
        
        guard let collectionOfToDoItemsJson = dict["toDoItem"] as? [[String: Any]] else {
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
    
    func readCSV(path: String) {
        collectionOfToDoItems = []
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(path).csv")
        
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = contents.components(separatedBy: "\n")
            for row in rows[1...rows.count - 2] {
                let itemtodo = TodoItem.parse(csv: row)
                if let itemtodo {
                    addingNewItem(item: itemtodo)
                }
            }
        } catch {
            print("Error reading from file: \(error)")
        }
    }
    
    func writeCSV(path: String?) {
        collectionOfToDoItems = []
        var savePath: String
        if let str = path {
            savePath = str
        } else {
            savePath = "newfile"
        }
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(savePath).csv")

        var csvText = "id,text,importance,deadline,didDone,dateOfCreation,dateOfChange\n"
        
        for item in collectionOfToDoItems {
            let newItem = item.csv+"\n"
            csvText.append(newItem)
        }

        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved successfully")
        } catch {
            print("Error saving file: \(error)")
        }
    }

    func writeJSON(path: String?) {
        var savePath: String
        if let str = path {
            savePath = str
        } else {
            savePath = "newfile"
        }

        let url = URL.documentsDirectory
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(savePath).json")
        var array: [Any] = []

        for item in collectionOfToDoItems {
            array.append(item.json)
        }

        do {
            let dict: [String:Any] = ["toDoItem": array]
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
