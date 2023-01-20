//
//  ScrollViewCompare.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

final class ScrollViewCompare: UIViewController {
    
    var headers: [UIView] = []
    
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
        for header in headers {
            header.frame = CGRect(x: currentPositionX,
                                  y: header.frame.minY,
                                  width: header.bounds.width,
                                  height: header.bounds.height)
        }
    }
}

struct Advert {
    let parameters: [String]
    
    init(_ parameters: [String?]) {
        self.parameters = parameters.map { $0 ?? " - "}
    }
}
