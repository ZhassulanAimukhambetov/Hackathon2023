//
//  ScrollViewComparable+Mock.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

import Foundation

extension ComparableContainerViewController {
    func adverts1() -> [Model] {
        guard let path = Bundle.main.path(forResource: "Directions", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let models = try? JSONDecoder().decode([Model].self, from: data) else {
            return []
        }
        
        return models
    }
    
    
    func advert() -> Model {
        let labels = ["Город", "Поколение", "Кузов", "Объем двигателя, л", "Пробег", "Коробка передач", "Привод", "Руль", "Растаможен в Казахстане"]
        let values = ["Актау", "2006 - 2009 XV40", "седан", "3.5 (газ-бензин)", "222 222 км", "автомат", "передний привод", "слева", "Да"]

        var parameters = [[String : String]]()

        for (index, label) in labels.enumerated() {
            let value = values[index]
            let appendingElement = ["label": label, "value": value]
            parameters.append(appendingElement)
        }

        return Model(advert: .init(parameters: parameters))
    }

    func adverts() -> [Model] {
        var result = [Model]()
        for _ in 1...20 {
            result.append(advert())
        }
        return result
    }
}
