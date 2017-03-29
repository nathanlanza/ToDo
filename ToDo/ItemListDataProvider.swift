import UIKit

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

enum Section: Int {
    case toDo
    case done
    
    static func from(number: Int) -> Section {
        switch number {
        case 0: return toDo
        case 1: return done
        default: fatalError("Invalid section number.")
        }
    }
}

class ItemListDataProvider: NSObject, ItemManagerSettable {
    var itemManager: ItemManager?
}

extension ItemListDataProvider: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemManager = itemManager else { return 0 }
        let section = Section.from(number: section)
        
        let numberOfRows: Int
        
        switch section {
        case .toDo:
            numberOfRows = itemManager.toDoCount
        case .done:
            numberOfRows = itemManager.doneCount
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        guard let itemManager = itemManager else { fatalError() }
        let section = Section.from(number: indexPath.section)
        
        
        let item: ToDoItem
        switch section {
        case .toDo:
            item = itemManager.item(at: indexPath.row)
        case .done:
            item = itemManager.doneItem(at: indexPath.row)
        }
        
        cell.configCell(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let itemManager = itemManager else { fatalError() }
        let section = Section.from(number: indexPath.section)
    
        switch section {
        case .toDo:
            itemManager.checkItem(at: indexPath.row)
        case .done:
            itemManager.uncheckItem(at: indexPath.row)
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemSection = Section(rawValue: indexPath.section) else { fatalError() }
        
        switch itemSection {
        case .toDo:
            NotificationCenter.default.post(name: .itemSelected, object: self, userInfo: ["index": indexPath.row])
        default:
            break
        }
    }
}

extension Notification.Name {
    static var itemSelected: Notification.Name { return Notification.Name("ItemSelectedNotification") }
}

extension ItemListDataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let section = Section.from(number: indexPath.section)
        
        let buttonTitle: String
        switch section {
        case .toDo:
            buttonTitle = "Check"
        case .done:
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }
}
