//
//  TableCell.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 16.07.2023.
//

import Foundation
import SwiftUI

struct TableCell: View {
    
    var todoItem: TodoItem
    init(toDoItem: TodoItem) {
        self.todoItem = toDoItem
    }
    
    @State private var taskText: String = ""
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    private var separator: some View {
        Rectangle()
            .frame(height: 1 / UIScreen.main.scale)
            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.separator)!))
            .padding(EdgeInsets(top: 0, leading: 52, bottom: 0, trailing: 0))
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.forward")
            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.gray)!))
            .fontWeight(.bold)
            .imageScale(.small)
    }
    
    private var calendar: some View {
        Image(systemName: "calendar")
            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!))
            .fontWeight(.bold)
    }
    
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                if todoItem.didDone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .background(Color.white)
                        .cornerRadius(40)
                }
                else if todoItem.importance == .important {
                        Image(systemName: "circle")
                            .foregroundColor(.red)
                            .background(Color.init(uiColor: UIColor(asset: Asset.Colors.redBackground)!))
                            .cornerRadius(40)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!))
                }
                
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 1) {
                            if todoItem.didDone == false {
                                if todoItem.importance == .important {
                                    Image(systemName: "exclamationmark.2")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                } else if todoItem.importance == .unimportant {
                                    Image(systemName: "arrow.down")
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                }
                            }
                            Text(todoItem.text)
                                .lineLimit(1...3)
                                .strikethrough(todoItem.didDone)
                                .foregroundColor(todoItem.didDone ?
                                                 Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!) : Color.init(uiColor: UIColor(asset: Asset.Colors.labelPrimary)!))
                        }
                        if todoItem.didDone == false {
                            if let deadline = todoItem.deadline {
                                HStack(spacing: 2) {
                                    calendar
                                    Text(formatter.string(from: deadline))
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!))
                                }
                            }
                        }
                        
                    }
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 16))
                Spacer()
                chevron
                    .frame(width: 1, height: 12)
            }
            
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            separator
        }
        
    }
}

struct TableCell_Previews:
    PreviewProvider {
        static var previews: some View {
            TableCell(toDoItem: TodoItem(text: "kdk", importance: .important, deadline: .now, didDone: false, lastUpdated: "kkd"))
        }
}


