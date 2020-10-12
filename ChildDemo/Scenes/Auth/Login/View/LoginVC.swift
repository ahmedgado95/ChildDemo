//
//  LoginVC.swift
//  ChildDemo
//
//  Created by ahmed gado on 10/12/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginVC: UIViewController {
     
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var createAccountButton: UIButton!
        @IBOutlet weak var loginButton: UIButton!
        // MARK: - Variable
        let loginViewModel = LoginViewModel()
        let disposeBag = DisposeBag()
        override func viewDidLoad() {
            super.viewDidLoad()
            setUpView()
            // Do any additional setup after loading the view.
            bindTextFiledsToViewModel()
            subscribeToLoding()
            subscribeToResponse()
            subscribeToSaveEnable()
            subscribeToSaveButton()
            subscribeToCreatAccountButton()
            title = "SIGN IN"
        }
        // MARK: - setUpView
        func setUpView(){
            setUpCornerRadious()
            setUpPadding()
            setUpPlaceHolder()
            setUpborderColor()
            setUpborderWidth()
            
        }
        
        // MARK: - setUpborderColor
        func setUpborderColor(){
            emailTextField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordTextField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        // MARK: - setUpborderWidth
        func setUpborderWidth(){
            emailTextField.layer.borderWidth = 0.4
            passwordTextField.layer.borderWidth = 0.4
        }
        // MARK: - setUpCornerRadious
        func setUpCornerRadious(){
            loginButton.layer.cornerRadius = loginButton.frame.height / 2
            emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
            passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        }
        // MARK: - setUpPadding
        func setUpPadding(){
            emailTextField.setLeftPaddingPoints(10)
            emailTextField.setRightPaddingPoints(10)
            passwordTextField.setLeftPaddingPoints(10)
            passwordTextField.setRightPaddingPoints(10)
        }
        // MARK: - setUpPlaceHolder
        func setUpPlaceHolder(){
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        
        // MARK: - bindTextFiledsToViewModel
        func bindTextFiledsToViewModel(){
            emailTextField.rx.text.orEmpty.bind(to: loginViewModel.emailBehavior).disposed(by: disposeBag)
            passwordTextField.rx.text.orEmpty.bind(to: loginViewModel.passwordBehavior).disposed(by: disposeBag)
        }
        // MARK: - subscribeToSaveButton
        func subscribeToSaveButton() {
            loginButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] (_) in
                guard let self = self else {return}
                self.loginViewModel.getLogin()
            }).disposed(by: disposeBag)
        }
        // MARK: - subscribeToCreatAccountButton
         func subscribeToCreatAccountButton() {
             createAccountButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] (_) in
                 guard let self = self else {return}
                self.goPush(vc: RegisterVC.self)
             }).disposed(by: disposeBag)
         }
        // MARK: - subscribeToLoding
        func subscribeToLoding(){
            loginViewModel.loadingBehavior.subscribe(onNext: {[weak self] (isLoading)
                in
                guard let self = self else {return}
                if isLoading {
                    self.showIndicator()
                }else{
                    self.hideIndicator()
                }
            }).disposed(by: disposeBag)
        }
        // MARK: - subscribeToResponse
        func subscribeToResponse() {
            loginViewModel.loginModelObserver.subscribe(onNext: {[weak self] (userId) in
                guard let self = self else {return}
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                let vc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
                vc.userId = userId
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        }
        // MARK: - subscribeToSaveEnable
        func subscribeToSaveEnable(){
            loginViewModel.isSaveButtonEnabel.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        }
    }
