//
//  SummaryView.swift
//  RS Driver
//
//  Created by Filip Karas on 31/03/2023.
//

import SwiftUI
import SwiftUIPullToRefresh

struct SummaryView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var summaryViewModel = SummaryViewModel()
    @State private var date = Date()
    @State private var calendarId: UUID = UUID()

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                DatePicker(
                    "Dátum:",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .id(calendarId)
                .onChange(of: date) { _ in
                    calendarId = UUID()
                    summaryViewModel.getSummary(date: date)
                }
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal, K.UI.Space.normal)
                .padding(.bottom)
                RefreshableScrollView(showsIndicators: false, onRefresh: { done in
                    summaryViewModel.getSummary(date: date)
                    done()
                }) {
                    VStack {
                        HStack {
                            Text("Spolu")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Text(summaryViewModel.summary.total.currency)
                                .font(.system(size: 22, weight: .bold))
                        }
                        .padding(K.UI.Space.normal)
                        .background(Color.background90)
                        .cornerRadius(K.UI.Radius.normal)
                        .padding(.vertical, K.UI.Space.small)
                        ForEach(summaryViewModel.summary.data) { item in
                            NavigationLink {
                                SummaryDetailView(summaryModel: item)
                            } label: {
                                HStack {
                                    Text((item.branch?.name).emptyIfNull)
                                        .font(.system(size: 16, weight: .bold))
                                    Spacer()
                                    Text(item.total.currency)
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.text100)
                            }
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
            .task { self.summaryViewModel.getSummary(date: date) }
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let status = PickupStatusModel(id: 1, title: "Čaká na príslub kuriéra")
        let branch = BranchModel(id: 1, name: "Bistro Nitra", desc: "Skusobne Bistro", address: "Nábrežná 1 940 61 Nové Zámky", contact: "0901 705 755")
        let address1 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 10, Nové Zámky", phone: "0904860597", note: "Skuska poznanka", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address2 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 12, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let address3 = PickupAddressModel(id: 1, idOrder: "123", name: "Filip Karas", value: "Cajkovskeho 14, Nitra", phone: "0904860597", note: "", payment: "Hotovosť", price: 7.8, status: PickupAddressStatusModel(id: 2, title: "Vytvorená"))
        let pickup1 = PickupModel(id: 1, distance: 10, deliveryPrice: 5, date: Date(), pickupPrice: 3, addresses: [address1, address2], status: status, branch: branch)
        let pickup2 = PickupModel(id: 2, distance: 12, deliveryPrice: 8, date: Date(), pickupPrice: 4, addresses: [address3], status: status, branch: branch)
        let summary1 = SummaryModel(branch: branch, pickups: [pickup1, pickup2], total: 12.34)
        let summary2 = SummaryModel(branch: branch, pickups: [pickup2], total: 23.45)
        let wrapper = SummaryModelWrapper(result: true, total: 112.34, data: [summary1, summary2])
        
        SummaryView(summaryViewModel: SummaryViewModel(demoItem: wrapper))
        SummaryView(summaryViewModel: SummaryViewModel(demoItem: wrapper)).preferredColorScheme(.dark)
    }
}
