//
//  ComparableContainerViewController.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

final class ComparableContainerViewController: UIViewController {
    private let items: [ComparableAdvert]
    private let headers: [String]
    private let scrollView = UIScrollView()
    private var noMovableHeaderView = UIView()
    private var advertParametersViews: [UIView] = []
    private var headerViews: [UIView] = []
    private var leftPinedView = UIView()
    private var leftSeparator = UIView()

    private var rightSeparator = UIView()
    private var rightPinedView = UIView()

    private var pinnedView = UIView()

    private let directionService = ScrollDirectionService()
    
    init(items: [ComparableAdvert], headers: [String]) {
        self.items = items
        self.headers = headers
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaders()
        setupScrollView()
        setupParameters()
        setupDirectionService()
        
        setPinnedView(for: 2)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .white
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
    }
    
    private func setupHeaders() {
        headerViews = items.enumerated().map { index, item in
            let width = view.bounds.width / 2
            let x = CGFloat(index) * width
            let headerView = ComparableAdvertHeaderView(frame: .init(origin: .init(x: x, y: 0),
                                                                     size: CGSize(width: width, height: 200)))
            
            headerView.configure(with: item)
            scrollView.addSubview(headerView)
            
            return headerView
        }
    }
    
    private func setupParameters() {
        let (views, parameterHeights) = ComparableViewBuilder
            .createAdvertViews(for: items,
                               headers: headers,
                               width: view.bounds.width / 2,
                               headerHeight: 200,
                               parameterNameHeight: Constants.headerHeight,
                               spaicing: Constants.itemSpacing)
        views.forEach { scrollView.addSubview($0) }
        advertParametersViews = views
        setupContentSize()
        setupParameterNames(with: headers, parameterHeights: parameterHeights)
    }
    
    private func setupParameterNames(with headers: [String], parameterHeights: [CGFloat]) {
        guard let view = ComparableViewBuilder.createNoMovableHeaderView(headerTitles: headers,
                                                                         parameterHeights: parameterHeights,
                                                                         width: view.bounds.width,
                                                                         spacing: Constants.itemSpacing,    headerHeight:  200,
                                                                         parameterNameHeight: Constants.headerHeight)
        else { return }
        
        noMovableHeaderView = view
        scrollView.addSubview(view)
    }
    
    private func setupContentSize() {
        guard let parameterView = advertParametersViews.first else { return }
        
        let width = CGFloat(advertParametersViews.count) * view.bounds.width / 2
        let size = parameterView.frame.size
        
        leftPinedView.frame = CGRect(origin: .zero, size: size)
        rightPinedView.frame = CGRect(origin: .init(x: view.bounds.width - size.width, y: .zero),
                                      size: size)
        
        leftPinedView.alpha = 0
        rightPinedView.alpha = 0
        leftPinedView.backgroundColor = .white
        rightPinedView.backgroundColor = .white
        
        leftSeparator.frame = CGRect(origin: CGPoint(x: size.width, y: 0),
                                     size: CGSize(width: 1, height: size.height))
        leftSeparator.backgroundColor = .lightGray
        leftSeparator.alpha = 0
        
        rightSeparator.frame = CGRect(origin: CGPoint(x: 1, y: 0),
                                      size: CGSize(width: 1, height: size.height))
        rightSeparator.backgroundColor = .lightGray
        rightSeparator.alpha = 0

        
        scrollView.contentSize = CGSize(width: width, height: parameterView.bounds.height)
        scrollView.addSubview(leftPinedView)
        scrollView.addSubview(rightPinedView)
        scrollView.addSubview(leftSeparator)
        scrollView.addSubview(rightSeparator)
    }
    
    private func setPinnedView(for index: Int) {
        pinnedView = advertParametersViews[index]
        
        guard let leftContainer = try? pinnedView.copyObject(),
              let rightContainer = try? pinnedView.copyObject(),
              let leftHeader = try? headerViews[index].copyObject(),
              let rightHeader = try? headerViews[index].copyObject()
        else { return }
    
        leftPinedView.removeAllSubviews()
        rightPinedView.removeAllSubviews()
        
        leftContainer.frame = leftPinedView.bounds
        leftPinedView.addSubview(leftContainer)
        
        leftHeader.frame = .init(origin: .zero, size: leftHeader.bounds.size)
        leftPinedView.addSubview(leftHeader)

        rightContainer.frame = rightPinedView.bounds
        rightPinedView.addSubview(rightContainer)
        
        rightHeader.frame = .init(origin: .zero, size: rightHeader.bounds.size)
        rightPinedView.addSubview(rightHeader)
    }
    
    private func setupDirectionService() {
        directionService.didChangeDirection = { [unowned self] direction in
            switch direction {
            case .up(let offset):
                if offset > pinnedView.frame.minX {
                    leftPinedView.alpha = 1
                    leftSeparator.alpha = 1
                }
                
                if offset + view.bounds.width > pinnedView.frame.maxX {
                    rightPinedView.alpha = 0
                    rightSeparator.alpha = 0
                }
                
            case .down(let offset):
                if offset < pinnedView.frame.minX {
                    leftPinedView.alpha = 0
                    leftSeparator.alpha = 0
                }
                
                if offset + view.bounds.width < pinnedView.frame.maxX {
                    rightPinedView.alpha = 1
                    rightSeparator.alpha = 1
                }
            }
        }
    }
}

extension ComparableContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPositionX = scrollView.contentOffset.x
        let currentPositionY = scrollView.contentOffset.y
        directionService.didScroll(to: currentPositionX)
        noMovableHeaderView.frame = .init(origin: .init(x: currentPositionX, y: noMovableHeaderView.frame.minY),
                                          size: noMovableHeaderView.bounds.size)
        leftPinedView.frame = .init(origin: .init(x: currentPositionX, y: leftPinedView.frame.minY),
                                    size: leftPinedView.bounds.size)
        
        rightPinedView.frame = .init(origin: .init(x: currentPositionX + view.bounds.width - rightPinedView.bounds.size.width, y: rightPinedView.frame.minY),
                                    size: rightPinedView.bounds.size)
        
        leftSeparator.frame = .init(origin: .init(x: currentPositionX + leftPinedView.bounds.width, y: leftSeparator.frame.minY),
                                    size: leftSeparator.bounds.size)
        rightSeparator.frame = .init(origin: .init(x: currentPositionX + view.bounds.width - rightPinedView.bounds.size.width - 1, y: rightSeparator.frame.minY),
                                    size: rightSeparator.bounds.size)
    }
}

extension ComparableContainerViewController {
    enum Constants {
        static let itemSpacing: CGFloat = 16.0
        static let headerHeight: CGFloat = 22.0
    }
}


extension UIView {
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension UIView {
    func copyObject<T: UIView>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
