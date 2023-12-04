//
//  PhoneTextFieldLeftView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

final class PhoneTextFieldLeftView: UIButton {
    
    var onTapCountryButton: ((CountryModel) -> Void)?
    
    var selectedCountry: CountryModel = CountryModel(code: "+62", name: "Indonesia", flag: .icFlagId, isSelected: true) {
        didSet {
            updateCountry(country: selectedCountry)
        }
    }
    
    private(set) lazy var countryButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.setTitleColor(.grey300, for: .normal)
    }
    let arrowImageView = UIImageView(image: .icArrowDown)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        updateCountry(country: selectedCountry)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(countryButton, arrowImageView)
        countryButton.makeConstraints(
            top: self.topAnchor,
            bottom: self.bottomAnchor,
            height: 24)
        countryButton.makeConstraints(
            leading: self.leadingAnchor,
            inset: 8)
        arrowImageView.makeConstraints(
            leading: countryButton.trailingAnchor,
            trailing: self.trailingAnchor,
            centerY: countryButton.centerYAnchor,
            width: 24,
            height: 24)
        
        addTarget(self, action: #selector(tapCountry), for: .touchUpInside)
    }
    
    private func updateCountry(country: CountryModel) {
        countryButton.setImage(country.flag, for: .normal)
        countryButton.setTitle("  \(country.code)", for: .normal)
    }
    
    @objc func tapCountry() {
        onTapCountryButton?(selectedCountry)
    }
    
}
