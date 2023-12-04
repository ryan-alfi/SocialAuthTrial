//
//  VerifyLinkViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 31/10/23.
//

import UIKit

final class VerifyLinkViewController: BaseViewController {
    
    private let viewModel: VerifyLinkViewModel
    private let messageView = MessageView()
    private var timer: CountDownTimer?
    
    init(viewModel: VerifyLinkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        handleClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.verifyLink()
    }
    
    private func configureUI() {
        view.addSubview(messageView)
        messageView.makeConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, inset: 24)
        messageView.makeConstraints(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
    }
    
    private func startTimer() {
        timer = CountDownTimer()
        timer?.onCountDownFinished = { [weak self] in
            self?.timer = nil
            self?.popToLogin()
        }
        timer?.startTimer(maxInterval: 3)
    }
    
    private func stopTimer() {
        self.timer?.removeTimer()
        self.timer = nil
    }
    
    private func handleClosures() {
        viewModel.onDataChanged = { [weak self] data in
            switch data {
            case let .loading(_, loading):
                self?.loadingIndicator(isLoading: loading)
            case .loaded:
                self?.messageView.updateUI(type: .basic(
                    title: "Your email has been verified",
                    subtitle: nil,
                    image: .assets(image: .illSuccess, size: CGSize(width: 150, height: 150)))
                )
                self?.startTimer()
            case let .failure(_, error):
                self?.handleError(error)
            case .none:
                break
            }
        }
        messageView.onTapPrimaryButton = { [weak self] in
            self?.viewModel.verifyLink()
        }
    }
    
    func handleError(_ error: Error) {
        guard let errorModel = error.toDataTransferError()?.errorModel else {
            if error.statusCode() > 500 {
                presentServerError(errorModel: nil)
            } else if (error as? DataTransferError)?.statusCode == NSURLErrorNotConnectedToInternet {
                showToast(leftImage: .icInternetOff?.withTintColor(.red), message: error.getErrorMessage())
            } else {
                showLinkExpiredMessageView()
            }
            return
        }
        
        switch ErrorCode(rawValue: errorModel.code.orEmpty) {
        case .errInternalServer:
            presentServerError(errorModel: errorModel)
        default:
            showLinkExpiredMessageView()
        }
    }
    
    func showLinkExpiredMessageView() {
        self.messageView.updateUI(type: .basic(
            title: "Link has expired",
            subtitle: NSAttributedString(string: "Verification link has been expired, please try to request a new one."))
        )
    }
    
    func popToLogin() {
        if let loginVC = navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
            navigationController?.popToViewController(loginVC, animated: true)
            (loginVC as? LoginViewController)?.moveToEmailTab()
        } else if let registerVC = navigationController?.viewControllers.first(where: { $0 is RegisterViewController }) {
            navigationController?.popToViewController(registerVC, animated: false)
            (registerVC as? RegisterViewController)?.moveToEmailLogin(email: "")
        } else {
            let loginVC = LoginViewController.build(delegate: SocialAuthTrial.shared.authDelegate)
            navigationController?.replace(to: loginVC)
            loginVC.moveToEmailTab()
        }
    }
    
    override func tapBackButton() {
        stopTimer()
        // when verifyEmail link success and the timer still running and user press back
        if viewModel.data.value != nil {
            popToLogin()
            return
        }
        super.tapBackButton()
    }

}

extension VerifyLinkViewController {
    
    static func build(sessionId: String, identity: String) -> VerifyLinkViewController {
        let viewModel = VerifyLinkViewModel(sessionId: sessionId, identity: identity)
        let viewController = VerifyLinkViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
