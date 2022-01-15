//
//  PhotoBase.swift
//  test
//
//  Created by Kanat on 12/1/22.
//

import Foundation
import UIKit


protocol PhotoManagerDelegate: AnyObject {
    func didGetAllPhotos(_ photos: [PhotoModel])
    func didUpdatePhoto(_ photoManager: PhotoManager, photo: PhotoModel)
    func didFailWithError(error: Error)
}

struct PhotoManager {
    
    weak var delegate: PhotoManagerDelegate?
    var token = "client_id=rlosF5mOFWZN6aXF6XkcyO_pGdaj3_w5orRinRKRrEQ"
    
// ссылка на список фотографий
    let photoUrl = "https://api.unsplash.com/photos"
    
    func fetchPhoto() {
        let urlString = "\(photoUrl)?\(token)"
        performRequest(with: urlString)
    }
    
// Запрос сессии
    func performRequest(with urlString: String) {
        //1. создание URL
        if let url = URL(string: urlString) {
            
            //2. создание URL сессии
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else { return }
                
                let jsonString = String(data: data, encoding: .utf8)
                
                do {
                    let decode = try JSONDecoder().decode([PhotoModel].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.didGetAllPhotos(decode)
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    
}
