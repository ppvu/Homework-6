//
//  API.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import UIKit
import SwiftKeychainWrapper

class API {
    private var accessToken: String? {
        if let token = KeychainWrapper.standard.string(forKey: "token") {
            return token
        }
        
        return nil
    }
    
    func fetchImage(with ImageInfo: ImageInfo, completion: @escaping(Result<ImageDataForDownload, NetworkErrors>) -> Void) {
        
        let url = ImageInfo.downloadURL
        
        guard let token = accessToken else {
            completion(.failure(.thereIsNoToken))
            return
        }
        
        let headers = ["Authorization": "Bearer: \(token)"]
        
        NetworkService.makeGetRequest(url: url, headers: headers) { result in
            switch result {
            case.success(let data):
                let imageData = ImageDataForDownload(name: ImageInfo.name, data: data, sha: ImageInfo.sha)
                completion(.success(imageData))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}
