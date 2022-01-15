//
//  InfoViewController.swift
//  test
//
//  Created by Kanat on 12/1/22.
//
//
import UIKit
import Kingfisher
import CoreData

class InfoViewController: UIViewController, UIScrollViewDelegate {
    
    var items: InfoList!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var id: String!
    var createdAt: String!
    var imageUrl: URL!
    var authorName: String!
    var likes: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        mainImageView.kf.setImage(with: imageUrl)
        firstLabel.text = "Author: \(authorName!)"
        secondLabel.text = "Created: \(createdAt!)"
        thirdLabel.text = "Likes: \(likes!)"
        
        view.addSubview(ScrollView)
        ScrollView.addSubview(mainImageView)
        ScrollView.addSubview(firstLabel)
        ScrollView.addSubview(secondLabel)
        ScrollView.addSubview(thirdLabel)
        
    }
    
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let firstLabel: UILabel = {
        let item = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        item.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        item.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        item.font = UIFont(name: "Arial-black", size: 20)
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    let secondLabel: UILabel = {
        let item = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        item.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        item.textColor = .black
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    let thirdLabel: UILabel = {
        let item = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        item.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        item.textColor = .black
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    
    
    lazy var ScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        
        return scroll
    }()
    
    override func viewDidLayoutSubviews() {
        ScrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        ScrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        ScrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        ScrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        mainImageView.centerYAnchor.constraint(equalTo: ScrollView.centerYAnchor).isActive = true
        mainImageView.centerXAnchor.constraint(equalTo: ScrollView.centerXAnchor).isActive = true
        firstLabel.topAnchor.constraint(equalTo: mainImageView.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: ScrollView.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        secondLabel.topAnchor.constraint(equalTo: firstLabel.safeAreaLayoutGuide.bottomAnchor).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: ScrollView.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
        thirdLabel.topAnchor.constraint(equalTo: secondLabel.safeAreaLayoutGuide.bottomAnchor).isActive = true
        thirdLabel.leftAnchor.constraint(equalTo: ScrollView.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        
    }
    
    
    
    func setImage(_ url: URL) {
        mainImageView.kf.setImage(with: imageUrl)
        
    }
    
    func getItem(with request: NSFetchRequest<InfoList> = InfoList.fetchRequest(),
                 id: String) -> Bool {
        let idPredicate = NSPredicate(format: "id = %@", id)
        request.predicate = idPredicate
        do {
            let items = try context.fetch(request)
            return items.first != nil
        } catch {
            print(error)
            return false
        }
    }
}
