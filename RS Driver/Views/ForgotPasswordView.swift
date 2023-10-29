//
//  ForgotPasswordView.swift
//  RS Driver
//
//  Created by Filip Karas on 06/05/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
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
                            routerViewModel.segueToForgotPassword = false
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
        .padding(.horizontal)
        .onChange(of: accountViewModel.inProgress) { value in
            withAnimation {
                routerViewModel.showLoadingIndicator = value
            }
            if accountViewModel.inProgress == false {
                routerViewModel.route()
            }
        }
        .onChange(of: accountViewModel.restResult) { value in
            routerViewModel.segueToForgotPassword = false
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
        !accountViewModel.email.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Ak chcete obnoviť svoje heslo, zadajte svoju e-mailovú adresu a stlačte tlačidlo \"Obnoviť heslo\". Pokyny, ako postupovať, vám zašleme na váš e-mail.")
                .padding(.bottom, K.UI.Space.normal)
            TextField("Email", text: $accountViewModel.email)
                .frame(height: 50)
                .padding(.horizontal)
                .background(Color.background90)
                .cornerRadius(K.UI.Radius.normal)
                .keyboardType(.emailAddress)
            Spacer()
                .frame(height: K.UI.Space.large)
            Button {
                if isFormValid {
                    accountViewModel.resetPassword()
                } else {
                    withAnimation {
                        self.accountViewModel.restResult = RestResult(success: false, message: "Pre obnovenie hesla vyplňte email.")
                    }
                }
            } label: {
                Text("Obnoviť heslo")
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
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView().preferredColorScheme(.light)
            .environmentObject(RouterViewModel())
        ForgotPasswordView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
