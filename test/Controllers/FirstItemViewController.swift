//
//  FirstItemViewController.swift
//  test
//
//  Created by Kanat on 12/1/22.
//

import UIKit
import CoreData
import Kingfisher


class FirstItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var searchUrl = "https://api.unsplash.com/search/photos"
    var token = "client_id=rlosF5mOFWZN6aXF6XkcyO_pGdaj3_w5orRinRKRrEQ"
    
    var photoManager = PhotoManager()
    private var collectionView: UICollectionView!
    var items = [PhotoModel]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchBar?.self
    lazy var searchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = true
        view.addSubview(collectionView)
        
        photoManager.delegate = self
        photoManager.fetchPhoto()
        
        collectionView.backgroundColor = .white
// SearchBar
        navigationController?.navigationBar.backgroundColor = .none
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as! CollectionViewCell
        cell.setImage(items[indexPath.row].urls.small)
        cell.name = items[indexPath.row].user.name
        cell.id = items[indexPath.row].id
        cell.createdAt = items[indexPath.row].createdAt
        cell.likes = "\(items[indexPath.row].likes)"
        cell.imageUrl = items[indexPath.row].urls.small
        
        if getItem(id: cell.id) {
            cell.isFavorite = true
        } else {
            cell.isFavorite = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: Constants.galleryItemWidth, height: collectionView.frame.width * 0.7)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
    
// Выгружаем из базы
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
    
// Сохраняем в базу
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        collectionView.reloadData()
    }
    
// Метод для пуша в InfoViewController
    func showDetailInfo(id: String, name: String, likes: String, createdAt: String, imageUrl: URL) {
        let infoVC = InfoViewController()
        infoVC.authorName = name
        infoVC.id = id
        infoVC.createdAt = createdAt
        infoVC.likes = likes
        infoVC.imageUrl = imageUrl
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
// Передача данных в следующий контроллер
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetailInfo(id: items[indexPath.row].id, name: items[indexPath.row].user.name, likes: String(items[indexPath.row].likes), createdAt: items[indexPath.row].createdAt, imageUrl: items[indexPath.row].urls.small)
    }
    
}

//MARK: - EXTENSIONS

extension FirstItemViewController {
    func didUpdatePhoto(_ photoManager: PhotoManager, photo: PhotoModel) {
        DispatchQueue.main.async {
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension FirstItemViewController: PhotoManagerDelegate {
    func didGetAllPhotos(_ photos: [PhotoModel]) {
        self.items = photos
        collectionView.reloadData()
    }
}
//MARK: - SearchBar

extension FirstItemViewController: UINavigationControllerDelegate, UISearchBarDelegate {
    
    
    
}



