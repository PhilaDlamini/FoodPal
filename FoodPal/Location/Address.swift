//
//  Address.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation
import MapKit

let flagMap = [
    "Ascension Island": "🇦🇨",
    "Andorra": "🇦🇩",
    "United Arab Emirates": "🇦🇪",
    "Afghanistan": "🇦🇫",
    "Antigua & Barbuda": "🇦🇬",
    "Anguilla": "🇦🇮",
    "Albania": "🇦🇱",
    "Armenia": "🇦🇲",
    "Angola": "🇦🇴",
    "Antarctica": "🇦🇶",
    "Argentina": "🇦🇷",
    "American Samoa": "🇦🇸",
    "Austria": "🇦🇹",
    "Australia": "🇦🇺",
    "Aruba": "🇦🇼",
    "Åland Islands": "🇦🇽",
    "Azerbaijan": "🇦🇿",
    "Bosnia & Herzegovina": "🇧🇦",
    "Barbados": "🇧🇧",
    "Bangladesh": "🇧🇩",
    "Belgium": "🇧🇪",
    "Burkina Faso": "🇧🇫",
    "Bulgaria": "🇧🇬",
    "Bahrain": "🇧🇭",
    "Burundi": "🇧🇮",
    "Benin": "🇧🇯",
    "St. Barthélemy": "🇧🇱",
    "Bermuda": "🇧🇲",
    "Brunei": "🇧🇳",
    "Bolivia": "🇧🇴",
    "Caribbean Netherlands": "🇧🇶",
    "Brazil": "🇧🇷",
    "Bahamas": "🇧🇸",
    "Bhutan": "🇧🇹",
    "Bouvet Island": "🇧🇻",
    "Botswana": "🇧🇼",
    "Belarus": "🇧🇾",
    "Belize": "🇧🇿",
    "Canada": "🇨🇦",
    "Cocos (Keeling) Islands": "🇨🇨",
    "Congo - Kinshasa": "🇨🇩",
    "Central African Republic": "🇨🇫",
    "Congo - Brazzaville": "🇨🇬",
    "Switzerland": "🇨🇭",
    "Côte d’Ivoire": "🇨🇮",
    "Cook Islands": "🇨🇰",
    "Chile": "🇨🇱",
    "Cameroon": "🇨🇲",
    "China": "🇨🇳",
    "Colombia": "🇨🇴",
    "Clipperton Island": "🇨🇵",
    "Costa Rica": "🇨🇷",
    "Cuba": "🇨🇺",
    "Cape Verde": "🇨🇻",
    "Curaçao": "🇨🇼",
    "Christmas Island": "🇨🇽",
    "Cyprus": "🇨🇾",
    "Czechia": "🇨🇿",
    "Germany": "🇩🇪",
    "Diego Garcia": "🇩🇬",
    "Djibouti": "🇩🇯",
    "Denmark": "🇩🇰",
    "Dominica": "🇩🇲",
    "Dominican Republic": "🇩🇴",
    "Algeria": "🇩🇿",
    "Ceuta & Melilla": "🇪🇦",
    "Ecuador": "🇪🇨",
    "Estonia": "🇪🇪",
    "Egypt": "🇪🇬",
    "Western Sahara": "🇪🇭",
    "Eritrea": "🇪🇷",
    "Spain": "🇪🇸",
    "Ethiopia": "🇪🇹",
    "European Union": "🇪🇺",
    "Finland": "🇫🇮",
    "Fiji": "🇫🇯",
    "Falkland Islands": "🇫🇰",
    "Micronesia": "🇫🇲",
    "Faroe Islands": "🇫🇴",
    "France": "🇫🇷",
    "Gabon": "🇬🇦",
    "United Kingdom": "🇬🇧",
    "Grenada": "🇬🇩",
    "Georgia": "🇬🇪",
    "French Guiana": "🇬🇫",
    "Guernsey": "🇬🇬",
    "Ghana": "🇬🇭",
    "Gibraltar": "🇬🇮",
    "Greenland": "🇬🇱",
    "Gambia": "🇬🇲",
    "Guinea": "🇬🇳",
    "Guadeloupe": "🇬🇵",
    "Equatorial Guinea": "🇬🇶",
    "Greece": "🇬🇷",
    "South Georgia & South Sandwich Islands": "🇬🇸",
    "Guatemala": "🇬🇹",
    "Guam": "🇬🇺",
    "Guinea-Bissau": "🇬🇼",
    "Guyana": "🇬🇾",
    "Hong Kong SAR China": "🇭🇰",
    "Heard & McDonald Islands": "🇭🇲",
    "Honduras": "🇭🇳",
    "Croatia": "🇭🇷",
    "Haiti": "🇭🇹",
    "Hungary": "🇭🇺",
    "Canary Islands": "🇮🇨",
    "Indonesia": "🇮🇩",
    "Ireland": "🇮🇪",
    "Israel": "🇮🇱",
    "Isle of Man": "🇮🇲",
    "India": "🇮🇳",
    "British Indian Ocean Territory": "🇮🇴",
    "Iraq": "🇮🇶",
    "Iran": "🇮🇷",
    "Iceland": "🇮🇸",
    "Italy": "🇮🇹",
    "Jersey": "🇯🇪",
    "Jamaica": "🇯🇲",
    "Jordan": "🇯🇴",
    "Japan": "🇯🇵",
    "Kenya": "🇰🇪",
    "Kyrgyzstan": "🇰🇬",
    "Cambodia": "🇰🇭",
    "Kiribati": "🇰🇮",
    "Comoros": "🇰🇲",
    "St. Kitts & Nevis": "🇰🇳",
    "North Korea": "🇰🇵",
    "South Korea": "🇰🇷",
    "Kuwait": "🇰🇼",
    "Cayman Islands": "🇰🇾",
    "Kazakhstan": "🇰🇿",
    "Laos": "🇱🇦",
    "Lebanon": "🇱🇧",
    "St. Lucia": "🇱🇨",
    "Liechtenstein": "🇱🇮",
    "Sri Lanka": "🇱🇰",
    "Liberia": "🇱🇷",
    "Lesotho": "🇱🇸",
    "Lithuania": "🇱🇹",
    "Luxembourg": "🇱🇺",
    "Latvia": "🇱🇻",
    "Libya": "🇱🇾",
    "Morocco": "🇲🇦",
    "Monaco": "🇲🇨",
    "Moldova": "🇲🇩",
    "Montenegro": "🇲🇪",
    "St. Martin": "🇲🇫",
    "Madagascar": "🇲🇬",
    "Marshall Islands": "🇲🇭",
    "North Macedonia": "🇲🇰",
    "Mali": "🇲🇱",
    "Myanmar (Burma)": "🇲🇲",
    "Mongolia": "🇲🇳",
    "Macao SAR China": "🇲🇴",
    "Northern Mariana Islands": "🇲🇵",
    "Martinique": "🇲🇶",
    "Mauritania": "🇲🇷",
    "Montserrat": "🇲🇸",
    "Malta": "🇲🇹",
    "Mauritius": "🇲🇺",
    "Maldives": "🇲🇻",
    "Malawi": "🇲🇼",
    "Mexico": "🇲🇽",
    "Malaysia": "🇲🇾",
    "Mozambique": "🇲🇿",
    "Namibia": "🇳🇦",
    "New Caledonia": "🇳🇨",
    "Niger": "🇳🇪",
    "Norfolk Island": "🇳🇫",
    "Nigeria": "🇳🇬",
    "Nicaragua": "🇳🇮",
    "Netherlands": "🇳🇱",
    "Norway": "🇳🇴",
    "Nepal": "🇳🇵",
    "Nauru": "🇳🇷",
    "Niue": "🇳🇺",
    "New Zealand": "🇳🇿",
    "Oman": "🇴🇲",
    "Panama": "🇵🇦",
    "Peru": "🇵🇪",
    "French Polynesia": "🇵🇫",
    "Papua New Guinea": "🇵🇬",
    "Philippines": "🇵🇭",
    "Pakistan": "🇵🇰",
    "Poland": "🇵🇱",
    "St. Pierre & Miquelon": "🇵🇲",
    "Pitcairn Islands": "🇵🇳",
    "Puerto Rico": "🇵🇷",
    "Palestinian Territories": "🇵🇸",
    "Portugal": "🇵🇹",
    "Palau": "🇵🇼",
    "Paraguay": "🇵🇾",
    "Qatar": "🇶🇦",
    "Réunion": "🇷🇪",
    "Romania": "🇷🇴",
    "Serbia": "🇷🇸",
    "Russia": "🇷🇺",
    "Rwanda": "🇷🇼",
    "Saudi Arabia": "🇸🇦",
    "Solomon Islands": "🇸🇧",
    "Seychelles": "🇸🇨",
    "Sudan": "🇸🇩",
    "Sweden": "🇸🇪",
    "Singapore": "🇸🇬",
    "St. Helena": "🇸🇭",
    "Slovenia": "🇸🇮",
    "Svalbard & Jan Mayen": "🇸🇯",
    "Slovakia": "🇸🇰",
    "Sierra Leone": "🇸🇱",
    "San Marino": "🇸🇲",
    "Senegal": "🇸🇳",
    "Somalia": "🇸🇴",
    "Suriname": "🇸🇷",
    "South Sudan": "🇸🇸",
    "São Tomé & Príncipe": "🇸🇹",
    "El Salvador": "🇸🇻",
    "Sint Maarten": "🇸🇽",
    "Syria": "🇸🇾",
    "Eswatini": "🇸🇿",
    "Tristan da Cunha": "🇹🇦",
    "Turks & Caicos Islands": "🇹🇨",
    "Chad": "🇹🇩",
    "French Southern Territories": "🇹🇫",
    "Togo": "🇹🇬",
    "Thailand": "🇹🇭",
    "Tajikistan": "🇹🇯",
    "Tokelau": "🇹🇰",
    "Timor-Leste": "🇹🇱",
    "Turkmenistan": "🇹🇲",
    "Tunisia": "🇹🇳",
    "Tonga": "🇹🇴",
    "Turkey": "🇹🇷",
    "Trinidad & Tobago": "🇹🇹",
    "Tuvalu": "🇹🇻",
    "Taiwan": "🇹🇼",
    "Tanzania": "🇹🇿",
    "Ukraine": "🇺🇦",
    "Uganda": "🇺🇬",
    "U.S. Outlying Islands": "🇺🇲",
    "United Nations": "🇺🇳",
    "United States": "🇺🇸",
    "Uruguay": "🇺🇾",
    "Uzbekistan": "🇺🇿",
    "Vatican City": "🇻🇦",
    "St. Vincent & Grenadines": "🇻🇨",
    "Venezuela": "🇻🇪",
    "British Virgin Islands": "🇻🇬",
    "U.S. Virgin Islands": "🇻🇮",
    "Vietnam": "🇻🇳",
    "Vanuatu": "🇻🇺",
    "Wallis & Futuna": "🇼🇫",
    "Samoa": "🇼🇸",
    "Kosovo": "🇽🇰",
    "Yemen": "🇾🇪",
    "Mayotte": "🇾🇹",
    "South Africa": "🇿🇦",
    "Zambia": "🇿🇲",
    "Zimbabwe": "🇿🇼",
    "England": "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
    "Scotland": "🏴󠁧󠁢󠁳󠁣󠁴󠁿",
    "Wales": "🏴󠁧󠁢󠁷󠁬󠁳󠁿"
]


class Address: ObservableObject, Identifiable {
    var id = UUID()
    @Published var num: String
    @Published var street: String
    @Published var city: String
    @Published var state: String
    @Published var country: String
    
     init() {
        self.num = ""
        self.street = ""
        self.city = ""
        self.state = ""
        self.country = ""
    }
    
    init(num: String, street: String, city: String, region: String, country: String) {
        self.num = num
        self.street = street
        self.city = city
        self.state = region
        self.country = country
    }
    
    func isValid() -> Bool {
        return !(city.isEmpty || state.isEmpty || country.isEmpty)
    }
    
    func update(to address: Address) {
        self.num = address.num
        self.street = address.street
        self.city = address.city
        self.state = address.state
        self.country = address.country
    }
    
    func getString() -> String {
        return "\(num) \(street) \(city) \(state) \(country)"
    }
    
    func getStreetAddress() -> String {
        var ret = ""
        if !num.isEmpty {
            ret.append("\(num) ")
        }
        
        if !street.isEmpty {
            ret.append("\(street) ")
        }
        
        if !city.isEmpty {
            ret.append("\(city) ")
        }
        
        if ret.isEmpty {
            return "- - -"
        }
        
        return ret
        
    }
    
    func getStateAndCountry() -> String {
        var ret = ""
        if !state.isEmpty {
            ret.append("\(state) ")
        }
        
        if !country.isEmpty {
            ret.append("\(country) ")
        }
        
        if ret.isEmpty {
            return "- -"
        }
        
        return ret
        
    }
}

//Get address for given CLLocation
func getAddress(for location: CLLocation, completion: @escaping (Address) -> Void)  {
    CLGeocoder().reverseGeocodeLocation(location) {placemarks, _ in
        guard let placemark = placemarks?.first else { completion(Address()); return }
        let num = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let city = placemark.locality ?? ""
        let region = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""
        completion(Address(num: num, street: street, city: city, region: region, country: country))
    }
}

//Get address for given MKMapItem
func getAddress(for mapItem: MKMapItem) -> String {
    let placemark = mapItem.placemark
    let num = placemark.subThoroughfare ?? ""
    let street = placemark.thoroughfare ?? ""
    let state = placemark.administrativeArea ?? ""
    let city = placemark.locality ?? ""
    return "\(num) \(street) \(city) \(state)"
}
