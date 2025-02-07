//
//  SearchView.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var username: String = ""
    @State private var showAlert = false
    @State private var navigateToProfile = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Text("GitHub Viewer")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.lightGray)

                    Divider()
                        .frame(height: 3)
                        .background(AppColors.mediumGray)

                    Spacer()

                    TextField("Username", text: $username)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .font(.system(size: 20))
                        .background(AppColors.offWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppColors.gray, lineWidth: 1)
                        )
                        .frame(width: geometry.size.width * 0.85, height: 100)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .accessibilityLabel("Username input")

                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }

                    TextLinkButton(title: "Search", textColor: AppColors.blue) {
                        viewModel.searchUser(username: username)
                    }
                    .frame(width: geometry.size.width * 0.5)
                    .accessibilityLabel("Search GitHub User Button")

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? "Erro desconhecido"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onChange(of: viewModel.profile) { oldValue, newValue in
                    if newValue != nil {
                        navigateToProfile = true
                    }
                }
                .onChange(of: viewModel.errorMessage) { oldValue, newValue in
                    if newValue != nil {
                        showAlert = true
                    }
                }
                .navigationDestination(isPresented: $navigateToProfile) {
                    ProfileView(profile: viewModel.profile ?? Profile(user: UserProfile(login: "", avatarUrl: ""), repositories: []))
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
