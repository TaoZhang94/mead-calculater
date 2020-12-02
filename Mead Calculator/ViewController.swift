//
//  ViewController.swift
//  Mead Calculator
//
//  Created by ZHANG, Tao - zhaty039 on 28/9/19.
//  Copyright © 2019 ZHANG, Tao - zhaty039. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Home page components initiate
    @IBOutlet weak var lb_title: UILabel!

    @IBOutlet weak var tf_weight: UITextField!
    @IBOutlet weak var lb_weight: UILabel!
    @IBOutlet weak var tf_volume: UITextField!
    @IBOutlet weak var lb_volume: UILabel!
    @IBOutlet weak var tf_yeast: UITextField!
    
    @IBOutlet weak var seg_metric: UISegmentedControl!
    @IBOutlet weak var lb_alcohol: UILabel!
    @IBOutlet weak var lb_sg: UILabel!
    @IBOutlet weak var btn_hw: UIButton!
    
    //Home page variables

    var weight: Double = 0
    var volume: Double = 0
    var yeastTollerance: Double = 0
    var alcohol: Double = 0
    var specificGravity: Double = 0
    var finalSG: Double = 0
    
    var alocholPercentages: String = ""
    
    //Honey calculator componnets initiate
    @IBOutlet weak var lb_volumeHC: UILabel!
    @IBOutlet weak var lb_alcoholPercentage: UITextField!
    
    
    @IBOutlet weak var lb_weightHC: UILabel!
    @IBOutlet weak var tf_alcoholPercentage: UITextField!
    @IBOutlet weak var tf_volumeHC: UITextField!
    
    @IBOutlet weak var lb_predictedWeight: UILabel!
    @IBOutlet weak var seg_hc: UISegmentedControl!
    
    var predictedWeight: Double = 0
    var volume_hc: Double = 0
    var inputAlcohol: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    /**
     The action that Calculate button making
     Basically checks if either of the textboxes is empty or non-numeric characters contains before calculating
     - Parameter: sender

     - Returns: void
     */
    @IBAction func btn_calculate(_ sender: Any) {
        let yeastEmpty = tf_yeast.text!.isEmpty
        
        //if the textboxes are filled and no yeast entered, use output the specific gravity from formular specific gravity = 1 + ((pounds of honey / gallons water) * 0.035)
        if (isNumeric(input: tf_weight.text!) && isNumeric(input: tf_volume.text!) && yeastEmpty){
            weight = Double(tf_weight.text!)!
            volume = Double(tf_volume.text!)!
            
            //when imperial is selected
            if(seg_metric.selectedSegmentIndex == 0){
                alcohol = calculateInImperial(weight: weight, volume: volume, type: "alcohol")
                specificGravity = calculateInImperial(weight: weight, volume: volume, type: "spg")
            }
            //when metric is selected
            else{
                alcohol = calculateInMetric(weight: weight, volume: volume, type: "alcohol")
                specificGravity = calculateInMetric(weight: weight, volume: volume, type: "spg")
            }
            
            lb_alcohol.text = String(alcohol) + "%"
            lb_sg.text = String(specificGravity)
        }
        
        //when yeast tollerance is entered
        else if (isNumeric(input: tf_weight.text!) && isNumeric(input: tf_volume.text!) && isNumeric(input: tf_yeast.text!)){
            
            //check is the yeast tollerance valid?
            if(Double(tf_yeast.text!)! > 1 || Double(tf_yeast.text!)! <= 0){
                let alert = UIAlertController(title: "Invalid input", message: "The yeast tollerance can only between 0 to 1", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
                
            else{
                weight = Double(tf_weight.text!)!
                volume = Double(tf_volume.text!)!
                yeastTollerance = Double(tf_yeast.text!)!
                
                //imperial
                if(seg_metric.selectedSegmentIndex == 0){
                    alcohol = calculateInImperial(weight: weight, volume: volume, type: "alcohol")
                    specificGravity = calculateInImperial(weight: weight, volume: volume, type: "spg")
                }
                //metric
                else{
                    alcohol = calculateInMetric(weight: weight, volume: volume, type: "alcohol")
                    specificGravity = calculateInMetric(weight: weight, volume: volume, type: "spg")
                    
                }
                
                alocholPercentages = String(alcohol)
                
                lb_alcohol.text = String(alcohol) + "%"
  
                //final specific gravity in three decimal places
                finalSG = (specificGravity - 1) / alcohol * (alcohol - yeastTollerance * 100) + 1
                finalSG = Double(round(1000 * finalSG) / 1000)
                
                lb_sg.text = String(finalSG)
            }

            
        }
        //show alert when the input are not valid
        else{
            let alert = UIAlertController(title: "Invalid input", message: "The text boxes of weight and volume cannot be empty and only accept numeric characters!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)

        }

    }
    
    /**
     Change the text of labels and textfield when changing the metric
     - Parameter sender
     
     - Returns: void
     */
    @IBAction func seg_metric(_ sender: Any) {
        
        if (isNumeric(input: tf_weight.text!) && isNumeric(input: tf_volume.text!)){
            
            weight = Double(tf_weight.text!)!
            volume = Double(tf_volume.text!)!
        }
        switch seg_metric.selectedSegmentIndex
        {
            //imperial
        case 0:
            
            lb_weight.text = "Enter the weight of honey (Pounds)"
            lb_volume.text = "Enter the weight of water (Gallons)"
            
            changeMetric()
        case 1:
            //metric
            lb_weight.text = "Enter the weight of honey (Kg)"
            lb_volume.text = "Enter the weight of water (Litres)"
            
            changeMetric()
        default:
            break
        }
    }
    
    /**
     Go honey weight calculator page
     - Parameter sender
     
     - Returns: void
     */
    @IBAction func btn_getHoneyWeight(_ sender: Any) {
        performSegue(withIdentifier: "showHoneyCalculatorPage", sender: self)
        
        
    }
    
    /**
     Validate the input. It has to be not null and numeric
     - Parameter String in the textfield
     
     - Returns: bool
     */
    func isNumeric(input: String) -> Bool {
        
        if(input.isEmpty){
            return false
        }
        return Double(input) != nil
    }

    /**
     Change the metric of textfield base on the selected segment index
     To reduce the tollerance, the result should be in three decimal places
     - Parameter None
     
     - Returns: void
     */
    func changeMetric(){
        
        switch seg_metric.selectedSegmentIndex {
            
            //Imperial
        case 0:
            weight = round(1000 * weight * 2.20462) / 1000
            volume = round(1000 * volume * 0.264172) / 1000
            
            tf_weight.text = String(weight)
            tf_volume.text = String(volume)
            
            //Metric
        case 1:
            weight = round(1000 * weight / 2.20462) / 1000
            volume = round(1000 * volume / 0.264172) / 1000
            
            tf_weight.text = String(weight)
            tf_volume.text = String(volume)
        default:
            break
        }
    }
    
    /**
     Calculate the alcohol percentage or predict specific gravity in imperial based on the textfield input
     
     - Parameter
                -weight: the weight of honey
                -volume: the volume of water
                -type: the string that determines which one should be calculated (alcohol or specific gravity)
     - Returns: a double of predicted alcohol percentage or specific gravity
     */
    func calculateInImperial(weight: Double, volume: Double, type: String) -> Double{
        
        if(type == "alcohol"){
            let alcoholPredict: Double = Double(round(100 * (weight / volume * 5)) / 100)

            return alcoholPredict
        }
        
        let specificGravityPredict: Double = 1 + Double(round(1000 * weight / volume * 0.035) / 1000)
        
        return specificGravityPredict
        
    }
    
    /**
     Calculate the alcohol percentage or predict specific gravity in metric based on the textfield input
     
     - Parameter
             -weight: the weight of honey
             -volume: the volume of water
             -type: the string that determines which one should be calculated (alcohol or specific gravity)
     - Returns: a double of predicted alcohol percentage or specific gravity
     */
    
    func calculateInMetric(weight: Double, volume: Double, type: String) -> Double{
        
        let weightNum: Double = weight * 2.20462
        let volumeNum: Double = volume * 0.264172
        
        if(type == "alcohol"){
            let alcoholPredict: Double = Double(round(100 * (weightNum / volumeNum * 5)) / 100)
            
            return alcoholPredict
        }
        
        let specificGravityPredict: Double = 1 + Double(round(1000 * weightNum / volumeNum * 0.035) / 1000)
        
        return specificGravityPredict
    }
    
    //Honey calculator components
    
    /**
     Back to home page
     
     - Parameter sender

     - Returns: void
     */
    @IBAction func exitHoneyCal(_ sender: Any) {
        performSegue(withIdentifier: "homePage", sender: self)
    }

    /**
     Change the text of labels and textfield when changing the metric
     - Parameter sender
     
     - Returns: void
     */
    @IBAction func seg_hc(_ sender: Any) {
        
        //if the volume is empty, set to 0 as default to prevent crashing
        if (!isNumeric(input: tf_alcoholPercentage.text!) && !isNumeric(input: tf_volumeHC.text!)){
            
            tf_volumeHC.text = "0"
        }
        
        switch seg_hc.selectedSegmentIndex
        {
        case 0:
            
            lb_volumeHC.text = "Enter the weight of honey (Gallons)"
            changeMetricHC()
            lb_weightHC.text = String(predictedWeight) + " pounds"
            

            
        case 1:
            lb_volumeHC.text = "Enter the weight of honey (Litres)"
            changeMetricHC()
            lb_weightHC.text = String(predictedWeight) + " Kg"


        default:
            break
        }
    }
    
    /**
     Calculate button on honey weight calculator page
     - Parameter sender
     - Returns:void
     */
    
    @IBAction func calculateHC(_ sender: Any) {
        //validate the input
        if (isNumeric(input: tf_volumeHC.text!) && isNumeric(input: tf_alcoholPercentage.text!)){

            //ensure the alcohol percentage is between 0 to 1
            if(Double(tf_alcoholPercentage.text!)! > 1 || Double(tf_alcoholPercentage.text!)! <= 0){
                let alert = UIAlertController(title: "Invalid input", message: "The alcohol percentages can only between 0 to 1", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }

            else{
                inputAlcohol = Double(tf_alcoholPercentage.text!)!
                volume_hc = Double(tf_volumeHC.text!)!

                //imperial
                if(seg_hc.selectedSegmentIndex == 0){
                    predictedWeight = calculateWeightInImperial(alcoholPercentage: inputAlcohol, volume: volume_hc)
                    var optWeight: String = String(predictedWeight)
                    lb_weightHC.text = String(predictedWeight) + " pounds"
                }
                    
                //metric
                else{
                    predictedWeight = calculateWeightInMetric(alcoholPercentage: inputAlcohol, volume: volume_hc)
                    var optWeight: String = String(predictedWeight)
                    lb_weightHC.text = String(predictedWeight) + " Kg"
                }

            }

        }

        else{
            let alert = UIAlertController(title: "Invalid input", message: "The text boxes of alcohol percentages and volume cannot be empty and only accept numeric characters!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)

        }

    }
    /**
     Calculate the honey weight in imperial based on the textfield input
     
     - Parameter
             -alcoholPercentage: expected alcohol percentage
             -volume: the volume of water

     - Returns: a double of predicted honey weight
     */
    func calculateWeightInImperial(alcoholPercentage: Double, volume: Double) -> Double{
        
        var weightPredict: Double = 0
        weightPredict = alcoholPercentage * volume / 5 * 100
        
        weightPredict = Double(round(100 * weightPredict) / 100)
        return weightPredict
    }
    
    /**
     Calculate the honey weight in metric based on the textfield input
     
     - Parameter
             -alcoholPercentage: expected alcohol percentage
             -volume: the volume of water
     
     - Returns: a double of predicted honey weight
     */
    func calculateWeightInMetric(alcoholPercentage: Double, volume: Double) -> Double{
        
        let volumeNum: Double = volume * 0.264172
        
        var weightPredict: Double = 0
        weightPredict = alcoholPercentage * volumeNum / 5 * 100
        
        weightPredict = Double(round(100 * weightPredict / 2.20462) / 100)
        return weightPredict
        
    return weightPredict
    }
    
    /**
     Change the metric of textfield base on the selected segment index
     To reduce the tollerance, the result should be in three decimal places
     - Parameter None
     
     - Returns: void
     */
    func changeMetricHC(){
        
        switch seg_hc.selectedSegmentIndex {
            
        case 0:
            
            volume_hc = Double(tf_volumeHC.text!)!
            volume_hc = round(100 * volume_hc * 0.264172) / 100
            tf_volumeHC.text = String(volume_hc)
            
        case 1:
            
            volume_hc = Double(tf_volumeHC.text!)!
            volume_hc = round(100 * volume_hc / 0.264172) / 100
            tf_volumeHC.text = String(volume_hc)
        default:
            break
        }
    }
}

