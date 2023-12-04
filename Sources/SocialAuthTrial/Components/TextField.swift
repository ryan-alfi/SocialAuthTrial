//
//  TextField.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

@objc protocol TextFieldDelegate: UITextFieldDelegate {
    @objc optional func editingChanged(_ textField: TextField)
    @objc optional func didSelectErrorButton(_ textField: TextField)
}

final class TextField: UIView {
    
    enum TextFieldState {
        case enabled
        case disabled
        case error(message: String, messageColor: UIColor = .errorRed, buttonMessage: String? = nil)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private(set) lazy var textField = UITextField().then {
        $0.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        $0.font = .systemFont(ofSize: 12)
        $0.backgroundColor = .black300
        $0.borderStyle = .roundedRect
        $0.layer.cornerRadius = 8
        $0.textColor = .white
    }
    lazy var secureTextButton = UIButton().then {
        $0.setTitle("  ", for: .normal)
        $0.setImage(.icVisibilityOn, for: .normal)
        $0.addTarget(self, action: #selector(tapSecureTextButton), for: .touchUpInside)
    }
    private let errorStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let errorLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .errorRed
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    private(set) lazy var errorButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapErrorButton), for: .touchUpInside)
        $0.isHidden = true
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .heavy)
        $0.setTitleColor(.primary100, for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.titleLabel?.textAlignment = .right
    }
    
    weak var delegate: TextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
    var text: String {
        get { textField.text ?? "" }
        set {
            textField.text = newValue
            textFieldEditingChanged()
        }
    }
    
    var isEmpty: Bool {
        return text.isEmpty
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [.foregroundColor: UIColor.grey300, .font: UIFont.systemFont(ofSize: 12)])
        }
    }
    
    var rightView: UIView? {
        didSet {
            textField.rightView = rightView
            textField.rightViewMode = .always
        }
    }
    
    var leftView: UIView? {
        didSet {
            textField.leftView = nil
            textField.leftView = leftView
            textField.leftViewMode = .always
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var isSecureTextEntry: Bool = false {
        didSet {
            let image: UIImage? = isSecureTextEntry ? .icVisibilityOff : .icVisibilityOn
            secureTextButton.setImage(image, for: .normal)
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateState(_ state: TextFieldState) {
        switch state {
        case .enabled:
            hideError()
            removeBorderLayer()
            self.enable(true)
        case .disabled:
            hideError()
            removeBorderLayer()
            self.enable(false)
        case let .error(message, messageColor, buttonMessage):
            self.enable(true)
            errorLabel.isHidden = false
            errorLabel.text = message
            errorLabel.textColor = messageColor
            errorButton.setTitle(buttonMessage, for: .normal)
            errorButton.isHidden = buttonMessage == nil
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        }
    }
    
    func removeBorderLayer() {
        textField.layer.borderColor = nil
        textField.layer.borderWidth = 0
    }
    
    func hideError() {
        errorButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func configureUI() {
        addSubviews(titleLabel, textField, errorStackView)
        titleLabel.makeConstraints(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        textField.makeConstraints(top: titleLabel.bottomAnchor, inset: 8)
        textField.makeConstraints(leading: self.leadingAnchor, trailing: self.trailingAnchor, height: 40)
        errorStackView.makeConstraints(top: textField.bottomAnchor, inset: 4)
        errorStackView.makeConstraints(bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        errorStackView.addArrangedSubviews(errorLabel, errorButton)
    }
    
    @objc private func tapErrorButton() {
        delegate?.didSelectErrorButton?(self)
    }
    
    @objc private func tapSecureTextButton() {
        isSecureTextEntry = !isSecureTextEntry
    }
    
    @objc func textFieldEditingChanged() {
        delegate?.editingChanged?(self)
    }
    
}

extension TextField {
    
    func initEmailField() {
        textField.keyboardType = .emailAddress
        title = "Enter Email"
        placeholder = "Email (ex:mail@gmail.com)"
    }
    
    func initPhoneField(leftView: PhoneTextFieldLeftView) {
        self.leftView = leftView
        textField.keyboardType = .numberPad
        title = "Enter Phone Number"
        placeholder = "Phone number (ex:083123xxx)"
    }
    
    func initPasswordField() {
        rightView = secureTextButton
        title = "Enter Password"
        placeholder = "Password"
        isSecureTextEntry = true
    }
    
}
