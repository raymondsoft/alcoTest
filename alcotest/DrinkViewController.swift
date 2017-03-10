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
    
    
    
    // datas for lastDrinkPickerView
    var lastDrinkTime = [["1", "2", "3", "4", "5"] , ["H", "Min", "s"]]
    
    var user = User()
    
    var drinks : [Drink] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lastDrinkPickerView.delegate = self
        self.lastDrinkPickerView.dataSource = self
        
        self.drinkedBeerLabel.text = "0"
        self.drinkedWineLabel.text = "0"
        self.drinkedWhiskyLabel.text = "0"
        self.drinkedPortoLabel.text = "0"
        
        self.user.nbOfGlasses = [0, 0, 0, 0]
        
        drinks.append(Drink(name: "Bière", alcooholRate: 0.04, glassSize: 330))
        drinks.append(Drink(name: "Vin", alcooholRate: 0.12, glassSize: 120))
        drinks.append(Drink(name: "Whisky", alcooholRate: 0.40, glassSize: 50))
        drinks.append(Drink(name: "Porto", alcooholRate: 0.18, glassSize: 80))
        
        updateView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func updateView(){
        updateLabels()
        updateRate()
        updateAlcoholLevelProgressView()
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
        if (alcoholeLevel > Float(firstAlcooholRate)) {
            self.alcoholLevelProgressView.progressTintColor = UIColor.orange
        }
        if(alcoholeLevel > 1 ){
            self.alcoholLevelProgressView.progressTintColor = UIColor.red
            }
        
        self.alcoholLevelProgressView.setProgress(alcoholeLevel, animated: true)
    }

    

}
