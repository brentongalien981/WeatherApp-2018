import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


// ###################################################################################
// ###################################################################################
// IMOW: Conforming to the protocol "ChangeCityDelegate" is like saying:
// Hey, me as class "WeatherViewController", I want to do that role. So delegate me.
// 1) But the protocol would ask, are you capable of doing / handling the responsibilities / functions?
// To answer yes, you need to declare / define / implement those functions in your class..

// 2) And also, as a final step, you "WeatherViewController" the aspiring delegate need to tell / enlist to
// mother class "ChangeCityViewController" that you actually are doing this role..
// Ex: motherClassObj.delegate = self
// And that line of code will be called in func prepare(for segue...)
// ###################################################################################
// ###################################################################################
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "39599847a3bcd5588cfe55283dbd08a9"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel() 
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        // Asynchronous method.
        locationManager.startUpdatingLocation()
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Success! Got the weather data..")
                
                // This JSON() method is from SwiftyJSON
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Error with connection issues"
            }
        }
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            
//            for object in photos {
//                let url = object.url
//            }
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }

    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Angela says that the last index contains the most recent, and most accurate location.
        // Let's test it out..
        let location = locations[locations.count - 1]
        
        // If the location is valid..
        if location.horizontalAccuracy > 0 {
            // Once we get a valid location, stop locationManager from
            // keep on retrieving locations, 'cause it drains the battery.
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude: \(location.coordinate.longitude)")
            print("latitude: \(location.coordinate.latitude)")
            

            //
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            
            //
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        print(city)
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        
        //
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "randomSegue" {
            let destinationVC = segue.destination as! RandomViewController
            destinationVC.textReceived = textField.text
        }
        else if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
    
    
    // MARK: - Extra code for segue transitions...
    @IBAction func showRandomVC(_ sender: Any) {
        performSegue(withIdentifier: "randomSegue", sender: self)
    }
    
    
}


