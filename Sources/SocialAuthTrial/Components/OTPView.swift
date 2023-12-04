//
//  OTPView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

enum OTPState {
    case enableOtpField
    case enabled
    case disabled
    case error(message: String, messageColor: UIColor = .errorRed)
}

class OTPView: UIView {
    
    weak var delegate: OTPDelegate? {
        didSet {
            otpStackView.delegate = delegate
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "Enter OTP"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private let otpStackView = OTPStackView()
    
    private let coundownStackView = UIStackView()
    private let countdownLabel = CountDownLabel().then {
        $0.prefixText = "Resend in "
        $0.isHidden = true
    }
    
    private(set) lazy var rightButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.primary100, for: .normal)
        $0.setTitle("Send OTP", for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.titleLabel?.textAlignment = .right
        $0.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
    }
    private let errorStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let errorLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .errorRed
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var otp: String {
        return otpStackView.getOTP()
    }
    var state: OTPState = .disabled {
        didSet {
            updateState(state)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(titleLabel, coundownStackView, otpStackView, errorStackView)
        titleLabel.makeConstraints(top: self.topAnchor, leading: self.leadingAnchor)
        coundownStackView.makeConstraints(trailing: self.trailingAnchor, centerY: titleLabel.centerYAnchor)
        otpStackView.makeConstraints(top: titleLabel.bottomAnchor, inset: 8)
        otpStackView.makeConstraints(leading: self.leadingAnchor, height: 42)
        otpStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        coundownStackView.addArrangedSubviews(countdownLabel, rightButton)
        countdownLabel.onCountdownFinished = { [weak self] in
            self?.showCountDown(false)
        }
        
        errorStackView.makeConstraints(top: otpStackView.bottomAnchor, inset: 4)
        errorStackView.makeConstraints(bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor)
        errorStackView.addArrangedSubview(errorLabel)
    }
    
    private func updateState(_ state: OTPState) {
        switch state {
        case .enableOtpField:
            enable(true)
            hideError()
            otpStackView.updateBorderColor()
            otpStackView.state = .disabled
        case .enabled:
            enable(true)
            hideError()
            otpStackView.updateBorderColor()
            otpStackView.state = .enabled
        case .disabled:
            enable(false)
            otpStackView.resetOTP()
            hideError()
            otpStackView.updateBorderColor()
            otpStackView.state = .disabled
        case let .error(message, messageColor):
            enable(true)
            hideError()
            errorLabel.isHidden = false
            errorLabel.text = message
            errorLabel.textColor = messageColor
            otpStackView.state = .error
        }
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func resetOTP() {
        otpStackView.resetOTP()
        showCountDown(false)
    }
    
    func showCountDown(_ show: Bool) {
        countdownLabel.isHidden = !show
        rightButton.isHidden = show
    }
    
    func startCountdown(interval: TimeInterval) {
        guard interval > 0 else {
            return
        }
        countdownLabel.startTimer(interval: interval)
        showCountDown(true)
    }
    
    @objc private func tapRightButton() {
        delegate?.sendOtp()
    }
    
}
