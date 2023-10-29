//
//  PickupCell.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import SwiftUI

struct PickupCell: View {
    @EnvironmentObject var routerViewModel: RouterViewModel
    @StateObject var pickupViewModel: PickupViewModel
    
    var pickup: PickupModel
    var color: Color {
        guard let idStatus = pickup.status?.id else { return .primary100 }
        switch idStatus {
        case 1:
            return .status1
        case 2:
            return .status2
        case 3:
            return .status3
        default:
            return .primary100
        }
    }
    
    @State private var confirmAccept: Bool = false
    @State private var confirmReject: Bool = false
    @State private var confirmCancel: Bool = false
    @State private var confirmGo: Bool = false
    @State private var confirmComplete: Bool = false
    @State private var confirmReturn: Bool = false
    @State private var selectedAddress: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    Spacer()
                    Text((pickup.status?.title).emptyIfNull.uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.textDarkBg100)
                        .padding(K.UI.Space.small)
                        .background(color)
                        .cornerRadius(K.UI.Radius.normal, corners: [.topLeft, .topRight])
                }
                Spacer()
                Text(pickup.deliveryPrice.currency)
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(Color.textDarkBg100)
                    .padding(K.UI.Space.small)
                    .background(color)
                    .cornerRadius(K.UI.Radius.normal, corners: [.topLeft, .topRight])
            }
            HStack {
                color
                    .frame(width: 4)
                VStack(alignment: .leading, spacing: 0) {
                    Text("#" + String(pickup.id) + " - " + (pickup.branch?.name).emptyIfNull.uppercased())
                        .font(.system(size: 20, weight: .black))
                        .padding(.vertical, K.UI.Space.small)
                    if !pickup.note.isBlank {
                        Text(pickup.note)
                            .padding(.bottom, K.UI.Space.normal)
                    }
                }
                Spacer()
            }
            .background(Color.background90)
            VStack(spacing: 0) {
                ForEach(pickup.addresses) { address in
                    HStack {
                        color
                            .frame(width: 4)
                            .padding(.trailing, K.UI.Space.small)
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("#" + address.idOrderMinor)
                                        Text(address.idOrderMajor)
                                            .font(.system(size: 24, weight: .bold))
                                        Spacer()
                                    }
                                    Text(address.value)
                                    if !address.products.isBlank {
                                        Text(address.products)
                                            .font(.system(size: 14))
                                            .opacity(0.5)
                                            .padding(.top, 4)
                                    }
                                }
                                .padding(.leading, K.UI.Space.small)
                                Spacer()
                                VStack(alignment: .trailing, spacing: 0) {
                                    Text(address.price.currency)
                                        .fontWeight(.bold)
                                    Text(address.payment)
                                        .padding(.horizontal, K.UI.Space.small)
                                        .padding(.vertical, 2)
                                        .foregroundColor(Color.textDarkBg100)
                                        .background(address.paymentColor)
                                        .cornerRadius(K.UI.Radius.normal)
                                        .padding(.top, 4)
                                }
                                .padding(.trailing, 8)
                            }
                            if pickup.status?.id == 3 {
                                HStack {
                                    Spacer()
                                    if address.idStatus == 0 {
                                        Button(action: {
                                            selectedAddress = address.id
                                            confirmGo = true
                                        }, label: {
                                            ButtonLabel(title: "IDEM NA ADRESU", color: .success100)
                                        })
                                    }
                                    if address.idStatus == 1 {
                                        Button(action: {
                                            selectedAddress = address.id
                                            confirmComplete = true
                                        }, label: {
                                            ButtonLabel(title: "DORUČENÁ", color: .success100)
                                        })
                                        Button(action: {
                                            selectedAddress = address.id
                                            confirmReturn = true
                                        }, label: {
                                            ButtonLabel(title: "VRÁTENÁ", color: .primary100)
                                        })
                                    }
                                    if address.idStatus == 2 {
                                        ButtonLabel(title: "DORUČENÁ", color: .background80, textColor: .text100)
                                    }
                                    if address.idStatus == 3 {
                                        ButtonLabel(title: "NEDORUČENÁ", color: .background80, textColor: .text100)
                                    }
                                    Button(action: {
                                        MapApplication.shared.getDirectionsTo(address.value)
                                    }, label: {
                                        Image(systemName: "mappin.circle")
                                            .font(.system(size: 16))
                                            .foregroundColor(.text100)
                                            .padding(K.UI.Space.small)
                                            .background(Color.background80)
                                            .cornerRadius(K.UI.Radius.normal)
                                    })
                                    Button(action: {
                                        guard let url = address.phoneUrl,
                                              UIApplication.shared.canOpenURL(url) else {
                                            return
                                        }
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }, label: {
                                        Image(systemName: "phone.circle")
                                            .font(.system(size: 16))
                                            .foregroundColor(.text100)
                                            .padding(K.UI.Space.small)
                                            .background(Color.background80)
                                            .cornerRadius(K.UI.Radius.normal)
                                    })
                                    Spacer()
                                }
                            }
                            Color.text100
                                .frame(height: 1)
                                .padding(.bottom, 8)
                                .padding(.trailing, 8)
                        }
                        .opacity(address.isActive ? 1 : 0.5)
                        .allowsHitTesting(address.isActive)
                    }
                }
                HStack {
                    color
                        .frame(width: 4)
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName: "alarm")
                                Text(pickup.date.timeString().emptyIfNull)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.background80)
                            .cornerRadius(K.UI.Radius.normal)
                            Spacer()
                            HStack {
                                Image(systemName: "flag")
                                Text(String(round(Double(pickup.distance) / 1000.0 * 100) / 100) + " km")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.background80)
                            .cornerRadius(K.UI.Radius.normal)
                            Spacer()
                            Button {
                                guard let url = pickup.branch?.phoneUrl,
                                      UIApplication.shared.canOpenURL(url) else {
                                    return
                                }
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } label: {
                                HStack {
                                    Image(systemName: "headphones")
                                    Text("Operátor")
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(.text100)
                                .background(Color.background80)
                                .cornerRadius(K.UI.Radius.normal)
                            }
                            Spacer()
                        }
                        .padding(.bottom, K.UI.Space.small)
                        if pickup.status?.id == 1 {
                            HStack {
                                Spacer()
                                Button(action: {
                                    confirmAccept = true
                                }, label: {
                                    ButtonLabel(title: "PRIJAŤ", color: .success100)
                                })
                                Spacer()
                                Button(action: {
                                    confirmReject = true
                                }, label: {
                                    ButtonLabel(title: "ODMIETNUŤ", color: .primary100)
                                })
                                Spacer()
                            }
                            .padding(.bottom, K.UI.Space.small)
                        }
                        if pickup.status?.id == 2 {
                            HStack {
                                Spacer()
                                Button(action: {
                                    confirmCancel = true
                                }, label: {
                                    ButtonLabel(title: "ZRUŠIŤ ZVOZ", color: .primary100)
                                })
                                Spacer()
                            }
                            .padding(.bottom, K.UI.Space.small)
                        }
                    }
                    .padding(.bottom, K.UI.Space.small)
                    .padding(.top, K.UI.Space.small)
                }
            }
            .background(Color.background90)
            .cornerRadius(K.UI.Radius.normal, corners: [.bottomLeft, .bottomRight])
        }
        .opacity(!pickup.challengeDeleted ? 1 : 0.5)
        .allowsHitTesting(!pickup.challengeDeleted)
        .overlay {
            if (pickup.challengeDeleted) {
                Text("Výzvu prijal\niný kuriér")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.primary100)
                    .rotationEffect(Angle(degrees: -45))
                    .overlay {
                        Circle()
                            .stroke(Color.primary100, lineWidth: 10)
                            .frame(width: 200, height: 200)
                    }
                    .opacity(0.5)
            }
        }
        .alert("Idem na adresu", isPresented: $confirmGo, actions: {
            Button("Idem", role: .destructive, action: {
                pickupViewModel.goPickupAddress(idPickup: pickup.id, idAddress: selectedAddress)
            })
            Button("Zrušiť", role: .cancel, action: {})
        }, message: {
            Text("Naozaj chcete potvrdiť, že idete na adresu?")
        })
        .alert("Potvrdenie", isPresented: $confirmComplete, actions: {
            Button("Áno", role: .destructive, action: {
                pickupViewModel.completePickupAddress(idPickup: pickup.id, idAddress: selectedAddress)
            })
            Button("Nie", role: .cancel, action: {})
        }, message: {
            Text("Doručili ste objednávku v poriadku? Ste si istý, že chcete ukončiť doručenie?")
        })
        .alert("Potvrdenie", isPresented: $confirmReturn, actions: {
            Button("Áno", role: .destructive, action: {
                pickupViewModel.returnPickupAddress(idPickup: pickup.id, idAddress: selectedAddress)
            })
            Button("Nie", role: .cancel, action: {})
        }, message: {
            Text("Naozaj chcete objednávku označiť ako vrátaná?")
        })
        .alert("Prijať výzvu", isPresented: $confirmAccept, actions: {
            Button("Prijať", role: .destructive, action: {
                pickupViewModel.acceptPickup(idPickup: pickup.id) {
                    routerViewModel.showToast("Výzva bola úspešne prijatá")
                } failure: { error in
                    if let error = error {
                        routerViewModel.showToast(error.message, success: false)
                    }
                }
            })
            Button("Zrušiť", role: .cancel, action: {})
        }, message: {
            Text("Naozaj chcete prijať túto výzvu?")
        })
        .alert("Odmietnuť výzvu", isPresented: $confirmReject, actions: {
            Button("Odmietnuť", role: .destructive, action: {
                pickupViewModel.rejectPickup(idPickup: pickup.id)
            })
            Button("Zrušiť", role: .cancel, action: {})
        }, message: {
            Text("Naozaj chcete odmietnuť túto výzvu?")
        })
        .alert("Zrušiť zvoz", isPresented: $confirmCancel, actions: {
            Button("Zrušiť", role: .destructive, action: {
                pickupViewModel.cancelPickup(idPickup: pickup.id)
            })
            Button("Ponechať", role: .cancel, action: {})
        }, message: {
            Text("Naozaj chcete zrušiť tento zvoz?")
        })
    }
}
