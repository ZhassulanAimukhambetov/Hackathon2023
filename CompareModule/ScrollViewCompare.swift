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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.frame = view.bounds
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.contentSize = .init(width: 10000, height: 7700)
        scrollView.backgroundColor = .white
        
        
        for i in (0...10) {
            
            let header = UIView(frame: .init(x: 0, y: CGFloat(i * 40 + 20), width: 200, height: 15))
            header.backgroundColor = .green
            
            let paramView = UIView(frame: .init(x: 0, y: CGFloat(i * 40), width: 10000, height: 20))
            
            for x in (0...20) {
                let label = UILabel(frame: .init(x: CGFloat(x * 100), y: 0, width: 50, height: 16))
                label.backgroundColor = .red
                paramView.addSubview(label)
            }
            paramView.backgroundColor = .blue
            scrollView.addSubview(header)
            scrollView.addSubview(paramView)
            
            headers.append(header)
        }
        
        scrollView.delegate = self
    }
}

extension ScrollViewCompare: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPositionX = scrollView.contentOffset.x
        print(scrollView.contentOffset.x)
        for header in headers {
            header.frame = CGRect(x: currentPositionX,
                                  y: header.frame.minY,
                                  width: header.bounds.width,
                                  height: header.bounds.height)
        }
    }
}
