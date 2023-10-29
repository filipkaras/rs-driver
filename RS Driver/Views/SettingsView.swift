//
//  SettingsView.swift
//  RS Driver
//
//  Created by Filip Karas on 28/03/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    @State private var confirmDelete: Bool = false
    
    var body: some View {
        VStack(spacing: K.UI.Space.normal) {
            ZStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                HStack {
                    Button {
                        withAnimation {
                            routerViewModel.segueToSettings = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text100)
                    }
                    .padding(.leading, K.UI.Space.small)
                    Spacer()
                }
            }
            Text("Nastavenia")
                .textCase(.uppercase)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, K.UI.Space.large)
            InfoButton(title: "Zmena hesla")
            InfoButton(title: "Mapová aplikácia") {
                routerViewModel.segueToMapApplication = true
            }
            InfoButton(title: "Aktualizovať profil") {
                routerViewModel.segueToProfile = true
            }
            InfoButton(title: "Zmazať účet", danger: true) {
                confirmDelete = true
            }
            .alert("Zmazať účet", isPresented: $confirmDelete, actions: {
                Button("Áno", role: .destructive, action: {
                    accountViewModel.deleteAccount()
                })
                Button("Nie", role: .cancel, action: {})
            }, message: {
                Text("Naozaj chcete zmazať účet? Táto akcia je nevratná!")
            })
            .onChange(of: accountViewModel.inProgress) { value in
                withAnimation {
                    routerViewModel.showLoadingIndicator = value
                }
                if accountViewModel.inProgress == true { return }
                routerViewModel.route()
            }
            .onChange(of: accountViewModel.restResult) { value in
                if let result = accountViewModel.restResult, result.success {
                    Auth.shared.signOut()
                    routerViewModel.route()
                    routerViewModel.segueToSettings = false
                    routerViewModel.tabSelection = 1
                } else {
                    routerViewModel.showToast(value) {
                        accountViewModel.restResult = nil
                    }
                }
            }
            Spacer()
            NavigationLink(destination: NavigationLazyView(MapApplicationView()), isActive: $routerViewModel.segueToMapApplication) { EmptyView() }.isDetailLink(false).hidden()
            NavigationLink(destination: NavigationLazyView(ProfileView()), isActive: $routerViewModel.segueToProfile) { EmptyView() }.isDetailLink(false).hidden()
        }
        .padding(.horizontal, K.UI.Space.large)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(RouterViewModel())
        SettingsView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
