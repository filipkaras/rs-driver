//
//  RootView.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI
import ActivityIndicatorView

struct RootView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var notificationManager = NotificationManager.shared
    
    var body: some View {
        ZStack {
            TabView(selection: $routerViewModel.tabSelection) {
                Group {
                    if routerViewModel.loggedIn {
                        ChallengeView()
                    } else {
                        LoginView()
                    }
                }
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .renderingMode(.template)
                    Text("Výzvy")
                }
                .tag(1)
                .badge(routerViewModel.badgeChallenge)
                Group {
                    if routerViewModel.loggedIn {
                        PickupView()
                    } else {
                        LoginView()
                    }
                }
                .tabItem {
                    Image(systemName: "car")
                        .renderingMode(.template)
                    Text("Zvozy")
                }
                .tag(2)
                .badge(routerViewModel.badgePickup)
                BranchListView()
                .tabItem {
                    Image(systemName: "fork.knife")
                        .renderingMode(.template)
                    Text("Prevádzky")
                }
                .tag(3)
                Group {
                    if routerViewModel.loggedIn {
                        SummaryView()
                    } else {
                        LoginView()
                    }
                }
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .renderingMode(.template)
                    Text("Sumáre")
                }
                .tag(4)
                InfoView()
                .tabItem {
                    Image(systemName: "ellipsis")
                        .renderingMode(.template)
                    Text("Viac")
                }
                .tag(5)
            }
            .accentColor(Color.primary100)
            ActivityIndicatorView(isVisible: $routerViewModel.showLoadingIndicator, type: .arcs(count: 3, lineWidth: 2))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.red)
        }
        .onChange(of: routerViewModel.tabSelection) { newValue in
            notificationManager.selectedTab = newValue
        }
        .onChange(of: notificationManager.selectedTab) { newValue in
            if newValue != routerViewModel.tabSelection {
                routerViewModel.tabSelection = newValue
            }
        }
        .popup(isPresented: $routerViewModel.showToast) {
            Text(routerViewModel.toastMessage?.message ?? "")
                .foregroundColor(Color.textDarkBg100)
                .padding(K.UI.Space.normal)
                .background(routerViewModel.toastMessage?.success ?? false ? Color.success100 : Color.primary100)
                .cornerRadius(K.UI.Radius.normal)
        } customize: {
            $0
                .type(.floater())
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(5)
                .dismissCallback {
                    routerViewModel.toastMessage?.dismissCallback?()
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().preferredColorScheme(.dark)
    }
}
