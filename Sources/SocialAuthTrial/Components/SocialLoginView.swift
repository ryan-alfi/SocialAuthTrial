//
//  SocialLoginView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 16/10/23.
//

import UIKit

protocol SocialLoginDelegate: AnyObject {
    func didSelectAppleId()
    func didSelectGoogle()
    func didSelectFacebook()
}

final class SocialLoginView: UIView {
    
    private let lineView = UIView().then {
        $0.backgroundColor = .grey500
    }
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.backgroundColor = .black
        $0.textColor = .white
        $0.text = "    or continue with    "
    }
    private let stackView = UIStackView().then {
        $0.spacing = 60
        $0.alignment = .center
        $0.distribution = .equalCentering
        $0.axis = .horizontal
    }
    
    private(set) lazy var appleIdButton = UIButton().then {
        $0.setImage(.icAppleId, for: .normal)
        $0.addTarget(self, action: #selector(tapAppleId), for: .touchUpInside)
    }
    
    private let appleIdLabel = UILabel().then {
        $0.text = "APPLE ID"
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .grey300
    }
    
    private(set) lazy var googleButton = UIButton().then {
        $0.setImage(.icGoogle, for: .normal)
        $0.addTarget(self, action: #selector(tapGoogle), for: .touchUpInside)
    }
    
    private let googleLabel = UILabel().then {
        $0.text = "GOOGLE"
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .grey300
    }
    
    private(set) lazy var facebookButton = UIButton().then {
        $0.setImage(.icFacebook, for: .normal)
        $0.addTarget(self, action: #selector(tapFacebook), for: .touchUpInside)
    }
    
    private let facebookLabel = UILabel().then {
        $0.text = "FACEBOOK"
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .grey300
    }
    
    weak var delegate: SocialLoginDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(lineView, titleLabel, stackView)
        stackView.addArrangedSubviews(appleIdButton, googleButton, facebookButton)
        lineView.makeConstraints(top: self.topAnchor, height: 1)
        lineView.makeConstraints(leading: self.leadingAnchor, trailing: self.trailingAnchor, inset: 30)
        titleLabel.makeConstraints(centerX: lineView.centerXAnchor, centerY: lineView.centerYAnchor)
        stackView.makeConstraints(top: titleLabel.bottomAnchor, bottom: self.bottomAnchor, inset: 16)
        stackView.makeConstraints(centerX: self.centerXAnchor, height: 50)
        
        appleIdButton.addSubview(appleIdLabel)
        appleIdLabel.makeConstraints(top: appleIdButton.bottomAnchor, inset: 8)
        appleIdLabel.makeConstraints(centerX: appleIdButton.centerXAnchor)
        
        googleButton.addSubview(googleLabel)
        googleLabel.makeConstraints(top: googleButton.bottomAnchor, inset: 8)
        googleLabel.makeConstraints(centerX: googleButton.centerXAnchor)
        
        facebookButton.addSubview(facebookLabel)
        facebookLabel.makeConstraints(top: facebookButton.bottomAnchor, inset: 8)
        facebookLabel.makeConstraints(centerX: facebookButton.centerXAnchor)
    }
    
    @objc private func tapAppleId() {
        delegate?.didSelectAppleId()
    }
    
    @objc private func tapGoogle() {
        delegate?.didSelectGoogle()
    }
    
    @objc private func tapFacebook() {
        delegate?.didSelectFacebook()
    }
    
}
