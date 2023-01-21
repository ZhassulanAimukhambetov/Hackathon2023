//
//  ScrolleDirectionService.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

import Foundation

///  Сервис, который сообщает о смене направления скролла.
///  Требуется вызывать метод didScroll при скролле и подписаться на изменения didChangeDirection.
final class ScrollDirectionService {
    enum ScrollDirection: Equatable {
        /// Контент двигается вверх
        case up(offset: CGFloat)
        
        /// Контент двигается вниз
        case down(offset: CGFloat)
    }
    
    ///  didChangeDirection - вызывается только, когда было изменение направления и достигнут
    ///  предел minDownOffset для направления .down или maxUpOffset для направления .up.
    var didChangeDirection: ((ScrollDirection) -> Void)?
    
    private var currentOffset: CGFloat = .zero
    private var direction: ScrollDirection = .down(offset: .zero) {
        didSet {
            didChangeDirection(value: direction, oldValue: oldValue)
        }
    }
    
    private let minDownOffset: CGFloat
    private let maxUpOffset: CGFloat
    
    /// Создает сервис с минимальным и максимальными пределами.
    ///
    /// - Parameters:
    ///   - minDownOffset: минимальный предел для направления .down, при достижении которого
    ///   сработает didChangeDirection. Значение по умолчанию - максимальный предел CGFloat.
    ///   - maxUpOffset: максимальный предел для направления .up, при достижении которого
    ///   сработает didChangeDirection. Значение по умолчанию - минимальный предел CGFloat, то есть .zero.
    ///
    /// - Description: Если создать сервис с значениями по умолчанию, то didChangeDirection будет
    /// вызывать каждый раз при смене направления.
    init(minDownOffset: CGFloat = .greatestFiniteMagnitude, maxUpOffset: CGFloat = .zero) {
        self.minDownOffset = minDownOffset
        self.maxUpOffset = maxUpOffset
    }
    
    ///  Метод нужно вызывать в одноименном методе делгата UIScrollView.
    ///
    /// - Parameters:
    ///   - offset: текущее положение контента в UIScrollView.
    ///
    @inlinable
    func didScroll(to offset: CGFloat) {
        defer { currentOffset = offset }
        
        guard offset >= .zero else {
            return
        }
        
        if offset > max(currentOffset, maxUpOffset) {
            direction = .up(offset: offset)
        }

        if offset < min(currentOffset, minDownOffset) {
            direction = .down(offset: offset)
        }
    }
}

private extension ScrollDirectionService {
    private func didChangeDirection(value: ScrollDirection, oldValue: ScrollDirection) {
//        if case .up = value, case .up = oldValue {
//            return
//        }
//        
//        if case .down = value, case .down = oldValue {
//            return
//        }
        
        didChangeDirection?(value)
    }
}
