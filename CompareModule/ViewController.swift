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
    case seven
    case eight
    case nine
    
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
              case .seven:
                  return 10
              case .eight:
                  return 10
              case .nine:
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in (0..<collectionView.numberOfSections) {
            let sv = collectionView.getScrollViewFromCompositionLayout(section: i)
            print("\(i)  - \(sv)")
            scrollViewsForIndex[i] = collectionView.getScrollViewFromCompositionLayout(section: i)
        }
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
                                
                // Проверяем что бы секция 1 не двигала сама себя
                if iPath == 1 || iPath == 2 || iPath == 3 || iPath == 4 || iPath == 5 {
                    return
                }
                

                for i in (0..<scrollViewsForIndex.keys.count) {
                    if i == 0 { continue }
                    
                    let yPosition: CGFloat = CGFloat(i) * 140.0 + 20
                    scrollViewsForIndex[i]?.setContentOffset(.init(x: point.x, y: yPosition), animated: false)
                }
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
