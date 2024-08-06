import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @EnvironmentObject var googlePlacesViewModel: GooglePlacesViewModel
    @State var places: [Place] = []
    @State var wordList: [String] = ["Attraction","Monumnet","Coffee","Bakery","Museum","Park","Restaurant","Hotel","Cinema","Gym","Bookstore","Pharmacy", "Supermarket","Electronics","Florist","Clothing","Jewelry","Hair Salon","Nail Salon","Spa","Furniture","Hardware","Pet Store","Dentist","Hospital","School","University","Library","Theatre","Bar","Nightclub","Bank","ATM","Gas Station","Car Rental","Bicycle Store","Art Gallery","Zoo","Aquarium","Theme Park","Winery"]
    @State var keyword: String = "Attraction"
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)
    
    var body: some View {

            ZStack(alignment: .top) {
                if weatherMapViewModel.coordinates != nil {
                    Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: places) { place in
                        MapMarker(coordinate: CLLocationCoordinate2D(
                            latitude: place.geometry?.location.lat ?? 0,
                            longitude: place.geometry?.location.lng ?? 0
                        ))
                    }.edgesIgnoringSafeArea(.all).frame(height: 400)
                }
                VStack(alignment: .center) {
                    Text("Tourist Attractions in \(weatherMapViewModel.city)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(wordList, id: \.self) { word in
                                
                                if word == keyword {
                                    Text(word)
                                        .padding().background(.green).cornerRadius(50.0)
                                }else{
                                    Text(word)
                                        .padding().background(.gray).cornerRadius(50.0).onTapGesture{
                                            change(word: word)
                                        }
                                }
                                
                            }
                        }
                    }.frame(width: 350)
                    
                    ScrollView {
                        if !places.isEmpty {
                            ForEach(places) { location in
                                
                                HStack {
                                    if let photos = location.photos, !photos.isEmpty {
                                        let photoReference = photos[0].photoReference
                                        let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(photoReference)&key=AIzaSyB5pqABKskGR8tiokaaf16Q3vDHmlOS9TY")
                                        
                                        if let imageUrl = url {
                                            AsyncImage(url: imageUrl) { image in
                                                image.resizable().scaledToFill().frame(width: 70, height: 70).cornerRadius(10).clipped()
                                            } placeholder: {
                                                
                                            }.frame(width: 70, height: 70)
                                            
                                            
                                        } else {
                                            Text("No Image Found")
                                                .frame(width: 70, height: 70)
                                                .background(Color.gray)
                                                .cornerRadius(10)
                                        }
                                    } else {
                                        Text("No Image Found")
                                            .frame(width: 70, height: 70)
                                            .background(Color.gray)
                                            .cornerRadius(10)
                                    }
                                    
                          
                                        VStack {
                                            Text("\(location.name)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(location.rating.map { String($0) } ?? "No Rating")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("\(location.vicinity)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    
                                }
                                .frame(height: 150)
                                .padding(.horizontal, 50)
                            }
                        }else{
                            Text("Could not find any attractions")
                                .fontWeight(.bold)
                                .padding()
                        }
                        
                    }
                }
                .background(Color.white)
                
                .padding(.top, 300)
            
            .onAppear {
                mapRegion = weatherMapViewModel.region
                places = googlePlacesViewModel.places ?? []
            }
        }
    }
    func change(word: String) {
        keyword = word
        Task {
            do {
                places = try await googlePlacesViewModel.fetchPlaceId(city: weatherMapViewModel.city, keyword: word)
            } catch {
                print("Error fetching places: \(error)")
            }
        }
    }
    
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel()).environmentObject(GooglePlacesViewModel())
    }
}
