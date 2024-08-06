//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    var current: Current

    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt))
       
        ZStack{
            Color(red: 1 / 255, green: 174 / 255, blue: 195 / 255)
            
            VStack(alignment: .center, spacing: 5) {
                Text(formattedDate)
                    .font(.body)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png")){
                    image in image .resizable().aspectRatio(contentMode: .fill)
                    
                }placeholder: {
                    
                }.frame(width: 30,height: 30)
                
                Text("\(current.temp, specifier: "%.0f") ºC")
                Text("\(current.weather[0].weatherDescription.rawValue)")
            }.padding()
        }
       
        
    }
}




