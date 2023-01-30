//
//  NasaViewModel.swift
//  NASA
//
//  Created by Nuntapat Hirunnattee on 23/1/2566 BE.
//

import Foundation

protocol NasaViewModelDelegate: AnyObject{
    func NasaUpdateWithData()
    func NasaUpdateWithError(error: Error, description: String)
}

enum dateValidationError: Error{
    case dateInvalid
    var description: String{
        return "Start date must be less or equal End date and both dates must not be more than today date"
    }
}

class NasaViewModel{
    weak var delegate: NasaViewModelDelegate?
    var data: [NasaData]?{
        didSet{
            delegate?.NasaUpdateWithData()
        }
    }
    
    private var nowDate: String{
        get{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let dateFormatted = formatter.string(from: date)
            return formatDate(dateString: dateFormatted)
        }
    }
    
    func requestWithDate(startDate: String, endDate: String){
        //Validate start and end date
        if dateValidate(startDate: startDate, endDate: endDate){
            //Start requseting
            let urlString = "\(K.NasaURL)\(K.apiKey)&start_date=\(startDate)&end_date=\(endDate)"
            APICaller.shared.request(urlString: urlString, expecting: [NasaData].self) {[weak self] result in
                switch result{
                case .success(let data):
                    self?.data = data
                    self?.delegate?.NasaUpdateWithData()
                case .failure(let error):
                    self?.delegate?.NasaUpdateWithError(error: error, description: error.errorDescription)
                }
            }
        }
    }
    
    private func dateValidate(startDate: String, endDate: String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let startDateFormated = dateFormatter.date(from: startDate), let endDateFormated = dateFormatter.date(from: endDate) , let today = dateFormatter.date(from: nowDate) else {
            print("Could not format dateString input.")
            return false
        }
        if (startDateFormated <= endDateFormated) && (startDateFormated <= today) && (endDateFormated <= today){
            return true
        } else {
            let error = dateValidationError.dateInvalid
            let description = error.description
            delegate?.NasaUpdateWithError(error: error, description: description)
            return false
        }
    }
    
    func formatDate(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "th_TH")
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Could not format dateString input.")
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatedString = dateFormatter.string(from: date)
        return dateFormatedString
    }
}
