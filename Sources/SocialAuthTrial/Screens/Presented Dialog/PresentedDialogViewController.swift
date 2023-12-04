//
//  PresentedDialogViewController.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

enum PresentedDialogType: Equatable {
    case normal
    case full
    case fixedHeight(height: CGFloat)
}

// Pull/Swipe Down To Dismiss Presented VC
final class PresentedDialogViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    private let shadowView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private enum DialogState {
        case expanded
        case collapsed
    }
    
    // set your UIView that extend PresentedDialogView through constructor
    private var dialogView: PresentedDialogView?
    
    
    private var dialogHeight: CGFloat = AppConstants.screenHeight - 100
    private var fractionComplete: CGFloat = 0
    
    private var dialogVisible = true
    private var nextState: DialogState {
        return dialogVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0
    private var maxHeight = AppConstants.screenHeight - 100
    private var type: PresentedDialogType = .normal
    private var enablePanGesture: Bool = true

    var isDismissShadowTap: Bool = false
    var dismissShadowTap: (() -> Void)?
    var onTapShadowOrCollapsed: (() -> Void)?
    
    // MARK: Initiliazed
    
    init(dialogView: PresentedDialogView, type: PresentedDialogType = .normal, enablePanGesture: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        self.dialogView = dialogView
        self.type = type
        self.enablePanGesture = enablePanGesture
        initMaxHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        handleClosures()
        addKeyboardObserver()
        enableTapGestureOnView()
    }
    
    override func viewDidLayoutSubviews() {
        dialogView?.roundCorners([.topLeft, .topRight], radius: 10)
        updateDialogHeight()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dialogView?.onViewDisappeared()
    }
    
    override func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        dialogView?.constraint(.bottom)?.constant = -(keyboardRect.height)
    }
    
    override func keyboardWillHidden(notification: Notification) {
        dialogView?.constraint(.bottom)?.constant = 0
    }
    
    // MARK: - Private Methods
    
    private func initMaxHeight() {
        switch type {
        case .full:
            maxHeight = AppConstants.screenHeight
        case .fixedHeight(let height):
            let newHeight = AppConstants.screenHeight - 40
            maxHeight = height > newHeight ? newHeight : height
        default:
            break
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shadowTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dialogPan(recognizer:)))
        
        panGestureRecognizer.delegate = self
        shadowView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(shadowView)
        shadowView.edgesTo(view)
        
        if let dialogView = dialogView {
            view.addSubview(dialogView)
            
            dialogView.makeConstraints(
                bottom: view.bottomAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor)
            
            switch type {
            case .fixedHeight(let height):
                dialogView.makeConstraints(height: height)
            default:
                dialogView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaTop, constant: type == .normal ? 38 : 0).isActive = true
            }
            if enablePanGesture {
                dialogView.addGestureRecognizer(panGestureRecognizer)
            }
        }
    }
    
    private func updateDialogHeight() {
        guard let dialogView = dialogView else {
            return
        }
        dialogHeight = dialogView.frame.height > maxHeight ? maxHeight : dialogView.frame.height
    }
    
    private func handleClosures() {
        dialogView?.onTapCloseButton = { [weak self] in
            self?.animateTransitionIfNeeded(state: .collapsed, duration: 0.5)
        }
    }
    
    // MARK: - UIPanGestureRecognizer Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let dialogView = dialogView {
            return dialogView.shouldDismissDialogView()
        }
        
        return true
    }

    // MARK: - Gesture Handler
    
    @objc private func shadowTap(recognizer: UITapGestureRecognizer) {
        if isDismissShadowTap {
            dismissShadowTap?()
            return
        }
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: .collapsed, duration: 0.5)
        default:
            break
        }
    }
    
    @objc private func dialogPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            let translationView = dialogView
            let translation = recognizer.translation(in: translationView)
            fractionComplete = translation.y / dialogHeight
            fractionComplete = dialogVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            if fractionComplete < 0.25 {
                for animator in runningAnimations {
                    animator.isReversed = true
                }
                self.dialogVisible = !self.dialogVisible
            }
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // MARK: Animation Handler
    
    private func animateTransitionIfNeeded(state: DialogState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.dialogView?.frame.origin.y = self.view.frame.height - self.dialogHeight
                case .collapsed:
                    self.dialogView?.frame.origin.y = self.view.frame.height
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.dialogVisible = !self.dialogVisible
                self.runningAnimations.removeAll()
                if !self.dialogVisible {
                    self.onTapShadowOrCollapsed?()
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    
    private func startInteractiveTransition(state: DialogState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
}

