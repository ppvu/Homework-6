//
//  AuthentificationViewController.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

protocol AuthentificationDelegate: AnyObject {
    func handleAccessToken(accessToken: String)
}

class AuthentificationViewController: UIViewController {
    
    weak var delegate: AuthentificationDelegate?
    
    lazy private var uuid = UUID().uuidString
    
    lazy private var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: view.bounds, configuration: config)
        
        return webView
    }()
    
    override func viewDidLoad() {
        setupWebView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.stopLoading()
        webView.navigationDelegate = nil
    }
}

private extension AuthentificationViewController {
    
    func setupWebView() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GithubConstants.CLIENT_ID + "&scope=" +
            GithubConstants.SCOPE + "&redirect_uri=" +
            GithubConstants.REDIRECT_URI + "&state=" +
            uuid
        
        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                            target: self,
                                            action: #selector(refreshAction))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
}

extension AuthentificationViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        self.RequestForCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        guard let url = request.url,
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let authCode = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value
        else { return }
        
        AuthService().githubRequestForAccessToken(authCode: authCode) { [weak self] result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self?.dismiss(animated: true) {
                        self?.delegate?.handleAccessToken(accessToken: token)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

