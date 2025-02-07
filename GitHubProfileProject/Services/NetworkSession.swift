//
//  NetworkSession.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 06/02/25.
//

import Foundation

protocol NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
