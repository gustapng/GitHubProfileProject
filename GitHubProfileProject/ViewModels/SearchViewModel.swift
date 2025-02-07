//
//  SearchViewModel.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var profile: Profile?

    private let gitHubService = GitHubService()

    func searchUser(username: String) {
        errorMessage = nil
        isLoading = true
        profile = nil

        gitHubService.fetchUserProfileAndRepos(username: username) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let profile):
                    self.profile = profile
                case .failure(let error):
                    if (error as NSError).domain == "UserNotFound" {
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.errorMessage = "A network error has occurred. Check your Internet connection and try again later."
                    }
                }
            }
        }
    }
}
