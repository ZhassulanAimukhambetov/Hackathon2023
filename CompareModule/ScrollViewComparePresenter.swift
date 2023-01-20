//
//  ScrollViewComparePresenter.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 21.01.2023.
//

import Foundation

final class ScrollViewComparePresenter {
    
    var parameters: [[String: String]] = []
    
    func viewDidLoad() {
        createParameters()
        fetchAdverts()
        
    }
    
    
    private func fetchAdverts() {
        do {
            if let path = Bundle.main.path(forResource: "AdvertResponse", ofType: "json") {
               let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(AdvertsSearchResult.self, from: data)
                print(response.items.count)
            }
        } catch {
            print(error)
        }
    }
    
    private func createParameters() {
        let labels = ["Город", "Поколение", "Кузов", "Объем двигателя, л", "Пробег", "Коробка передач", "Привод", "Руль", "Растаможен в Казахстане"]
        let values = ["Актау", "2006 - 2009 XV40", "седан", "3.5 (газ-бензин)", "222 222 км", "автомат", "передний привод", "слева", "Да"]
        
        
        for (index, label) in labels.enumerated() {
            let value = values[index]
            let appendingElement = ["label": label, "value": value]
            parameters.append(appendingElement)
        }
    }
    
    func getAdvert() -> Advert {
        var parametersForAdvert: [String] = []
        parameters.forEach { paramDict in
            let values = paramDict["value"] ?? "-"
            parametersForAdvert.append(values)
        }
        
        return Advert(parametersForAdvert)
    }
    
    func getHeaders() -> [String] {
        parameters.map { paramDict in
            let labels = paramDict["label"] ?? "-"
            return labels
        }
    }
}
