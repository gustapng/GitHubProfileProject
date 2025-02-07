//
//  ProfileView.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import SwiftUI

struct ProfileView: View {
    let profile: Profile

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if let avatarUrl = profile.user.avatarUrl, let url = URL(string: avatarUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(profile.user.login)
                    .font(.title3)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.lightGray)

            Divider()
                .background(AppColors.gray)
            
            List(profile.repositories) { repo in
                VStack(alignment: .leading) {
                    Text(repo.name)
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top)
                        .foregroundColor(AppColors.black)

                    if let language = repo.language {
                        Text(language)
                            .font(.callout)
                            .foregroundColor(AppColors.gray)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }

                    Divider()
                        .frame(maxWidth: .infinity)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            .listStyle(.plain)

            Spacer()
        }
    }
}

#Preview {
    ProfileView(profile: Profile(user: UserProfile(login: "User Example", avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4"), repositories: [Repository(id: 1, name: "Hello-World", language: "Swift")]))
}
