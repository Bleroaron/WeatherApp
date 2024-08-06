//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(red: 150 / 255, green: 177 / 255, blue: 200 / 255))
                        .frame( width: 365 ,height: 300)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 16) {
                    if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(hourlyData) { hour in
                                    HourWeatherView(current: hour)
                                        .cornerRadius(10.0)
                                }
                            }
                            .padding(.horizontal, 16)
                            
                        }
                        .frame(height: 180).padding(.vertical,5).padding(.top,20)
                        
                    }
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                        List {
                            ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in
                                DailyWeatherView(day: day) .frame(height: 50)
                            }
                        }
                        .padding(.top, 0)
                        .listStyle(PlainListStyle())
                        .frame(height: 450)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                        VStack{
                            Text("Weather Forecast for \(weatherMapViewModel.city)").font(.title3)
                                .fontWeight(.bold)
                            
                        }
                    }
                }
            }
        }
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView().environmentObject(WeatherMapViewModel())
    }
}
