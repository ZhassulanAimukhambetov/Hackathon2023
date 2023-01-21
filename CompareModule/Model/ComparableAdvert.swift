//
//  ComparableAdvert.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

protocol ComparableAdvert {
    var photoUrl: String? { get }
    var name: String? { get }
    var price: String { get }
    func advertParameters(for names: [String]) -> [String]
}
