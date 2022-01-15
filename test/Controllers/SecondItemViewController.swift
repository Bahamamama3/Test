//
//  SecondItemViewController.swift
//  test
//
//  Created by Kanat on 12/1/22.
//

import UIKit
import Kingfisher
import CoreData

class SecondItemViewController: UITableViewController {
    
    
    var items = [InfoList]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListInfoCell")
        loadList()
        addObserverToContextChanging()
    }
    
//Прослушивание изменений данных
    func addObserverToContextChanging() {
        NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: context, queue: nil) { notif in
            self.loadList()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListInfoCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        
        tableView.backgroundColor = .white
        
        return cell
    }
    
//Удаление из базы
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(items[indexPath.row])
            items.remove(at: indexPath.row)
            try! context.save()
            tableView.reloadData()
        }
    }
    
// Push VC to InfoViewController
    func showDetailInfo(id: String, name: String, createdAt: String, imageUrl: String, likes: String) {
        let infoVC = SecondInfoViewController()
        infoVC.id = id
        infoVC.authorName = name
        infoVC.createdAt = createdAt
        infoVC.imageUrl = URL(string: imageUrl)
        infoVC.likes = likes
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailInfo(id: items[indexPath.row].id!, name: items[indexPath.row].name!, createdAt: items[indexPath.row].createdAt!, imageUrl: items[indexPath.row].imageUrl!, likes: String(items[indexPath.row].likes))
    }
    
    func loadList(with request: NSFetchRequest<InfoList> = InfoList.fetchRequest(), predicate: NSPredicate? = nil) {
        do {
            items = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
