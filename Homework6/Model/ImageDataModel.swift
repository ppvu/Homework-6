//
//  ImageData.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import Foundation

struct ImageDataModel: Codable {
    
    let type: String
    let name: String
    let sha: String
    let downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case type, name, sha
        case downloadURL = "download_url"
    }
}
