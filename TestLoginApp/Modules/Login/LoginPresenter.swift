//
//  LoginPresenter.swift
//  TestLoginApp
//
//  Created Tim on 3/7/19.
//  Copyright © 2019 Heads and Hands. All rights reserved.
//

import Foundation

final class LoginPresenter {
    
    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    private let minimumPasswordLenght = 6
    
    init() { }
    
    private func validatePassword(_ password: String?) -> (isValid: Bool, errorMessage: String) {
        var errorMessage: String = ""
        let password = password ?? ""
        var isPasswordValid = true
        
        if password.count < minimumPasswordLenght {
            isPasswordValid = false
            errorMessage += LS.Auth.Error.Password.toShort.localized() + LS.Global.space.localized()
        }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            isPasswordValid = false
            errorMessage += LS.Auth.Error.Password.oneUppercase.localized() + LS.Global.space.localized()
        }
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            isPasswordValid = false
            errorMessage += LS.Auth.Error.Password.oneLowercase.localized() + LS.Global.space.localized()
        }
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            isPasswordValid = false
            errorMessage += LS.Auth.Error.Password.oneDigit.localized() + LS.Global.space.localized()
        }
        
        return (isValid: isPasswordValid,
                errorMessage: errorMessage)
    }
    
}

// MARK: - LoginViewOutput
extension LoginPresenter: LoginViewOutput {

    func viewIsReady() {
        
    }
    
    func didTapForgotPassword() {
        
    }
    
    func didTapLogin(email: String?, password: String?) {
        guard let email = email,
              !email.isEmpty else {
            view.showMessage(LS.Auth.Error.incorrectEmail.localized())
            return
        }
        let result = validatePassword(password)
        guard result.isValid else {
            view.showMessage(result.errorMessage)
            return
        }
        
        interactor.loadWeather(query: "London")
    }
    
    func didTapRegistration() {
        interactor.loadWeather(query: "London")
    }
    
}

// MARK: - LoginInteractorOutput
extension LoginPresenter: LoginInteractorOutput {
    
    func didLoadWeather(_ weatherResponse: WeatherResponse) {
        guard let weather = weatherResponse.weather else {
            let weatherReport = "Для города \(weatherResponse.name) погода не найдена."
            view.showMessage(weatherReport)

            return
        }
        let weatherReport = "\(weatherResponse.name): \(weather.main). \(weather.description)"
        view.showMessage(weatherReport)
    }
    
    func didReceivedAnError(_ error: String) {
        view.showMessage(error)
    }
    
}
