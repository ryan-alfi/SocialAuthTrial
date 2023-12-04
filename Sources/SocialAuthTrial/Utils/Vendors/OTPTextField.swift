//
//  OTPTextField.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.

import UIKit

class OTPTextField: UITextField {
    
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
    
}

protocol OTPDelegate: AnyObject {
    func otpFieldDidChanged(otp: String)
    func didBeginEditing()
    func sendOtp()
}

class OTPStackView: UIStackView {
    
    //Customise the OTPField here
    let numberOfFields = 4
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    //Colors
    let inactiveFieldBorderColor = UIColor(white: 1, alpha: 0.3)
    let activeFieldBorderColor = UIColor.white
    var remainingStrStack: [String] = []
    
    enum OTPFieldState {
        case enabled
        case disabled
        case error
    }
    
    var state: OTPFieldState = .disabled {
        didSet {
            switch state {
            case .error:
                updateBorderColor(color: .red)
            case .enabled:
                updateBorderColor()
                enable(true)
            case .disabled:
                updateBorderColor()
                enable(false)
            }
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addOTPFields()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
        self.makeConstraints(height: 42)
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 60).isActive = true
        textField.backgroundColor = .black300
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        textField.textColor = .white
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
        textField.attributedPlaceholder = NSAttributedString(
            string: "-",
            attributes: [ .font: UIFont.systemFont(ofSize: 22, weight: .medium), .foregroundColor: UIColor.grey500])
    }
    
    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        delegate?.otpFieldDidChanged(otp: getOTP())
        remainingStrStack = []
    }
    
    func resetOTP() {
        textFieldsCollection.forEach {
            $0.text = ""
        }
        delegate?.otpFieldDidChanged(otp: getOTP())
    }
    
    func updateBorderColor(color: UIColor? = nil) {
        textFieldsCollection.forEach {
            $0.layer.borderColor = color?.cgColor
            $0.layer.borderWidth = color == nil ? 0 : 1
        }
    }
}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        if state == .error {
            delegate?.didBeginEditing()
            state = .enabled
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.otpFieldDidChanged(otp: getOTP())
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text, !text.isNumeric() || !string.isNumeric() {
            return false
        }
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0 && string == "") {
                return false
            } else if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}
