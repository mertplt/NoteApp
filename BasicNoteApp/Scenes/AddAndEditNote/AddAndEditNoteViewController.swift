//
//  AddAndEditNoteViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 25.07.2023.
//

import UIKit
import ToastViewSwift
import IQKeyboardManagerSwift

class AddAndEditNoteViewController: UIViewController, UITextViewDelegate {
    
    var isPressesdSaveButton : Bool = false
    var isAdd = Bool()
    var noteID = Int()
    var noteText = String()
    var noteTitle = String()
    
    var viewModel: AddAndEditNoteViewModel!
    
    private var router: AddAndEditNoteRouter!

    private let noteTitleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.interSemiBold, size: .custom(size: 22))
        textView.textColor = UIColor.color(.TextPrimary)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.backgroundColor = UIColor.color(.White)
        
        return textView
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.font(.interSemiBold, size: .normal)
        textView.textColor = UIColor.color(.TextSecondary)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textView.backgroundColor = UIColor.color(.White)

        return textView
    }()
    
    private let NavigationBarTitle: NaLabel = {
        let label = NaLabel()
        label.style = .explanation
        label.textColor = UIColor.color(.TextPrimary)
        label.labelText = "Add Note"
        return label
    }()
    
    private lazy var saveNoteButton: NaButton = {
        let button = NaButton()
        button.style = .primary
        button.buttonTitle = "Save Note"
        button.addTarget(self, action: #selector(saveNoteButtonTapped), for: .touchUpInside)
        button.size(CGSize(width: 142, height: 41))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
        textViewAndRouterSettings()
    }

    func configureUI() {
        view.addSubview(NavigationBarTitle)
        view.addSubview(noteTitleTextView)
        view.addSubview(saveNoteButton)
        view.addSubview(noteTextView)
        
        noteTitleTextView.topToSuperview().constant = 135
        noteTitleTextView.leadingToSuperview().constant = 24
        noteTitleTextView.trailingToSuperview().constant = -24
        noteTitleTextView.centerXToSuperview()

        noteTextView.topToBottom(of: noteTitleTextView, offset: 8)
        noteTextView.leadingToSuperview().constant = 24
        noteTextView.trailingToSuperview().constant = -24
        noteTextView.centerXToSuperview()

        saveNoteButton.topToBottom(of: noteTextView, offset: 25)
        saveNoteButton.centerXToSuperview()

        view.backgroundColor = UIColor.color(.White)

        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backButtonTapped))
        backBarButtonItem.tintColor = UIColor(named: "Text Primary")
        navigationItem.leftBarButtonItem = backBarButtonItem

        navigationItem.titleView = NavigationBarTitle
        
        if isAdd == true {
            noteTitleTextView.text = "Enter Title"
            noteTitleTextView.textColor = UIColor.lightGray
            noteTitleTextView.becomeFirstResponder()
            noteTitleTextView.selectedTextRange = noteTitleTextView.textRange(from: noteTitleTextView.beginningOfDocument, to: noteTitleTextView.beginningOfDocument)
            
            noteTextView.text = "Enter Text"
            noteTextView.textColor = UIColor.lightGray
            noteTextView.becomeFirstResponder()
            noteTextView.selectedTextRange = noteTextView.textRange(from: noteTextView.beginningOfDocument, to: noteTextView.beginningOfDocument)
        } else {
            NavigationBarTitle.labelText = "Edit Note"
            print(noteID)
            noteTextView.text = noteText
            noteTitleTextView.text = noteTitle
        }
        
        saveNoteButton.isEnabled = false
    }
    
    private func configureViewModel(){
        viewModel = AddAndEditNoteViewModel(
                    noteID: noteID,
                    noteText: noteText,
                    noteTitle: noteTitle
                )
        
        viewModel.isAdd = isAdd
        
        if viewModel.isAdd {
            noteTitleTextView.text = viewModel.noteTextPlaceholder
            noteTitleTextView.textColor = UIColor.lightGray
            
            noteTextView.text = viewModel.noteTextPlaceholder
            noteTextView.textColor = UIColor.lightGray
        } else {
            noteTitleTextView.text = viewModel.noteTitle
            noteTextView.text = viewModel.noteText
        }
    }
    
    private func textViewAndRouterSettings(){
        noteTitleTextView.delegate = self
        noteTextView.delegate = self
        IQKeyboardManager.shared.enable = true
        
        router = AddAndEditNoteRouter(viewController: self)
    
        noteTitleTextView.autocapitalizationType = .sentences
        noteTextView.autocapitalizationType = .sentences
    }
    
    func validateInputs() {
           if viewModel.isTitleValid && viewModel.isNoteValid {
               saveNoteButton.isEnabled = true
           } else {
               saveNoteButton.isEnabled = false
           }
       }

    @objc func backButtonTapped() {
        router.navigateBack()
    }
    
    @objc func saveNoteButtonTapped() {
        saveNoteButton.isEnabled = false
        
        viewModel.saveNote { result in
            switch result {
            case .success(let ID):
                if self.viewModel.isAdd {
                    let toast = Toast.default(
                        image: UIImage(named: "ic_success")!,
                        title: "Note Added"
                    )
                    toast.show()
                } else {
                    let toast = Toast.default(
                        image: UIImage(named: "ic_success")!,
                        title: "Note Updated"
                    )
                    toast.show()
                }
                
                self.saveNoteButton.isEnabled = true
                
            case .failure(let error):
                let toast = Toast.default(
                    image: UIImage(named: "ic_error64x64")!,
                    title: "Failed to save note.",
                    subtitle: error.localizedDescription
                )
                toast.show()
                
                self.saveNoteButton.isEnabled = true
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        if !text.isEmpty {
             let firstChar = text.prefix(1).capitalized
             let restOfText = text.dropFirst()
             
             textView.text = firstChar + restOfText.lowercased()
         }
        
        if textView == noteTitleTextView {
            viewModel.updateNoteTitle(text)
        } else if textView == noteTextView {
            viewModel.updateNoteText(text)
        }
            validateInputs()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            if textView == noteTextView {
                textView.text = "Enter Text"
            } else {
                textView.text = "Enter Title"
            }
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            if textView == noteTextView {
                textView.textColor = UIColor.color(.TextSecondary)
            } else {
                textView.textColor = UIColor.color(.TextPrimary)
            }
            textView.text = text
        } else {
            return true
        }
        
        validateInputs()
        
        return false
    }
}
