//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI
import CoreLocation
struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @EnvironmentObject var googlePlacesViewModel: GooglePlacesViewModel
    @State private var isLoading = false
    @State private var temporaryCity = "London"
    
    var body: some View {
        ZStack{
            if let currentWeather = weatherMapViewModel.weatherDataModel?.current {
                            let backgroundImageName = getBackgroundImageName(for: currentWeather.weather[0].icon)
                            
                Image(backgroundImageName).resizable().aspectRatio(contentMode: .fill).frame( height: 1000).edgesIgnoringSafeArea(.all)
                        } else {
                            Image("day_cloud")
                        }
            
            
            
            VStack{
                HStack{
                    
                    Text("Change Location")
                    
                    TextField("Enter New Location", text: $temporaryCity)
                        .onSubmit {
                            submit()
                            Attractions()
                        }
                }
                .bold()
                .font(.system(size: 20))
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Arial", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15)
                VStack{
                    HStack{
                        Text("Current Location: \(weatherMapViewModel.city)")
                    }
                    .bold()
                    .font(.system(size: 20))
                    .padding(10)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Arial", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(15)
                    let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)
                    let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
                    Text(formattedDate)
                        .padding()
                        .font(.title)
                        .shadow(color: .black, radius: 1)
                    
                    VStack(alignment: .center) {
                        if let currentWeather = weatherMapViewModel.weatherDataModel?.current {
                            
   
                            
                            HStack{
                                Grid {
                                    GridRow {
                                        if let currentWeather = weatherMapViewModel.weatherDataModel?.current {
                                            
                                            
                                            AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(currentWeather.weather[0].icon)@2x.png"))
                                            
                                        } else {
                                            Text("Weather data not available")
                                        }
                                        
                                        Text("\(currentWeather.weather[0].main.rawValue)")
                                    }
                                    GridRow {
                                        Image(.temperature).resizable().frame(width:50,height:50)
                                        Text("Temp: \(currentWeather.temp, specifier: "%.0f") ºC")
                                    }
                                    GridRow {
                                        Image(.humidity).resizable().frame(width:50,height:50)
                                        Text("Humidity: \(currentWeather.humidity)%")
                                    }
                                    GridRow{
                                        Image(.pressure).resizable().frame(width:50,height:50)
                                        Text("Pressure: \(currentWeather.pressure) hPa")
                                    }
                                    GridRow{
                                        Image(.temperature).resizable().frame(width:50,height:50)
                                        Text("Windspeed: \(currentWeather.windSpeed, specifier: "%.0f") mph")
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        } else {
                            Text("Weather data unavailable")
                                .font(.system(size: 25, weight: .medium))
                            Grid {
                               
                                
                                GridRow {
                                    Image(.temperature).resizable().frame(width:50,height:50)
                                    Text("Temp: N/A")
                                }
                                GridRow {
                                    Image(.humidity).resizable().frame(width:50,height:50)
                                    Text("Humidity: N/A")
                                }
                                GridRow{
                                    Image(.pressure).resizable().frame(width:50,height:50)
                                    Text("Pressure: N/A")
                                }
                                GridRow{
                                    Image(.temperature).resizable().frame(width:50,height:50)
                                    Text("Windspeed: N/A")
                                }
                                
                                
                            }
                        }
                        
                    }.font(.system(size: 25, weight: .medium))
                    
                }
                
            }
            
        }.padding(.bottom,150).foregroundColor(foregroundStyle).onAppear{
            if !temporaryCity.isEmpty {
                submit()
                Attractions()
            }
            
        }
    }
    func Attractions() {
        Task {
            do {
                let _ = try await googlePlacesViewModel.fetchPlaceId(city: temporaryCity,keyword: "Attraction")
                isLoading = false
            } catch {
                print("Error: \(error)")
                isLoading = false
            }
        }
    }
    private var foregroundStyle: Color {
        if let currentWeather = weatherMapViewModel.weatherDataModel?.current {
            let icon = currentWeather.weather[0].icon
            return icon.contains("n") || icon == "11d" || icon == "09d" || icon == "10d" || icon == "13d" ? .white : .black
        } else {
            return .black
        }
    }
    
    func submit(){
        weatherMapViewModel.city = temporaryCity
        Task {
            do {
                
                try await weatherMapViewModel.getCoordinatesForCity()
                let _ = try await weatherMapViewModel.loadData(lat:weatherMapViewModel.coordinates?.latitude ?? 0,lon:weatherMapViewModel.coordinates?.longitude ?? 0)
                isLoading = false
            } catch {
                print("Error: \(error)")
                isLoading = false
            }
        }
    }
}
private func getBackgroundImageName(for weatherIcon: String) -> String {
        switch weatherIcon {
        case "11d":
            return "thunder"
        case "09d", "10d":
            return "day_rain"
        case "13d":
            return "snow"
        case "50d":
            return "fog"
        case "01d":
            return "day_clear"
        case "01n":
            return "night_clear"
        case "02d", "03d", "04d":
            return "day_cloud"
        case "02n", "03n", "04n":
            return "night_cloud"
        default:
            return "sky"
        }
    }

struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView().environmentObject(WeatherMapViewModel()).environmentObject(GooglePlacesViewModel())
    }
}
