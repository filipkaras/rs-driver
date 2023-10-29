//
//  UtilityExtensions.swift
//  RS Driver
//
//  Created by Filip Karas on 28/10/2022.
//

import SwiftUI
import Introspect

struct KShadow: ViewModifier {
    var bottom: Bool = true
    var small: Bool = true
    var dark: Bool = false
    var mask: Bool = false
    
    func body(content: Content) -> some View {
        let radius: CGFloat = small ? 5 : 15
        content
            .shadow(color: .black.opacity(dark ? 0.3 : 0.1), radius: radius, x: 0, y: bottom ? 2 : -2)
            .conditionalModifier(mask, transform: { content in
                content.mask(Rectangle().padding(bottom ? .bottom : .top, -radius * 2))
            })
    }
}

extension View {
    func kShadow(bottom: Bool = true, small: Bool = true, dark: Bool = false, mask: Bool = false) -> some View {
        modifier(KShadow(bottom: bottom, small: small, dark: dark, mask: mask))
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    @ViewBuilder
    func removeListBackground() -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder
    func conditionalModifier<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct ListSpacer: View {
    var height: CGFloat = 10
    
    var body: some View {
        Spacer()
            .frame(height: height)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

// https://stackoverflow.com/questions/69663197/how-can-i-reverse-the-slide-transition-for-a-swiftui-animation
extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
}

// https://stackoverflow.com/questions/57594159/swiftui-navigationlink-loads-destination-view-immediately-without-clicking
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
