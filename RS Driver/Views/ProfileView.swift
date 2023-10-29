//
//  Profile.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                HStack {
                    Button {
                        withAnimation {
                            routerViewModel.segueToProfile = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text100)
                    }
                    .padding(.leading, K.UI.Space.small)
                    Spacer()
                }
            }
            FormView(
                accountViewModel: accountViewModel
            )
            .padding(.horizontal)
            Spacer()
        }
        .onChange(of: accountViewModel.inProgress) { value in
            withAnimation {
                routerViewModel.showLoadingIndicator = value
            }
        }
        .onChange(of: accountViewModel.restResult) { value in
            routerViewModel.showToast(value) {
                accountViewModel.restResult = nil
            }
        }
    }
}

private struct FormView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var accountViewModel: AccountViewModel
    @State var isSecured: Bool = true
    
    private var isFormValid: Bool {
        !accountViewModel.name.isEmpty &&
        !accountViewModel.phoneNumber.isEmpty &&
        !accountViewModel.company.isEmpty &&
        !accountViewModel.ico.isEmpty &&
        !accountViewModel.address.isEmpty &&
        !accountViewModel.country.isEmpty
    }
    
    var body: some View {
        VStack {
            Group {
                Text("Profilové informácie a fakturačné údaje")
                    .foregroundColor(.text100)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Group {
                    TextField("Meno a priezvisko", text: $accountViewModel.name)
                    TextField("Telefónne číslo", text: $accountViewModel.phoneNumber)
                    TextField("Názov spoločnosti", text: $accountViewModel.company)
                    TextField("IČO", text: $accountViewModel.ico)
                    TextField("DIČ", text: $accountViewModel.dic)
                    TextField("IČ DPH", text: $accountViewModel.icDph)
                    TextField("Adresa", text: $accountViewModel.address)
                    TextField("Krajina", text: $accountViewModel.country)
                }
                .frame(height: 50)
                .padding(.horizontal)
                .background(Color.background90)
                .cornerRadius(K.UI.Radius.normal)
            }
            Group {
                Button {
                    if isFormValid {
                        accountViewModel.updateProfile()
                    } else {
                        withAnimation {
                            self.accountViewModel.restResult = RestResult(success: false, message: "Pre uloženie profilu musíte vyplniť všetky údaje.")
                        }
                    }
                } label: {
                    Text("Aktualizovať profil")
                        .foregroundColor(Color.textDarkBg100)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color.primary100)
                        .cornerRadius(K.UI.Radius.normal)
                }
                .padding(.top)
            }
        }
        .allowsHitTesting(!accountViewModel.inProgress)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().preferredColorScheme(.light)
            .environmentObject(RouterViewModel())
        ProfileView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
