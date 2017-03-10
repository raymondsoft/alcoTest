//
//  ProfilViewController.swift
//  alcotest
//
//  Created by etudiant-09 on 07/03/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var weightLabel: UILabel!

    @IBOutlet weak var weightPickerView: UIPickerView!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var AlcoholemieRate: UILabel!
    
    var weightDataArray : [Int] = []
    
    var utilisateur : User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1...40 {
            weightDataArray.append(index * 5)
            
        }
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
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
    

//
//    override func viewWillAppear(_ animated: Bool) {
//        weightLabel.text = weightDataArray[weightPickerView.selectedRow(inComponent: 1)]
//    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(weightDataArray[row]) kg"
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        utilisateur.weight = weightDataArray[row]
        updateView()
    }
    
    
    func updateView(){
        genderSegmentedControl.selectedSegmentIndex = utilisateur.gender.rawValue
        weightPickerView.selectRow( (utilisateur.weight/5) - 1 , inComponent: 0, animated: true)
        self.weightLabel.text = "Votre poids : \(self.utilisateur.weight) kg"
        self.AlcoholemieRate.text = "Taux d'alcoolémie avant les changements : \(self.utilisateur.alcoholRate.toFormattedString(2)!) g/l"
        
        if(utilisateur.gender == Gender.man){
            genderSegmentedControl.tintColor = UIColor.blue
        } else {
            genderSegmentedControl.tintColor = UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    
    @IBAction func genderSegmentedControlTapped(_ sender: UISegmentedControl) {
        if (self.genderSegmentedControl.selectedSegmentIndex == 0){
            utilisateur.gender = Gender.man
        }
        else {
            utilisateur.gender = Gender.woman
        }
        updateView()
    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        utilisateur.persistData()
//    }
//    
    
}




















