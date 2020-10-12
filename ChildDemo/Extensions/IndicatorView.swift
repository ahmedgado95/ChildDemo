//
//  IndicatorView.swift
//  ChildDemo
//
//  Created by ahmed gado on 10/5/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
extension UIViewController {
    func showIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
        activityIndicator.tag = 100 // 100 for example
        
        // before adding it, you need to check if it is already has been added:
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }
        
        view.addSubview(activityIndicator)
    }
    
    func hideIndicator() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        
        // I think you forgot to remove it?
        activityIndicator?.removeFromSuperview()
        
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
  
    func goPush<T:UIViewController>( vc : T.Type )  {
           let identifer = String(describing: T.self)
           if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: identifer) as? T{
               navigationController?.pushViewController(vc, animated: true)
           }
       }
}
