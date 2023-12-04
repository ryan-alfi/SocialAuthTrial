//
//  LoginViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 16/10/23.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    weak var delegate: VPAuthDelegate?
    private var provider: VPAuthProvider = .email
    
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
    private let createAccountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.text = "Don’t have an account?"
        $0.textColor = .grey900
    }
    private(set) lazy var registerButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapRegister), for: .touchUpInside)
        $0.setTitleColor(.primary100, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        $0.setTitle("Register", for: .normal)
    }
    private let socialLoginView = SocialLoginView()
    private let formView = LoginFormView()
    private(set) lazy var loginButton = UIButton().then {
        $0.enable(false)
        $0.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        $0.setTitle("Login", for: .normal)
        $0.primaryStyle()
    }
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
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
        socialLoginView.delegate = self
        formView.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animateAlongsideTransition(in: nil, animation: { context in
            
        })
    }
    
    override func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.constraint(.bottom)?.constant = -(keyboardRect.height - 42 - view.safeAreaInsets.bottom)
    }
    
    override func keyboardWillHidden(notification: Notification) {
        scrollView.constraint(.bottom)?.constant = 0
    }
    
    private func configureUI() {
        view.addSubviews(scrollView, loginButton)
        title = "Login"
        
        loginButton.makeConstraints(
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing,
            inset: AppConstants.insetX)
        loginButton.makeConstraints(
            bottom: view.safeAreaBottom,
            inset: 20)
        scrollView.makeConstraints(
            top: view.safeAreaTop,
            bottom: loginButton.topAnchor,
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
        registerButton.makeConstraints(height: 20)
        
        containerStackView.addArrangedSubviews(createAccountLabel, registerButton)
        stackView.addArrangedSubviews(formView, socialLoginView)
    }
    
    func observeClosures() {
        viewModel.onDataChanged = { [weak self] data in
            switch data {
            case let .loading(_, loading):
                self?.loadingIndicator(isLoading: loading)
            case let .failure(_, error):
                self?.handleError(error: error)
            case .loaded(let value):
                if let value = value as? LoginResponseModel, let provider = self?.provider {
                    self?.delegate?.didAuthenticationSuccess(token: value.code, provider: provider)
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
                self.delegate?.didAuthenticationFailure(error: error)
            }
            return
        }
        
        switch ErrorCode(rawValue: errorModel.code.orEmpty) {
        case .errEmailOrPassword:
            presentPrimaryPopup(errorModel: errorModel, cta: "OK")
        case .errQuotaExceded:
            presentVerticalSecondaryPopup(
                errorModel: errorModel,
                primaryCta: "OK",
                secondaryCta: "Forgot Password",
                onTapSecondaryButton: { [weak self] in
                    self?.moveToForgotPassword()
                }
            )
        case .errPhoneUnregistered, .errEmailUnregistered:
            presentPrimaryPopup(
                errorModel: errorModel,
                cta: "Register",
                onTapPrimaryButton: { [weak self] in
                    self?.moveToRegister()
                }
            )
        case .errEmailRegisteredByExternalProvider:
            presentPrimaryPopup(
                errorModel: errorModel,
                cta: "Forgot Password",
                onTapPrimaryButton: { [weak self] in
                    self?.moveToForgotPassword(identity: self?.formView.getLoginForm().identity)
                }
            )
        case .errPhoneUnverified, .errEmailUnverified:
            presentPrimaryPopup(
                errorModel: errorModel,
                cta: "Verify Account",
                onTapPrimaryButton: { [weak self] in
                    self?.moveToRegister(
                        identity: self?.formView.getLoginForm().identity,
                        password: self?.formView.getLoginForm().password
                    )
                }
            )
        case .errInternalServer:
            presentServerError(errorModel: errorModel)
        default:
            self.showErrorToast(error: error)
        }
        self.delegate?.didAuthenticationFailure(error: error)
    }
    
    func moveToEmailTab() {
        formView.tapRightButton()
    }
    
    func moveToPhoneTab() {
        formView.tapLeftButton()
    }
    
    func updatePhone(phone: String) {
        formView.phoneTextField.text = phone
    }
    
    func updateEmail(email: String) {
        formView.emailTextField.text = email
    }
    
    @objc private func tapLogin() {
        self.viewModel.login(param: formView.getLoginForm())
    }
    
    @objc private func tapRegister() {
        navigationController?.replace(to: RegisterViewController.build())
    }
    
    func moveToRegister(identity: String? = nil, password: String? = nil) {
        let vc = RegisterViewController.build()
        if formView.formType == .phone {
            vc.updatePhone(phone: identity ?? String(), password: password ?? String())
        } else {
            vc.updateEmail(email: identity ?? String(), password: password ?? String())
        }
        navigationController?.replace(to: vc)
    }
    
    func moveToForgotPassword(identity: String? = nil) {
        let vc = ForgotPasswordViewController.build()
        if formView.formType == .phone {
            vc.updatePhone(phone: identity ?? String())
        } else {
            vc.updateEmail(email: identity ?? String())
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController {
    
    static func build(delegate: VPAuthDelegate?) -> LoginViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.delegate = delegate
        
        return viewController
    }
    
}

extension LoginViewController: SocialLoginDelegate {
    
    func didSelectAppleId() {
        AppleProvider.shared.delegate = self
        AppleProvider.shared.signIn(controller: self)
    }
    
    func didSelectGoogle() {
        GoogleProvider.shared.delegate = self
        GoogleProvider.shared.signIn(controller: self)
    }
    
    func didSelectFacebook() {
        FacebookProvider.shared.delegate = self
        FacebookProvider.shared.signIn(controller: self)
    }
}

extension LoginViewController: LoginFormDelegate {
    
    func didSelectForgotPassword() {
        moveToForgotPassword()
    }
    
    func didSelectCountry(country: CountryModel) {
        let view = CountryCodeListView()
        view.delegate = self
        view.countries = viewModel.countries
        presentDialog(view: view)
    }
    
    func didCompleteForm(state: Bool) {
        loginButton.enable(state)
    }
}

extension LoginViewController: CountryCodeListDelegate {
    
    func didSelectItem(country: CountryModel) {
        viewModel.updateSelectedCountry(country: country)
        formView.updateSelectedCountry(country: country)
    }
    
}

extension LoginViewController: VPAuthDelegate {
    
    func didAuthenticationSuccess(token: String, provider: VPAuthProvider) {
        self.provider = provider
        self.viewModel.socialLogin(param: .init(
            clientID: AppConstants.clientID,
            token: token,
            provider: provider.rawValue.lowercased(),
            responseType: .code
        ))
    }
    
    func didAuthenticationFailure(error: Error) {
        self.delegate?.didAuthenticationFailure(error: error)
    }
}
