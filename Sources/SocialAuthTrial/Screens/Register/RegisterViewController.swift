//
//  RegisterViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

final class RegisterViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: AppConstants.insetX, bottom: 0, right: AppConstants.insetX)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 32
        $0.axis = .vertical
    }
    private let containerStackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
        $0.axis = .horizontal
    }
    private let accountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.text = "Already have an account?"
        $0.textColor = .grey900
    }
    private(set) lazy var loginButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        $0.setTitleColor(.primary100, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        $0.setTitle("Login", for: .normal)
    }
    private let socialLoginView = SocialLoginView()
    private let formView = RegisterFormView()
    private(set) lazy var registerButton = UIButton().then {
        $0.enable(false)
        $0.addTarget(self, action: #selector(tapRegister), for: .touchUpInside)
        $0.setTitle("Register", for: .normal)
        $0.primaryStyle()
    }

    private let viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        observeClosures()
        addKeyboardObserver()
        enableTapGestureOnView()
        formView.delegate = self
        socialLoginView.delegate = self
    }

    override func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.constraint(.bottom)?.constant = -(keyboardRect.height)
    }

    override func keyboardWillHidden(notification: Notification) {
        scrollView.constraint(.bottom)?.constant = -24
    }

    private func configureUI() {
        view.addSubviews(scrollView, registerButton)
        title = "Register"
        
        registerButton.makeConstraints(
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing,
            inset: AppConstants.insetX)
        registerButton.makeConstraints(
            bottom: view.safeAreaBottom,
            inset: 20)
        scrollView.makeConstraints(
            top: view.safeAreaTop,
            bottom: registerButton.topAnchor,
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing)
        
        scrollView.addSubviews(stackView, containerStackView)
        stackView.makeConstraints(
            top: scrollView.topAnchor,
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing)
        containerStackView.makeConstraints(centerX: view.centerXAnchor)
        containerStackView.makeConstraints(
            top: stackView.bottomAnchor,
            bottom: scrollView.bottomAnchor,
            inset: 24)
        loginButton.makeConstraints(height: 20)
        
        containerStackView.addArrangedSubviews(accountLabel, loginButton)
        stackView.addArrangedSubviews(formView, socialLoginView)
    }
    
    private func observeClosures() {
        viewModel.onDataChanged = { [weak self] data in
            switch data {
            case let .loading(_, loading):
                self?.loadingIndicator(isLoading: loading)
            case let .failure(_, error):
                self?.handleError(error: error)
            case .loaded(let value):
                if let value = value as? OtpResponseModel {
                    self?.formView.updatePasswordState(.disabled)
                    self?.formView.startOtpCountdown(interval: value.nextRetryInSecond)
                    self?.formView.updateOTPState(.enabled)
                } else if let value = value as? LoginResponseModel {
                    self?.formView.resetUI()
                    let provider: VPAuthProvider = self?.formView.formType == .email ? .email : .phone
                    SocialAuthTrial.shared.authDelegate?.didAuthenticationSuccess(token: value.code, provider: provider)
                }
            case .none:
                break
            }
        }
    }
    
    func handleError(error: Error) {
        guard let errorModel = error.toDataTransferError()?.errorModel else {
            if error.statusCode() > 500 {
                presentServerError(errorModel: nil)
            } else {
                self.showErrorToast(error: error)
            }
            return
        }
        
        switch ErrorCode(rawValue: errorModel.code.orEmpty) {
        case .errGeoBlock:
            presentPrimaryPopup(errorModel: errorModel, cta: "Got it")
        case .errEmailRegistered, .errPhoneRegistered, .errEmailRegisteredByExternalProvider:
            presentPrimaryPopup(
                errorModel: errorModel,
                cta: "Login",
                onTapPrimaryButton: { [weak self] in
                    self?.moveToLogin(identify: "")
                })
        case .errQuotaExceded, .errOtpWaitingTime:
            presentVerticalSecondaryPopup(
                errorModel: errorModel,
                primaryCta: "OK",
                secondaryCta: "I didn’t receive any verification",
                onTapSecondaryButton: {
                    // TODO: replace the url once the real url ready
                    UIApplication.openUrl("https://www.visionplus.id/websupport/faq")
                })
        case .errInvalidOtp, .errExpiredOtp:
            self.formView.updateOTPState(.error(message: errorModel.message.orEmpty))
        case .errInternalServer:
            presentServerError(errorModel: errorModel)
        default:
            self.showErrorToast(error: error)
        }
    }
    
    func moveToLogin(identify: String) {
        if formView.formType == .phone {
            moveToPhoneLogin(phone: identify)
        } else {
            moveToEmailLogin(email: identify)
        }
    }
    
    @objc private func tapLogin() {
        navigationController?.replace(to: LoginViewController.build(delegate: SocialAuthTrial.shared.authDelegate))
    }
    
    @objc private func tapRegister() {
        guard let sessionId = (self.viewModel.data.value as? OtpResponseModel)?.otpSessionId else {
            showToast(message: "Missing parameter")
            return
        }
        self.viewModel.verifyOtp(
            param: VerifyOtpRequestModel(
                otpSessionId: sessionId,
                otp: formView.getOtp(),
                identity: formView.getRegistrationForm().identity),
            loginParam: formView.getRegistrationForm().toLoginRequestModel())
    }
    
    func updatePhone(phone: String, password: String) {
        formView.tapLeftButton()
        formView.phoneTextField.text = phone
        formView.passwordTextField.text = password
    }
    
    func updateEmail(email: String, password: String) {
        formView.tapRightButton()
        formView.emailTextField.text = email
        formView.passwordTextField.text = password
    }
}

extension RegisterViewController {
    
    static func build() -> RegisterViewController {
        let viewModel = RegisterViewModel()
        let viewController = RegisterViewController(viewModel: viewModel)
        
        return viewController
    }
    
}

extension RegisterViewController: SocialLoginDelegate {
    
    func didSelectAppleId() {
        AppleProvider.shared.delegate = SocialAuthTrial.shared.authDelegate
        AppleProvider.shared.signIn(controller: self)
    }
    
    func didSelectGoogle() {
        GoogleProvider.shared.delegate = SocialAuthTrial.shared.authDelegate
        GoogleProvider.shared.signIn(controller: self)
    }
    
    func didSelectFacebook() {
        FacebookProvider.shared.delegate = SocialAuthTrial.shared.authDelegate
        FacebookProvider.shared.signIn(controller: self)
    }
}

extension RegisterViewController: RegisterFormDelegate {
    
    func otpFieldDidChanged(otp: String) {
        registerButton.enable(formView.isFormValid())
    }
    
    func sendOtp() {
        viewModel.register(param: formView.getRegistrationForm())
    }
    
    func moveToPhoneLogin(phone: String) {
        let vc = LoginViewController.build(delegate: SocialAuthTrial.shared.authDelegate)
        navigationController?.replace(to: vc)
        vc.updatePhone(phone: phone)
    }
    
    func moveToEmailLogin(email: String) {
        let vc = LoginViewController.build(delegate: SocialAuthTrial.shared.authDelegate)
        navigationController?.replace(to: vc)
        vc.moveToEmailTab()
        vc.updateEmail(email: email)
    }
    
    func didSelectCountry(country: CountryModel) {
        let view = CountryCodeListView()
        view.delegate = self
        view.countries = viewModel.countries
        presentDialog(view: view)
    }
    
}

extension RegisterViewController: CountryCodeListDelegate {
    
    func didSelectItem(country: CountryModel) {
        viewModel.updateSelectedCountry(country: country)
        formView.updateSelectedCountry(country: country)
    }
    
}
