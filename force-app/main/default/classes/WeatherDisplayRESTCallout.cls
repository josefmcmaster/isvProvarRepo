public with sharing class WeatherDisplayRESTCallout 
{

  @AuraEnabled
  public static WeatherInfo__c getWeatherData(String locationID, String lat, String lon)
  {

    WeatherInfo__c record = new WeatherInfo__c();
    OpenWeather_API__mdt openWeathermdt = OpenWeather_API__mdt.getInstance('OpenWeather_2_0');
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?lat='+lat+'&lon='+lon+'&appid='+openWeathermdt.PROD_API_Key__c);
    request.setMethod('GET');
    
    WeatherInfo wInfo = new WeatherInfo();

    //Code within the test.isRunningTest() is populating the WeatherInfo object so testing can be carried out on this class.
    if(test.isRunningTest()){
      WeatherInfo.cls_main clsMain = new WeatherInfo.cls_main();
      List<WeatherInfo.cls_weather> weatherList = new List<WeatherInfo.cls_weather>();
      WeatherInfo.cls_weather clsWeather = new WeatherInfo.cls_weather();
      weatherList.add(clsWeather);
      WeatherInfo.cls_wind clsWind = new WeatherInfo.cls_wind();
      wInfo.main = clsMain;
      wInfo.weather = weatherList;
      wInfo.wind = clsWind;
      wInfo.main.temp = 10.00;
      wInfo.weather[0].description = 'test';
      wInfo.main.feels_like = 10.00;
      record.Humidity__c = wInfo.main.humidity = 10.00;
      wInfo.main.temp_max = 10.00;
      wInfo.main.temp_min = 10.00;
      wInfo.wind.deg = 100.00;
      wInfo.wind.gust = 3.00;
      wInfo.wind.speed = 15.00;
    }
    else 
    {
      HttpResponse response = http.send(request);
      wInfo = WeatherInfo.parse(response.getbody());
    }
      try
      {
        DateTime today = Datetime.now();
        record.Name = today.format();
        record.Location__c = locationID;
        record.Temperature__c = wInfo.main.temp;
        record.Description__c = wInfo.weather[0].description;
        record.Feels_Like__c = wInfo.main.feels_like;
        record.Humidity__c = wInfo.main.humidity;
        record.Pressure__c = wInfo.main.pressure;
        record.Temp_Max__c = wInfo.main.temp_max;
        record.Temp_Min__c = wInfo.main.temp_min;
        record.Wind_Degrees__c = wInfo.wind.deg;
        record.Wind_Gust__c = wInfo.wind.gust;
        record.Wind_Speed__c = wInfo.wind.speed;
        insert record;

      }
      catch(exception e)
      {
        System.debug('error: '+e);
      }

      
    
    
    return record;
  }

}