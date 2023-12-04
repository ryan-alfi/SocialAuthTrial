//
//  ForgotPasswordViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: AppConstants.insetX, bottom: 8, right: AppConstants.insetX)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 32
        $0.axis = .vertical
    }
    private let formView = ForgotPasswordFormView()
    private(set) lazy var nextButton = UIButton().then {
        $0.enable(false)
        $0.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        $0.setTitle("Next", for: .normal)
        $0.primaryStyle()
    }
    private let descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .grey300
        $0.font = .systemFont(ofSize: 12)
        $0.text = "We will send the verification code to your email address."
    }
    
    private let viewModel: ForgotPasswordViewModel
    
    init(viewModel: ForgotPasswordViewModel) {
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
        view.addSubviews(scrollView, nextButton)
        title = "Forgot Password"
        
        nextButton.makeConstraints(
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing,
            inset: AppConstants.insetX)
        nextButton.makeConstraints(
            bottom: view.safeAreaBottom,
            inset: 20)
        scrollView.makeConstraints(
            top: view.safeAreaTop,
            bottom: nextButton.topAnchor,
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing)
        
        scrollView.addSubview(stackView)
        stackView.makeConstraints(
            top: scrollView.topAnchor,
            bottom: scrollView.bottomAnchor)
        stackView.makeConstraints(
            leading: view.safeAreaLeading,
            trailing: view.safeAreaTrailing)
        stackView.addArrangedSubviews(formView, descLabel)
    }
    
    private func observeClosures() {
        viewModel.onDataChanged = { [weak self] data in
            switch data {
            case let .loading(_, loading):
                self?.loadingIndicator(isLoading: loading)
            case let .failure(_, error):
                self?.handleError(error: error)
            case .loaded(let value):
                if let value = value as? PasswordRecoveryOtpResponseModel {
                    self?.formView.updatePasswordState(.disabled)
                    self?.formView.startOtpCountdown(interval: value.nextRetryInSecond)
                    self?.formView.updateOTPState(.enabled)
                } else if let value = value as? NextActionResponseModel {
                    if value.nextState == NextStateAction.login.rawValue {
                        self?.showToast(message: "Password changed. Please login again.")
                        self?.backToLogin()
                    }
                }
            case .none:
                break
            }
        }
    }
    
    private func backToLogin() {
        guard let loginVC = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController else {
            return
        }
        self.navigationController?.popToViewController(loginVC, animated: true)
        loginVC.moveToPhoneTab()
    }
    
    private func handleError(error: Error) {
        guard let errorModel = error.toDataTransferError()?.errorModel else {
            if error.statusCode() > 500 {
                presentServerError(errorModel: nil)
            } else {
                self.showErrorToast(error: error)
            }
            return
        }
        
        switch ErrorCode(rawValue: errorModel.code.orEmpty) {
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
    
    @objc private func tapNext() {
        guard let sessionId = (self.viewModel.data.value as? PasswordRecoveryOtpResponseModel)?.sessionId else {
            showToast(message: "Missing parameter")
            return
        }
        
        let formModel = formView.getRegistrationForm()
        let param = PasswordRecoveryOtpRequestModel(
            sessionId: sessionId,
            otp: formView.getOtp(),
            identity: formModel.identity,
            identityType: formModel.identityType,
            newPassword: formModel.password)
        viewModel.passwordRecovery(param: param)
    }
    
    func updatePhone(phone: String) {
        formView.tapLeftButton()
        formView.phoneTextField.text = phone
    }
    
    func updateEmail(email: String) {
        formView.tapRightButton()
        formView.emailTextField.text = email
    }
}

extension ForgotPasswordViewController {
    
    static func build() -> ForgotPasswordViewController {
        let viewModel = ForgotPasswordViewModel()
        let viewController = ForgotPasswordViewController(viewModel: viewModel)
        
        return viewController
    }
    
}

extension ForgotPasswordViewController: RegisterFormDelegate {
    
    func otpFieldDidChanged(otp: String) {
        nextButton.enable(formView.isFormValid())
    }
    
    func sendOtp() {
        let formModel = formView.getRegistrationForm()
        let param = OtpRequestModel(identity: formModel.identity, identityType: formModel.identityType)
        viewModel.requestPasswordRecoveryOtp(param: param)
    }
    
    func moveToPhoneLogin(phone: String) {}
    
    func moveToEmailLogin(email: String) {}
    
    func didSelectCountry(country: CountryModel) {
        let view = CountryCodeListView()
        view.delegate = self
        view.countries = viewModel.countries
        presentDialog(view: view)
    }
    
}

extension ForgotPasswordViewController: CountryCodeListDelegate {
    
    func didSelectItem(country: CountryModel) {
        viewModel.updateSelectedCountry(country: country)
        formView.updateSelectedCountry(country: country)
    }
    
}
