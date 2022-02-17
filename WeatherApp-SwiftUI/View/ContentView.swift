//
//  ContentView.swift
//  WeatherApp-SwiftUI
//
//  Created by Fedor Sychev on 17.02.22.
//

import SwiftUI

struct ContentView: View {
    @State var location = "Augsburg2"
    @State var date = "22.22.2222"
    @State var summary = "Sample Summary"
    @State var forecast = "Sample forecast"
    @State var searchedSity = ""
    
    @State var textFieldHidden: Bool = true
    
    @State var testData: [String] = ["Augsburg", "Odessa", "Munchen", "Frankfurt", "Dusseldorf", "Kiev", "Hamburg", "Munster"]
    @State var standartData: [String] = ["Augsburg", "Odessa", "Munchen", "Frankfurt", "Dusseldorf", "Kiev", "Hamburg", "Munster"]
    
    @State var viewModel = WeatherViewModel()
    
    var body: some View {
        let binding = Binding<String>(get: {
                    self.searchedSity
                }, set: {
                    self.searchedSity = $0
                    
                    if searchedSity.isEmpty == false {
                        print("CHANGED")
                        print(searchedSity)
                        var newArray: [String] = []
                        
                        for i in self.standartData {
                            var newSearchString = ""
                            for j in 0...searchedSity.count - 1 {
                                newSearchString += i[j]
                            }
                            if newSearchString == searchedSity {
                                newArray.append(i)
                            }
                        }
                        self.testData = newArray
                    } else {
                        self.testData = standartData
                        self.testData.sort()
                    }
                })
        
        HStack {
            VStack(alignment: .leading) {
                Text(location)
                
                Text(date)
                
                Text(summary)
                
                Text(forecast)
                
                HStack {
                    Button("Search") {
                        textFieldHidden.toggle()
                        if textFieldHidden == true {
                            testData = standartData
                        }
                    }
                    
                    TextField("Enter city name", text: binding) {
                        
                    }
                    .opacity(textFieldHidden ? 0 : 1)
                }
                
                ListView(viewModel: $viewModel, testData: $testData)
                    .background(Color.black)
            }
            .padding()
            Spacer()
        }
        .onAppear {
            testData.sort()
            
            viewModel.locationName.bind { locationName in
                self.location = locationName
            }
            
            viewModel.date.bind { date in
                self.date = date
            }
            
            viewModel.summary.bind { summary in
                self.summary = summary
            }
            
            viewModel.forecastSummary.bind { forecast in
                self.forecast = forecast
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListView: View {
    @Binding var viewModel: WeatherViewModel
    @Binding var testData: [String]
    
    var body: some View {
        List {
            ForEach(self.testData, id: \.self) { testData in
                HStack(alignment: .bottom, spacing: 0) {
                    Text(testData)
                    Spacer()
                }
                .frame(height: 44)
                .onTapGesture {
                    viewModel.changeLocation(to: testData)
                }
            }
        }
    }
}
