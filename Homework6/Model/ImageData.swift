//
//  ImageData.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import Foundation

struct ImageDataModel: Codable {
    
    var name: String
    var data: Data?
    var sha: String
    var downloadURL: String

    enum CodingKeys: String, CodingKey {
        case sha
        case name
        case downloadURL = "download_url"
    }
}
