//
//  WelcomeViewController.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 29/07/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    var screen: WelcomeScreen?
    
    override func loadView() {
        super.loadView()
        self.screen = WelcomeScreen()
        self.view = screen
        self.view.backgroundColor = .background
        self.screen?.delegate(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WelcomeViewController: WelcomeScreenDelegate {
    func tappedFirstCategoryButton() {
        navigationController?.pushViewController(CategoryViewController(), animated: true)
    }
}
