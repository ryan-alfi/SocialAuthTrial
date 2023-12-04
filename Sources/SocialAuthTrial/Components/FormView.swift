//
//  FormView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

class FormStackView: UIStackView {
    
    let lineView = UIView().then {
        $0.backgroundColor = .black300
    }
    let selectedLineView = UIView().then {
        $0.backgroundColor = .primary100
    }
    let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    private(set) lazy var leftButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.setTitleColor(.primary100, for: .selected)
        $0.setTitleColor(.grey300, for: .normal)
        $0.setTitle("Phone Number", for: .normal)
    }
    private(set) lazy var rightButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.setTitleColor(.primary100, for: .selected)
        $0.setTitleColor(.grey300, for: .normal)
        $0.setTitle("Email", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        spacing = 32
        backgroundColor = .black500
        layer.cornerRadius = 8
        layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
        isLayoutMarginsRelativeArrangement = true
        addArrangedSubviews(stackView)
        stackView.makeConstraints(height: 40)
        stackView.addArrangedSubviews(leftButton, rightButton)
        stackView.addSubview(lineView)
        lineView.makeConstraints(bottom: stackView.bottomAnchor, height: 2)
        lineView.makeConstraints(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor, inset: -16)
        updateSelectedLineView(to: leftButton)
    }
    
    private func updateSelectedLineView(to button: UIButton) {
        selectedLineView.removeFromSuperview()
        selectedLineView.removeConstraints(selectedLineView.constraints)
        
        button.isSelected = true
        button.addSubview(selectedLineView)
        selectedLineView.makeConstraints(bottom: button.bottomAnchor, height: 3)
        selectedLineView.layer.cornerRadius = 6
        selectedLineView.makeConstraints(leading: button.leadingAnchor, trailing: button.trailingAnchor, inset: 16)
    }
    
    func hideHeaderView() {
        stackView.isHidden = true
    }
    
    @objc func tapLeftButton() {
        rightButton.isSelected = false
        updateSelectedLineView(to: leftButton)
    }
    
    @objc func tapRightButton() {
        leftButton.isSelected = false
        updateSelectedLineView(to: rightButton)
    }
    
}
