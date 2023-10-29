//
//  InfoButton.swift
//  RS Driver
//
//  Created by Filip Karas on 26/04/2023.
//

import SwiftUI

struct InfoButton: View {
    var title: String
    var danger: Bool = false
    var success: Bool = false
    var inactive: Bool = false
    var action: () -> Void = {}
    var foregroundColor: Color {
        if danger { return .primary100 }
        if success { return .success100 }
        if inactive { return .background80 }
        return .text100
    }
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text(title.uppercased())
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .foregroundColor(foregroundColor)
        .font(.system(size: 14, weight: .medium))
        .overlay(
            RoundedRectangle(cornerRadius: K.UI.Radius.normal)
                .stroke(foregroundColor, lineWidth: 1)
        )
        .padding(.horizontal, 1)
    }
}

struct InfoButton_Previews: PreviewProvider {
    static var previews: some View {
        InfoButton(title: "Button")
        InfoButton(title: "Button").preferredColorScheme(.dark)
    }
}
