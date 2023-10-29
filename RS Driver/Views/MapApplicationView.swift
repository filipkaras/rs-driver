//
//  MapApplicationView.swift
//  RS Driver
//
//  Created by Filip Karas on 28/03/2023.
//

import SwiftUI

struct MapApplicationView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var accountViewModel = AccountViewModel()
    @State private var showMapyCZAlert: Bool = false
    @State var selectedMapApplicationType: MapApplicationType? = Auth.shared.selectedMapApplicationType {
        didSet {
            Auth.shared.selectedMapApplicationType = selectedMapApplicationType
        }
    }
    
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
                            routerViewModel.segueToMapApplication = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text100)
                    }
                    .padding(.leading, K.UI.Space.small)
                    Spacer()
                }
            }
            Text("Mapová aplikácia")
                .textCase(.uppercase)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, K.UI.Space.large)
            if MapApplication.shared.canOpen(.mapyCZ) {
                InfoButton(title: "Mapy CZ", success: selectedMapApplicationType == .mapyCZ) {
                    selectedMapApplicationType = .mapyCZ
                }
            } else {
                InfoButton(title: "Mapy CZ", inactive: true) {
                    showMapyCZAlert = true
                }
                .alert("Aplikácia nedostupná", isPresented: $showMapyCZAlert, actions: {
                    Button("OK", role: .cancel) {
                        
                    }
                }, message: {
                    Text("Aplikáciu je najprv potrebné nainštalovať z AppStore.")
                })
            }
            if MapApplication.shared.canOpen(.googleMaps) {
                InfoButton(title: "Google Maps", success: selectedMapApplicationType == .googleMaps) {
                    selectedMapApplicationType = .googleMaps
                }
            } else {
                InfoButton(title: "Google Maps", inactive: true) {
                    showMapyCZAlert = true
                }
                .alert("Aplikácia nedostupná", isPresented: $showMapyCZAlert, actions: {
                    Button("OK", role: .cancel) {
                        
                    }
                }, message: {
                    Text("Aplikáciu je najprv potrebné nainštalovať z AppStore.")
                })
            }
            if MapApplication.shared.canOpen(.appleMaps) {
                InfoButton(title: "Apple Maps", success: selectedMapApplicationType == .appleMaps) {
                    selectedMapApplicationType = .appleMaps
                }
            } else {
                InfoButton(title: "Apple Maps", inactive: true) {
                    showMapyCZAlert = true
                }
                .alert("Aplikácia nedostupná", isPresented: $showMapyCZAlert, actions: {
                    Button("OK", role: .cancel) {
                        
                    }
                }, message: {
                    Text("Aplikáciu je najprv potrebné nainštalovať z AppStore.")
                })
            }
            Spacer()
        }
        .padding(.horizontal, K.UI.Space.large)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct MapApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        MapApplicationView()
            .environmentObject(RouterViewModel())
        MapApplicationView().preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
