//
//  NetworkService.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import Foundation
import SwiftKeychainWrapper

enum Method: String {
    case get
    case post
}

class NetworkService {
    
    static func makeGetRequest(
        url: String,
        headers: [String: String]? = nil,
        completion: @escaping (Result<Data, NetworkErrors>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = Method.get.rawValue
        

        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {

                completion(.failure(.invalidStatusCode))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }

    static func makePostRequest(
        urlString: String,
        parameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<Data, NetworkErrors>) -> Void) {

        var components = URLComponents(string: urlString)

        if let parameters = parameters {
            var queryItems = [URLQueryItem]()
            parameters.forEach {
                let queryItem = URLQueryItem(name: $0.key, value: $0.value)
                queryItems.append(queryItem)
            }

            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            completion(.failure(.invalidUrl))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = Method.post.rawValue

        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {

                completion(.failure(.invalidStatusCode))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }


}
