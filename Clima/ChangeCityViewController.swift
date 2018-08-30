import UIKit


//Write the protocol declaration here:
// IMOW: A protocol is a role.
protocol ChangeCityDelegate {
    
    // IMOW: This is a handler. You, the chosen one withe a "role" / "the delegate",
    //       can you do this method? Can you handle this method?
    func userEnteredANewCityName(city : String)
}



class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    // IMOW: This is like the class "ChangeCityViewController" saying:
    // Ok, for me to operate well, I need to either do the extra role "ChangeCityDelegate" myself, or
    // I need to assign / delegate it to someone else.
    // But since it is with "?" (an optional), this class doesn't necessarily need to have this role / delegate assigned..
    var delegate : ChangeCityDelegate?

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!

        
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil )
        
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
