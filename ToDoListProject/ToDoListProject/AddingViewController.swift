//
//  AddingViewController.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 23.06.2023.
//

import Foundation
import UIKit

final class AddingViewController: UIViewController {
    
    private var fileCache = FileCache(collectionOfToDoItems: [])
    
    private var todoItem : TodoItem?
    private func readFromFile(filename: String) -> TodoItem? {
        fileCache.readJSON(path: filename)
        if fileCache.collectionOfToDoItems.count > 0 {
            return fileCache.collectionOfToDoItems[0]
        } else {
            return nil
        }
    }
    
    func configure() {
        if let item = readFromFile(filename: "filename") {
            let itemId = item.id
            listItem.text = item.text
            listItem.textColor = UIColor(asset: Asset.Colors.labelPrimary)

            informationTaskView.setImportance(importanceCheck: item.importance)
            informationTaskView.setDate(newDate: item.deadline ?? .now)
            
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    var stackView = UIStackView()
    let scrollView = UIScrollView()
    var stackViewWithInformation = UIStackView()
    var informationTaskView = InformationTaskView()
    
    lazy var listItem: UITextView = {
        let item = UITextView()
        item.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        item.layer.cornerRadius = 16
        item.text = "Что надо сделать?"
        item.textColor = UIColor(asset: Asset.Colors.labelTertiary)
        item.font = .systemFont(ofSize: 17)
        item.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        item.isScrollEnabled = false
        
        item.delegate = self
        item.backgroundColor = UIColor(asset: Asset.Colors.backSecondary)
        return item
    }()
    
    lazy var calendarView: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        let tommorowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
        calendar.date = todoItem?.deadline ?? tommorowDate
        calendar.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(asset: Asset.Colors.backSecondary)
        button.layer.cornerRadius = 16
        button.setTitle("Удалить", for: .normal)
        if todoItem != nil {
            button.setTitleColor(UIColor(asset: Asset.Colors.red), for: .normal)
        } else {
            button.setTitleColor(UIColor(asset: Asset.Colors.labelTertiary), for: .normal)
        }
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(asset: Asset.Colors.separator)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    
    private func setapStackAndScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        informationTaskView.configure(delegate: self)
        stackViewWithInformation = UIStackView(arrangedSubviews: [informationTaskView, separator, calendarView])
        separator.isHidden = true
        calendarView.isHidden = true
        stackViewWithInformation.backgroundColor = UIColor(asset: Asset.Colors.backSecondary)
        stackViewWithInformation.spacing = 0
        stackViewWithInformation.axis = .vertical
        stackViewWithInformation.layer.cornerRadius = 16
        stackView = UIStackView(arrangedSubviews: [listItem, stackViewWithInformation, deleteButton])
        scrollView.addSubview(stackView)
        stackView.spacing = 16
        stackView.axis = .vertical
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        readFromFile(filename: "filename")
        view.backgroundColor = UIColor(asset: Asset.Colors.backPrimary)
        setupNavBar()
        setapStackAndScrollView()
        configure()
        makeConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
        let saveButtonItem = UIBarButtonItem(title: "Сохранить",
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapSaveButton))

        let canselButtonItem = UIBarButtonItem(title: "Отменить",
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapCanselButton))
        if todoItem == nil {
            saveButtonItem.isEnabled = false
        }
        navigationItem.leftBarButtonItem = canselButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        title = "Дело"
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    func switchControlChangedValue() {
        informationTaskView.switchControlChangedValue()
    }
    
    @objc
    func didTapCanselButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    func didTapSaveButton() {
        var importance = informationTaskView.returnImportance()
        if let text = listItem.text {
            let deadline: Date? = calendarView.date
            let item: TodoItem
            if let id = todoItem?.id {
                item = TodoItem(id: id, text: text, importance: importance, deadline: deadline)
            } else {
                item = TodoItem(text: text, importance: importance, deadline: deadline)
            }
            fileCache.addingNewItem(item: item)
            fileCache.writeJSON(path: "filename")
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func didChangeDate() {
        informationTaskView.setDate(newDate: calendarView.date)
    }
    
    @objc
    func didTapDeleteButton() {
        listItem.text = "Что надо сделать?"
        listItem.textColor = UIColor(asset: Asset.Colors.labelTertiary)
        listItem.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        deleteButton.setTitleColor(UIColor(asset: Asset.Colors.labelTertiary), for: .normal)
        
        if let id = todoItem?.id {
            fileCache.deleteItem(id: id)
            fileCache.writeJSON(path: "privet")
        }
        configure()
    }
}

extension AddingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(asset: Asset.Colors.labelTertiary) {
            textView.text = nil
            textView.textColor = UIColor(asset: Asset.Colors.labelPrimary)
        }
        
        if textView.textColor == UIColor(asset: Asset.Colors.labelPrimary) {
            navigationItem.rightBarButtonItem?.isEnabled = true
            deleteButton.setTitleColor(UIColor(asset: Asset.Colors.red), for: .normal)
        }
    }
}

extension AddingViewController: InInformationTaskViewDelegate {
    func closeCalendar() {
        self.calendarView.alpha = 1
        separator.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.calendarView.alpha = 0
            self.calendarView.isHidden = true
        }
    }
    
    
    func didTapDate() {
        separator.isHidden.toggle()
        var alpha: CGFloat = 0
        if calendarView.isHidden {
            calendarView.alpha = 0
            alpha = 1
        } else {
            calendarView.alpha = 1
            alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.calendarView.alpha = alpha
            self.calendarView.isHidden.toggle()
        }
    }
}

extension AddingViewController: UICalendarSelectionSingleDateDelegate & UICalendarViewDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
}
