//
//  CreateNewPasswordViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 18/10/23.
//

import UIKit

final class CreateNewPasswordViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.layoutMargins = UIEdgeInsets(top: 16, left: AppConstants.insetX, bottom: 8, right: AppConstants.insetX)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 32
        $0.axis = .vertical
    }
    private let formView = CreateNewPasswordFormView()
    private(set) lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        $0.setTitle("Save Password", for: .normal)
        $0.primaryStyle()
    }
    
    private let viewModel: CreateNewPasswordViewModel
    
    init(viewModel: CreateNewPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubviews(scrollView, nextButton)
        title = "Create New Password"
        
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
        stackView.addArrangedSubviews(formView)
    }
    
    @objc private func tapNext() {
        showToast(message: "Password changed. Please login again.")
        if let loginVC = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController {
            self.navigationController?.popToViewController(loginVC, animated: true)
            loginVC.moveToPhoneTab()
        }
    }

}

extension CreateNewPasswordViewController {
    
    static func build() -> CreateNewPasswordViewController {
        let viewModel = CreateNewPasswordViewModel()
        let viewController = CreateNewPasswordViewController(viewModel: viewModel)
        
        return viewController
    }
    
}
