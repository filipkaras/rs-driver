//
//  CommonViews.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import SwiftUI

struct ButtonLabel: View {
    var title: String
    var color: Color
    var textColor: Color = Color.textDarkBg100
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, K.UI.Space.small)
            .padding(.vertical, K.UI.Space.small)
            .background(color)
            .cornerRadius(K.UI.Radius.normal)
    }
}

struct NoticeView: View {
    @Binding var errorMessage: String?
    @State private var showNotice: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Text(errorMessage ?? "")
                    .lineLimit(nil)
                    .padding(.vertical, K.UI.Space.normal)
                    .foregroundColor(.textDarkBg100)
                    .padding(.leading)
                Spacer()
                VStack {
                    Button {
                        withAnimation {
                            errorMessage = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.textDarkBg100)
                    }
                    Spacer()
                }
                .padding(K.UI.Space.normal)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(height: showNotice ? nil : 0)
        .opacity(showNotice ? 1 : 0)
        .background(Color.primary100)
        .cornerRadius(K.UI.Radius.normal)
        .overlay {
            RoundedRectangle(cornerRadius: K.UI.Radius.normal)
                .stroke(lineWidth: 1).foregroundColor(.primary100)
        }
        .onChange(of: errorMessage) { value in
            withAnimation {
                showNotice = value != nil
            }
        }
    }
}
