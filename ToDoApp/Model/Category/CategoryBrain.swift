//
//  CategoryBrain.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 30/07/23.
//

import Foundation
import CoreData
import UIKit

struct CategoryBrain {
    var categories = [Category]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            var allCategoriesOrdered = try context.fetch(request)
            allCategoriesOrdered.sort {
                $0.order < $1.order
            }
            self.categories = allCategoriesOrdered
        } catch {
            print("Error request Category \(error)")
        }
    }
    
    mutating func createNewCategory(category: CategoryModel) {
        let newCategory = Category(context: context.self)

        newCategory.name = category.name
        newCategory.id = category.id
        newCategory.order = category.order
        
        categories.append(newCategory)
    }
    
    mutating func removeCategorieByIndex(indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        let itemsRequest: NSFetchRequest<Item> = Item.fetchRequest()
        if let categoryId = category.id {
            let predicate = NSPredicate(format: "parentRelation.id == %@", categoryId as CVarArg)
            itemsRequest.predicate = predicate
            do {
                let items = try context.fetch(itemsRequest)
                
                for item in items {
                    context.delete(item)
                }
                
                self.context.delete(category)
                self.categories.remove(at: indexPath.row)
            } catch {
                print("Error request Items for delete category \(error)")
            }
        }
    }
    
    func editCategory(name: String, indexPath: IndexPath) {
        categories[indexPath.row].name = name
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error save context category \(error)")
        }
    }
}

