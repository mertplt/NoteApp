//
//  NotesViewController.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.07.2023.
//

import UIKit
import TinyConstraints
import IQKeyboardManagerSwift
import ToastViewSwift

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements

    private let titleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let menuButton = UIButton(type: .custom)
    private let profileButton = UIButton(type: .custom)
    
    private let viewModel = NotesViewModel()
    private var router: NotesRouter!
    
    private lazy var addNoteButton: NaButton = {
        let button = NaButton()
         button.style = .primary
        button.isEnabled = true
         button.buttonTitle = "Add Note"
        button.leftImage = UIImage(named: "ic_addNote")
         button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        button.size(CGSize(width: 142, height: 41))
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

         return button
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
        configureKeyboardSettings()
        setupViewModelAndRouter()
        navigationBarSettings()
        refreshSettings()
        searchBar.delegate = self
        }

    @objc func refreshNotes() {
        viewModel.fetchNotes()
        tableView.refreshControl?.endRefreshing()
    }

    func configureUI(){
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(profileButton)
        view.addSubview(menuButton)
        view.addSubview(addNoteButton)
        
        view.backgroundColor = .white
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.color(.White)
       
        tableView.leadingToSuperview(offset: 24)
        tableView.trailingToSuperview(offset: 24)
        tableView.topToSuperview(usingSafeArea: true).constant = 8
        
        menuButton.setImage(UIImage(named: "ic_menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action:#selector(menuButtonTapped), for:.touchUpInside)
        let menuBarButtonItem=UIBarButtonItem(customView :menuButton)
        
        profileButton.setImage(UIImage(named: "img_user"), for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        let profileBarButtonItem = UIBarButtonItem(customView: profileButton)
        
        navigationItem.rightBarButtonItems=[profileBarButtonItem]
        navigationItem.leftBarButtonItems=[menuBarButtonItem]
        
        searchBar.translatesAutoresizingMaskIntoConstraints=true
        searchBar.placeholder="Search..."
        searchBar.setImage(UIImage(named: "ic_search")?.withTintColor(UIColor.color(.TextSecondary)), for: .search, state: .normal)
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .white
        searchBar.searchTextField.textColor = UIColor.color(.TextPrimary)
        
        searchBar.frame = titleView.bounds
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                searchBar.searchBarStyle = .default
                searchBar.layer.borderWidth = 1
                searchBar.layer.cornerRadius = 4
        
        searchBar.layer.borderColor = UIColor.color(.BorderColor).cgColor
        searchBar.searchTextField.backgroundColor = UIColor.color(.White)

                searchBar.delegate = self
                titleView.addSubview(searchBar)
                navigationItem.titleView = titleView

        navigationItem.hidesBackButton=true
        
        searchBar.widthAnchor.constraint(equalToConstant: 223).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
 
        addNoteButton.centerXToSuperview()
        addNoteButton.bottomToSuperview().constant = -58
   
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.color(.ActionPrimaryEnable)], for: .normal)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: addNoteButton.frame.height + 30 , right: 0)
        tableView.showsVerticalScrollIndicator = false
        
        profileButton.width(48)
        menuButton.width(48)
        
    }
    
    private func configureKeyboardSettings() {
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "Action Primary -100")
        IQKeyboardManager.shared.placeholderColor = UIColor(named: "Action Primary-50")
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Bitti"
         IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    private func setupViewModelAndRouter() {
        viewModel.fetchNotes()
        router = NotesRouter(viewController: self)
    }
    
    private func refreshSettings(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNotes), for: .valueChanged)
        tableView.refreshControl = refreshControl

    }
    
    private func navigationBarSettings(){
        let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()
                    
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.titleTextAttributes = [ .foregroundColor: UIColor.red ]
                    
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private func configureViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            print(errorMessage)
        }
    }
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         tableView.bottomToSuperview(offset:0)
         tableView.centerXToSuperview()
         tableView.topToSuperview(offset :20, usingSafeArea:true)
     }
    
    // MARK: - TableView Data Source and Delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        let note = viewModel.getNote(at: indexPath.row, with: searchBar.text)
        cell.titleLabel.text = note.title
        cell.noteLabel.text = note.note
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfNotes(with: searchBar.text)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return addNoteButton.frame.height
    }

    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return editAndDeleteRow(at: indexPath)
    }

    func deleteRow(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.performDeleteRow(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        deleteAction.setValue(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), forKey: "titleTextColor")
        
        present(alertController, animated: true, completion: nil)
    }

    func performDeleteRow(at indexPath: IndexPath) {
        viewModel.deleteNote(at: indexPath.row) { [weak self] isSuccess in
            if isSuccess {
                let toast = Toast.default(
                    image: UIImage(named: "ic_success")!,
                    title: "Note deleted"
                )
                toast.show()
                
                if let searchText = self?.searchBar.text, !searchText.isEmpty {
                    self?.viewModel.filterNotes(with: searchText)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                let toast = Toast.default(
                    image: UIImage(named: "ic_error64x64")!,
                    title: "Note could not be deleted"
                )
                toast.show()
            }
        }
    }

    func editRow(at indexPath: IndexPath) {
        let note = viewModel.getNote(at: indexPath.row, with: searchBar.text)
        router.navigateToEditNote(noteID: note.id, noteText: note.note, noteTitle: note.title)
    }

    func editAndDeleteRow(at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completionHandler) in
            self?.editRow(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor(named: "Helper Color-Yellow")
        editAction.image = UIImage(named: "ic_edit")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            self?.deleteRow(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Helper Color-Red")
        deleteAction.image = UIImage(named: "ic_trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: - Button Actions
    
     @objc
     func menuButtonTapped(){
        
     }
    
     @objc
     func profileButtonTapped(){
         router.navigateToProfile()
     }
    
     @objc
     func addNoteButtonTapped(){
         router.navigateToAddNote()
     }
    
    @objc func cancelButtonTapped() {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        profileButton.isHidden = false
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        viewModel.filterNotes(with: nil)
    }
}

class CustomTableViewCell :UITableViewCell{
    let titleLabel=UILabel()
    let noteLabel=UILabel()

    override init(style :UITableViewCell.CellStyle,reuseIdentifier:String?){
       super.init(style :style,reuseIdentifier :reuseIdentifier)
       
        titleLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        titleLabel.textColor = UIColor(named: "Text Primary")
       titleLabel.numberOfLines=0
       contentView.addSubview(titleLabel)
        
        selectionStyle = .none
        
       noteLabel.font = UIFont(name: "Inter-Medium", size: 14)
        noteLabel.textColor = UIColor(named: "Text Secondary")
       noteLabel.numberOfLines=0
       contentView.addSubview(noteLabel)
        
       titleLabel.top(to: contentView, offset: 8)
       titleLabel.left(to: contentView, offset: 8)
       titleLabel.right(to: contentView, offset: -8)
        
       noteLabel.topToBottom(of: titleLabel, offset: 4)
       noteLabel.left(to: contentView, offset: 8)
       noteLabel.right(to: contentView, offset: -8)
       noteLabel.bottom(to: contentView, offset: -8)
        
        contentView.backgroundColor = UIColor.color(.White)

    }
    
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Search Bar Delegate

extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterNotes(with: searchText)
     }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        profileButton.isHidden = true
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
                 .foregroundColor: UIColor.color(.ActionPrimaryEnable),
                 .font: UIFont.font(.interSemiBold, size: .small)
             ]
        
        cancelButton.setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(cancelButtonAttributes, for: .highlighted)
        
        navigationItem.rightBarButtonItem = cancelButton
        
        searchBar.showsCancelButton = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        profileButton.isHidden = false
    }
}
