//
//  ContentView.swift
//  Bubbly
//
//  Created by Devin Jay on 9/5/26.
//

import SwiftUI

struct ContentView: View
{
    let defaults = UserDefaults.standard

    @State private var num:Int? = nil
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()

    var body: some View
    {
        ZStack
        {
            Color(.blue)
                .ignoresSafeArea()
            VStack
            {
                VStack
                {
                    Text("Bubbly!")
                        .font(.custom("MarkerFelt-Thin", size: 90))
                        .foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                }
                Spacer()
                ZStack
                {
                    Image("BubbleWrap")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .scaleEffect(x: 1, y: -1)
                        .overlay
                        {
                            HStack
                            {
                                ZStack
                                {
                                    Image("Bubble")
                                        .resizable()
                                        .frame(width: 110, height: 110)
                                    TextField("Num?", value: $num, format: .number)
                                        .keyboardType(.numberPad)
                                        
                                }
                                VStack
                                {
                                    DatePicker("", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                                        .onChange(of: selectedStartTime)
                                        {
                                            _, newStart in defaults.set(newStart, forKey: "startTime")
                                        }
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .overlay
                                        {
                                            Image("Bubble")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 110, height: 110)
                                                .allowsHitTesting(false)
                                        }
                                        .padding(.trailing, 50)
                                        .padding(.bottom, 100)
                                        DatePicker("", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                                            .onChange(of: selectedEndTime)
                                            {
                                                _, newStart in defaults.set(newStart, forKey: "endTime")
                                            }
                                            .datePickerStyle(.compact)
                                            .labelsHidden()
                                            .overlay
                                            {
                                                Image("Bubble")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 110, height: 110)
                                                    .allowsHitTesting(false)
                                            }
                                            .padding(.trailing, 50)
                                }

                            }
                        }
                }
            }
        }
        .onAppear
                {
                    if let pastStartTime = defaults.object(forKey: "startTime")
                    {
                        selectedStartTime = pastStartTime as! Date
                    }
                    
                    if let pastEndTime = defaults.object(forKey: "endTime")
                    {
                        selectedEndTime = pastEndTime as! Date
                    }
                }
    }
}

#Preview
{
    ContentView()
}
