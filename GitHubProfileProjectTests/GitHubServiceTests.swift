//
//  GitHubProfileProjectTests.swift
//  GitHubProfileProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import XCTest
@testable import GitHubProfileProject

final class GitHubProfileProjectTests: XCTestCase {
    var service: GitHubService!
    var mockSession: MockNetworkSession!

    override func setUp() {
        super.setUp()
        mockSession = MockNetworkSession()
        service = GitHubService(session: mockSession)
    }

    override func tearDown() {
        service = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchUserProfileAndRepos_Success() {
        let userURL = URL(string: "https://api.github.com/users/gustapng")!
        let reposURL = URL(string: "https://api.github.com/users/gustapng/repos")!
        
        let userJSON = """
        {
            "login": "gustapng",
            "avatar_url": "https://example.com/avatar.png"
        }
        """.data(using: .utf8)
        
        let reposJSON = """
        [
            { "id": 1, "name": "Repo1", "language": "Swift" },
            { "id": 2, "name": "Repo2", "language": "Python" }
        ]
        """.data(using: .utf8)
        
        mockSession.mockResponses[userURL] = userJSON
        mockSession.mockResponses[reposURL] = reposJSON
        
        let expectation = self.expectation(description: "UserProfile Success")
        
        service.fetchUserProfileAndRepos(username: "gustapng") { result in
            switch result {
            case .success(let profile):
                XCTAssertEqual(profile.user.login, "gustapng")
                XCTAssertEqual(profile.user.avatarUrl, "https://example.com/avatar.png")
                XCTAssertEqual(profile.repositories.count, 2)
                XCTAssertEqual(profile.repositories[0].name, "Repo1")
                XCTAssertEqual(profile.repositories[1].name, "Repo2")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchUserProfileAndRepos_Failure() {
        mockSession.mockError = NSError(domain: "TestError", code: -1, userInfo: nil)
        
        let expectation = self.expectation(description: "UserProfile Failure")
        
        service.fetchUserProfileAndRepos(username: "gustapng") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchUserProfileAndRepos_UserNotFound() {
        let userURL = URL(string: "https://api.github.com/users/this-is-a-invalid-user")!
        mockSession.mockResponses[userURL] = nil
        
        let expectation = self.expectation(description: "User Not Found")
        
        service.fetchUserProfileAndRepos(username: "this-is-a-invalid-user") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "UserNotFound")
                XCTAssertEqual(error.code, 404)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
