//
//  MapApplication.swift
//  RS Driver
//
//  Created by Filip Karas on 30/04/2023.
//

import UIKit

enum MapApplicationType: String, CaseIterable {
    case mapyCZ = "mapy-cz"
    case googleMaps = "google-maps"
    case appleMaps = "apple-maps"
}

class MapApplication {
    static let shared = MapApplication()
    
    func canOpen(_ mapApplicationType: MapApplicationType) -> Bool {
        switch mapApplicationType {
        case .mapyCZ:
            return UIApplication.shared.canOpenURL(URL(string: "szn-mapy://")!)
        case .googleMaps:
            return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        case .appleMaps:
            return UIApplication.shared.canOpenURL(URL(string: "map://")!)
        }
    }
    
    func getDirectionsTo(_ address: String) {
        guard let mapApplicationType = Auth.shared.selectedMapApplicationType else { return }
        let address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        switch mapApplicationType {
        case .mapyCZ:
            print("szn-mapy://zakladni?q=\(address)&z=17&source=query")
            UIApplication.shared.open(URL(string: "szn-mapy://mapy.cz/zakladni?q=\(address)&z=17&source=query")!)
        case .googleMaps:
            UIApplication.shared.open(URL(string: "comgooglemaps-x-callback://?daddr=\(address)&directionsmode=driving")!)
        case .appleMaps:
            UIApplication.shared.open(URL(string: "maps://?daddr=\(address)")!)
        }
    }
}
