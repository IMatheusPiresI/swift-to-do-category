//
//  ItemsViewController.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 30/07/23.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var screen: ItemsScreen?
    
    var itemBrain = ItemBrain()
    var selectedCategory: Category?
    
    override func loadView() {
        super.loadView()
        self.screen = ItemsScreen()
        self.view = screen
        view.backgroundColor = .background
        self.screen?.delegate(delegate: self)
        
        self.initialSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadItems() {
        if let categoryId = selectedCategory?.id {
            let allPredicate =  NSPredicate(format: "parentRelation.id == %@", categoryId as CVarArg)

            self.itemBrain.loadItems(predicate: allPredicate)
        }
    }
    
    func initialSetup() {
        self.loadItems()
        self.screen?.items = self.itemBrain.items
        self.screen?.itemsTableView.reloadData()
    }
    
    func saveItems() {
        self.itemBrain.saveItems()
        self.screen?.items = self.itemBrain.items
        self.screen?.itemsTableView.reloadData()
    }
    
    func verifyLayout() {
        if itemBrain.items.isEmpty {
            UIView.transition(with: self.screen!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.screen?.emptyContainerView.isHidden = false
                self.screen?.itemsTableView.isHidden = true
            })
            return
        }
        UIView.transition(with: self.screen!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.screen?.emptyContainerView.isHidden = true
            self.screen?.itemsTableView.isHidden = false
        })
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

extension ItemsViewController: ItemsScreenDelegate {
    func tappedAddItemButton() {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            let newItem = ItemModel(id: UUID(), name: textfield.text ?? "", done: false, order: Int16(self.itemBrain.items.count))
            
            self.itemBrain.createNewItem(item: newItem, category: self.selectedCategory)
            self.saveItems()
            
            if self.itemBrain.items.count == 1 {
                self.verifyLayout()
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { alertAction in
            self.dismiss(animated: true)
        }
        
        alert.addTextField { alertTextField in
            textfield = alertTextField
            textfield.placeholder = "Add New Item"
        }
        
        alert.addAction(actionCancel)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    func tappedItemCell() {
        print(#function)
    }
    
    func tappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func swipeDeleteButton(indexPath: IndexPath) {
        self.itemBrain.deleteItem(indexPath: indexPath)
        self.itemBrain.saveItems()
        
        if self.itemBrain.items.isEmpty {
            self.verifyLayout()
        }
    }
    
    func toggleCheckItem(indexPath: IndexPath) {
        self.itemBrain.toggleDoneItemByIndex(indexPath: indexPath)
        self.saveItems()
    }
    
    func swipeEditActionButton(indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        
        let confirmEditAction = UIAlertAction(title: "Confirm Edit", style: .default) { alertAction in
            
            if let text = textField.text {
                self.itemBrain.editItem(name: text, indexPath: indexPath)
                self.saveItems()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { alertAction in
            self.dismiss(animated: true)
        }
        
        alert.addTextField() {
            alertTextField in
            textField = alertTextField
            textField.placeholder = "Edit Item"
            textField.text = self.itemBrain.items[indexPath.row].name
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmEditAction)
        
        self.present(alert, animated: true)
    }
    
    func moveRowDragAndDropOrder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let mover = self.itemBrain.items.remove(at: sourceIndexPath.row)
        self.itemBrain.items.insert(mover, at: destinationIndexPath.row)
        
        for (index, item) in self.itemBrain.items.enumerated() {
            item.order = Int16(index)
        }
        self.screen?.items = self.itemBrain.items
        self.itemBrain.saveItems()
    }
}
