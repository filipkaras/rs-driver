//
//  SummaryDetailView.swift
//  RS Driver
//
//  Created by Filip Karas on 04/04/2023.
//

import SwiftUI

import SwiftUI
import SwiftUIPullToRefresh

struct SummaryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routerViewModel: RouterViewModel
    var summaryModel: SummaryModel

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
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text100)
                    }
                    .padding(.leading, K.UI.Space.small)
                    Spacer()
                }
            }
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text((summaryModel.branch?.name).emptyIfNull)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                    }
                    .padding(K.UI.Space.normal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                    .padding(.vertical, K.UI.Space.small)
                    ForEach(summaryModel.pickups) { pickup in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("#" + String(pickup.id))
                                        .font(.system(size: 18, weight: .bold))
                                    ForEach(pickup.addresses) { address in
                                        Text("#" + String(address.id) + " - " + address.value)
                                            .font(.system(size: 14))
                                    }
                                }
                                Spacer()
                                Text(pickup.deliveryPrice.currency)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(K.UI.Space.normal)
                    .background(Color.background90)
                    .cornerRadius(K.UI.Radius.normal)
                    .padding(.vertical, K.UI.Space.small)
                }
            }
            Spacer()
        }
        .padding(.horizontal, K.UI.Space.small)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct SummaryDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let status = PickupStatusModel(id: 1, title: "Čaká na príslub kuriéra")
        let branch = BranchModel(id: 1, name: "Bistro Nitra", desc: "Skusobne Bistro", address: "Nábrežná 1 940 61 Nové Zámky", contact: "0901 705 755")
        let address1 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 10, Nové Zámky", phone: "0904860597", note: "Skuska poznanka", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address2 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 12, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address3 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 14, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let pickup1 = PickupModel(id: 1, distance: 10, deliveryPrice: 5, date: Date(), pickupPrice: 3, addresses: [address1, address2], status: status, branch: branch)
        let pickup2 = PickupModel(id: 2, distance: 12, deliveryPrice: 8, date: Date(), pickupPrice: 4, addresses: [address3], status: status, branch: branch)
        let summary = SummaryModel(branch: branch, pickups: [pickup1, pickup2], total: 12.34)
        
        SummaryDetailView(summaryModel: summary)
        SummaryDetailView(summaryModel: summary).preferredColorScheme(.dark)
    }
}
