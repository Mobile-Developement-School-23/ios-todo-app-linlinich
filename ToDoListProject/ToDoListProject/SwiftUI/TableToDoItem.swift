//
//  TableToDoItem.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 21.07.2023.
//

import Foundation
import SwiftUI

struct TableToDoItem: View {
    
    var toDoItems: [TodoItem]
    @State private var currentToDoItems: [TodoItem]
    
    init(_ todoItems: [TodoItem]) {
        toDoItems = todoItems.sorted(by: {$0.dateOfCreation > $1.dateOfCreation})
        currentToDoItems = toDoItems.filter { $0.didDone == false }
    }
    
    
    @State private var didTapShowOrHideButton = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    HStack {
                        Text("Выполнено — " + String(toDoItems.filter { $0.didDone == true }.count))
                            .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 16))
                            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!))
                            .font(.system(size: 15))
                        Spacer()
                        if didTapShowOrHideButton {
                            Button("Скрыть") {
                                didTapShowOrHideButton = !didTapShowOrHideButton
                                currentToDoItems = toDoItems.filter { $0.didDone == false }
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.blue)!))
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
                        } else {
                            Button("Показать") {
                                currentToDoItems = toDoItems
                                didTapShowOrHideButton = !didTapShowOrHideButton
                            }
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.blue)!))
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
                        }
                    }
                    LazyVStack(spacing: 0) {
                        
                            
                            ForEach(currentToDoItems, id: \.id) { item in
                                NavigationLink {
                                SingleTask(todoItem: item)
                                
                                } label: {
                                    TableCell(toDoItem: item)
                                }
                        }
                        HStack {
                            Text("Новое")
                                .padding(EdgeInsets(top: 16, leading: 52, bottom: 16, trailing: 16))
                                .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.labelTertiary)!))
                            Spacer()
                        }
                        .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backSecondary)!))
                    }
                    .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backSecondary)!))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    .navigationTitle("Мои дела")
                    
                }
                .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backPrimary)!))
                Button(action: {
                    // действие при нажатии на кнопку
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                            .fontWeight(.bold)
                    }
                }
                .shadow(color: Color.init(uiColor: UIColor(asset: Asset.Colors.shadow)!), radius: 10, x: 0, y: 8)
            }
        }
    }
}

struct Table_Previews:
    PreviewProvider {
        static var previews: some View {
            TableToDoItem(todoList)
        }
}

private let todoList: [TodoItem] = [
    TodoItem(id: "1",
             text: "Buy grocerie",
             importance: .usual,
             deadline: Date().addingTimeInterval(86400),
             didDone: false,
             dateOfCreation: Date().addingTimeInterval(-86400),
             dateOfChange: Date().addingTimeInterval(-86400),
             lastUpdated: "John"),
    TodoItem(id: "2",
             text: "Clean the house",
             importance: .important,
             deadline: Date().addingTimeInterval(172800),
             didDone: false,
             dateOfCreation: Date().addingTimeInterval(-172800),
             dateOfChange: Date().addingTimeInterval(-172800),
             lastUpdated: "Jane"),
    TodoItem(id: "3",
             text: "Finish project",
             importance: .important,
             deadline: Date().addingTimeInterval(259200),
             didDone: true,
             dateOfCreation: Date().addingTimeInterval(-259200),
             dateOfChange: Date().addingTimeInterval(-259200),
             lastUpdated: "John"),
    TodoItem(id: "4",
             text: "Call mom",
             importance: .unimportant,
             deadline: nil,
             didDone: false,
             dateOfCreation: Date().addingTimeInterval(-345600),
             dateOfChange: Date().addingTimeInterval(-345600),
             lastUpdated: "Jane"),
    TodoItem(id: "5",
             text: "Go for a run",
             importance: .usual,
             deadline: Date().addingTimeInterval(432000),
             didDone: false,
             dateOfCreation: Date().addingTimeInterval(-432000),
             dateOfChange: Date().addingTimeInterval(-432000),
             lastUpdated: "John"),
    TodoItem(id: "6",
             text: "Read a book and Read a book and Read a book and Read a book and Read a book and Read a book and Read a book and",
             importance: .unimportant,
             deadline: nil, didDone: true,
             dateOfCreation: Date().addingTimeInterval(-518400),
             dateOfChange: Date().addingTimeInterval(-518400),
             lastUpdated: "Jane")]
