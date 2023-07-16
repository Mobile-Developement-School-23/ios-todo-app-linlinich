//
//  SingleTask.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 16.07.2023.
//

import Foundation
import SwiftUI


struct SingleTask: View {
    @State var taskText: String = ""
    @State var importance = 0
    @State private var segmentOptions = [
        Image.init(uiImage: (UIImage(systemName: "exclamationmark.2",
                                     withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))?
            .withTintColor(UIColor(asset: Asset.Colors.red) ?? .red,
                           renderingMode: .alwaysOriginal))!),
        Image.init(uiImage: UIImage(systemName: "arrow.down",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))?
            .withTintColor(UIColor(asset: Asset.Colors.gray) ?? .gray,
                           renderingMode: .alwaysOriginal) ?? UIImage())
    ]
    @State var showDeadline = true
    @State private var showCalendar = true
    @State private var deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
    
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private var arrorDown: Image = {
        let image = Image.init(systemName: "exclamationmark.2")
        return image
    }()
    
    var separator: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.separator)!))
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
    
    var calendar: some View {
        VStack(spacing: 0) {
            separator
            DatePicker(
                "",
                selection: $deadline,
                in: Date()...,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding(EdgeInsets(top: 0, leading: 9, bottom: 9, trailing: 16))
            .environment(\.locale, Locale.init(identifier: "ru"))
        }
    }
    
    var informationView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Важность")
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                Spacer()
                Picker("", selection: $importance) {
                    segmentOptions[1].tag(0)
                    Text("Нет").tag(1)
                    segmentOptions[0].tag(2)
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 12))
            }
            separator
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Сделать до")
                    if showDeadline {
                        Button(formatter.string(from: deadline)) {
                            withAnimation {
                                showCalendar.toggle()
                            }
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.init(uiColor: UIColor(asset: Asset.Colors.blue)!))
                    }
                }
                Spacer()
                Toggle("", isOn: $showDeadline)
                    .onChange(of: showDeadline) { _ in
                        showCalendar = false
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 16, bottom: 12, trailing: 16))
            if showCalendar {
                if showDeadline {
                    calendar
                    
                }
            }
            
        }
        .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backSecondary)!))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        TextField(
                            "Что нужно сделать?",
                            text: $taskText, axis: .vertical)
                        .lineLimit(5...100)
                        .font(.system(size: 17))
                        .padding()
                    }
                    .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backSecondary)!))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                    
                    informationView
                    
                    Button {
                    } label: {
                        HStack {
                            Spacer()
                            Text("Удалить")
                            Spacer()
                        }
                        .padding()
                    }
                    .font(.system(size: 17))
                    .foregroundColor(.red)
                    
                    
                    .background(Color.init(uiColor: UIColor(asset: Asset.Colors.backSecondary)!))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    Spacer()
                    
                }
                    .navigationTitle("Дело")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Отменить") {
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Сохранить") {
                            }
                            .font(.system(size: 17, weight: .bold))
                        }
                    }
            }.background(Color.init(uiColor: UIColor(asset: Asset.Colors.backPrimary)!))
        }
    }
    
}

struct Content_Previews:
    PreviewProvider {
        static var previews: some View {
            SingleTask()
        }
}
