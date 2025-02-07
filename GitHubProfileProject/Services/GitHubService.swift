//
//  GitHubService.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import Foundation

class GitHubService {
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func fetchUserProfileAndRepos(username: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let url = URL(string: "https://api.github.com/users/\(username)")!

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found. Please enter another name."])))
                return
            }

            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)

                self.fetchRepositoriesForUser(username: username) { result in
                    switch result {
                    case .success(let repositories):
                        let profile = Profile(user: userProfile, repositories: repositories)
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func fetchRepositoriesForUser(username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let url = URL(string: "https://api.github.com/users/\(username)/repos")!

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
