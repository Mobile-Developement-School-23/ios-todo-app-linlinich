import UIKit
import Combine

final class ToDoItemsViewController: UIViewController {
    
    var output: ToDoItemsViewOutput?
    
    enum TypeOfTableView {
        case all
        case undone
    }

    var typeOfTableView: TypeOfTableView = .undone
    private let itemsCellId = "itemsCellId"
    private let headerView = HeaderViewForMyTasks()
    private lazy var toDoItemsTableView: UITableView = .init(frame: CGRect.zero, style: .insetGrouped)
    
    func setupTableView() {
        toDoItemsTableView.delegate = self
        toDoItemsTableView.frame = CGRect.zero
        toDoItemsTableView.dataSource = self
        toDoItemsTableView.backgroundColor = UIColor(asset: Asset.Colors.backPrimary)
        toDoItemsTableView.showsVerticalScrollIndicator = false
        toDoItemsTableView.rowHeight = UITableView.automaticDimension
        toDoItemsTableView.register(ToDoItemCell.self, forCellReuseIdentifier: "itemsCellId")
        toDoItemsTableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        toDoItemsTableView.separatorColor = UIColor(asset: Asset.Colors.separator)
        toDoItemsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var addingButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.layer.cornerRadius = 50

        let shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 0)
        button.layer.shadowPath = shadowPath.cgPath
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowColor = UIColor(asset: Asset.Colors.shadow)?.cgColor
        button.layer.position = button.center

        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(asset: Asset.Colors.blue)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(didTouchAddingButton), for: .touchUpInside)

        return button
    }()


    override func viewDidLoad() {
        output?.didLoadView()
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.backPrimary)
        setupNavBar()
        view.addSubview(toDoItemsTableView)
        view.addSubview(addingButton)
        setupTableView()
        makeConstraints()
    }

    @objc
    func didTouchAddingButton() {
        let viewController = SingleTaskViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.output = self
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Мои дела"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.directionalLayoutMargins.leading = 32
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            toDoItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoItemsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            toDoItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


        NSLayoutConstraint.activate([
            addingButton.heightAnchor.constraint(equalToConstant: 44),
            addingButton.widthAnchor.constraint(equalToConstant: 44),
            addingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
        ])
    }
}

extension ToDoItemsViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeOfTableView {
        case .undone:
            if let cellsCount = output?.getCellsCount(type: .undone) {
                return cellsCount + 1
            } else {
                return 1
            }
        case .all:
            if let cellsCount = output?.getCellsCount(type: .all) {
                return cellsCount + 1
            } else {
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCellId",
                                                       for: indexPath) as? ToDoItemCell else {
            return UITableViewCell()
        }
        if let cellsCount = output?.getCellsCount(type: typeOfTableView) {
            if cellsCount == 0 {
                cell.position = .solo
            } else if indexPath.row == 0 {
                cell.position = .first
            } else if indexPath.row == cellsCount {
                cell.position = .last
            } else {
                cell.position = .middle
            }
            if indexPath.row == cellsCount {
                cell.configureNewCell()
            } else {
                if let data = output?.displayToDoItems(row: indexPath.row, type: typeOfTableView) {
                    cell.configure(data: data, delegate: self, indexPath: indexPath)
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let countOfCompleted = output?.countOfCompleted() {
            headerView.configure(countOfCompleted: countOfCompleted, delegate: self)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleTaskViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.output = self
        if indexPath.row != output?.getCellsCount(type: typeOfTableView) {
            guard let data = output?.displayToDoItems(row: indexPath.row, type: typeOfTableView) else { return }
            viewController.todoItem = data
        }
        present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != output?.getCellsCount(type: self.typeOfTableView) {
            let delete = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
                self.output?.deleteItem(type: self.typeOfTableView, row: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            delete.image = UIImage(systemName: "trash.fill")
            delete.backgroundColor = UIColor(asset: Asset.Colors.red)
            
            let info = UIContextualAction(style: .normal, title: nil) { (_, _, complitionHand) in
                if let data = self.output?.displayToDoItems(row: indexPath.row, type: self.typeOfTableView) {
                    let formatter = DateFormatter()
                    if let localeID = Locale.preferredLanguages.first {
                        formatter.locale = Locale(identifier: localeID)
                    }
                    formatter.dateFormat = "d MMMM yyyy"
                    var message: String = "Текст задачи: \(data.text)\n"
                    message += "Дата создания: \(formatter.string(from: data.dateOfCreation))"
                    if data.didDone == true {
                        message += "\nВажность задачи: \(data.importance.rawValue)"
                        if let deadline = data.deadline {
                            message += "\nДедлайн: \(formatter.string(from: deadline))"
                        }
                    }
                    if let dateOfChange = data.dateOfChange {
                        message += "\nДата последнего изменения: \(formatter.string(from: dateOfChange))"
                    }
                    let alertViewController = UIAlertController(title: "Информация о задаче", message: message, preferredStyle: .alert)
                    alertViewController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alertViewController, animated: true)
                }
                complitionHand(true)
            }
            
            info.image = UIImage(systemName: "info.circle.fill")
            info.backgroundColor = UIColor(asset: Asset.Colors.grayLight)
            
            return UISwipeActionsConfiguration(actions: [delete, info])
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != output?.getCellsCount(type: typeOfTableView)
            && ((output?.checkIsDone(type: typeOfTableView, row: indexPath.row)) != true) {
            let checkmark = UIContextualAction(style: .destructive, title: nil) { (_, _, _) in
                self.didTapDoneButton(indexPath: indexPath)
            }
            checkmark.image = UIImage(systemName: "checkmark.circle.fill")
            checkmark.backgroundColor = UIColor(asset: Asset.Colors.green)
            
            return UISwipeActionsConfiguration(actions: [checkmark])
        }
        return nil
    }
}


extension ToDoItemsViewController: HeaderViewForMyTasksDelegate {
    func didTapShowOrHideButton() {
        if typeOfTableView == .all {
            typeOfTableView = .undone
            toDoItemsTableView.reloadData()
        } else {
            typeOfTableView = .all
            toDoItemsTableView.reloadData()
        }
    }
}

extension ToDoItemsViewController: ToDoItemCellDelegate {
    @objc func didTapDoneButton(indexPath: IndexPath) {
        output?.changeIsDone(type: typeOfTableView, row: indexPath.row)
        headerView.configure(countOfCompleted: output?.countOfCompleted() ?? 0, delegate: self)
        switch typeOfTableView {
        case .all:
            toDoItemsTableView.reloadRows(at: [indexPath], with: .fade)
        case .undone:
            toDoItemsTableView.deleteRows(at: [indexPath], with: .fade)
            toDoItemsTableView.reloadData()
        }
    }
}

extension ToDoItemsViewController: ToDoItemsViewInput {
    func reload() {
    }
}

extension ToDoItemsViewController: SingleTaskViewControllerOutput {
    func reloadData() {
        output?.didLoadView()
        toDoItemsTableView.reloadData()
    }
}
