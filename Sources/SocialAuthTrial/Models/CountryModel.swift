//
//  CountryModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 14/11/23.
//

import UIKit

struct CountryModel {
    let code: String
    let name: String
    let flag: UIImage?
    var isSelected: Bool
}

extension CountryModel {
    // TODO: replace from api if needed
    static func availableCountries() -> [CountryModel] {
        return [
            CountryModel(code: "+62", name: "Indonesia", flag: .icFlagId, isSelected: true),
            CountryModel(code: "+60", name: "Malaysia", flag: .icFlagMy, isSelected: false)
        ]
    }
    
}

extension Array where Element == CountryModel {
    
    func search(keyword: String) -> [CountryModel] {
        if keyword.isEmpty {
            return self
        }
        
        let _keyword = keyword.lowercased()
        return self.filter {
            $0.name.lowercased().contains(_keyword) ||
            $0.code.contains(_keyword)
        }
    }
    
    func updateSelectedCountry(country selectedCountry: CountryModel) -> [CountryModel] {
        return self.map {
            var country = $0
            country.isSelected = country.code == selectedCountry.code
            return country
        }
    }
    
}
