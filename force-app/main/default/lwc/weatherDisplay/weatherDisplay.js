import { LightningElement, api, wire } from 'lwc';
import getWeatherData from '@salesforce/apex/WeatherDisplayRESTCallout.getWeatherData';
import { getRecord } from "lightning/uiRecordApi";
import LONGITUDE_FIELD from "@salesforce/schema/Location__c.Longitude__c";
import LATITUDE_FIELD from "@salesforce/schema/Location__c.Latitude__c";

const fields = [LATITUDE_FIELD, LONGITUDE_FIELD];


export default class WeatherDisplay extends LightningElement {

    @api recordId;
    test = 'test';
    weatherData;
    disabled = false;

    temp = 'N/A';
    desc = 'N/A';
    feelsLike = 'N/A';
    humidity = 'N/A';
    pressure = 'N/A';
    tempMax = 'N/A';
    tempMin = 'N/A';
    windDeg = 'N/A';
    windGust = 'N/A';
    windSpeed = 'N/A';
    location = 'N/A';
    long;
    lat;

//Retrieves the Location record that the User is currently on
    @wire(getRecord, { recordId: "$recordId", fields })
    wiredLocation({ error, data }) {
        if (data) {
            this.record = data;
            this.long = this.record.fields.Longitude__c.value;
            this.lat = this.record.fields.Latitude__c.value;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    //Calls a GET method to OpenWeather and retrieves weather info based on the passed Latitude and Longtitude stored on the current Location record
    handleCallWeatherREST() {
        getWeatherData({ locationID: this.recordId, lat: this.lat, lon: this.long })
            .then(data => {
                this.weatherData = data;
                this.temp = this.convertKelvinToCelsius(this.weatherData.Temperature__c);
                this.desc = this.weatherData.Description__c;
                this.feelsLike = this.convertKelvinToCelsius(this.weatherData.Feels_Like__c);
                this.humidity = this.weatherData.Humidity__c;
                this.pressure = this.weatherData.Pressure__c;
                this.tempMax = this.convertKelvinToCelsius(this.weatherData.Temp_Max__c);
                this.tempMin = this.convertKelvinToCelsius(this.weatherData.Temp_Min__c);
                this.windDeg = this.weatherData.Wind_Degrees__c;
                this.windGust = this.weatherData.Wind_Gust__c;
                this.windSpeed = this.weatherData.Wind_Speed__c;
                this.location = this.weatherData.Location__c;
                this.disabled = true;
            })
            .catch(error => {
                console.log(error);
            })
    }

//Degress returned by OpenWeather is in Kelvin so this method converts it to Celsius.
    convertKelvinToCelsius(temp) {
        return temp - 273.15;
    }


}