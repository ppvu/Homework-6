//
//  AuthService.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//

import Foundation
import SwiftKeychainWrapper

class AuthService {
    public func githubRequestForAccessToken(authCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        let grantType = "authorization_code"

        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GithubConstants.CLIENT_ID + "&client_secret=" + GithubConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: GithubConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?["access_token"] as! String
                KeychainWrapper.standard.set(accessToken, forKey: "token")
            }
        }
        task.resume()
    }
}
