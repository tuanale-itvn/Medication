//
//  TGLoginViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/26/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TGLoginViewController: UIViewController {

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

enum StoryboardName: String{
    case Main = "Main", Home = "Home", Notice = "Notice", Transactions = "Transactions" , MyAccount = "MyAccount" , Login = "LoginVC"
}


extension UIStoryboard {
    static func storyboard(name: StoryboardName) -> UIStoryboard{
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
    
    func viewController(aClass: AnyClass) -> UIViewController{
        return self.instantiateViewController(withIdentifier: String.className(aClass: aClass))
    }
}


extension String {
//    public var appLocalizedString: String {
//        return LocalizationManager.shared.localizedString(forKey: self, value: "") ?? self
//    }
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
