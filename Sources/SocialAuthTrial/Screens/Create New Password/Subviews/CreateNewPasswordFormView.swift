//
//  CreateNewPasswordFormView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 18/10/23.
//

import UIKit

final class CreateNewPasswordFormView: FormStackView {
    
    let passwordTextField = TextField().then {
        $0.initPasswordField()
    }
    private let passwordDescLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .grey400
        $0.font = .systemFont(ofSize: 12)
        $0.text = "Your password must be at least 8 characters with a mix of uppercase-lowercase letters and numbers"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
        hideHeaderView()
        addArrangedSubviews(passwordTextField, passwordDescLabel)
        setCustomSpacing(8, after: passwordTextField)
    }
    
}
