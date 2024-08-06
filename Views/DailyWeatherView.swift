//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    var day: Daily
    var body: some View {

        let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
        ZStack{
            Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255)
            HStack{
                AsyncImage(url: URL(string:"https://openweathermap.org/img/wn/\(day.weather[0].icon)@2x.png")){
                    image in image .resizable().aspectRatio(contentMode: .fill)
                    
                }placeholder: {
                    
                }.frame(width: 50,height: 50)
                Spacer()
                VStack{
                    Text("\(day.weather[0].main.rawValue)")
                    Text(formattedDate)
                        .font(.body)
                        .foregroundColor(.black)
                    
                }.padding()
                Spacer()
                
                Text("\(day.temp.max, specifier: "%.0f") ºC / \(day.temp.min, specifier: "%.0f")ºC")
                
            }.padding(.horizontal)
        }
       
    }
}

