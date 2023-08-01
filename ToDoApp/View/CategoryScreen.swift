//
//  CategoryScreen.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 29/07/23.
//

import UIKit

protocol CategoryScreenDelegate: AnyObject {
    func tappedAddCategoryButton()
    func prepareAndNavigateToItemsByCategory(category: Category)
    func swipeDeleteActionButton(indexPath: IndexPath)
    func swipeEditActionButton(indexPath: IndexPath)
    func moveRowDragAndDropOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
}

class CategoryScreen: UIView {
    
    private weak var delegate: CategoryScreenDelegate?
    
    public func delegate(delegate: CategoryScreenDelegate?){
        self.delegate = delegate
    }
    
    var categories = [Category]()
    
    lazy var headerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primary
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view.addSubview(titleLabel)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = K.Texts.categories
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var addCategoryButton: UIButton = {
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
        button.addTarget(self, action: #selector(tappedAddCategoryButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
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
        self.addSubview(categoriesTableView)
        self.addSubview(emptyContainerView)
        self.addSubview(addCategoryButton)
        
        self.configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedAddCategoryButton(){
        self.delegate?.tappedAddCategoryButton()
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor, constant: 10),
            
            self.addCategoryButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -52),
            self.addCategoryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.addCategoryButton.widthAnchor.constraint(equalToConstant: 65),
            self.addCategoryButton.heightAnchor.constraint(equalToConstant: 65),
            
            self.categoriesTableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.categoriesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.categoriesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.categoriesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.emptyContainerView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.emptyContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.emptyContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.emptyContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.emptyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emptyImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.emptyImage.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension CategoryScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension CategoryScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCategory = categories[indexPath.row]
        
        self.delegate?.prepareAndNavigateToItemsByCategory(category: selectedCategory)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.swipeDeleteActionButton(indexPath: indexPath)
            completionHandler(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completeHandler in
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

extension CategoryScreen: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.categories[indexPath.row]
        
        return [ dragItem ]
    }
}
