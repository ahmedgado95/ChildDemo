//
//  RegisterVC.swift
//  ChildDemo
//
//  Created by ahmed gado on 10/5/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RegisterVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var haveAccountButton: UIButton!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    // MARK: - Variable
    let rigisterViewModel = RegisterViewModel()
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
        subscribeToHaveAccountButton()
        title = "REGISTER"

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
        nameTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        emailTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        confirmPasswordTxt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: - setUpborderWidth
    func setUpborderWidth(){
        nameTxt.layer.borderWidth = 0.4
        emailTxt.layer.borderWidth = 0.4
        passwordTxt.layer.borderWidth = 0.4
        confirmPasswordTxt.layer.borderWidth = 0.4
    }
    // MARK: - setUpCornerRadious
    func setUpCornerRadious(){
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        nameTxt.layer.cornerRadius = nameTxt.frame.height / 2
        passwordTxt.layer.cornerRadius = passwordTxt.frame.height / 2
        emailTxt.layer.cornerRadius = emailTxt.frame.height / 2
        confirmPasswordTxt.layer.cornerRadius = confirmPasswordTxt.frame.height / 2
    }
    // MARK: - setUpPadding
    func setUpPadding(){
        nameTxt.setLeftPaddingPoints(10)
        nameTxt.setRightPaddingPoints(10)
        emailTxt.setLeftPaddingPoints(10)
        emailTxt.setRightPaddingPoints(10)
        passwordTxt.setLeftPaddingPoints(10)
        passwordTxt.setRightPaddingPoints(10)
        confirmPasswordTxt.setLeftPaddingPoints(10)
        confirmPasswordTxt.setRightPaddingPoints(10)
    }
    // MARK: - setUpPlaceHolder
    func setUpPlaceHolder(){
        nameTxt.attributedPlaceholder = NSAttributedString(string: "Enter Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Enter Email",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        confirmPasswordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    // MARK: - bindTextFiledsToViewModel
    func bindTextFiledsToViewModel(){
        nameTxt.rx.text.orEmpty.bind(to: rigisterViewModel.nameBehavior).disposed(by: disposeBag)
        emailTxt.rx.text.orEmpty.bind(to: rigisterViewModel.emailBehavior).disposed(by: disposeBag)
        passwordTxt.rx.text.orEmpty.bind(to: rigisterViewModel.passwordBehavior).disposed(by: disposeBag)
        confirmPasswordTxt.rx.text.orEmpty.bind(to: rigisterViewModel.confiemPasswordBehavior).disposed(by: disposeBag)
    }
    // MARK: - subscribeToSaveButton
    func subscribeToSaveButton() {
        registerButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] (_) in
            guard let self = self else {return}
            self.rigisterViewModel.getRegister() { (success) in
                print("finish fetch data")
                self.nameTxt.text = ""
                self.emailTxt.text = ""
                self.passwordTxt.text = ""
                self.confirmPasswordTxt.text = ""
                let vc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
                            vc.userId = success
                            self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    // MARK: - subscribeToLoding
    func subscribeToLoding(){
        rigisterViewModel.lodaingBehavior.subscribe(onNext: {[weak self] (isLoading)
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
        rigisterViewModel.registerModelObserver.subscribe(onNext: {
            if $0.count >= 0 {
                print("Done")
//                self.goPush(vc: HomeVC.self)
            
            }
        }).disposed(by: disposeBag)
    }
    // MARK: - subscribeToSaveEnable
    func subscribeToSaveEnable(){
        rigisterViewModel.isSaveButtonEnabel.bind(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
    }
    // MARK: - subscribeToHaveAccountButton
      func subscribeToHaveAccountButton() {
          haveAccountButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] (_) in
              guard let self = self else {return}
              self.navigationController?.popViewController(animated: true)        }).disposed(by: disposeBag)
      }
}
