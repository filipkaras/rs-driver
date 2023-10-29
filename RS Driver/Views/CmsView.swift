//
//  CmsView.swift
//  RS Driver
//
//  Created by Filip Karas on 28/03/2023.
//

import SwiftUI
import AttributedText

struct CmsView: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var cmsViewModel = CmsViewModel()
    @State var idCms: Int
    
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
                            routerViewModel.segueToCmsAbout = false
                            routerViewModel.segueToCmsTerms = false
                            routerViewModel.segueToCmsPrivacy = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text100)
                    }
                    .padding(.leading, K.UI.Space.small)
                    Spacer()
                }
            }
            HTMLStringView(htmlContent: cmsViewModel.cms.content.htmlPage())
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .task { self.cmsViewModel.getCms(idCms: idCms) }
    }
}

struct CmsView_Previews: PreviewProvider {
    static var previews: some View {
        CmsView(idCms: 1)
            .environmentObject(RouterViewModel())
        CmsView(idCms: 1).preferredColorScheme(.dark)
            .environmentObject(RouterViewModel())
    }
}
