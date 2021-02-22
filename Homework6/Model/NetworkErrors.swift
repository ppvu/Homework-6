//
//  NetworkErrors.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import Foundation

enum NetworkErrors: Error {
    case invalidStatusCode
    case thereIsNoToken
    case invalidUrl
    case networkError(Error)
    case invalidData
}
