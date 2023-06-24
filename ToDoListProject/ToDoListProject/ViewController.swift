

import UIKit
import Combine

final class ToDoItemsViewController: UIViewController {
    
    
    private let scrollView = UIScrollView()
    private let itemsCellId = "itemsCellId"
    var stackView = UIStackView()
    var tableViewHeightConstraint: NSLayoutConstraint?
    var cancellables: Set<AnyCancellable> = []
    
    
    lazy var myTasksLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои дела"
        label.textColor = UIColor(asset: Asset.Colors.labelPrimary)
        label.font = .boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countOfDoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — 5"
        label.textColor = UIColor(asset: Asset.Colors.labelTertiary)
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var toDoItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SuggestCell.self, forCellReuseIdentifier: itemsCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var addingButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .white
        button.layer.cornerRadius = 50

        let shadowPath0 = UIBezierPath(roundedRect: button.bounds, cornerRadius: 0)
        button.layer.shadowPath = shadowPath0.cgPath
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
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.backPrimary)
        //view.addSubview(scrollView)
        view.addSubview(toDoItemsTableView)
        view.addSubview(myTasksLabel)
        view.addSubview(countOfDoneLabel)
        view.addSubview(addingButton)
        toDoItemsTableView.isHidden = true
       // setupStackView()
        makeConstraints()
        
    }
    
    @objc
    func didTouchAddingButton() {
        let viewController = AddingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func setupStackView() {
        
        scrollView.addSubview(myTasksLabel)
        scrollView.addSubview(countOfDoneLabel)
        scrollView.addSubview(toDoItemsTableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            myTasksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTasksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTasksLabel.topAnchor.constraint(equalTo: view.topAnchor),
            myTasksLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            countOfDoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countOfDoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countOfDoneLabel.topAnchor.constraint(equalTo: myTasksLabel.topAnchor, constant: 100),
            countOfDoneLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            toDoItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoItemsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            toDoItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addingButton.heightAnchor.constraint(equalToConstant: 44),
            addingButton.widthAnchor.constraint(equalToConstant: 44),
            addingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
        ])
    }
}

extension ToDoItemsViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: itemsCellId, for: indexPath) as? SuggestCell else {return UITableViewCell()}
        cell.taskLabel.text = "kkv"
        cell.area.text = "dkdkckk"
        cell.backgroundColor = UIColor(asset: Asset.Colors.backSecondary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Notification Times"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .yellow
            
            headerView.addSubview(label)
            
            return headerView
        }
    
    
}

