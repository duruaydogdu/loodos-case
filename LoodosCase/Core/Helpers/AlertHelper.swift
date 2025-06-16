//
//  AlertHelper.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation
import UIKit

enum AlertHelper {
    
    static func showRetryAlert(on viewController: UIViewController,
                                title: String,
                                message: String,
                                retryButtonTitle: String = "Tekrar Dene",
                                onRetry: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: retryButtonTitle, style: .default) { _ in
            onRetry()
        }
        
        alert.addAction(retryAction)
        viewController.present(alert, animated: true)
    }
}

// static yerine protocol tabanlı alert gösterimi de yapılabilir.
