import Foundation
import XCTest
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AlamofireObjectMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResponseObject() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")

        _ = AF.request(URL, method: .get).responseObject { (response: AFDataResponse<WeatherResponse>) in
            expectation.fulfill()
            
            let mappedObject = response.value
            
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testResponseObjectMapToObject() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        let weatherResponse = WeatherResponse()
        weatherResponse.date = Date()
        
        _ = AF.request(URL, method: .get).responseObject(mapToObject: weatherResponse) { (response: AFDataResponse<WeatherResponse>) in
            expectation.fulfill()
            
            let mappedObject = response.value
            print(weatherResponse)
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.date, "Date should not be nil") // Date is not in JSON but should not be nil because we mapped onto an existing object with a date set
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testResponseObjectWithKeyPath() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/2ee8f34d21e8febfdefb2b3a403f18a43818d70a/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseObject(keyPath: "data") { (response: AFDataResponse<WeatherResponse>) in
            expectation.fulfill()
            
            let mappedObject = response.value
            
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testResponseObjectWithNestedKeyPath() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/97231a04e6e4970612efcc0b7e0c125a83e3de6e/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseObject(keyPath: "response.data") { (response: AFDataResponse<WeatherResponse>) in
            expectation.fulfill()
            
            let mappedObject = response.value
            
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }

    func testResponseArray() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/f583be1121dbc5e9b0381b3017718a70c31054f7/sample_array_json"
        let expectation = self.expectation(description: "\(URL)")

        _ = AF.request(URL, method: .get).responseArray { (response: AFDataResponse<[Forecast]>) in
            expectation.fulfill()
            
            let mappedArray = response.value
            
            XCTAssertNotNil(mappedArray, "Response should not be nil")
            
            XCTAssertTrue(mappedArray?.count == 3, "Didn't parse correct amount of objects")
            
            for forecast in mappedArray! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }

        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testArrayResponseArrayWithKeyPath() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseArray(keyPath: "three_day_forecast") { (response: AFDataResponse<[Forecast]>) in
        
            expectation.fulfill()
            
            let mappedArray = response.value
            
            XCTAssertNotNil(mappedArray, "Response should not be nil")
            
            for forecast in mappedArray! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testArrayResponseArrayWithNestedKeyPath() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/97231a04e6e4970612efcc0b7e0c125a83e3de6e/sample_keypath_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseArray(keyPath: "response.data.three_day_forecast") { (response: AFDataResponse<[Forecast]>) in
            
            expectation.fulfill()
            
            let mappedArray = response.value
            
            XCTAssertNotNil(mappedArray, "Response should not be nil")
            
            for forecast in mappedArray! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    // MARK: - Immutable Tests
    
    func testResponseImmutableObject() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseObject { (response: AFDataResponse<WeatherResponseImmutable>) in
            expectation.fulfill()
            
            let mappedObject = response.value
            
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
    func testResponseImmutableArray() {
        // This is an example of a functional test case.
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/f583be1121dbc5e9b0381b3017718a70c31054f7/sample_array_json"
        let expectation = self.expectation(description: "\(URL)")
        
        _ = AF.request(URL, method: .get).responseArray { (response: AFDataResponse<[ImmutableForecast]>) in
            expectation.fulfill()
            
            let mappedArray = response.value
            
            XCTAssertNotNil(mappedArray, "Response should not be nil")
            
            XCTAssertTrue(mappedArray?.count == 3, "Didn't parse correct amount of objects")
            
            for forecast in mappedArray! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, "\(String(describing: error))")
        }
    }
    
}

// MARK: - Response classes

// MARK: - ImmutableMappable

class ImmutableWeatherResponse: ImmutableMappable {
    let location: String
    let threeDayForecast: [ImmutableForecast]
    
    required init(map: Map) throws {
        location = try map.value("location")
        threeDayForecast = try map.value("three_day_forecast")
    }

    func mapping(map: Map) {
        location >>> map["location"]
        threeDayForecast >>> map["three_day_forecast"]
    }
}

class ImmutableForecast: ImmutableMappable {
    let day: String
    let temperature: Int
    let conditions: String
    
    required init(map: Map) throws {
        day = try map.value("day")
        temperature = try map.value("temperature")
        conditions = try map.value("conditions")
    }
    
    func mapping(map: Map) {
        day >>> map["day"]
        temperature >>> map["temperature"]
        conditions >>> map["conditions"]
    }
    
}

// MARK: - Mappable

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    var date: Date?
    
    init(){}
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}
    
struct WeatherResponseImmutable: ImmutableMappable {
    let location: String
    var threeDayForecast: [Forecast]
    var date: Date?
    
    init(map: Map) throws {
        location = try map.value("location")
        threeDayForecast = try map.value("three_day_forecast")
    }
    
    func mapping(map: Map) {
        location >>> map["location"]
        threeDayForecast >>> map["three_day_forecast"]
    }
}

struct ForecastImmutable: ImmutableMappable {
    let day: String
    var temperature: Int
    var conditions: String?
    
    init(map: Map) throws {
        day = try map.value("day")
        temperature = try map.value("temperature")
        conditions = try? map.value("conditions")
    }
    
    func mapping(map: Map) {
        day >>> map["day"]
        temperature >>> map["temperature"]
        conditions >>> map["conditions"]
    }
}
