//
//  AccessibilityIdentifier.swift
//  ImageFeedUITests
//

enum AccessibilityIdentifier {
    enum AuthScreen {
        static let view = "AuthView"
        static let signInButton = "SignInButton"
        static let logoImageView = "LogoImageView"
    }

    enum WebViewScreen {
        static let webView = "UnsplashWebView"
        static let backButton = "UnsplashWebViewBackButton"
        static let progressView = "UnsplashWebViewProgressView"
        static let loginButton = "Login"
    }

    enum ImagesListScreen {
        static let view = "ImagesListView"
        static let tableView = "ImagesListTableView"

        enum Cell {
            static let view = "ImagesListCellView"
            static let imageView = "ImagesListCellImageView"
            static let gradientView = "ImagesListCellGradientImageView"
            static let likeButton = "ImagesListCellLikeButton"
            static let dateLabel = "ImagesListCellDateLabel"
        }
    }

    enum SingleImageScreen {
        static let view = "SingleImageView"
        static let scrollView = "SingleImageScrollView"
        static let imageView = "SingleImageImageView"
        static let backButton = "SingleImageBackButton"
        static let shareButton = "SingleImageShareButton"
    }

    enum ProfileScreen {
        static let view = "ProfileView"
        static let avatarImageView = "ProfileAvatarImageView"
        static let logoutButton = "ProfileLogoutButton"
        static let nameLabel = "ProfileNameLabel"
        static let loginLabel = "ProfileLoginLabel"
        static let descriptionLabel = "ProfileDescriptionLabel"
    }

    enum TabBar {
        static let view = "TabBarView"
        static let imagesListTab = "TabBarImagesListTab"
        static let profileTab = "TabBarProfileTab"
    }

    enum Alert {
        static let view = "AlertView"
    }
}
