//
//  MockNetworkSession.swift
//  GitHubProfileProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 06/02/25.
//

import XCTest
@testable import GitHubProfileProject

class MockNetworkSession: NetworkSession {
    var mockResponses: [URL: Data] = [:]
    var mockError: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let error = mockError {
            completionHandler(nil, nil, error)
        } else if let data = mockResponses[url] {
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(data, response, nil)
        } else {
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
            let error = NSError(domain: "UserNotFound", code: 404, userInfo: nil)
            completionHandler(nil, response, error)
        }
    }
}
