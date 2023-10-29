//
//  BranchRequestView.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI

struct BranchRequestView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var branchViewModel = BranchViewModel()
    var selectedBranch: Int
    
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
                            routerViewModel.segueToBranchRequest = false
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
                branchViewModel: branchViewModel,
                selectedBranch: selectedBranch
            )
            .padding(.horizontal)
            Spacer()
        }
        .onChange(of: branchViewModel.inProgress) { value in
            withAnimation {
                routerViewModel.showLoadingIndicator = value
            }
        }
        .onChange(of: branchViewModel.restResult) { value in
            routerViewModel.segueToBranchRequest = false
            routerViewModel.showToast(value) {
                branchViewModel.restResult = nil
            }
        }
    }
}

private struct FormView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var branchViewModel: BranchViewModel
    @State var isSecured: Bool = true
    @State var selectedBranch: Int
    
    private var isFormValid: Bool {
        !branchViewModel.message.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Napíšte správu pre prevádzku. Tá vás bude následne kontaktovať.")
                .foregroundColor(.text100)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            TextEditor(text: $branchViewModel.message)
                .frame(height: 150)
                .cornerRadius(K.UI.Radius.normal)
                .overlay {
                    RoundedRectangle(cornerRadius: K.UI.Radius.normal)
                        .stroke(lineWidth: 1)
                }
            Group {
                Button {
                    if isFormValid {
                        branchViewModel.request(idBranch: selectedBranch)
                    } else {
                        withAnimation {
                            self.branchViewModel.restResult = RestResult(success: false, message: "Pre odoslanie požiadavky musíte zadať správu.")
                        }
                    }
                } label: {
                    Text("Odoslať požiadavku")
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
        .allowsHitTesting(!branchViewModel.inProgress)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct BranchRequestView_Previews: PreviewProvider {
    static var previews: some View {
        BranchRequestView(selectedBranch: 1).preferredColorScheme(.light)
            .environmentObject(RouterViewModel())
        BranchRequestView(selectedBranch: 1).preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
