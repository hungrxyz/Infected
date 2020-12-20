<img src=./assets/qr-code.jpg width=250>
<a href="https://apps.apple.com/us/app/infected-covid-19-nl/id1537441887?itsct=apps_box&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-top-left-radius: 13px; border-top-right-radius: 13px; border-bottom-right-radius: 13px; border-bottom-left-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-US?size=250x83&amp;releaseDate=1605744000&h=139e16d48710b88c0ea28e96c3136a53" alt="Download on the App Store" style="border-top-left-radius: 13px; border-top-right-radius: 13px; border-bottom-right-radius: 13px; border-bottom-left-radius: 13px; width: 250px; height: 83px;"></a>

# Infected – COVID-19 NL
iOS app built in SwiftUI to bring you the latest COVID-19 numbers in the Netherlands as reported by RIVM, NICE and LCPS.

<img src=./assets/my-regions.png width=250><img src=./assets/all-regions.png width=250><img src=./assets/provinces.png width=250>

## Data Sources
Listed in [infected-data#sources](https://github.com/hungrxyz/infected-data#sources)

## Run the App
1. Clone this repository.
1. Open _Infected.xcodeproj_ in Xcode.
1. Add required configuration files ([Templates](./config-templates) provided for all files.):  
`Infected/Infected.xcconfig`  
`Infected/Infected.entitlements`  
`InfectedWidget/InfectedWidgetExtension.entitlements`  
1. Run _Infected_ scheme on preferred device.

## Upcoming Features
- [ ] Medium/large widget showing regions from Watchlist.
- [ ] Sorting options for regions.
- [ ] Mortality/Survival rate.
- [ ] Positive cases per population
- [ ] Test information (how many tests done, positivity rate,...).
- [x] ICU occupancy. [Released with Hospital Occupancy in [1.2.0](https://github.com/hungrxyz/Infected/releases/tag/1.2.0)]
- [x] Watchlist (similar to iOS Stocks app). [My Regions [1.1.0](https://github.com/hungrxyz/Infected/releases/tag/1.1.0)]

Feel free to propose a feature by opening an Issue or reaching out to me on [Twitter](https://twitter.com/hungrxyz). Or even better, build the feature you want to see and open a pull request.

## License
Code base is licensed under [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/). Original data is copyright RIVM.
