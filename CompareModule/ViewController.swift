//
//  ViewController.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 20.01.2023.
//

import UIKit

enum Section: Int, CaseIterable {
    case first
    case second
    case third
    case fourth
    
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
              }
          }
}

final class ViewController: UIViewController {
    
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
        
            section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.orthogonalScrollingBehavior = .continuous
            
            section.visibleItemsInvalidationHandler = {  [weak self] visibleItems, point, environment in
                
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
