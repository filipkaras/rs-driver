//
//  BranchListView.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import SwiftUI
import SwiftUIPullToRefresh
import PopupView

struct BranchListView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var branchViewModel = BranchViewModel()
    @StateObject var pagingViewModel = PagingViewModel<BranchViewModel>(source: BranchViewModel())
    @State var selectedBranch: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
                RefreshableScrollView(showsIndicators: false, onRefresh: { done in
                    pagingViewModel.reloadData()
                    done()
                }) {
                    LazyVStack(spacing: 0) {
                        ForEach(pagingViewModel.items) { item in
                            BranchCell(branchViewModel: branchViewModel, branch: item, selectedBranch: $selectedBranch)
                                .onAppear {
                                    pagingViewModel.onItemAppear(item)
                                }
                        }
                    }
                }
                NavigationLink(destination: NavigationLazyView(BranchRequestView(selectedBranch: selectedBranch)), isActive: $routerViewModel.segueToBranchRequest) { EmptyView() }.isDetailLink(false).hidden()
            }
            .padding(.horizontal, K.UI.Space.small)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onChange(of: branchViewModel.inProgress) { value in
                withAnimation {
                    routerViewModel.showLoadingIndicator = value
                }
                if branchViewModel.inProgress == false {
                    pagingViewModel.reloadData()
                }
            }
            .onChange(of: branchViewModel.restResult) { value in
                routerViewModel.showToast(value) {
                    branchViewModel.restResult = nil
                }
            }
        }
    }
}

struct BranchCell: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @ObservedObject var branchViewModel = BranchViewModel()
    var branch: BranchModel!
    @Binding var selectedBranch: Int
    
    var body: some View {
        VStack(spacing: K.UI.Space.small) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(branch.name.uppercased())
                        .fontWeight(.bold)
                    Text(branch.address)
                    Text(branch.desc)
                        .font(.system(size: 14))
                        .opacity(0.5)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Group {
                        HStack {
                            Image(systemName: "location")
                            Text(String(format: "%.0f km", branch.distance))
                        }
                        HStack {
                            Image(systemName: "shippingbox")
                            Text(String(format: "%.2f €", branch.defaultPriceBase))
                        }
                        HStack {
                            Image(systemName: "road.lanes")
                            Text(String(format: "%.2f €", branch.defaultPriceDistance))
                        }
                    }
                    .padding(K.UI.Space.small)
                    .background(Color.status3)
                    .cornerRadius(K.UI.Radius.normal)
                    .foregroundColor(Color.textDarkBg100)
                    Spacer()
                }
            }
            HStack {
                Button {
                    guard let url = branch.phoneUrl,
                        UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } label: {
                    ButtonLabel(title: "KONTAKTOVAŤ", color: .background80, textColor: .text100)
                }
                Button {
                    MapApplication.shared.getDirectionsTo(branch.address)
                } label: {
                    ButtonLabel(title: "NAVIGOVAŤ", color: .background80, textColor: .text100)
                }
            }
            if (branch.myBranch) {
                if (branch.iAmActive) {
                    Button {
                        branchViewModel.setStatus(idBranch: branch.id, status: false)
                    } label: {
                        ButtonLabel(title: "DEAKTIVOVAŤ", color: .primary100)
                    }
                } else {
                    Button {
                        branchViewModel.setStatus(idBranch: branch.id, status: true)
                    } label: {
                        ButtonLabel(title: "AKTIVOVAŤ", color: .success100)
                    }
                }
            } else {
                Button {
                    selectedBranch = branch.id
                    routerViewModel.segueToBranchRequest = true
                } label: {
                    ButtonLabel(title: "POŽIADAŤ O SPOLUPRÁCU", color: .status3)
                }
            }
        }
        .padding(K.UI.Space.normal)
        .background(Color.background90)
        .cornerRadius(K.UI.Radius.normal)
        .padding(.vertical, K.UI.Space.small)
    }
}

struct BranchListView_Previews: PreviewProvider {
    static var previews: some View {
        let pagingViewModel = PagingViewModel<BranchViewModel>(source: BranchViewModel(), demoItems: [
            BranchModel(id: 1, name: "Branch 1", desc: "Popis 1"),
            BranchModel(id: 2, name: "Branch 2", desc: "Popis 2"),
            BranchModel(id: 3, name: "Branch 3", desc: "Popis 3"),
            BranchModel(id: 4, name: "Branch 4", desc: "Popis 4")
        ])
        BranchListView(pagingViewModel: pagingViewModel)
        BranchListView(pagingViewModel: pagingViewModel).preferredColorScheme(.dark)
    }
}
