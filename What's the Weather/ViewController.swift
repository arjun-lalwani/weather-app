//
//  ViewController.swift
//  What's the Weather
//
//  Created by Arjun Lalwani on 06/11/16.
//  Copyright © 2016 Arjun Lalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        
        // converting space into - because that's how the URL will read it.
        if let weatherUrl = URL(string: "http://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
            let request = NSMutableURLRequest(url: weatherUrl)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, respone, error in // this task is a closure, it's happening in the main thread.
                
                var message = "Not found"

                if error != nil {
                    
                    print (error!)
                    
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        // This makes the first String in array equal to everything in page source
                        // and the second item of the array is everything after the above string.
                        if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                            
                            if contentArray.count > 1 { // to make sure that contentArray has items in it as we don't know if the page code changed or not..
                                
                                stringSeperator = "</span"
                                
                                // further seperates the second part of the source code with the stringSeperator
                                // this array will only have the part of the message we want from the website.
                                let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                
                                if newContentArray.count > 1 {
                                    
                                    // got degree message by pressing -> option + shift + 8
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    
                                    print (message)
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
                
                if message == "Not Found" {
                    
                    print ("Weather in city could not be found. Please try again.")
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.resultLabel.text = message // use self. because you are accessing something outside the closure, from the view controller.
                    
                })
            }
            
            task.resume()
        } else {
            
            // not a valid url
            resultLabel.text = "Weather in city could not be found. Please try again."
            
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

