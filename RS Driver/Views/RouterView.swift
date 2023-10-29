//
//  RouterView.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import SwiftUI

struct ModalView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        content
    }
}

struct RouterView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    
    var body: some View {
        if routerViewModel.currentPage == .login {
            LoginView()
                .transition(.scale)
        }
        else if routerViewModel.currentPage == .root {
            RootView()
                .transition(.scale)
        }
    }
}

struct RouterView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
            .environmentObject(RouterViewModel())
    }
}
