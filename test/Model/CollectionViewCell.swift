//
//  CollectionViewCell.swift
//  test
//
//  Created by Kanat on 12/1/22.
//

import UIKit
import Kingfisher
import CoreData

class CollectionViewCell: UICollectionViewCell {
    static let reuseId = "CollectionViewCell"
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list = [InfoList]()
    var name: String!
    var id: String!
    var likes: String!
    var createdAt: String!
    var imageUrl: URL!
    var isFavorite: Bool! {
        didSet {
            if isFavorite {
                favoriteView.image = UIImage(named: "likeTapped")
            } else {
                favoriteView.image = UIImage(named: "like")
            }
        }
    }
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let favoriteView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
        imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        addSubview(favoriteView)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
// mainImageView constraints
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2.5/3).isActive = true
        
// favoriteImage constraints
        favoriteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        favoriteView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10).isActive = true
        favoriteView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
// TapRecognizer для лайка
        let Tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(recognizer:)))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(Tap)
        
    }
    
// LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 8)
        self.clipsToBounds = false
    }

    //setImage with Kinfisher methods
    func setImage(_ url: URL) {
        mainImageView.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//Сохранение данных и смнена картинки по нажатию
    @objc
    func imageViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended) {
            
            let newItem = InfoList(context: self.context)
            newItem.name = name
            newItem.id = id
            newItem.likes = Int64(likes)!
            newItem.createdAt = createdAt
            newItem.imageUrl = imageUrl.absoluteString
            
            if !isFavorite {
                isFavorite = true
                favoriteView.image = UIImage(named: "likeTapped")
                saveItems()
            } else {
                isFavorite = false
                favoriteView.image = UIImage(named: "like")
                deleteItem(with: id)
                saveItems()
            }
        }
    }
    
// Сохраняем в базу
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
// Удаляем из базы
    func deleteItem(with id: String) {
        let fetchRequest: NSFetchRequest<InfoList> = InfoList.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id = %@", id)
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
        
        
    }
    
}



