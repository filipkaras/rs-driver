//
//  Constants.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI

struct K {
    struct UI {
        struct Space {
            static let xlarge: CGFloat = 32
            static let large: CGFloat = 24
            static let normal: CGFloat = 16
            static let small: CGFloat = 8
        }
        struct Radius {
            static let normal: CGFloat = 8
        }
    }
    struct Cms {
        static let About = 1
        static let Terms = 2
        static let Privacy = 3
    }
    struct General {
        static let AppName = "RS Driver"
    }
    struct Api {
        static let Url = "https://api-delivery.redspoon.sk/api"
        static let DataUrl = "https://api-delivery.redspoon.sk/data"
    }
    struct Keychain {
        static let Credentails = "sk.redspoon.rs-driver.credentials"
    }
    struct Notification {
        static let NeedAuthorization = "NeedAuthorization"
        static let UpdateBadge = "UpdateBadge"
        static let NoConnection = "NoConnection"
        static let ChangeLanguage = "ChangeLanguage"
    }
    struct DateFormat {
        static let Date = "dd.MM.yyyy"
        static let DateShort = "dd.MM.yy"
        static let Time = "HH:mm"
    }
    struct Misc {
        static let FlowiiPhoneNumber = "+421 904 860 597"
        static let FlowiiSupportEmail = "info@redspoon.sk"
    }
}

extension Color {
    static let primary100 = Color("Primary100")
    static let primary80 = Color("Primary80")
    static let primary60 = Color("Primary60")
    static let primary40 = Color("Primary40")
    static let primary20 = Color("Primary20")
    static let text100 = Color("Text100")
    static let textDarkBg100 = Color("TextDarkBg100")
    static let textLightBg100 = Color("TextLightBg100")
    static let background100 = Color("Background100")
    static let background90 = Color("Background90")
    static let background80 = Color("Background80")
    static let success100 = Color("Success100")
    static let secondary100 = Color("Secondary100")
    static let status1 = Color("Status1")
    static let status2 = Color("Status2")
    static let status3 = Color("Status3")
    static let paymentCard = Color("PaymentCard")
    static let paymentCash = Color("PaymentCash")
    static let paymentCardpay = Color("PaymentCardpay")
}
