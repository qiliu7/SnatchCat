//
//  UIViewController+Alert.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-24.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(title: String?, message: String?, actionHandler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
