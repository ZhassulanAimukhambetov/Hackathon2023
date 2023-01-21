//
//  ComparableViewBuilder.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

import UIKit

enum ComparableViewBuilder {
    static func createAdvertViews(for adverts: [ComparableAdvert],
                                  headers: [String],
                                  width: CGFloat,
                                  headerHeight: CGFloat,
                                  parameterNameHeight: CGFloat,
                                  spaicing: CGFloat) -> (views: [UIView], parameterHeights: [CGFloat]) {
        let allParameters: [[String]] = adverts.map { $0.advertParameters(for: headers) }
        var heightArray = [CGFloat]()
        var yArray = [CGFloat]()
        var y: CGFloat = 0.0
        for (index, _) in headers.enumerated() {
            var height: CGFloat = 0.0
            let label = UILabel(frame: .init(origin: .zero, size: .init(width: width - spaicing, height: 0)))
            label.numberOfLines = 0
            y = y + parameterNameHeight + spaicing
            yArray.append(y)
            adverts.enumerated().forEach { advertIndex, _ in
                label.text = nil
                label.sizeToFit()
                label.text = allParameters[advertIndex][index]
                label.sizeToFit()
                height = max(height, label.frame.height)
            }
            heightArray.append(height)
            y = y + spaicing + height
        }
        
        let views = adverts.enumerated().map { index, advert in
            let x = CGFloat(index) * width
            return  createAdvertContainerView(advertParameters: allParameters[index],
                                              x: x,
                                              headerHeight: headerHeight,
                                              width: width,
                                              spacing: spaicing,
                                              yArr: yArray)
        }
        
        return (views, heightArray)
    }
    
    static func createNoMovableHeaderView(headerTitles: [String],
                                          parameterHeights: [CGFloat],
                                          width: CGFloat,
                                          spacing: CGFloat,
                                          headerHeight: CGFloat,
                                          parameterNameHeight: CGFloat) -> UIView? {
        guard headerTitles.count == parameterHeights.count else { return nil }
        let noMovableHeaderView = UIView()
        let headerSpaceHeight = CGFloat(parameterHeights.count) * (parameterNameHeight + spacing + spacing)
        let allParameterHeights = parameterHeights.reduce(0) { partialResult, parameterHeight in
            return partialResult + parameterHeight
        }
        
        noMovableHeaderView.frame = .init(origin: .init(x: .zero, y: headerHeight),
                                          size: .init(width: width, height: allParameterHeights + headerSpaceHeight))
        
        var totalHeight: CGFloat = 0
        
        for (index, headerTitle) in headerTitles.enumerated() {
            let y: CGFloat
            
            if index == 0 {
                y = 0
            } else {
                let parameterHeight = parameterHeights[index - 1]
                let blockHeight = parameterNameHeight + spacing + parameterHeight + spacing
                totalHeight += blockHeight
                y = totalHeight
            }
            
            let label = UILabel(frame: .init(x: spacing, y: y, width: width / 2, height: parameterNameHeight))
            label.text = headerTitle
            label.font = .systemFont(ofSize: 12)
            label.textColor = .lightGray
            noMovableHeaderView.addSubview(label)
        }
        
        return noMovableHeaderView
    }
    
    private static func createAdvertContainerView(advertParameters: [String],
                                                  x: CGFloat,
                                                  headerHeight: CGFloat,
                                                  width: CGFloat,
                                                  spacing: CGFloat,
                                                  yArr: [CGFloat]) -> UIView {
        let containerView = UIView()
        var lastHeigt: CGFloat = 0.0
        advertParameters.enumerated().forEach { (index, parameter) in
            let size = CGSize(width: width - spacing, height: 0)
            let label = UILabel(frame: .init(origin: .init(x: spacing, y: yArr[index]), size: size))
            label.text = parameter
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 14)
            label.sizeToFit()
            containerView.addSubview(label)
            lastHeigt = label.frame.height
        }
        containerView.frame = CGRect(origin: .init(x: x, y: headerHeight),
                                     size: CGSize(width: width, height: yArr.last! + lastHeigt))
        
        return containerView
    }
}
