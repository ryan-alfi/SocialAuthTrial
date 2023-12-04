//
//  PresentedDialogView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

protocol PresentedDialogViewDelegate {
    func shouldDismissDialogView() -> Bool
}

// extend this class to use PresentedDialogViewController
class PresentedDialogView: UIView, PresentedDialogViewDelegate {
    
    var onTapCloseButton: (() -> Void)?
    
    private let drawerLineView = UIView().then {
        $0.layer.cornerRadius = 3
        $0.backgroundColor = .grey500
    }
    lazy var closeButton = UIButton().then {
        $0.setImage(.icClose?.resize(to: .init(width: 24, height: 24)), for: .normal)
        $0.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
    }
    
    /*** override this method to handle ScrollView, TableView, CollectionView, WebView scrolling.
     When the scroll reach top (.contentOffset.y == 0) will enable PresentedDialogViewController to dismiss
     ***/
    func shouldDismissDialogView() -> Bool {
        true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black500
        addSubviews(drawerLineView, closeButton)
        drawerLineView.makeConstraints(top: self.topAnchor, inset: 16)
        drawerLineView.makeConstraints(centerX: self.centerXAnchor, width: 64, height: 5)
        closeButton.makeConstraints(top: drawerLineView.bottomAnchor, inset: 8)
        closeButton.makeConstraints(leading: self.leadingAnchor, inset: 24)
        closeButton.makeConstraints(width: 24, height: 24)
    }
    
    func onViewDisappeared() {}
    
    @objc func tapCloseButton() {
        onTapCloseButton?()
    }
}
