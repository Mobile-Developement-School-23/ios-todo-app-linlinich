//
//  ItemCell.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 21.06.2023.
//

import UIKit

class SuggestCell: UITableViewCell {
    
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPRODISPLAY", size: 17)
        label.textColor = UIColor(asset: Asset.Colors.labelPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var area: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPRODISPLAY", size: 12)
        label.textColor = .red
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(taskLabel)
        self.addSubview(area)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            taskLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
}
