//
//  CountryCodeListView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

protocol CountryCodeListDelegate: AnyObject {
    func didSelectItem(country: CountryModel)
}

final class CountryCodeListView: PresentedDialogView {
    
    weak var delegate: CountryCodeListDelegate?
    
    private let leftView = UIView()
    private(set) lazy var countryCodeTextField = TextField().then {
        $0.delegate = self
        $0.titleFont = .systemFont(ofSize: 15, weight: .heavy)
        $0.leftView = leftView
        $0.placeholder = "Enter country name or country code"
        $0.title = "Country Code"
    }
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(CountryCodeItemCell.self, forCellReuseIdentifier: "CountryCodeItemCell")
        $0.backgroundColor = .black500
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.bounces = false
        $0.tableFooterView = UIView()
    }
    private let notFoundLabel = UILabel().then {
        $0.textAlignment = .center
        $0.isHidden = true
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .grey300
        $0.text = "No country code found."
    }
    
    var countries: [CountryModel] = [] {
        didSet {
            filteredCountries = countries
            reloadTableView()
        }
    }
    private var keyword: String = "" {
        didSet {
            filteredCountries = countries.search(keyword: keyword)
            reloadTableView()
        }
    }
    private var filteredCountries: [CountryModel] = []
    
    // MARK: - Initialized
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func shouldDismissDialogView() -> Bool {
        return tableView.contentOffset.y == 0
    }
    
    private func configureUI() {
        addSubviews(countryCodeTextField, tableView, notFoundLabel)
        countryCodeTextField.makeConstraints(top: closeButton.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, inset: 24)
        tableView.makeConstraints(top: countryCodeTextField.bottomAnchor, inset: 16)
        tableView.makeConstraints(bottom: self.safeAreaBottom, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        tableView.makeConstraints(height: 0)
        notFoundLabel.makeConstraints(centerX: self.centerXAnchor)
        notFoundLabel.makeConstraints(top: tableView.topAnchor, inset: 24)
        
        let imageView = UIImageView(image: .icSearch)
        leftView.addSubview(imageView)
        imageView.makeConstraints(leading: leftView.leadingAnchor, inset: 8)
        imageView.makeConstraints(
            top: leftView.topAnchor,
            bottom: leftView.bottomAnchor,
            trailing: leftView.trailingAnchor,
            width: 24,
            height: 24)
    }
    
    private func reloadTableView() {
        notFoundLabel.isHidden = !filteredCountries.isEmpty
        tableView.isHidden = !notFoundLabel.isHidden
        tableView.reloadData {
            self.tableView.constraint(.height)?.constant = self.notFoundLabel.isHidden ? self.tableView.getEstimationRowHeight() : 60
        }
    }
    
}

extension CountryCodeListView: TextFieldDelegate {
    
    func editingChanged(_ textField: TextField) {
        keyword = textField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyword = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CountryCodeListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onTapCloseButton?()
        delegate?.didSelectItem(country: countries[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeItemCell") as? CountryCodeItemCell else {
            return UITableViewCell()
        }

        cell.cellModel = filteredCountries[indexPath.row]
        return cell
    }
    
}
