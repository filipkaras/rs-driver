//
//  RegisterView.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    @State private var showSuccessAlert: Bool = false
    
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
                            routerViewModel.segueToRegister = false
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
            if accountViewModel.inProgress == true { return }
            routerViewModel.route()
        }
        .onChange(of: accountViewModel.restResult) { value in
            routerViewModel.segueToRegister = false
            routerViewModel.showToast(value)
            accountViewModel.restResult = nil
        }
        .allowsHitTesting(!accountViewModel.inProgress)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

private struct FormView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var accountViewModel: AccountViewModel
    @State var isSecured: Bool = true
    
    private var isFormValid: Bool {
        !accountViewModel.email.isEmpty &&
        !accountViewModel.password.isEmpty
    }
    
    var body: some View {
        VStack {
            Group {
                Text("Zadajte svoju emailovú adresu a heslo, ktoré budete používať na prihlásenie do svojho účtu.")
                    .foregroundColor(.text100)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                TextField("Email", text: $accountViewModel.email)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                    .keyboardType(.emailAddress)
                TextField("Meno a priezvisko", text: $accountViewModel.name)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                TextField("Telefónne číslo", text: $accountViewModel.phoneNumber)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                TextField("IČO", text: $accountViewModel.ico)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                Group {
                    if isSecured {
                        SecureField("Heslo", text: $accountViewModel.password)
                    } else {
                        TextField("Heslo", text: $accountViewModel.password)
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .overlay(alignment: .trailing) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                        .foregroundColor(.gray)
                        .onTapGesture {
                            isSecured.toggle()
                        }
                }
                .background(Color.background90)
                .cornerRadius(K.UI.Radius.normal)
            }
            Group {
                Spacer()
                    .frame(height: K.UI.Space.large)
                /*Toggle(isOn: $accountViewModel.terms) {
                    Button {
                        routerViewModel.segueToCmsTerms = true
                    } label: {
                        Text("Súhlasím s obchodnými podmienkami")
                            .foregroundColor(.text100)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .primary100))
                Toggle(isOn: $accountViewModel.privacy) {
                    Button {
                        routerViewModel.segueToCmsPrivacy = true
                    } label: {
                        Text("Súhlasím so zásadami ochrany osobných údajov")
                            .foregroundColor(.text100)
                            .multilineTextAlignment(.leading)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .primary100))*/
                Button {
                    if isFormValid {
                        accountViewModel.register()
                    } else {
                        withAnimation {
                            self.accountViewModel.restResult = RestResult(success: false, message: "Pre dokončenie registrácie musíte vyplniť všetky údaje.")
                            //self.accountViewModel.restResult = RestResult(success: false, message: "Pre dokončenie registrácie musíte vyplniť všetky údaje a súhlasiť s obchodnými podmienkami a zásadami ochrany osobných údajov.")
                        }
                    }
                } label: {
                    Text("Dokončit registráciu")
                        .foregroundColor(Color.textDarkBg100)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color.primary100)
                        .cornerRadius(K.UI.Radius.normal)
                }
                .padding(.top)
            }
            NavigationLink(destination: NavigationLazyView(CmsView(idCms: K.Cms.Privacy)), isActive: $routerViewModel.segueToCmsPrivacy) { EmptyView() }.isDetailLink(false).hidden()
            NavigationLink(destination: NavigationLazyView(CmsView(idCms: K.Cms.Terms)), isActive: $routerViewModel.segueToCmsTerms) { EmptyView() }.isDetailLink(false).hidden()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().preferredColorScheme(.light)
            .environmentObject(RouterViewModel())
        RegisterView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
