//
//  ViewController.swift
//  NASA
//
//  Created by Nuntapat Hirunnattee on 23/1/2566 BE.
//

import UIKit
import Kingfisher
class NasaViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var stopDateTextField: UITextField!
    @IBOutlet weak var NasaTableView: UITableView!
    
    let viewModel = NasaViewModel()
    var datePickerInUseTextField = UITextField()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpDelegates()
        setUpDatePicker()
        setUpRequest()
    }
    
    private func setUp(){
        startDateTextField.text = datePickerformatDate(date: Date(), mode: .date)
        stopDateTextField.text = datePickerformatDate(date: Date(), mode: .date)
    }
    
    
    private func setUpDelegates(){
        viewModel.delegate = self
        startDateTextField.delegate = self
        stopDateTextField.delegate = self
        NasaTableView.dataSource = self
        NasaTableView.delegate = self
    }
    
    private func setUpDatePicker(){
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "TH")
    }
    
    private func setUpRequest(){
        guard let startDateString = startDateTextField.text else {
            print("Could not get start date from startDateTextField")
            return
        }
        guard let endDateString = stopDateTextField.text else {
            print("Could not get start date from startDateTextField")
            return
        }
        let startDateFormatedString = viewModel.formatDate(dateString: startDateString)
        let endDateFormatedString = viewModel.formatDate(dateString: endDateString)
        viewModel.requestWithDate(startDate: startDateFormatedString, endDate: endDateFormatedString)
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        setUpRequest()
    }
    
}

extension NasaViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateTextField{
            openDatePicker(with: textField, mode: .date)
        } else if textField == stopDateTextField{
            openDatePicker(with: textField, mode: .date)
        }
    }
    
    //prevent user for change date text in start date and end date TextFields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == startDateTextField, textField == stopDateTextField{
            return true
        } else {
            return false
        }
    }
}

extension NasaViewController: NasaViewModelDelegate{
    func NasaUpdateWithData() {
        DispatchQueue.main.async {[weak self] in
            self?.NasaTableView.reloadData()
        }
    }
    
    func NasaUpdateWithError(error: Error, description: String) {
        print("\(error) : \(description)")
    }
}

extension NasaViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? NasaTableViewCell, let nasaData = viewModel.data
        else {
            return UITableViewCell()
        }
        if let imageUrl = nasaData[indexPath.row].hdurl{
            cell.cellImageView.kf.setImage(with: URL(string: imageUrl), options: [.transition(ImageTransition.fade(1))])
        }
        cell.dateLabel.text = nasaData[indexPath.row].date
        cell.titleLabel.text = nasaData[indexPath.row].title
        return cell
    }
    
    
}

extension NasaViewController{
    func openDatePicker(with textField: UITextField, mode: UIDatePicker.Mode){
        datePickerInUseTextField = textField
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        textField.inputView = datePicker
        textField.inputAccessoryView = setUpToolBar()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        datePickerInUseTextField.text = datePickerformatDate(date: datePicker.date, mode: datePicker.datePickerMode)
    }
    
    //add done and cancel to datePicker
    func setUpToolBar() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnPressed))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnPressed))
        let flexibelBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelBtn, flexibelBtn, doneBtn], animated: false)
        toolBar.barTintColor = UIColor(named: "PrimaryColor")
        return toolBar
    }
    
    @objc func cancelBtnPressed(){
        datePickerInUseTextField.resignFirstResponder()
        datePickerInUseTextField = UITextField()
    }
    
    @objc func doneBtnPressed(){
        if let datePicker = datePickerInUseTextField.inputView as? UIDatePicker{
            datePickerInUseTextField.text = datePickerformatDate(date: datePicker.date, mode: datePicker.datePickerMode)
            datePickerInUseTextField = UITextField()
        }
        view.endEditing(true)
    }
    
    
    func datePickerformatDate(date: Date, mode: UIDatePicker.Mode) -> String{
        let formatter = DateFormatter()
        if mode == .date{
            formatter.dateStyle = .medium
        }
        if mode == .time{
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}
