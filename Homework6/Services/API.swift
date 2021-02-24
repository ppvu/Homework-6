//
//  API.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import UIKit
import Foundation
import SwiftKeychainWrapper

class API {
    
    private var accessToken: String? {
        if let token = KeychainWrapper.standard.string(forKey: "token") {
            return token
        }
        
        return nil
    }
    
    func fetchImage(with ImageInfo: ImageInfo, onDone: @escaping(Result<ImageDataForDownload, NetworkErrors>) -> Void) {
        
        let url = ImageInfo.downloadURL
        
        guard let token = accessToken else {
            onDone(.failure(.thereIsNoToken))
            return
        }
        
        let headers = ["Authorization": "Bearer: \(token)"]
        
        NetworkService.makeGetRequest(url: url, headers: headers) { result in
            switch result {
            case.success(let data):
                let imageData = ImageDataForDownload(name: ImageInfo.name, data: data, sha: ImageInfo.sha)
                onDone(.success(imageData))
            case .failure(let error):
                onDone(.failure(.networkError(error)))
            }
        }
    }
    
    func getInfo(onDone: @escaping (Result<[ImageInfo], NetworkErrors>) -> Void) {
        
        guard let token = accessToken else {
            onDone(.failure(.thereIsNoToken))
            return
        }
        
        let url = GithubConstants.REPOURL
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        
        NetworkService.makeGetRequest(url: url, headers: headers) { result in
            switch result {
            case .success(let data):
                guard let items = try? JSONDecoder().decode([ImageDataModel].self, from: data) else {
                    onDone(.failure(.invalidData))
                    return
                }
                
                let imageFormats = [
                    "bmp",
                    "cur",
                    "gif",
                    "ico",
                    "jpeg",
                    "jpg",
                    "png",
                    "tiff",
                    "xbm"
                ]
                
                let imageData = items.filter { content in
                    if content.type == "file",
                       let ext = content.name.split(separator: ".").last,
                       imageFormats.contains(String(ext).lowercased()) {
                        return true
                    }
                    return false
                }.compactMap { content -> ImageInfo? in
                    guard let downloadUrl = content.downloadURL else {
                        return nil
                    }
                    return ImageInfo(name: content.name, downloadURL: downloadUrl, sha: content.sha)
                }
                onDone(.success(imageData))
            case .failure(let error):
                onDone(.failure(.networkError(error)))
            }
        }
    }
    
}


