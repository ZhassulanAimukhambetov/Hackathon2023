//
//  ComparableAdvertHeaderView.swift
//  CompareModule
//
//  Created by Zhassulan Aimukhambetov on 21.01.2023.
//

import UIKit

final class ComparableAdvertHeaderView: UIView {
    enum Action {
        case call
        case lock(needLock: Bool)
        case remove
    }
    
    var handler: ((Action) -> Void)?
    
    private let photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .yellow
        return $0
    }(UIImageView(frame: .zero))
    
    private let priceLabel: UILabel = {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
        $0.backgroundColor = .red
        return $0
    }(UILabel())
    private let nameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
        $0.backgroundColor = .blue
        return $0
    }(UILabel())
    private let callButton: UIButton = {
        $0.layer.cornerRadius = 5
        $0.setTitle("Позвонить", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = .brown
        return $0
    }(UIButton())
    private let lockButton: UIButton = {
        $0.setImage(UIImage(systemName: "lock.open")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "lock.fill")?.withRenderingMode(.alwaysOriginal), for: .selected)
        $0.backgroundColor = .white.withAlphaComponent(0.8)
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        layer.cornerRadius = 8
        backgroundColor = .green
        setupSubviews()
        setupSubviewsSize()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with model: ComparableAdvert) {
        nameLabel.text = model.name
        priceLabel.text = model.price
    }
    
    private func setupAction() {
        callButton.addTarget(self, action: #selector(didTapCallButton), for: .touchUpInside)
        lockButton.addTarget(self, action: #selector(didTapLockButton), for: .touchUpInside)
    }
    
    @objc private func didTapCallButton() {
        handler?(.call)
    }
    
    @objc private func didTapLockButton() {
        lockButton.isSelected = !lockButton.isSelected
        let needLock = lockButton.isSelected
        handler?(.lock(needLock: needLock))
    }
        
    private func setupSubviews() {
        addSubview(photoImageView)
        addSubview(lockButton)
        addSubview(priceLabel)
        addSubview(nameLabel)
        addSubview(callButton)
    }
    
    private func setupSubviewsSize() {
        photoImageView.frame = .init(x: 5,
                                     y: 5,
                                     width: bounds.size.width - 10,
                                     height: bounds.height * 0.6)
        lockButton.frame = .init(x: photoImageView.frame.origin.x,
                                 y: photoImageView.frame.origin.y,
                                 width: 30,
                                 height: 30)
        lockButton.layer.cornerRadius = lockButton.bounds.width / 2
        priceLabel.frame = .init(x: photoImageView.frame.origin.x,
                                 y: photoImageView.frame.maxY + 3,
                                 width: photoImageView.bounds.width,
                                 height: 15)
        nameLabel.frame = .init(origin: .init(x: priceLabel.frame.origin.x,
                                              y: priceLabel.frame.maxY + 3),
                                size: priceLabel.bounds.size)
        callButton.frame = .init(x: nameLabel.frame.origin.x,
                                 y: nameLabel.frame.maxY + 5,
                                 width: priceLabel.bounds.width,
                                 height: 25)
    }
}
