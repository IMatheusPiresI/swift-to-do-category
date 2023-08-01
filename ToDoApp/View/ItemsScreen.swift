//
//  ItemsScreen.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 30/07/23.
//

import Foundation
import UIKit

protocol ItemsScreenDelegate: AnyObject {
    func tappedAddItemButton()
    func tappedItemCell()
    func tappedBackButton()
    func swipeDeleteButton(indexPath: IndexPath)
    func toggleCheckItem(indexPath: IndexPath)
    func swipeEditActionButton(indexPath: IndexPath)
    func moveRowDragAndDropOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
}

class ItemsScreen: UIView {
    
    private weak var delegate: ItemsScreenDelegate?
    
    public func delegate(delegate: ItemsScreenDelegate){
        self.delegate = delegate
    }
    
    var items = [Item]()
    
    lazy var headerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primary
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view.addSubview(titleLabel)
        view.addSubview(backHeaderButton)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = K.Texts.items
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var backHeaderButton: UIButton = {
        let button = UIButton()
        
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default)
        let iconImage = UIImage(systemName: K.Icons.arrowLeft, withConfiguration: iconConfiguration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(iconImage, for: .normal)
        button.addOpacityEffect()
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addItemButton: UIButton = {
        let button = UIButton()
        
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .default)
        let iconImage = UIImage(systemName: K.Icons.addIcon, withConfiguration: iconConfiguration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(iconImage, for: .normal)
        button.layer.cornerRadius = 32.5
        button.backgroundColor = .primary
        button.addOpacityEffect()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(tappedAddItemButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var itemsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        
        return tableView
    }()
    
    lazy var emptyContainerView: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addSubview(emptyImage)
        
        return stack
    }()
    
    lazy var emptyImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: K.Images.empty)
        image.contentMode = .scaleAspectFit
        
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(headerView)
        self.addSubview(itemsTableView)
        self.addSubview(emptyContainerView)
        self.addSubview(addItemButton)
        
        self.configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedAddItemButton(){
        self.delegate?.tappedAddItemButton()
    }
    
    @objc func tappedBackButton() {
        self.delegate?.tappedBackButton()
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),

            self.titleLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor, constant: 10),
            
            self.backHeaderButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor, constant: 10),
            self.backHeaderButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.backHeaderButton.widthAnchor.constraint(equalToConstant: 50),
            self.backHeaderButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.addItemButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -52),
            self.addItemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.addItemButton.widthAnchor.constraint(equalToConstant: 65),
            self.addItemButton.heightAnchor.constraint(equalToConstant: 65),
            
            self.itemsTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.itemsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.itemsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.itemsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.emptyContainerView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.emptyContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.emptyContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.emptyContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.emptyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emptyImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.emptyImage.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

extension ItemsScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
}

extension ItemsScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.toggleCheckItem(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            
            self.items.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.swipeDeleteButton(indexPath: indexPath)
            completionHandler(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            _, _, completeHandler in
            self.delegate?.swipeEditActionButton(indexPath: indexPath)
            
            completeHandler(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath != destinationIndexPath {
            self.delegate?.moveRowDragAndDropOrder(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        }
        
    }
}

extension ItemsScreen: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = items[indexPath.row]
        return [ dragItem ]
    }
}
