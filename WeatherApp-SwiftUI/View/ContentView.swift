//
//  ContentView.swift
//  WeatherApp-SwiftUI
//
//  Created by Fedor Sychev on 17.02.22.
//

import SwiftUI

struct ContentView: View {
    @State var location = "\(Image(systemName: "location")) Augsburg"
    @State var date = "22.22.2222"
    @State var summary = "Sample Summary"
    @State var forecast = "Sample forecast"
    @State var searchedSity = ""
    
    @State var textFieldHidden: Bool = true
    @State var tap: Bool = false
    
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
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(location)
                            .padding(.top, 10)
                        
                        Text(date)
                            .padding(.top, 10)
                        
                        Text(summary)
                            .padding(.top, 10)
                        
                    }
                    .foregroundColor(Color.black)
                    .animation(.easeOut(duration: 0.3))
                    .animation(.linear(duration: 5))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    HStack {
                        Button("\(Image(systemName: "magnifyingglass"))") {
                            textFieldHidden.toggle()
                            if textFieldHidden == true {
                                testData = standartData
                            }
                        }
                        
                        TextField("Enter city name", text: binding) {
                            
                        }
                        .opacity(textFieldHidden ? 0 : 1)
                        
                        //Loading animation
                        RingView(color1: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), color2: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), width: 40, height: 40, percent: tap ? 100 : 0, show: .constant(true))
                            .animation(.linear)
                    }
                    .task {
                        await returnRingView()
                    }
                }
                .padding()
                
                ListView(viewModel: $viewModel, testData: $testData, tap: $tap, location: $location, date: $date, summary: $summary, forecast: $forecast)
            }
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
        .background(Image("Background1"))
    }
    
    private func returnRingView() async {
        try? await Task.sleep(nanoseconds: 1)
        self.tap = false
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
    @Binding var tap: Bool
    @Binding var location: String
    @Binding var date: String
    @Binding var summary: String
    @Binding var forecast: String
    
    var body: some View {
        List {
            ForEach(self.testData, id: \.self) { testData in
                HStack(alignment: .bottom, spacing: 0) {
                    Text(testData)
                    Spacer()
                }
                .frame(height: 44)
                .onTapGesture {
                    location = " "
                    date = " "
                    summary = " "
                    forecast = " "
                    tap = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.tap = false
                        viewModel.changeLocation(to: testData)
                    }
                }
            }
        }
    }
}
