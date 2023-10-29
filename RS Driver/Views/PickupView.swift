//
//  PickupView.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI
import SwiftUIPullToRefresh

struct PickupView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var pickupViewModel = PickupViewModel(listType: "active")
    @StateObject var pagingViewModel = PagingViewModel<PickupViewModel>(source: PickupViewModel(listType: "active"))
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 80)
            RefreshableScrollView(showsIndicators: false, onRefresh: { done in
                pagingViewModel.reloadData()
                done()
            }) {
                if pagingViewModel.items.count > 0 {
                    LazyVStack(spacing: 0) {
                        ForEach(pagingViewModel.items) { item in
                            PickupCell(pickupViewModel: pickupViewModel, pickup: item)
                                .onAppear {
                                    pagingViewModel.onItemAppear(item)
                                }
                                .padding(.bottom, K.UI.Space.normal)
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "car")
                            .font(.system(size: 60))
                            .padding(.top, 60)
                        Text("Aktuálne nie sú dostupné žiadne zvozy.")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.top, K.UI.Space.normal)
                            .padding(.horizontal, K.UI.Space.large)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding(.horizontal, K.UI.Space.small)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: pickupViewModel.inProgress) { value in
            if value == true { return }
            pagingViewModel.reloadData()
        }
    }
}

struct PickupView_Previews: PreviewProvider {
    static var previews: some View {
        let status = PickupStatusModel(id: 1, title: "Čaká na príslub kuriéra")
        let branch = BranchModel(id: 1, name: "Bistro Nitra", desc: "Skusobne Bistro", address: "Nábrežná 1 940 61 Nové Zámky", contact: "0901 705 755")
        let address1 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 10, Nové Zámky", phone: "0904860597", note: "Skuska poznanka", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address2 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 12, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address3 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 14, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let pagingViewModel = PagingViewModel<PickupViewModel>(source: PickupViewModel(), demoItems: [
            PickupModel(id: 1, distance: 1234, deliveryPrice: 7.8, date: Date(), pickupPrice: 5.6, addresses: [address1, address2, address3], status: status, branch: branch)
        ])
        PickupView(pagingViewModel: pagingViewModel)
        PickupView(pagingViewModel: pagingViewModel).preferredColorScheme(.dark)
    }
}
