//
//  RegisterViewModel.swift
//  ChildDemo
//
//  Created by ahmed gado on 10/5/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Firebase

class RegisterViewModel {
    var nameBehavior = BehaviorRelay<String>(value: "")
    var emailBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var confiemPasswordBehavior = BehaviorRelay<String>(value: "")
    
   var lodaingBehavior = BehaviorRelay<Bool>(value: false)
    
       private var registerModelSubject = PublishSubject<[String: Any]>()
       var registerModelObserver : Observable<[String: Any]> {
           return registerModelSubject
       }
    
    var isEmailValid : Observable<Bool>{
        return emailBehavior.asObservable().map { (email) -> Bool in
            let isEmaillEmpty = email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isEmaillEmpty
        }
    }
    
    var isPasswordValid : Observable<Bool>{
        return passwordBehavior.asObservable().map { (password) -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isPasswordEmpty
        }
    }
    
    var isConfirmPasswordValid : Observable<Bool>{
        return confiemPasswordBehavior.asObservable().map { (password) -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isPasswordEmpty
        }
    }
    
    var isSaveButtonEnabel : Observable<Bool>{
        return Observable.combineLatest(isEmailValid , isPasswordValid , isConfirmPasswordValid){(isEmailEmpty , isPassworlEmpty , isConfirmPasswordEmpty) in
            let loginValid = !isEmailEmpty && !isPassworlEmpty && !isConfirmPasswordEmpty
            return loginValid
            
        }
    }
    // MARK: - getRegister
    func getRegister(successed : @escaping (String) -> Void){
        lodaingBehavior.accept(true)
        Auth.auth().createUser(withEmail: emailBehavior.value, password: passwordBehavior.value ) { [weak self](success, error) in
            guard let self = self else {return}
            self.lodaingBehavior.accept(false)
            if error == nil {
                // success
                print(success ?? "success")
                guard let userId = success?.user.uid else {return}
                self.addDataRef(uid: userId)
                UserDefaults.standard.set(userId, forKey: "id")
                UserDefaults.standard.synchronize()
                successed(userId)
            }else {
                // error
                print(error?.localizedDescription ?? "error")
            }
        }

    }
    // MARK: - addDataRef
       func addDataRef(uid : String) {
           let reference = Database.database().reference()
           let user = reference.child(Constants.uSERSCHILD).child(uid)
           let value:[String: Any] = [Constants.iD : uid , Constants.nAME: self.nameBehavior.value , Constants.eMail : self.emailBehavior.value ]
           user.setValue(value)
           self.registerModelSubject.onNext(value)
       }
}
