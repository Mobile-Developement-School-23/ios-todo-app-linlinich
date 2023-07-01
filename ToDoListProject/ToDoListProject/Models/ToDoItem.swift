import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: ImportanceOfTask
    let deadline: Date?
    var didDone: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
    
    
    enum ImportanceOfTask: String {
        case unimportant = "unimportant"
        case usual = ""
        case important = "important"
    }
    
    init(id: String = UUID().uuidString, text: String, importance: ImportanceOfTask, deadline: Date? = nil, didDone: Bool = false, dateOfCreation: Date = Date(), dateOfChange: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.didDone = didDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
    }
}

enum CodingKeys: String {
    case id
    case text
    case importance
    case deadline
    case didDone
    case dateOfCreation
    case dateOfChange
}

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard
            let json = json as? [String: Any],
            let id = json[CodingKeys.id.rawValue] as? String,
            let text = json[CodingKeys.text.rawValue] as? String,
            let didDone = json[CodingKeys.didDone.rawValue] as? Bool,
            let dateOfCreationJson = json[CodingKeys.dateOfCreation.rawValue] as? String
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
            importance = ImportanceOfTask.usual
        }
        
        let formatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: localeID)
        }
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        guard let dateOfCreation = formatter.date(from: dateOfCreationJson) else { return nil }
        
        let deadline: Date?
        if let deadlineJson = json[CodingKeys.deadline.rawValue] as? String {
            deadline = formatter.date(from: deadlineJson)
        } else {
            deadline = nil
        }
        
        let dateOfChange: Date?
        if let dateOfChangeJson = json[CodingKeys.dateOfChange.rawValue] as? String {
            dateOfChange = formatter.date(from: dateOfChangeJson)
        } else {
            dateOfChange = nil
        }
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        didDone: didDone,
                        dateOfCreation: dateOfCreation,
                        dateOfChange: dateOfChange)
    }
    
    var json: Any {
        let formatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: localeID)
        }
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        var json: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.text.rawValue: text,
            CodingKeys.didDone.rawValue: didDone,
            CodingKeys.dateOfCreation.rawValue: formatter.string(from: dateOfCreation)
        ]
        
        if let deadline = deadline {
            json[CodingKeys.deadline.rawValue] = formatter.string(from: deadline)
        }
        
        if let dateOfChange = dateOfChange {
            json[CodingKeys.dateOfChange.rawValue] = formatter.string(from: dateOfChange)
        }
        
        if importance != .usual {
            json[CodingKeys.importance.rawValue] = importance.rawValue
        }
        
        return json
    }
    
    static func parse(csv: String) -> TodoItem? {
        var mas = csv.components(separatedBy: ",").map{String($0)}
        let formatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: localeID)
        }
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        guard let didDone = Bool(mas[4]) else { return nil }
        guard let dateOfCreation = formatter.date(from: mas[5]) else { return nil }
        if mas.count == 7, mas[0] != "" , mas[1] != "", mas[5] != "" {
            let importance: ImportanceOfTask
            
            if mas[2] == "" {
                importance = ImportanceOfTask.usual
                
            } else {
                if let importanceTry = ImportanceOfTask(rawValue: mas[2]) {
                    importance = importanceTry
                } else {
                    return nil
                }
            }
            let deadline: Date?
            if mas[3] == "" {
                deadline = nil
            } else {
                deadline = formatter.date(from: mas[3])
            }
            
            let dateOfChange: Date?
            if mas[6] == "" {
                dateOfChange = nil
            } else {
                dateOfChange = formatter.date(from: mas[6])
            }
            
            return TodoItem(id: mas[0],
                            text: mas[1],
                            importance: importance,
                            deadline: deadline,
                            didDone: didDone,
                            dateOfCreation: dateOfCreation,
                            dateOfChange: dateOfChange)
        } else {
            return nil
        }
    }
    
    var csv: String {
        let formatter = DateFormatter()
        if let localeID = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: localeID)
        }
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        var mas: Array<String> = []
        mas += [id, text, importance.rawValue]
        
        if let deadline = deadline {
            mas.append(formatter.string(from: deadline))
        } else {
            mas.append("")
        }
        
        mas += ["\(didDone)", formatter.string(from: dateOfCreation)]
        if let dateOfChange = dateOfChange {
            mas.append(formatter.string(from: dateOfChange))
        } else {
            mas.append("")
        }
        return mas.joined(separator: ",")
    }
}
