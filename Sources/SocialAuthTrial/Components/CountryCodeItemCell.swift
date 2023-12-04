//
//  CountryCodeItemCell.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

class CountryCodeItemCell: UITableViewCell {
    
    var cellModel: CountryModel? {
        didSet {
            updateUI()
        }
    }
    
    let flagImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .white
    }
    let countryCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .black500
        contentView.addSubviews(flagImageView, countryLabel, countryCodeLabel)
        flagImageView.makeConstraints(leading: contentView.leadingAnchor, inset: 24)
        flagImageView.makeConstraints(centerY: contentView.centerYAnchor, width: 24, height: 24)
        countryLabel.makeConstraints(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor,
            leading: flagImageView.trailingAnchor,
            trailing: countryCodeLabel.leadingAnchor,
            inset: 16)
        countryCodeLabel.makeConstraints(trailing: contentView.trailingAnchor, inset: 24)
        countryCodeLabel.makeConstraints(centerY: contentView.centerYAnchor)
    }
    
    private func updateUI() {
        guard let cellModel = cellModel else {
            return
        }
        flagImageView.image = cellModel.flag
        countryLabel.text = cellModel.name
        countryCodeLabel.text = cellModel.code
        backgroundColor = cellModel.isSelected ? .black400 : .black500
    }
    
}
