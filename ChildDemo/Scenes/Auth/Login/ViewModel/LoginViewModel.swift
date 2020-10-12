//
//  LoginViewModel.swift
//  ChildDemo
//
//  Created by ahmed gado on 10/12/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import Foundation
import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth
class LoginViewModel {
    var emailBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var loginModelSubject = PublishSubject<String>()
    
    var loginModelObserver : Observable<String> {
        return loginModelSubject
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
    
    var isSaveButtonEnabel : Observable<Bool>{
        return Observable.combineLatest(isEmailValid , isPasswordValid ){(isEmailEmpty , isPassworlEmpty ) in
            let loginValid = !isEmailEmpty && !isPassworlEmpty
            return loginValid
            
        }
    }
    func getLogin(){
        loadingBehavior.accept(true)
        Auth.auth().signIn(withEmail: emailBehavior.value, password: passwordBehavior.value) { [weak self](authResult, error) in
            guard let self = self else{return}
            self.loadingBehavior.accept(false)
            if(error == nil){
                print("User has Signed In  \(authResult?.user.email ?? "")")
                self.loginModelSubject.onNext((authResult?.user.uid)!)
            } else {
                print("Cant Sign in user\(error!.localizedDescription)")
            }
        }
        
    }
    
}
