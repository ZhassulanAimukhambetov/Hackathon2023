//
//  ScrollViewCompare.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

final class ScrollViewCompare: UIViewController {
    private var noMovableHeaderView = UIView()
    private let scrollView = UIScrollView()
    private var advertParametersViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupParameters()
        setupContentSize()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .white
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self

    }
    
    private func setupParameters() {
        let headers = hedares()
        let adverts = adverts()
        let (views, parameterHeights) = ComparableViewBuilder
            .createAdvertViews(for: adverts,
                               headers: headers,
                               width: view.bounds.width / 2,
                               headerHeight: Constants.headerHeight,
                               spaicing: Constants.itemSpacing)
        views.forEach { scrollView.addSubview($0) }
        advertParametersViews = views
        setupParameterNames(with: headers, parameterHeights: parameterHeights)
    }
    
    private func setupParameterNames(with headers: [String], parameterHeights: [CGFloat]) {
        guard let view = ComparableViewBuilder.createNoMovableHeaderView(headerTitles: headers,
                                                                         parameterHeights: parameterHeights,
                                                                         width: view.bounds.width,
                                                                         spacing: Constants.itemSpacing,
                                                                         headerHeight: Constants.headerHeight)
        else { return }
        
        noMovableHeaderView = view
        scrollView.addSubview(view)
    }
    
    private func setupContentSize() {
        guard let height = advertParametersViews.first?.bounds.height else { return }
        
        let width = CGFloat(advertParametersViews.count) * view.bounds.width / 2
        scrollView.contentSize = CGSize(width: width, height: height)
    }
}

extension ScrollViewCompare: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPositionX = scrollView.contentOffset.x
        noMovableHeaderView.frame = .init(origin: .init(x: currentPositionX, y: noMovableHeaderView.frame.minY),
                                          size: noMovableHeaderView.bounds.size)
    }
}

extension ScrollViewCompare {
    enum Constants {
        static let itemSpacing: CGFloat = 16.0
        static let headerHeight: CGFloat = 44.0
    }
}


protocol ComparableAdvert {
    var parameters: [String] { get }
}


final class Advert: ComparableAdvert {
    let parameters: [String]
    
    init(_ parameters: [String?]) {
        self.parameters = parameters.map { $0 ?? " - "}
    }
}
