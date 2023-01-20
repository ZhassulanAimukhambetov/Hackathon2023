//
//  ViewController.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case first
    case second
    case third
    case fourth
    case fivth
    case sixth
    
    var columnCount: Int {
              switch self {
              case .first:
                  return 5
              case .second:
                  return 7
              case .third:
                  return 9
              case .fourth:
                  return 11
              case .fivth:
                  return 10
              case .sixth:
                  return 10
              }
          }
}

final class ViewController: UIViewController {
    
    private var scrollViewsForIndex: [Int: UIScrollView] = [:]
    
    var xContentOffset: CGFloat = 0
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        createDataSource()
        
        view.backgroundColor = .white
        
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView,
                                                                      cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
            
            
            cell.contentView.backgroundColor = indexPath.section == 0 ? .red : indexPath.section == 1 ? UIColor.green: UIColor.yellow
            
            return cell
        })
        
        let itemsPerSection = 6
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        Section.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }


    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout2 = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionInfo = Section(rawValue: sectionIndex) else { return nil }

            let cellCount = sectionInfo.columnCount

            let group = createGroup(item: createItem(), count: 1)
            let section = createSection(group: group)
        
            section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            
            section.visibleItemsInvalidationHandler = {  [weak self] visibleItems, point, environment in
                let comLayout = self!.collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout
                
                
                guard let iPath = visibleItems.first?.indexPath.section else { return }
                
                let scrollView0 = self!.collectionView.getScrollViewFromCompositionLayout(section: 0)
                let scrollView1 = self!.collectionView.getScrollViewFromCompositionLayout(section: 1)
                let scrollView2 = self!.collectionView.getScrollViewFromCompositionLayout(section: 2)
                let scrollView3 = self!.collectionView.getScrollViewFromCompositionLayout(section: 3)
                let scrollView4 = self!.collectionView.getScrollViewFromCompositionLayout(section: 4)
                let scrollView5 = self!.collectionView.getScrollViewFromCompositionLayout(section: 5)
                
                if let scrollView0, let scrollView1, let scrollView2, let scrollView3 {
                    self!.scrollViewsForIndex[0] = scrollView0
                    self!.scrollViewsForIndex[1] = scrollView1
                    self!.scrollViewsForIndex[2] = scrollView2
                    self!.scrollViewsForIndex[3] = scrollView3
                    self!.scrollViewsForIndex[4] = scrollView4!
                    self!.scrollViewsForIndex[5] = scrollView5!
                    
                }
                print("0 ", self!.scrollViewsForIndex[0]?.contentOffset.x)
                print("1 ", self!.scrollViewsForIndex[1]?.contentOffset.x)
                print("2 ", self!.scrollViewsForIndex[2]?.contentOffset.x)
                print("3 ", self!.scrollViewsForIndex[3]?.contentOffset.x)
                
                // Проверяем что бы секция 1 не двигала сама себя
                if iPath == 1 || iPath == 2 || iPath == 3 || iPath == 4 || iPath == 5 {
                    return
                }
                
                
                print("second SV - \(scrollView1?.contentOffset)")
                DispatchQueue.main.async {
                    self!.xContentOffset = self!.xContentOffset + 1
                    self!.scrollViewsForIndex[1]?.setContentOffset(.init(x: point.x, y: 160.0), animated: false)
                    self!.scrollViewsForIndex[2]?.setContentOffset(.init(x: point.x, y: 300.0), animated: false)
                    self!.scrollViewsForIndex[3]?.setContentOffset(.init(x: point.x, y: 440.0), animated: false)
                    self!.scrollViewsForIndex[4]?.setContentOffset(.init(x: point.x, y: 580.0), animated: false)
                    self!.scrollViewsForIndex[5]?.setContentOffset(.init(x: point.x, y: 720.0), animated: false)
//                    scrollView?.contentOffset = .init(x: point.x, y: 160.0)//.init(x: point.x, y: scrollView!.contentOffset.y)
//                    scrollView?.setContentOffset(.init(x: point.x, y: scrollView!.contentOffset.y), animated: false)
                }
                print(point)
                
            }
            
            return section
        }
        
        return layout2
    }
    
    
    private func createSection(group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        NSCollectionLayoutSection(group: group)
    }
    
    private func createGroup(item: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
       
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
    }
    
    private func createItem() -> NSCollectionLayoutItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return item
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}


class TestCell: UICollectionViewCell {
}


extension UICollectionView {
    func getScrollViewFromCompositionLayout(section: Int) -> UIScrollView? {
        return subviews
            .compactMap { $0 as? UIScrollView }
            .first(where: { scrollView in
                guard let cell = scrollView.subviews.first as? UICollectionViewCell else {
                    return false
                }

                return indexPath(for: cell)?.section == section
            })
    }
}
