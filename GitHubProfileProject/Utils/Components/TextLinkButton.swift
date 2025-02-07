//
//  TextLinkButton.swift
//  GitHubProfileProject
//
//  Created by Gustavo Ferreira dos Santos on 05/02/25.
//

import SwiftUI

struct TextLinkButton: View {
    var title: String
    var textColor: Color
    var action: () -> Void
    var fontSize: CGFloat = 24

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .regular))
                .foregroundColor(textColor)
        }
    }
}
