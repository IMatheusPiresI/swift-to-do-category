//
//  UIButton + TouchableOpacity.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 29/07/23.
//

import Foundation
import UIKit

extension UIButton {
    func addOpacityEffect() {
        addTarget(self, action: #selector(removeOpacity), for: .touchUpInside)
        addTarget(self, action: #selector(addOpacity), for: .touchDown)
        addTarget(self, action: #selector(removeOpacity), for: .touchDragExit)
    }
    
    @objc private func addOpacity() {
        self.alpha = 0.6
    }
    
    @objc private func removeOpacity() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alpha = 1.0
        }
    }
}
