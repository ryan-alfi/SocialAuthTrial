//
//  LoginFormView.swift
//  Pods
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

protocol LoginFormDelegate: AnyObject {
    func didSelectForgotPassword()
    func didSelectCountry(country: CountryModel)
    func didCompleteForm(state: Bool)
}

final class LoginFormView: FormStackView {
    
    weak var delegate: LoginFormDelegate?
    
    private(set) lazy var phoneLeftView = PhoneTextFieldLeftView().then {
        $0.onTapCountryButton = { [weak self] country in
            self?.delegate?.didSelectCountry(country: country)
        }
    }
    private(set) lazy var emailTextField = TextField().then {
        $0.delegate = self
        $0.initEmailField()
    }
    private(set) lazy var phoneTextField = TextField().then {
        $0.delegate = self
        $0.initPhoneField(leftView: phoneLeftView)
    }
    private(set) lazy var passwordTextField = TextField().then {
        $0.delegate = self
        $0.updateState(.disabled)
        $0.initPasswordField()
    }
    
    private(set) lazy var forgotPasswordContainerView = UIView()
    private(set) lazy var forgotPasswordButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapForgotPassword), for: .touchUpInside)
        $0.setTitleColor(.grey300, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        $0.setTitle("Forgot Password?", for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.titleLabel?.textAlignment = .right
    }
    
    enum LoginFormType {
        case phone
        case email
    }
    
    var formType: LoginFormType = .phone {
        didSet {
            resetUI()
        }
    }
    
    var isPhoneValid: Bool = false {
        didSet {
            if isPhoneValid != oldValue {
                passwordTextField.updateState(isIdentityValid() ? .enabled : .disabled)
            }
        }
    }
    
    var isEmailValid: Bool = false {
        didSet {
            if isEmailValid != oldValue {
                passwordTextField.updateState(isIdentityValid() ? .enabled : .disabled)
            }
        }
    }
    
    var isPasswordValid: Bool = false {
        didSet {
            if isPasswordValid != oldValue {
                self.delegate?.didCompleteForm(state: !isPasswordValid)
            }
        }
    }
    
    func isIdentityValid() -> Bool {
        return isPhoneValid || isEmailValid
    }
    
    func isFormValid() -> Bool {
        return isIdentityValid() && isPasswordValid
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addArrangedSubviews(emailTextField, phoneTextField, passwordTextField, forgotPasswordContainerView)
        forgotPasswordContainerView.addSubview(forgotPasswordButton)
        forgotPasswordButton.makeConstraints(
            top: forgotPasswordContainerView.topAnchor,
            bottom: forgotPasswordContainerView.bottomAnchor,
            trailing: forgotPasswordContainerView.trailingAnchor,
            width: 150,
            height: 20)
        emailTextField.isHidden = true
    }
    
    override func tapLeftButton() {
        super.tapLeftButton()
        formType = .phone
    }
    
    override func tapRightButton() {
        super.tapRightButton()
        formType = .email
    }
    
    func resetUI() {
        phoneTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordTextField.updateState(.disabled)
        
        self.emailTextField.isHidden = formType == .phone
        self.phoneTextField.isHidden = formType == .email
    }
    
    func updateSelectedCountry(country: CountryModel) {
        phoneLeftView.selectedCountry = country
        phoneTextField.leftView = phoneLeftView
    }
    
    func validatePhone() {
        isPhoneValid = phoneTextField.text.isValidPhone()
        if isPhoneValid || phoneTextField.text.count < 5 {
            phoneTextField.updateState(.enabled)
        } else {
            phoneTextField.updateState(.error(message: "Phone number format incorrect."))
        }
    }
    
    func validateEmail() {
        isEmailValid = emailTextField.text.isValidEmail()
        if isEmailValid || emailTextField.text.count < 5 {
            emailTextField.updateState(.enabled)
        } else {
            emailTextField.updateState( .error(message: "Email format incorrect."))
        }
    }
    
    func validatePassword() {
        isPasswordValid = passwordTextField.text.isValidPassword()
        if isPasswordValid || passwordTextField.text.count < 5 {
            passwordTextField.updateState(.enabled)
        } else {
            passwordTextField.updateState(.error(message: "Password does not match criteria."))
        }
    }
    
    @objc private func tapForgotPassword() {
        delegate?.didSelectForgotPassword()
    }
    
    func getLoginForm() -> LoginRequestModel {
        switch formType {
        case .phone:
            return .init(
                clientID: AppConstants.clientID,
                identity: phoneTextField.text.addCountryCode(code: phoneLeftView.selectedCountry.code),
                identityType: "phone",
                password: passwordTextField.text,
                responseType: .code
            )
        case .email:
            return .init(
                clientID: AppConstants.clientID,
                identity: emailTextField.text,
                identityType: "email",
                password: passwordTextField.text,
                responseType: .code)
        }
    }
}

extension LoginFormView: TextFieldDelegate {
    
    func editingChanged(_ textField: TextField) {
        if textField == phoneTextField {
            if !passwordTextField.isEmpty {
                passwordTextField.text = ""
            }
            validatePhone()
        } else if textField == emailTextField {
            if !passwordTextField.text.isEmpty {
                passwordTextField.text = ""
            }
            validateEmail()
        } else if textField == passwordTextField {
            validatePassword()
            self.delegate?.didCompleteForm(state: isFormValid())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
