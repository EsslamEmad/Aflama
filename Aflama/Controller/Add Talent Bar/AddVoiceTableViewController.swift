//
//  AddVoiceTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 7/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import AVFoundation

class AddVoiceTableViewController: UITableViewController , UIPickerViewDelegate, UIPickerViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    let user = Auth.auth.user!
    var voice = Voice()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var meterTimer: Timer!
    var isRecording = false
    var isPlaying = false
    var category: Category!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var recordPhoto: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var soundTypeTF: UITextField!
    @IBOutlet weak var attachementView: UIView!
    @IBOutlet weak var attachementLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        attachementLabel.text = category.scinario
        self.title = category.title
        containerView.clipsToBounds = true
        sendButton.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        sendButton.layer.cornerRadius = 10.0
        recordPhoto.clipsToBounds = true
        recordPhoto.layer.cornerRadius = 40.0
        attachementView.layer.borderColor = UIColor.darkGray.cgColor
        attachementView.layer.borderWidth = 1.0
        playButton.clipsToBounds = true
        playButton.alpha =  1
        playButton.isEnabled = false
        initializeToolbar()
        recordingSession = AVAudioSession.sharedInstance()
        attachementView.layer.cornerRadius = 10.0
        attachementView.clipsToBounds = true
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordPhoto.isUserInteractionEnabled = true
                    } else {
                        self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع استخدام المايكروفون الخاص بك", comment: ""))
                        self.recordPhoto.isUserInteractionEnabled = false
                    }
                }
            }
        } catch {
            self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع استخدام المايكروفون الخاص بك", comment: ""))
            self.recordPhoto.isUserInteractionEnabled = false
        }
        
        
        
    }
    
    
    
    
    @IBAction func didPressSend(_ sender: Any) {
        guard voice.soundType != nil, isRecorded else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك قم بإكمال البيانات الخاصة بالإستمارة!", comment: ""))
            return
        }
        
        voice.userID = user.id
        voice.subCategory = category.id
        
        
        sendRequest()
        
        
    }
    
    func sendRequest() {
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.upload(image: nil, file: audioFilename, video: nil))
            }.done {
                let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                self.voice.soundFile = resp.image
                firstly{
                    return API.CallApi(APIRequests.addVoice(voice: self.voice))
                    }.done{ resp in
                        self.showAlert(error: false, withMessage: NSLocalizedString("تم إرسال الإستمارة بنجاح", comment: ""), completion: {(UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.performMainSegue()
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
    
   
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = category.scinario
        let neededSize = label.sizeThatFits(CGSize(width: self.view.frame.width - 80, height: CGFloat.greatestFiniteMagnitude))
        return neededSize.height + 464
    }
    
    
    //Mark: Sex Picker
    
    private let sexPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    private var typePicker = UIPickerView()
    
    private func initializeSexPicker() {
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        soundTypeTF.inputView = typePicker
        soundTypeTF.inputAccessoryView = inputAccessoryBar
    }
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializeSexPicker()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            switch row {
            case 0:
                return NSLocalizedString("غنائي", comment: "")
                
            default:
                return NSLocalizedString("نصي", comment: "")
                
            }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            switch row {
            case 0:
                soundTypeTF.text = NSLocalizedString("غنائي", comment: "")
                voice.soundType = 1
            default:
                soundTypeTF.text = NSLocalizedString("نصي", comment: "")
                voice.soundType = 2
            }
        
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    
    
    //Mark: audio recorder
    
    @IBAction func didPressRecord(recognizer: UITapGestureRecognizer) {
        if isRecording{
            finishRecording(success: true)
        }else {
            startRecording()
        }
    }
    var audioFilename: URL!
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("record.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            playButton.isEnabled = false
            recordPhoto.image = UIImage(named: "stop")
            recordPhoto.backgroundColor = .clear
            isRecording = true
        } catch {
            finishRecording(success: false)
        }
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            
            let sec = Double(audioRecorder.currentTime)
            guard sec <= 30.0 else {
                finishRecording(success: true)
                timerLabel.text = "30.0 / 30.0"
                return
            }
            let milsec = Double(round(10*sec)/10)
            let fraction = milsec.truncatingRemainder(dividingBy: 1.0)
            let secs = milsec - fraction
            // let melSec = (audioRecorder.currentTime * 100.0).truncatingRemainder(dividingBy: 100)
            
            timerLabel.text = "\(Int(secs)).\(Int(fraction * 10)) / 30.0"
            audioRecorder.updateMeters()
        }
    }
    
    var isRecorded = false
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        isRecording = false
        
        recordPhoto.image = UIImage(named: "undo-button-2")
        if !success{
            self.showAlert(withMessage: NSLocalizedString("التطبيق لم يستطع إكمال التسجيل، من فضلك أعد المحاولة.", comment: ""))
        }
        else {
            playButton.isEnabled = true
            isRecorded = true
        }
    }
    
    func Play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            recordPhoto.isUserInteractionEnabled = false
            playButton.setImage(UIImage(named: "round-pause-button"), for: .normal)
            audioPlayer.play()
            isPlaying = true
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func didPressPlay(_ sender: Any)
    {
        if(isPlaying)
        {
            Pause()
        }
        else
        {
            if FileManager.default.fileExists(atPath: audioFilename.path)
            {
                Play()
            }
            else
            {
                self.showAlert(withMessage: NSLocalizedString("لم يتم العثور على الملف الصوتي", comment: ""))
            }
        }
    }
    
    func Pause(){
        audioPlayer.stop()
        recordPhoto.isUserInteractionEnabled = true
        playButton.setImage(UIImage(named: "play-button-3"), for: .normal)
        isPlaying = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Pause()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad && string != "" {
            let numberStr: String = string
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            if let final = formatter.number(from: numberStr) {
                textField.text =  "\(textField.text ?? "")\(final)"
            }
            return false
        }
        return true
    }
}
