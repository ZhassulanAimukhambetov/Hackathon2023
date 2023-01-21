//
//  ComparableModel.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

import Foundation

struct Model: Decodable {
    let advert: Advert
    
    struct Advert: Decodable {
        let parameters: [[String: String]]
        let price: Int
        let name: String?
        let photos: [Photo]
    }
    
    struct Photo: Decodable {
        let path: String?
    }
    
    enum Constants {
        static let name = "label"
        static let value = "value"
    }
}

extension Model: ComparableAdvert {
    var photoUrl: String? {
        advert.photos.first?.path
    }
    
    var name: String? {
        advert.name
    }
    
    var price: String {
        String(advert.price)
    }
    
    func advertParameters(for names: [String]) -> [String] {
        var dict: [String: String] = [:]
        
        advert.parameters.forEach {
            guard let name = $0[Constants.name],
                  let value = $0[Constants.value] else {
                return
            }
            dict[name] = value
        }
        
        return names.map { dict[$0]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? " - " }
    }
}


extension Array where Element == Model {
    var headers: [String] {
        let x = map { $0.advert.parameters }
        if x.isEmpty { return [] }
        var indexX = 0
        var count = 0
        x.enumerated().forEach { index, parameters in
            if count < parameters.count {
                count = parameters.count
                indexX = index
            }
        }
        
        return x[indexX].compactMap { $0[Element.Constants.name] }
    }
}
