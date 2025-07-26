import UIKit

// MARK: - Action Item Model
struct ActionItem: Hashable {
    let id = UUID()
    let title: String
    let icon: String?
    let action: ActionType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ActionItem, rhs: ActionItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum ActionType {
    case openURL(URL)
    case pushViewController(() -> UIViewController)
    case showAlert(title: String, message: String)
    case custom(() -> Void)
}

// MARK: - MoreViewController
class MoreViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ActionItem>!
    
    private var actionItems: [ActionItem] = []
    
    enum Section {
        case main
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        loadActionItems()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "More"
        view.backgroundColor = .systemBackground
        
        // Configure collection view layout
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        // Register cell
        collectionView.register(ActionItemCell.self, forCellWithReuseIdentifier: ActionItemCell.reuseIdentifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Data Source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ActionItem>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ActionItemCell.reuseIdentifier,
                for: indexPath
            ) as! ActionItemCell
            cell.configure(with: item)
            return cell
        }
    }
    
    private func loadActionItems() {
        // Example action items - customize these as needed
        actionItems = [
            ActionItem(
                title: "Open GitHub",
                icon: "link",
                action: .openURL(URL(string: "https://github.com")!)
            ),
            ActionItem(
                title: "Show Sample View",
                icon: "square.stack",
                action: .pushViewController { SampleViewController() }
            ),
            ActionItem(
                title: "Show Alert",
                icon: "exclamationmark.bubble",
                action: .showAlert(title: "Alert", message: "This is a sample alert")
            ),
            ActionItem(
                title: "Custom Action",
                icon: "star",
                action: .custom { print("Custom action executed") }
            )
        ]
        
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ActionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(actionItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Public Methods
    func addActionItem(_ item: ActionItem) {
        actionItems.append(item)
        updateSnapshot()
    }
    
    func removeActionItem(at index: Int) {
        guard actionItems.indices.contains(index) else { return }
        actionItems.remove(at: index)
        updateSnapshot()
    }
}

// MARK: - UICollectionViewDelegate
extension MoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item.action {
        case .openURL(let url):
            UIApplication.shared.open(url)
            
        case .pushViewController(let viewControllerProvider):
            let viewController = viewControllerProvider()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .showAlert(let title, let message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        case .custom(let action):
            action()
        }
    }
}

// MARK: - ActionItemCell
class ActionItemCell: UICollectionViewCell {
    static let reuseIdentifier = "ActionItemCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
    }
    
    func configure(with item: ActionItem) {
        titleLabel.text = item.title
        if let iconName = item.icon {
            iconImageView.image = UIImage(systemName: iconName)
        }
    }
}

// MARK: - SampleViewController
class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sample View"
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "This is a sample view controller"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}