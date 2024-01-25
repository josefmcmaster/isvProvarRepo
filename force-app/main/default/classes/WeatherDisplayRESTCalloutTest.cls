@isTest
global class WeatherDisplayRESTCalloutTest{

    @isTest
    static void getWeatherDataTestCallout()
    {
        Location__c testLocation = new Location__c(Name='Test Location', Longitude__c = 1.0, Latitude__c = 50.0);
        insert testLocation;


        test.startTest();
        WeatherInfo__c weatherRecord = WeatherDisplayRESTCallout.getWeatherData((String)testLocation.Id, '1.0','5.0');
        test.stopTest();

        System.assertEquals(weatherRecord.Temperature__c, 10.00, 'The Temp returned was not as expected or null.');
        System.assertEquals(weatherRecord.Wind_Gust__c, 3.00, 'The Wind Gust returned was not as expected or null.');
        System.assertEquals(weatherRecord.Wind_Speed__c, 15.00, 'The Wind Speed returned was not as expected or null.');
        System.assertEquals(weatherRecord.Description__c, 'test', 'The Description returned was not as expected or null.');
    }

    
    @isTest
    static void incorrectIDWeatherDataTestCallout()
    {
        Location__c testLocation = new Location__c(Name='Test Location', Longitude__c = 1.0, Latitude__c = 50.0);
        insert testLocation;

        try 
        {
            
            WeatherInfo__c weatherRecord = WeatherDisplayRESTCallout.getWeatherData('FAKEID', '10.0','28.0');
            
        } 
        catch (Exception e) 
        {
            Assert.areEqual(e, 'System.StringException: Invalid id: FAKEID', 'An error should be thrown if the Location ID does not exist');
        }
    }


    @isTest
    static void testParse() {
        string json = '{'+
        '    "main": {'+
        '        "temp": 300.96,'+
        '        "feels_like": 304.5,'+
        '        "temp_min": 300.96,'+
        '        "temp_max": 300.96,'+
        '        "pressure": 1013,'+
        '        "humidity": 78,'+
        '        "sea_level": 1013,'+
        '        "grnd_level": 1013'+
        '    },'+
        '    "visibility": 10000,'+
        '    "wind": {'+
        '        "speed": 3,'+
        '        "deg": 144,'+
        '        "gust": 3.01'+
        '    }'+
        '}';

        WeatherInfo obj = WeatherInfo.parse(json);
        System.assert(obj.coord == null);
		System.assert(obj.main.temp != null);
        System.assert(obj.main.temp_min != null);
        System.assert(obj.main.temp_max != null);
        System.assert(obj.wind.speed != null);
        System.assert(obj.wind.deg != null);
	}

}




    
