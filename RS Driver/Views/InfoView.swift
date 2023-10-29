//
//  InfoView.swift
//  RS Driver
//
//  Created by Filip Karas on 28/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct InfoView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: K.UI.Space.normal) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                if routerViewModel.loggedIn {
                    HStack {
                        Group {
                            if image.size.width > 0 {
                                Image(uiImage: image)
                                    .resizable()
                            } else {
                                WebImage(url: URL(string: Auth.shared.user?.photo ?? ""))
                                    .placeholder(Image(systemName: "person"))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                            }
                        }
                            .clipped()
                            .frame(width: 60, height: 60)
                            .cornerRadius(60)
                            .overlay(
                                Circle()
                                    .stroke(Color.text100, lineWidth: 2)
                            )
                            .overlay(
                                Image(systemName: "pencil.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 25))
                                    .padding(.leading, 48)
                                    .padding(.top, 48)
                            )
                            .onTapGesture {
                                showSheet = true
                            }
                            .sheet(isPresented: $showSheet) {
                                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                            }
                            .onChange(of: image) { _ in
                                accountViewModel.uploadProfilePhoto(image: self.image)
                            }
                        VStack(alignment: .leading) {
                            Text("Prihlásený ako:")
                            Text((Auth.shared.user?.email).emptyIfNull)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .padding(.leading, K.UI.Space.small)
                        Spacer()
                    }
                    .padding(.bottom)
                    InfoButton(title: "Nastavenia") {
                        routerViewModel.segueToSettings = true
                    }
                }
                InfoButton(title: "O Projekte") {
                    routerViewModel.segueToCmsAbout = true
                }
                /*InfoButton(title: "Podmienky používania") {
                    routerViewModel.segueToCmsTerms = true
                }*/
                if routerViewModel.loggedIn {
                    InfoButton(title: "Odhlásenie", danger: true) {
                        Auth.shared.signOut()
                        routerViewModel.route()
                        routerViewModel.tabSelection = 1
                    }
                }
                Spacer()
                NavigationLink(destination: NavigationLazyView(SettingsView()), isActive: $routerViewModel.segueToSettings) { EmptyView() }.isDetailLink(false).hidden()
                NavigationLink(destination: NavigationLazyView(CmsView(idCms: K.Cms.About)), isActive: $routerViewModel.segueToCmsAbout) { EmptyView() }.isDetailLink(false).hidden()
                NavigationLink(destination: NavigationLazyView(CmsView(idCms: K.Cms.Terms)), isActive: $routerViewModel.segueToCmsTerms) { EmptyView() }.isDetailLink(false).hidden()
            }
            .padding(.horizontal, K.UI.Space.large)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .environmentObject(RouterViewModel())
        InfoView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
