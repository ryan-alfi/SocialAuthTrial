//
//  BaseViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    private func configureNavBar() {
        view.backgroundColor = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .icArrowLeft, style: .plain, target: self, action: #selector(tapBackButton))
    }
    
    func enableTapGestureOnView(cancelsTouchesInView: Bool = false) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapClick(_:)))
        view.isUserInteractionEnabled = true
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {}
    
    @objc func keyboardShow(notification: Notification) {}
    
    @objc func keyboardWillHidden(notification: Notification) {}
    
    @objc func tapBackButton() {
        guard let viewControllers = navigationController?.viewControllers else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc func tapClick(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension BaseViewController {
    
    func showLoadingIndicator(view: UIView? = UIApplication.shared.keyWindow) {
        guard let view = view, view.viewWithTag(100001) == nil else {
            return
        }
        
        let containerView = UIView().then {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
            $0.tag = 100001
        }
        let indicator = UIActivityIndicatorView(style: .medium).then {
            $0.startAnimating()
            $0.color = .white
        }
        containerView.addSubview(indicator)
        indicator.makeConstraints(centerX: containerView.centerXAnchor, centerY: containerView.centerYAnchor)
        view.addSubview(containerView)
        containerView.edgesTo(view)
    }
    
    func hideLoadingIndicator(view: UIView? = UIApplication.shared.keyWindow) {
        view?.viewWithTag(100001)?.removeFromSuperview()
    }
    
    func loadingIndicator(isLoading: Bool) {
        isLoading ? showLoadingIndicator() : hideLoadingIndicator()
    }
    
    func presentDialog(
        view: PresentedDialogView,
        dialogType: PresentedDialogType = .normal,
        onTapShadowOrCollapsed: (() -> Void)? = nil)
    {
        let modalVC = PresentedDialogViewController(dialogView: view, type: dialogType)
        modalVC.onTapShadowOrCollapsed = onTapShadowOrCollapsed
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true)
    }
    
    func presentPopUp(
        type: MessageType,
        onTapPrimaryButton: (() -> Void)? = nil,
        onTapSecondaryButton: (() -> Void)? = nil)
    {
        let popupVC = PopUpViewController(type: type)
        popupVC.onTapPrimaryButton = onTapPrimaryButton
        popupVC.onTapSecondaryButton = onTapSecondaryButton
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .overCurrentContext
        present(popupVC, animated: true)
    }
    
    func showToast(
        on view: UIView? = UIApplication.shared.keyWindow,
        leftImage: UIImage? = nil,
        imageSize: CGSize = CGSize(width: 18, height: 18),
        message: String)
    {
        guard let view = view, view.viewWithTag(100002) == nil else {
            return
        }
        let toastView = ToastView()
        toastView.tag = 100002
        toastView.updateUI(image: leftImage, imageSize: imageSize, text: message)
        
        view.addSubview(toastView)
        toastView.constraintXTo(view: view, inset: AppConstants.insetX)
        toastView.makeConstraints(bottom: view.safeAreaBottom, inset: 80)
        
        UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseInOut, animations: {
            toastView.alpha = 0.0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
    }
    
    func showErrorToast(error: Error) {
        if (error as? DataTransferError)?.statusCode == NSURLErrorNotConnectedToInternet {
            showToast(leftImage: .icInternetOff?.withTintColor(.red), message: error.getErrorMessage())
        } else {
            showToast(message: error.getErrorMessage())
        }
    }
    
    func presentServerError(errorModel: ErrorModel?) {
        let title = errorModel?.messageTitle ?? "Server Error"
        let subtitle = errorModel?.message ??  "Our server currently facing a temporary error. Please try again later."
        presentPopUp(
            type: .customVertical(
                title: title,
                subtitle: NSAttributedString(string: subtitle),
                secondaryButton: .secondary("Close"),
                image: .assets(image: .illServerError)),
        onTapSecondaryButton: {
            let error = NSError(domain: "Vision Plus", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal server error"])
            VisionPlusBSS.shared.authDelegate?.didAuthenticationFailure(error: error)
        })
    }
    
    func presentPrimaryPopup(
        errorModel: ErrorModel,
        cta: String,
        onTapPrimaryButton: (() -> Void)? = nil) {
        presentPopUp(
            type: .withPrimaryButton(
                title: errorModel.messageTitle.orEmpty,
                subtitle: NSAttributedString(string: errorModel.message.orEmpty),
                button: cta),
            onTapPrimaryButton: onTapPrimaryButton)
    }
    
    func presentVerticalSecondaryPopup(
        errorModel: ErrorModel,
        primaryCta: String,
        secondaryCta: String,
        onTapPrimaryButton: (() -> Void)? = nil,
        onTapSecondaryButton: (() -> Void)? = nil) {
        presentPopUp(
            type: .withVerticalSecondaryButton(
                title: errorModel.messageTitle.orEmpty,
                subtitle: NSAttributedString(string: errorModel.message.orEmpty),
                primaryButton: primaryCta,
                secondaryButton: secondaryCta),
            onTapPrimaryButton: onTapPrimaryButton,
            onTapSecondaryButton: onTapSecondaryButton)
    }
    
}
