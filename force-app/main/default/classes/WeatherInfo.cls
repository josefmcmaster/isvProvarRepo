public class WeatherInfo{
	public cls_coord coord;
	public cls_weather[] weather;
	public String base;	
	public cls_main main;
	public Integer visibility;	
	public cls_wind wind;
	public cls_clouds clouds;
	public Integer dt;	
	public cls_sys sys;
	public Integer timezone;	
	public Integer id;	
	public String name;	
	public Integer cod;	
	public class cls_coord {
		public Double lon;	
		public Double lat;	
	}
	public class cls_weather {
		public Integer id;	
		public String main;	
		public String description;	
		public String icon;	
	}
	public class cls_main {
		public Double temp;	
		public Double feels_like;	
		public Double temp_min;	
		public Double temp_max;	
		public Double pressure;	
		public Double humidity;	
		public Double sea_level;	
		public Double grnd_level;	
	}
	public class cls_wind {
		public Double speed;	
		public Double deg;	
		public Double gust;	
	}
	public class cls_clouds {
		public Double all;	
	}
	public class cls_sys {
		public Integer sunrise;	
		public Integer sunset;	
	}
	public static WeatherInfo parse(String json){
		return (WeatherInfo) System.JSON.deserialize(json, WeatherInfo.class);
	}

    
    
}