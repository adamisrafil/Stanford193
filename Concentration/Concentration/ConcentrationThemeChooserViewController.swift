//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Adam Israfil on 1/23/20.
//  Copyright © 2020 Adam Israfil. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    let themes = [
        "Sports" : ["⚽️","🏀","🏈","⚾️","🏓","🎾","🏐","🎱","🥏","🛹","🥅","🥌","🏂"],
        "Animals" : ["🐶","🐱","🐧","🦁","🐨","🦊","🐼","🐻","🐣","🐯","🙉","🐔","🐙"],
        "Face Emojis" : ["😀","😇","😂","🥰","😎","🤪","🧐","🥳","🤯","😱","😭","😧","🙁"],
        "Funny Emojis" : ["🤬","😈","👻","💩","🖕🏻","💪🏻","🤖","👀","🤮","🥴","🥶","💀","👽"],
        "Vehicles" : ["🚗","🛴","🚒","🛸","🛺","✈️","🚉","🏎","🚲","🚞","🚁","🛶","🦽"],
        "Foods" : ["🍏","🥑","🍆","🍑","🥩","🥓","🍗","🍕","🌮","🍔","🍒","🍟","🧀"],
        "Random" : ConcentrationViewController().getRandomTheme()
    ]
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
