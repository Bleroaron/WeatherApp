import Foundation
import CoreLocation

class GooglePlacesViewModel: ObservableObject {
    @Published var places: [Place]?
    init() {
        
    }
    
    func fetchPlaceId(city: String,keyword: String) async throws -> [Place] {
        
        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(city),
           let location = placemarks.first?.location?.coordinate {
            let coordinate = "\(location.latitude),\(location.longitude)"
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=\(keyword)&location=\(coordinate)&radius=20000&type=\(keyword)&key=AIzaSyB5pqABKskGR8tiokaaf16Q3vDHmlOS9TY"
            guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
            let session = URLSession(configuration: .default)
           
            do {
                let (data, _) = try await session.data(from: url)
                let placesResponse = try JSONDecoder().decode(NearbySearchResponse.self, from: data)

                DispatchQueue.main.async {
                    self.places = placesResponse.results
                    print("Places are sorted and loaded.")
                }
                return placesResponse.results
            } catch {
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                throw error 
            }
            
        }else{
            throw NetworkError.invalidURL
        }
       
    }

    
    
    enum NetworkError: Error {
        case invalidURL
    }
}
