//
//  ItemBrain.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 30/07/23.
//

import Foundation
import CoreData
import UIKit

struct ItemBrain {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    mutating func loadItems(predicate: NSPredicate) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = predicate
        do {
            var allItemsOrdered = try context.fetch(request)
            allItemsOrdered.sort {
                $0.order < $1.order
            }
            self.items = allItemsOrdered
        } catch {
            print("Error request Item \(error)")
        }
    }
    
    mutating func createNewItem(item: ItemModel, category: Category?) {
        let newItem = Item(context: context.self)
        
        newItem.id = item.id
        newItem.name = item.name
        newItem.done = item.done
        newItem.order = item.order
        newItem.parentRelation = category
        
        self.items.append(newItem)
    }
    
    mutating func deleteItem(indexPath: IndexPath) {
        let item = items[indexPath.row]
        context.delete(item)
        items.remove(at: indexPath.row)
    }
    
    mutating func toggleDoneItemByIndex(indexPath: IndexPath) {
        items[indexPath.row].done.toggle()
    }

    mutating func editItem(name: String, indexPath: IndexPath) {
        items[indexPath.row].name = name
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error save items")
        }
    }
}
