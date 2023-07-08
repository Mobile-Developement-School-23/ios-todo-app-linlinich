import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: ImportanceOfTask
    let deadline: Date?
    var didDone: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
    let lastUpdated: String
    
    
    enum ImportanceOfTask: String {
        case unimportant = "low"
        case usual = "basic"
        case important = "important"
    }
    
    init(id: String = UUID().uuidString, text: String, importance: ImportanceOfTask, deadline: Date? = nil, didDone: Bool = false, dateOfCreation: Date = Date(), dateOfChange: Date? = nil, lastUpdated: String) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.didDone = didDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
        self.lastUpdated = lastUpdated
    }
}

enum CodingKeys: String {
    case id
    case text
    case importance
    case deadline
    case didDone = "done"
    case dateOfCreation = "created_at"
    case dateOfChange = "changed_at"
    case lastUpdated = "last_updated_by"
}

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard
            let json = json as? [String: Any],
            let id = json[CodingKeys.id.rawValue] as? String,
            let text = json[CodingKeys.text.rawValue] as? String,
            let didDone = json[CodingKeys.didDone.rawValue] as? Bool,
            let lastUpdated = json[CodingKeys.lastUpdated.rawValue] as? String,
            let dateOfCreationJson = json[CodingKeys.dateOfCreation.rawValue] as? Int
        else {
            return nil
        }
        
        let importance: ImportanceOfTask
        if let importanceJson = json[CodingKeys.importance.rawValue] as? String {
            if let importanceTry = ImportanceOfTask(rawValue: importanceJson) {
                importance = importanceTry
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        let dateOfCreation = Date(timeIntervalSince1970: TimeInterval(dateOfCreationJson))
        
        let deadline: Date?
        if let deadlineJson = json[CodingKeys.deadline.rawValue] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineJson)
        } else {
            deadline = nil
        }
        
        let dateOfChange: Date?
        if let dateOfChangeJson = json[CodingKeys.dateOfChange.rawValue] as? Double {
            dateOfChange = Date(timeIntervalSince1970: dateOfChangeJson)
        } else {
            dateOfChange = nil
        }
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        didDone: didDone,
                        dateOfCreation: dateOfCreation,
                        dateOfChange: dateOfChange,
                        lastUpdated: lastUpdated)
    }
    
    var json: Any {
        
        var json: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.text.rawValue: text,
            CodingKeys.didDone.rawValue: didDone,
            CodingKeys.dateOfCreation.rawValue: Int(dateOfCreation.timeIntervalSince1970),
            CodingKeys.lastUpdated.rawValue: lastUpdated,
            CodingKeys.importance.rawValue: importance.rawValue
        ]
        
        if let deadline = deadline {
            json[CodingKeys.deadline.rawValue] = Int(deadline.timeIntervalSince1970)
        }
        
        if let dateOfChange = dateOfChange {
            json[CodingKeys.dateOfChange.rawValue] = Int(dateOfChange.timeIntervalSince1970)
        }
        
        
        return json
    }
}
