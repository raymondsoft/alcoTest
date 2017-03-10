//
//  DrinkViewController.swift
//  alcotest
//
//  Created by etudiant-09 on 07/03/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var addBeerButton: UIButton!
    @IBOutlet weak var removeBeerButton: UIButton!
    @IBOutlet weak var drinkedBeerLabel: UILabel!
    @IBOutlet weak var blurBeerImage: UIImageView!
    
    @IBOutlet weak var addWineButton: UIButton!
    @IBOutlet weak var removeWineButton: UIButton!
    @IBOutlet weak var drinkedWineLabel: UILabel!
    
    @IBOutlet weak var addWhiskyButton: UIButton!
    @IBOutlet weak var removeWhiskyButton: UIButton!
    @IBOutlet weak var drinkedWhiskyLabel: UILabel!
    
    
    @IBOutlet weak var addPortoButton: UIButton!
    @IBOutlet weak var removePortoButton: UIButton!
    @IBOutlet weak var drinkedPortoLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var lastDrinkPickerView: UIPickerView!
    
    @IBOutlet weak var alcoholLevelLabel: UILabel!
    @IBOutlet weak var alcoholLevelProgressView: UIProgressView!
    
    
    @IBOutlet var AllElements: [UIView]!
    
    @IBOutlet var blurElements: [UIImageView]!
    
    // datas for lastDrinkPickerView
    var lastDrinkTime = [["1", "2", "3", "4", "5"] , ["H", "Min", "s"]]
    
    var user = User()
    
    var drinks : [Drink] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set pickerView delegates and dataSource
        
        self.lastDrinkPickerView.delegate = self
        self.lastDrinkPickerView.dataSource = self
        
        
        
        // Set removes Buttons round
        
        self.removeBeerButton.layer.cornerRadius = self.removeBeerButton.frame.width / 2
        self.removeBeerButton.clipsToBounds = true
        
        self.removeWineButton.layer.cornerRadius = self.removeWineButton.frame.width / 2
        self.removeWineButton.clipsToBounds = true
        
        self.removeWhiskyButton.layer.cornerRadius = self.removeWhiskyButton.frame.width / 2
        self.removeWhiskyButton.clipsToBounds = true
        
        self.removePortoButton.layer.cornerRadius = self.removePortoButton.frame.width / 2
        self.removePortoButton.clipsToBounds = true
        
        
        self.removeBeerButton.imageView?.backgroundColor = UIColor.red
        
        // Set the drinks array
        
        drinks.append(Drink(name: "Bière", alcooholRate: 0.04, glassSize: 330))
        drinks.append(Drink(name: "Vin", alcooholRate: 0.12, glassSize: 120))
        drinks.append(Drink(name: "Whisky", alcooholRate: 0.40, glassSize: 50))
        drinks.append(Drink(name: "Porto", alcooholRate: 0.18, glassSize: 80))
        
        
        
        // the reset method updates Views
        reset()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    // --------   SEGUE METHODS     --------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ProfilViewController {
            destinationVC.utilisateur = self.user
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // user.loadData()
        updateView()
    }
    
    
    // --------   FOR PICKERVIEW PROTOCOL     --------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lastDrinkTime[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lastDrinkTime[component][row]
    }
    
    
    // --------   BUTTONS ACTIONS     --------

    @IBAction func profileButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "moveToProfile", sender: self)
    }
    
    @IBAction func drinkGlassAction(_ sender: UIButton) {
        user.nbOfGlasses[sender.tag] += 1
        updateView()
    }
 
    @IBAction func removeGlassAction(_ sender: UIButton) {

        if (user.nbOfGlasses[sender.tag] > 0){
            user.nbOfGlasses[sender.tag] -= 1
        }
        updateView()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        reset()
    }

    
    
    // --------   UPDATES VIEW METHODS     ----------------------------------
    
    
    func updateView(){
        updateLabels()
        updateRate()
        updateAlcoholLevelProgressView()
        updateBackgroundColor()
        updateAlphaImages()
    }
    
    func updateLabels(){
        updateNumberOfDrinksLabels()
        self.descriptionLabel.text = "\(self.user.gender) \(self.user.weight) kg"
    }
    
    func updateNumberOfDrinksLabels(){
        drinkedBeerLabel.text    = "\(user.nbOfGlasses[0])"
        drinkedWineLabel.text    = "\(user.nbOfGlasses[1])"
        drinkedWhiskyLabel.text  = "\(user.nbOfGlasses[2])"
        drinkedPortoLabel.text   = "\(user.nbOfGlasses[3])"
    }

    func updateRate(){
        if let alcoholRate = user.computeAlcooholRate(drinks: drinks).toFormattedString(2) {
            alcoholLevelLabel.text = "\(alcoholRate) g/l"
        }
        else {
            alcoholLevelLabel.text = "0.00 g/l"
        }
    }
    
    func updateAlcoholLevelProgressView() {
        let alcoholeLevel : Float = Float(self.user.computeAlcooholRate(drinks: drinks) / maxAlcooholRate)
        self.alcoholLevelProgressView.progressTintColor = UIColor.blue
        if (alcoholeLevel > Float(firstAlcooholRate / maxAlcooholRate)) {
            self.alcoholLevelProgressView.progressTintColor = UIColor.orange
        }
        if(alcoholeLevel > 1 ){
            self.alcoholLevelProgressView.progressTintColor = UIColor.red
            }
        
        self.alcoholLevelProgressView.setProgress(alcoholeLevel, animated: true)
    }
    
    func updateBackgroundColor(){
        let ratioPercentage = user.alcoholRate/maxAlcooholRate
        let ratio = ratioPercentage > 1.0 ? 1.0 : ratioPercentage
 
        let red     = Float(ratio )
        let green   = Float(1.0 - ratio)
        let blue    = Float(0.0)

        let backgroundColor = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
        print(backgroundColor)
        self.view.backgroundColor = backgroundColor
    }

    func updateAlphaImages(){
        let ratioPercentage = user.alcoholRate/maxAlcooholRate
        let ratio = ratioPercentage > 1.0 ? 1.0 : ratioPercentage
        
//        self.blurBeerImage.alpha = CGFloat(ratio / 2)
//        self.addBeerButton.imageView?.alpha = CGFloat(1 - (ratio / 2) )
//        
//        self.addBeerButton.layer.removeAllAnimations()
//        self.blurBeerImage.layer.removeAllAnimations()
        
        
        for element in AllElements {
            element.alpha  = CGFloat(1 - (ratio / 2) )
            element.layer.removeAllAnimations()
        }
        
        for blurElement in blurElements {
            blurElement.alpha = CGFloat(ratio / 2)
            blurElement.layer.removeAllAnimations()
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction.union(UIViewAnimationOptions.repeat.union(UIViewAnimationOptions.autoreverse)), animations: {
            
            for element in self.AllElements {
                let rnd = Double(arc4random_uniform(UInt32(6)))
                element.frame.origin.x += CGFloat((ratio) * 2 * (rnd - 3))
                element.frame.origin.y += CGFloat((ratio) * 2 * (rnd - 3))
            }
            
            for blurElement in self.blurElements {
                let rnd = Double(arc4random_uniform(UInt32(6)))
                blurElement.frame.origin.x -= CGFloat((ratio) * 2 * (rnd - 3))
                blurElement.frame.origin.y -= CGFloat((ratio) * 2 * (rnd - 3))
            }
            
//            self.addBeerButton.frame.origin.x += CGFloat((ratio)*2)
//            self.blurBeerImage.frame.origin.x -= CGFloat((ratio)*2)
//            self.addBeerButton.frame.origin.y += CGFloat((ratio)*2)
//            self.blurBeerImage.frame.origin.y -= CGFloat((ratio)*2)
        }, completion: nil)
        
//        
//        UIView.animate(withDuration: 2, delay: 0, options: (UIViewAnimationOptions.repeat), animations: {
//            self.addBeerButton.frame.origin.x += CGFloat((ratio)*50)
//        }, completion: nil)
        
        
    
    }
    
    
    // --------   OTHERS METHODS     --------
    
    func reset()
    {
        self.user.nbOfGlasses = [0, 0, 0, 0]
        updateView()
    }
    

}

extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
