//
//  ContentView.swift
//  CalculatorApp
//
//  Created by admin on 1/1/20.
//  Copyright © 2020 admin. All rights reserved.
//

import SwiftUI

struct CalculationState {
     var currentNumber: Double = 0
    var storedNumber: Double?
    var storedAction: ActionView.Action?
    
    
    mutating func appendNumber(_ number: Double)  {
        if number.truncatingRemainder(dividingBy: 1) == 0
            && currentNumber.truncatingRemainder(dividingBy: 1) == 0 {
            currentNumber = 10 * currentNumber + number
        }else {
            currentNumber = number
        }
    }
    
}

struct ContentView: View {
    
    @State var state = CalculationState()
    
    var displayedString: String {
        return String(format: "%.2f", arguments: [state.currentNumber])
    }
    
    var body: some View {
        VStack (alignment: .trailing, spacing: 30) {
            Spacer()
           Text(displayedString)
            .font(.largeTitle)
            .fontWeight(.bold)
            .lineLimit(3)
            .padding(.bottom, 64)
            .animation(.spring())
            HStack{
                FunctionView(function: .sinus, state: $state)
                Spacer()
                FunctionView(function: .cosinus, state: $state)
                Spacer()
                FunctionView(function: .tangens, state: $state)
                Spacer()
                ActionView(action: .plus, state: $state)
            }
            HStack{
                NumberView(number: 7, state: $state)
                Spacer()
                NumberView(number: 8, state: $state)
                Spacer()
                NumberView(number: 9, state: $state)
                Spacer()
                ActionView(action: .minus, state: $state)
                       }
            HStack{
                NumberView(number: 4, state: $state)
                Spacer()
                NumberView(number: 5, state: $state)
                Spacer()
                NumberView(number: 6, state: $state)
                Spacer()
                ActionView(action: .multiply, state: $state)
                       }
            HStack{
                NumberView(number: 1, state: $state)
                Spacer()
                NumberView(number: 2, state: $state)
                Spacer()
                NumberView(number: 3, state: $state)
                Spacer()
                ActionView(action: .divide, state: $state)
                       }
            HStack{
                ActionView(action: .clear, state: $state)
                Spacer()
                NumberView(number: 0, state: $state)
                Spacer()
                NumberView(number: .pi, state: $state)
                Spacer()
                ActionView(action: .equal, state: $state)
                        }
        }.padding(32)
    }
}

struct NumberView: View {
    let number: Double
    @Binding var state: CalculationState
    
    var numberString: String{
        if number == .pi {
            
            return "π"
        }
        
       return String(Int(number))
    }
    
    var body: some View {
        
        Text(numberString)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 65, height: 64)
            .background(Color("MainButtonColor").opacity(0.8))
            .cornerRadius(20)
            .shadow(color: Color("MainButtonColor").opacity(0.9), radius: 10, x: 0, y: 10)
            .onTapGesture { 
                self.state.appendNumber(self.number)
        }
        
        
    }
}

struct FunctionView: View {
    enum MathFunction{
        case sinus, cosinus, tangens
        
        func string() -> String {
            switch self{
            case .sinus:
               return "sin"
            case .cosinus:
               return "cos"
            case .tangens:
               return "tan"
            
           
            }
        }
        
        func Operation(_ input: Double) -> Double {
            switch self {
            case .sinus:
                return sin(input)
            case .cosinus:
                return cos(input)
            case .tangens:
                return tan(input)
           
            
            }
        }
    }
    
    var function: MathFunction
    @Binding var state: CalculationState
    
    
    
    var body: some View{
        return Text(function.string())
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(width: 64, height: 64)
            .background(Color("TopButtonColor").opacity(0.5))
            .cornerRadius(20)
            .shadow(color: Color("TopButtonColor").opacity(0.9), radius: 10, x: 0, y: 10)
            .onTapGesture {
                self.state.currentNumber = self.function.Operation(self.state.currentNumber)
        }
        
    }
}

struct ActionView: View {
    enum Action{
        case equal, clear, plus, minus, multiply, divide
        func image() -> Image{
            switch self {
            case .equal:
                return Image(systemName: "equal")
            case .clear:
                return Image(systemName: "xmark.circle")
            case .plus:
                return Image(systemName: "plus")
            case .minus:
                return Image(systemName: "minus")
            case .multiply:
                return Image(systemName: "multiply")
            case .divide:
                return Image(systemName: "divide")
            }
        }
        
        func Calculate(_ input1: Double, _ input2: Double) -> Double? {
            switch self {
            
            case .plus:
                return input1 + input2
            case .minus:
                return input1 - input2
            case .multiply:
                return input1 * input2
            case .divide:
                return input1 / input2
             default:
                return nil
            }
        }
        
    }
    
    let action: Action
    @Binding var state: CalculationState
    
    var body: some View{
         action.image()
            .font(Font.title.weight(.bold))
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(Color("ActionButtonColor").opacity(0.8))
            .cornerRadius(20)
            .shadow(color: Color("ActionButtonColor").opacity(0.9), radius: 10, x: 0, y: 10)
            .onTapGesture {
                self.tapped()
        }
    }
    
    private func tapped() {
        
        switch action  {
        case .clear:
            state.currentNumber = 0
            state.storedNumber = nil
            state.storedAction = nil
            break
        case .equal:
            guard let storedAction = state.storedAction else {return}
            guard let storedNumber = state.storedNumber else {return}
            guard let result = storedAction.Calculate(storedNumber, state.currentNumber) else {return}
            state.currentNumber = result
            state.storedNumber = nil
            state.storedAction = nil
            break
        default:
            state.storedNumber = state.currentNumber
            state.currentNumber = 0
            state.storedAction = action
            break
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
