//
//  RegisterFormView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit
import Foundation

protocol RegisterFormDelegate: AnyObject {
    func moveToPhoneLogin(phone: String)
    func moveToEmailLogin(email: String)
    func didSelectCountry(country: CountryModel)
    func sendOtp()
    func otpFieldDidChanged(otp: String)
}

class RegisterFormView: FormStackView {
    
    enum RegisterFormType {
        case email
        case phone
    }
    
    weak var delegate: RegisterFormDelegate?
    
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
        $0.title = "Create Password"
    }
    private let passwordDescLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .grey400
        $0.font = .systemFont(ofSize: 12)
        $0.text = "Your password must be at least 8 characters with a mix of uppercase-lowercase letters and numbers"
    }
    let otpView = OTPView().then {
        $0.enable(false)
    }
    
    var formType: RegisterFormType = .phone {
        didSet {
            updateUI()
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
                otpView.state = isPasswordValid ? .enableOtpField : .disabled
                if !isPasswordValid {
                    otpView.resetOTP()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        otpView.delegate = self
        addArrangedSubviews(emailTextField, phoneTextField, passwordTextField, passwordDescLabel, otpView)
        setCustomSpacing(8, after: passwordTextField)
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
    
    func updateUI() {
        resetUI()
        otpView.title = formType == .phone ? "Enter OTP" : "Enter OTP or click link"
        self.emailTextField.isHidden = formType == .phone
        self.phoneTextField.isHidden = formType == .email
    }
    
    func resetUI() {
        phoneTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        phoneTextField.updateState(.enabled)
        emailTextField.updateState(.enabled)
        passwordTextField.updateState(.disabled)
        otpView.state = .disabled
        otpView.resetOTP()
    }
    
    // MARK: - Email
    
    func updateEmailState(_ state: TextField.TextFieldState) {
        emailTextField.updateState(state)
    }
    
    func validateEmail() {
        isEmailValid = emailTextField.text.isValidEmail()
        if isEmailValid || emailTextField.text.count < 5 {
            emailTextField.updateState(.enabled)
        } else {
            emailTextField.updateState( .error(message: "Email format incorrect."))
        }
    }
    
    // MARK: - Phone
    
    func updateSelectedCountry(country: CountryModel) {
        phoneLeftView.selectedCountry = country
        phoneTextField.leftView = phoneLeftView
    }
    
    func updatePhoneState(_ state: TextField.TextFieldState) {
        phoneTextField.updateState(state)
    }
    
    func validatePhone() {
        isPhoneValid = phoneTextField.text.isValidPhone()
        if isPhoneValid || phoneTextField.text.count < 5 {
            phoneTextField.updateState(.enabled)
        } else {
            phoneTextField.updateState(.error(message: "Phone number format incorrect."))
        }
    }
    
    // MARK: - Password
    
    func updatePasswordState(_ state: TextField.TextFieldState) {
        passwordTextField.updateState(state)
    }
    
    func validatePassword() {
        isPasswordValid = passwordTextField.text.isValidPassword()
        if isPasswordValid || passwordTextField.text.count < 5 {
            passwordTextField.updateState(.enabled)
        } else {
            passwordTextField.updateState(.error(message: "Password does not match criteria."))
        }
    }
    
    // MARK: - OTP
    
    func updateOTPState(_ state: OTPState) {
        otpView.state = state
    }
    
    func startOtpCountdown(interval: Int) {
        otpView.startCountdown(interval: TimeInterval(interval))
    }
    
    func getOtp() -> String {
        return otpView.otp
    }
    
    func getRegistrationForm() -> RegisterRequestModel {
        switch formType {
        case .email:
            return RegisterRequestModel(
                identity: emailTextField.text,
                identityType: "email",
                password: passwordTextField.text)
        case .phone:
            return RegisterRequestModel(
                identity: phoneTextField.text.addCountryCode(code: phoneLeftView.selectedCountry.code),
                identityType: "phone",
                password: passwordTextField.text)
        }
    }
    
    func isIdentityValid() -> Bool {
        return isPhoneValid || isEmailValid
    }
    
    func isFormValid() -> Bool {
        return isIdentityValid() && isPasswordValid && otpView.otp.count == 4
    }
    
}

extension RegisterFormView: TextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        if textField == phoneTextField.textField {
            return text.isNumeric() && string.isNumeric()
        }
        
        return true
    }
    
    func editingChanged(_ textField: TextField) {
        if textField == phoneTextField {
            if !passwordTextField.text.isEmpty {
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
        }
    }
    
    func didSelectErrorButton(_ textField: TextField) {
        if textField == emailTextField {
            delegate?.moveToEmailLogin(email: textField.text)
        } else if textField == phoneTextField {
            delegate?.moveToPhoneLogin(phone: textField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension RegisterFormView: OTPDelegate {
    func otpFieldDidChanged(otp: String) {
        delegate?.otpFieldDidChanged(otp: otp)
    }
    
    func didBeginEditing() {
        otpView.state = .enabled
    }
    
    func sendOtp() {
        delegate?.sendOtp()
    }
    
}
