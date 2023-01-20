//
//  ScrollViewCompare.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

final class ScrollViewCompare: UIViewController {
    
    private enum Constants {
        static let headerSize: CGFloat = 44
        static let bottomHeaderOffset: CGFloat = 16
        static let bottomParameterComponentOffset: CGFloat = 16
        
    }
    
//    private let presenter = ScrollViewComparePresenter()
    
    private let noMovableHeaderView: UIView = .init()
    
    let scrollView: UIScrollView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.frame = view.bounds
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.contentSize = .init(width: 10000, height: 7700)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        
        scrollView.addSubview(noMovableHeaderView)
        
        noMovableHeaderView.backgroundColor = .yellow.withAlphaComponent(0.5)
        
        
        if #available(iOS 16.0, *) {
            var clock = ContinuousClock()
            let result = clock.measure(createContent)
            
            print(result)
        }
        
//        presenter.viewDidLoad()
    }
    
    func createContent() {
        for i in (0...20) {
            let x = CGFloat(i) * view.bounds.width / CGFloat(2)
            
            let (containerView, parameterSizes) = createContainer(advert: createAdvert(), xPosition: x)
            scrollView.addSubview(containerView)
            
            if i == 0 {
                appendHeaders(headerTitles: ["Header", "Header", "Header", "Header", "Header", "Header", "Header", "Header",
                                             "Header", "Header", "Header", "Header", "Header", "Header", "Header", "Header",
                                             "Header", "Header", "Header", "Header", "Header", "Header", "Header", "Header",
                                             "Header", "Header", "Header", "Header", "Header", "Header", "Header", "Header"],
                              parameterHeights: parameterSizes)
            }
        }
    }
    
    func createContainer(advert: Advert, xPosition: CGFloat) -> (UIView, [CGFloat]) {
        let (containerView, arr) = createAdvertContainerView(advert: advert, x: xPosition, width: UIScreen.main.bounds.width / 2 - 32, headerHeight: 44)
        
        return (containerView, arr)
    }
    
    func createAdvertContainerView(advert: Advert,
                                   x: CGFloat,
                                   width: CGFloat,
                                   headerHeight: CGFloat,
                                       spacing: CGFloat = 16) -> (UIView, [CGFloat]) {
            let containerView = UIView()
            var y: CGFloat = headerHeight
            var array: [CGFloat] = []
            
            advert.parameters.enumerated().forEach { (index, parameter) in
                let label = UILabel(frame: .init(origin: .init(x: 0, y: y + spacing), size: .init(width: width, height: 0)))
                label.text = parameter
                label.numberOfLines = 0
                label.sizeToFit()
                let height = label.frame.height
                array.append(height)
                containerView.addSubview(label)
                if index < advert.parameters.count - 1 {
                    y += height + spacing + headerHeight
                } else {
                    y += height
                }
            }
            containerView.frame = CGRect(origin: .init(x: x, y: .zero), size: CGSize(width: width, height: y))
            return (containerView, array)
        }
    
    
    
    func appendHeaders(headerTitles: [String], parameterHeights: [CGFloat]) {
        guard headerTitles.count == parameterHeights.count else { return }
        
        let headerSpaceHeight = CGFloat(parameterHeights.count) * (Constants.headerSize + Constants.bottomHeaderOffset)
        let allParameterHeights = parameterHeights.reduce(0) { partialResult, parameterHeight in
            return partialResult + parameterHeight
        }
        
        noMovableHeaderView.frame = .init(x: 0,
                                          y: 0,
                                          width: view.bounds.width,
                                          height: allParameterHeights + headerSpaceHeight)
        
        scrollView.contentSize = .init(width: 50000, height: noMovableHeaderView.bounds.height)
        var totalHeight: CGFloat = 0
        
        for (index, headerTitle) in headerTitles.enumerated() {
            let y: CGFloat
            
            if index == 0 {
                y = 0
            } else {
                let parameterHeight = parameterHeights[index - 1]
                let blockHeight = Constants.headerSize + Constants.bottomHeaderOffset + parameterHeight
                totalHeight += blockHeight
                y = totalHeight
                
                print("\(index) -  \(y)")
            }
            
            let label = UILabel(frame: .init(x: 16, y: y, width: view.bounds.width / 2, height: Constants.headerSize))
            label.text = headerTitle
            noMovableHeaderView.addSubview(label)
        }
    }
    
    private func createAdvert() -> Advert {
        Advert(["asdkjcmpaoisemcpoiaec",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaec",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm asdl;jc,apoiseucoaiepcoaijepoicajmpsoiejcpmaoie poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                             "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaec",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m",
                                                  "asdkjcmpaoisemcpoiaecasdj maosidjm poaisjdm oiasjdm poiasjdmp oiasjdmp oijasmpodij mpaosidj m"
                            ])
    }
}

extension ScrollViewCompare: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPositionX = scrollView.contentOffset.x
        
        noMovableHeaderView.frame = .init(x: currentPositionX,
                                          y: noMovableHeaderView.frame.minY,
                                          width: noMovableHeaderView.bounds.width,
                                          height: noMovableHeaderView.bounds.height)
    }
//        print(scrollView.contentOffset.x)
//        for header in headers {
//            header.frame = CGRect(x: currentPositionX,
//                                  y: header.frame.minY,
//                                  width: header.bounds.width,
//                                  height: header.bounds.height)
//        }
//    }
}
//
//
//    for i in (0...10) {
//
//        let header = UIView(frame: .init(x: 0, y: CGFloat(i * 40 + 20), width: 200, height: 15))
//        header.backgroundColor = .green
//
//        let paramView = UIView(frame: .init(x: 0, y: CGFloat(i * 40), width: 10000, height: 20))
//
//        for x in (0...20) {
//            let widthMultyplayer = CGFloat(x) * view.bounds.width / 2 - 20
//            let label = UILabel(frame: .init(x: widthMultyplayer,
//                                y: 0, width: view.bounds.width / 2 - 20,
//                                height: 16))
//            label.backgroundColor = .red
//            paramView.addSubview(label)
//        }
//        paramView.backgroundColor = .blue
//        scrollView.addSubview(header)
//        scrollView.addSubview(paramView)
//
//        headers.append(header)
//    }
//
//    scrollView.delegate = self
//}

struct Advert {
    let parameters: [String]
    
    init(_ parameters: [String?]) {
        self.parameters = parameters.map { $0 ?? " - "}
    }
}
