//
//  ScrollViewCompare.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

final class ScrollViewCompare: UIViewController {
    
    var headers: [UIView] = []
    
    var noMovableHeaderView = UIView()
    
    let scrollView: UIScrollView = .init()
    var params: [String] = []
    
    let horisontalSpaing = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.frame = view.bounds
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.contentSize = .init(width: 10000, height: 7700)
        scrollView.backgroundColor = .white
        
        var adverts: [Advert] = []
        for _ in 1...100 {
            let advert = Advert(["asdkjcmpaoisemcpoiaec",
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
                                ])
            adverts.append(advert)
        }
        let headers = [
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl",
            "alsdjaslkdasdl"
        ]
        
        let containers = createAdvertViews(for: adverts,
                                      headers: headers,
                                      width: UIScreen.main.bounds.width / 2,
                                      headerHeight: 44,
                                      spaicing: 16)
        
        containers.views.forEach { scrollView.addSubview($0) }
        scrollView.delegate = self
        
        appendHeaders(headerTitles: headers, parameterHeights: containers.heightArr)
        scrollView.addSubview(noMovableHeaderView)
    }
    
    
    func createAdvertViews(for adverts: [Advert],
                           headers: [String],
                           width: CGFloat,
                           headerHeight: CGFloat,
                           spaicing: CGFloat) -> (views: [UIView], heightArr: [CGFloat]) {
        var heightArray = [CGFloat]()
        var yArray = [CGFloat]()
        var y: CGFloat = 0.0
        
        for (index, _) in headers.enumerated() {
            var height: CGFloat = 0.0
            let label = UILabel(frame: .init(origin: .zero, size: .init(width: width - spaicing, height: 0)))
            label.numberOfLines = 0
            y = y + headerHeight + spaicing
            yArray.append(y)
            adverts.forEach { advert in
                label.text = advert.parameters[index]
                label.sizeToFit()
                height = max(height, label.frame.height)
            }
            heightArray.append(height)
            y = y + spaicing + height
        }
        
        let views = adverts.enumerated().map { index, advert in
            let x = CGFloat(index) * width
            return createAdvertContainerView(advert: advert,
                                             x: x,
                                             width: width,
                                             spacing: spaicing,
                                             yArr: yArray)
        }
        
        return (views, heightArray)
    }
    
    func appendHeaders(headerTitles: [String], parameterHeights: [CGFloat]) {
        guard headerTitles.count == parameterHeights.count else { return }
        
        let headerSpaceHeight = CGFloat(parameterHeights.count) * (44 + 16 + 16)
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
                let blockHeight = 44 + 16 + parameterHeight + 16
                totalHeight += blockHeight
                y = totalHeight
                
                print("\(index) -  \(y)")
            }
            
            let label = UILabel(frame: .init(x: 16, y: y, width: view.bounds.width / 2, height: 44))
            label.backgroundColor = .blue
            label.text = headerTitle
            if index == headerTitles.count - 1 {
                label.backgroundColor = .red
            }
            noMovableHeaderView.addSubview(label)
        }
    }
    
    func createAdvertContainerView(advert: Advert,
                                   x: CGFloat,
                                   width: CGFloat,
                                   spacing: CGFloat,
                                   yArr: [CGFloat]) -> UIView {
        let containerView = UIView()
        var lastHeigt: CGFloat = 0.0
        advert.parameters.enumerated().forEach { (index, parameter) in
            let size = CGSize(width: width - spacing, height: 0)
            let label = UILabel(frame: .init(origin: .init(x: spacing, y: yArr[index]), size: size))
            label.text = parameter
            label.numberOfLines = 0
            label.sizeToFit()
            if index == advert.parameters.count - 1 {
                label.backgroundColor = .brown
            }
            containerView.addSubview(label)
            lastHeigt = label.frame.height
        }
        containerView.frame = CGRect(origin: .init(x: x, y: .zero),
                                     size: CGSize(width: width, height: yArr.last! + lastHeigt))
        
        return containerView
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
}

struct Advert {
    let parameters: [String]
    
    init(_ parameters: [String?]) {
        self.parameters = parameters.map { $0 ?? " - "}
    }
}
