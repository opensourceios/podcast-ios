//
//  NotificationsPageViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol NotificationsViewControllerDelegate: class {
    /// Update the notification count on the top tab bar item to reflect the number of unread notifications
    func updateNotificationCount(to number: Int, for viewController: NotificationsViewController)
    /// Keep track of notifications tapped/read
    func didTapNotification(notificationRead: NotificationType)
    /// Update tab bar item image to reflect the presence of unread notifications
    func updateNotificationTabBarImage(to newNotifications: Bool)
}

/// Paged ViewController that displays new episode and activity notifications.
class NotificationsPageViewController: UIPageViewController {

    var pages = [NotificationsViewController]()
    var tabBarView: UnderlineTabBarView!

    weak var tabBarDelegate: NotificationsPageViewControllerDelegate?

    static let tabBarViewHeight: CGFloat = 44.5
    static var readNotifications: [String: [String]] = ["follows": [], "shares": [], "episodes": []]

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navigationItem.title = "Notifications"

        tabBarView = UnderlineTabBarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: NotificationsPageViewController.tabBarViewHeight))
        tabBarView.delegate = self
        tabBarView.setUp(sections: ["New Episodes", "Activity"])
        view.addSubview(tabBarView)

        let newEpisodesViewController = NotificationsViewController(for: .newEpisodes)
        let followSharesViewController = NotificationsViewController(for: .activity)
        pages = [newEpisodesViewController, followSharesViewController]
        pages.forEach { 
            $0.delegate = self
            $0.view.layoutSubviews() // so that the notifications badge updates
            $0.loadNotifications()
        }

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self
        stylizeNavBar()
    }

    func stylizeNavBar() {
        navigationController?.navigationBar.tintColor = .sea
        navigationController?.navigationBar.backgroundColor = .offWhite
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = .offWhite
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarDelegate?.updateTabBarForNewNotifications(false)
    }

    /// Saves read notifications and sends them to the backend.
    /// - parameter success: Completion method upon success
    /// - parameter failure: Completion method upon failure
    static func saveReadNotifications(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let saveReadNotificationsEndpointRequest = SaveReadNotificationsEndpointRequest(readIds: NotificationsPageViewController.readNotifications)
        saveReadNotificationsEndpointRequest.success = { _ in
            print("Successfully saved read notifications")
            success?()
            self.readNotifications = ["follows": [], "shares": [], "episodes": []]
        }
        saveReadNotificationsEndpointRequest.failure = { _ in
            print("Failed to save read notifications")
            failure?()
        }
        System.endpointRequestQueue.addOperation(saveReadNotificationsEndpointRequest)
    }
}

// MARK: - UIPageViewController Methods

extension NotificationsPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        navigationController?.navigationBar.prefersLargeTitles = true
        if let viewController = viewController as? NotificationsViewController,
            let index = pages.index(of: viewController), index != 0 {
            return pages[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? NotificationsViewController,
            let index = pages.index(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let lastViewController = previousViewControllers.first as? NotificationsViewController,
            let index = pages.index(of: lastViewController), completed {
            tabBarView.updateSelectedTabAppearance(toNewIndex: index == 1 ? 0 : 1)
        }
    }

}

// MARK: - TabBarDelegate

extension NotificationsPageViewController: TabBarDelegate {
    func selectedTabDidChange(toNewIndex newIndex: Int) {
        if newIndex == 1 {
            setViewControllers([pages[newIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([pages[newIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
}

// MARK: - NotificationsViewController Delegate

extension NotificationsPageViewController: NotificationsViewControllerDelegate {
    func updateNotificationCount(to number: Int, for viewController: NotificationsViewController) {
        if let index = pages.index(of: viewController) {
            tabBarView.updateNotificationCount(to: number, for: index)
        }
    }

    func didTapNotification(notificationRead: NotificationType) {
        switch notificationRead {
        case .follow, .share:
            break
        case .newlyReleasedEpisode(_, let episode):
            NotificationsPageViewController.readNotifications["episodes"]?.append(episode.id)
        }
    }

    func updateNotificationTabBarImage(to newNotifications: Bool) {
        tabBarDelegate?.updateTabBarForNewNotifications(newNotifications)
    }

}