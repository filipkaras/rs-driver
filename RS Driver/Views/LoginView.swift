//
//  LoginView.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                FormView(accountViewModel: accountViewModel)
                .padding(.horizontal)
                Spacer()
                NavigationLink(destination: NavigationLazyView(RegisterView()), isActive: $routerViewModel.segueToRegister) { EmptyView() }.isDetailLink(false).hidden()
                NavigationLink(destination: NavigationLazyView(ForgotPasswordView()), isActive: $routerViewModel.segueToForgotPassword) { EmptyView() }.isDetailLink(false).hidden()
            }
            .padding(.horizontal)
        }
        .onChange(of: accountViewModel.inProgress) { value in
            withAnimation {
                routerViewModel.showLoadingIndicator = value
            }
            if accountViewModel.inProgress == false {
                routerViewModel.route()
            }
        }
        .onChange(of: accountViewModel.restResult) { value in
            routerViewModel.showToast(value)
            accountViewModel.restResult = nil
        }
    }
}

private struct FormView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var accountViewModel: AccountViewModel
    @State var isSecured: Bool = true
    
    private var isFormValid: Bool {
        !accountViewModel.email.isEmpty && !accountViewModel.password.isEmpty
    }
    
    var body: some View {
        VStack {
            TextField("Email", text: $accountViewModel.email)
                .frame(height: 50)
                .padding(.horizontal)
                .background(Color.background90)
                .cornerRadius(K.UI.Radius.normal)
                .keyboardType(.emailAddress)
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
            Spacer()
                .frame(height: K.UI.Space.large)
            Button {
                if isFormValid {
                    accountViewModel.login()
                } else {
                    withAnimation {
                        self.accountViewModel.restResult = RestResult(success: false, message: "Pre prihlásenie najskôr vyplňte email a heslo.")
                    }
                }
            } label: {
                Text("Prihlásiť sa")
                    .foregroundColor(Color.textDarkBg100)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color.primary100)
                    .cornerRadius(K.UI.Radius.normal)
            }
            .padding(.top)
            Spacer()
                .frame(height: K.UI.Space.large)
            HStack {
                Button {
                    routerViewModel.segueToRegister = true
                } label: {
                    Text("Vytvoriť nový účet")
                        .foregroundColor(.text100)
                        .underline()
                }
                Spacer()
                Button {
                    routerViewModel.segueToForgotPassword = true
                } label: {
                    Text("Zabudnuté heslo")
                        .foregroundColor(.text100)
                        .underline()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .allowsHitTesting(!accountViewModel.inProgress)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().preferredColorScheme(.light)
            .environmentObject(RouterViewModel())
        LoginView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
