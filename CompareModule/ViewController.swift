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
    case first1
    case second1
    case third1
    case fourth1
    case fivth1
    case sixth1
    case seven1
    case eight1
    case nine1
    
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
              case .first1:
                  return 5
              case .second1:
                  return 7
              case .third1:
                  return 9
              case .fourth1:
                  return 11
              case .fivth1:
                  return 10
              case .sixth1:
                  return 10
              case .seven1:
                  return 10
              case .eight1:
                  return 10
              case .nine1:
                  return 10
              }
          }
}

final class ViewController: UIViewController {
    
    var lasYContentOffset: CGFloat = 0
    
    private var scrollViewsForIndex: [Int: UIScrollView] = [:]
    private var scrollViewsIndexForYOffset: [CGFloat: Int] = [:]
    
    var xContentOffset: CGFloat = 0
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
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
            guard let sv else { return }
            
            scrollViewsIndexForYOffset[sv.bounds.minY] = i
            scrollViewsForIndex[i] = sv
        }
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView,
                                                                      cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
            
            
//            cell.contentView.backgroundColor = indexPath.section == 0 ? .red : indexPath.section == 1 ? UIColor.green: UIColor.yellow
            
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
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }


    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout2 = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionInfo = Section(rawValue: sectionIndex) else { return nil }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            // this activates the "sticky" behavior
//            headerElement.pinToVisibleBounds = true
            let group = createGroup(item: createItem(), count: 1)
            group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            let section = createSection(group: group)
        
            section.boundarySupplementaryItems = [headerElement]
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            section.visibleItemsInvalidationHandler = {  [weak self] visibleItems, point, environment in
//                guard lasYContentOffset == point.y else { return }
                
                lasYContentOffset = point.y
                let comLayout = self!.collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout
                
                
                guard let iPath = visibleItems.first?.indexPath.section else { return }
                                
                // Проверяем что бы секция 1 не двигала сама себя
                if iPath == 1 || iPath == 2 || iPath == 3 || iPath == 4 || iPath == 5 {
                    return
                }
                

                for i in (0..<scrollViewsForIndex.keys.count) {
                    if i == 0 { continue }
                    
                    let yPosition: CGFloat = scrollViewsForIndex[i]?.bounds.minY ?? 0
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
                                               heightDimension: .absolute(24))
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
    }
    
    private func createItem() -> NSCollectionLayoutItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(24))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        return item
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
          return header
      }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


class TestCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: .init(x: 0, y: 0, width: 200, height: 30))
        label.text = "Label 21312"
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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

final class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    let sectionHeaderlabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        sectionHeaderlabel.text = "Parameters"
        addSubview(sectionHeaderlabel)
        sectionHeaderlabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//if visibleItems.first(where: {
////                    collectionView.cellForItem(at: $0.indexPath)?.frame.origin == point
////                }) != nil {
////                    return
////                }
//
//
//              guard let iPath = visibleItems.first?.indexPath.section else { return }
//
//              // Проверяем что бы секция 1 не двигала сама себя
//              if iPath == 1 || iPath == 2 || iPath == 3 || iPath == 4 || iPath == 5 {
//                  return
//              }
//              let indexForCancel = scrollViewsIndexForYOffset[point.y] ?? 0
//
//              for i in (0..<scrollViewsForIndex.keys.count) {
//
////                    let s = Array(scrollViewsForIndex.keys)
//
////                    if i == indexForCancel {
////                        continue
////                    }
////                    if i == 0 { continue }
//
//
//                  DispatchQueue.main.async {
//                      let y = scrollViewsForIndex[i]?.bounds.minY ?? 0
//                      self!.scrollViewsForIndex[i]?.setContentOffset(.init(x: point.x, y: y), animated: false)
//                  }
//              }
