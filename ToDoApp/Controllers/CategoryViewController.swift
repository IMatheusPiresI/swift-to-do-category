//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 29/07/23.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    var screen: CategoryScreen?
    
    var categoryBrain = CategoryBrain()
    
    override func loadView() {
        super.loadView()
        self.screen = CategoryScreen()
        self.view = screen
        self.screen?.delegate(delegate: self)
        view.backgroundColor = .background
        self.initalSetup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initalSetup() {
        self.categoryBrain.loadCategories()
        self.screen?.categories = categoryBrain.categories
        self.screen?.categoriesTableView.reloadData()
        verifyLayout()
    }
    
    func saveCategories() {
        self.categoryBrain.saveContext()
        self.screen?.categories = self.categoryBrain.categories
        self.screen?.categoriesTableView.reloadData()
    }
    
    func verifyLayout() {
        if self.categoryBrain.categories.isEmpty {
            UIView.transition(with: self.screen!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.screen?.emptyContainerView.isHidden = false
                self.screen?.categoriesTableView.isHidden = true
            }, completion: nil)
            return
        }
        UIView.transition(with: self.screen!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.screen?.emptyContainerView.isHidden = true
            self.screen?.categoriesTableView.isHidden = false
        }, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CategoryViewController: CategoryScreenDelegate {
    func tappedAddCategoryButton() {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { alertAction in
            let newCategory = CategoryModel(id: UUID(), name: textfield.text ?? "", order: Int16(self.categoryBrain.categories.count))
            
            self.categoryBrain.createNewCategory(category: newCategory)
            
            self.saveCategories()
            
            if self.categoryBrain.categories.count == 1 {
                self.verifyLayout()
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { alertAction in
            self.dismiss(animated: true)
        }
        
        alert.addTextField { alertTextField in
            textfield = alertTextField
            textfield.placeholder = "Add New Category"
        }
        
        alert.addAction(actionCancel)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    func prepareAndNavigateToItemsByCategory(category: Category) {
        let itemsVC = ItemsViewController()
        
        itemsVC.selectedCategory = category
        
        navigationController?.pushViewController(itemsVC, animated: true)
    }
    
    func swipeDeleteActionButton(indexPath: IndexPath) {
        self.categoryBrain.removeCategorieByIndex(indexPath: indexPath)
        self.saveCategories()
        
        if self.categoryBrain.categories.isEmpty {
            self.verifyLayout()
        }
    }
    
    func swipeEditActionButton(indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Category", message: nil, preferredStyle: .alert)
        
        let confirmEditAction = UIAlertAction(title: "Confirm Edit", style: .default) { alertAction in
            if let text = textField.text {
                self.categoryBrain.editCategory(name: text, indexPath: indexPath)
                self.saveCategories()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {alertAction in
            self.dismiss(animated: true)
        }
        
        alert.addTextField() {
            alertTextField in
            textField = alertTextField
            textField.placeholder = "Edit Category"
            textField.text = self.categoryBrain.categories[indexPath.row].name
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmEditAction)
        
        self.present(alert, animated: true)
    }
    
    func moveRowDragAndDropOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let move = self.categoryBrain.categories.remove(at: sourceIndexPath.row)
        self.categoryBrain.categories.insert(move, at: destinationIndexPath.row)
        
        for (index, category) in self.categoryBrain.categories.enumerated() {
            category.order = Int16(index)
        }
        self.screen?.categories = self.categoryBrain.categories
        self.categoryBrain.saveContext()
    }
}
