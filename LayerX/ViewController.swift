//
//  ViewController.swift
//  LayerX
//
//  Created by Michael Chen on 2015/10/26.
//  Copyright © 2015年 Michael Chen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var imageView: MCDragAndDropImageView!
	@IBOutlet weak var sizeTextField: NSTextField!
	@IBOutlet weak var placeholderTextField: NSTextField!

	override var acceptsFirstResponder: Bool {
		return true
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		appDelegate().viewController = self
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.delegate = self

		sizeTextField.layer?.cornerRadius = 3
		sizeTextField.layer?.masksToBounds = true

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "windowDidResize:", name: NSWindowDidResizeNotification, object: appDelegate().window)
	}

	func windowDidResize(notification: NSNotification) {
		let window = notification.object as! NSWindow
		let size = window.frame.size
		sizeTextField.stringValue = "\(Int(size.width))x\(Int(size.height))"
	}

	override func scrollWheel(theEvent: NSEvent) {
		guard let _ = imageView.image else { return }

		let delta = theEvent.deltaY * 0.005;
		var alpha = imageView.alphaValue - delta
		alpha = min(alpha, 1)
		alpha = max(alpha, 0)
		imageView.alphaValue = alpha
	}
}

// MARK: - MCDragAndDropImageViewDelegate

extension ViewController: MCDragAndDropImageViewDelegate {
	func dragAndDropImageViewDidDrop(imageView: MCDragAndDropImageView) {

		sizeTextField.hidden = false
		placeholderTextField.hidden = true

		appDelegate().actualSize(nil)
	}
}

// MARK: - Movable NSView

class MCMovableView: NSView{
	override var mouseDownCanMoveWindow:Bool {
		return true
	}
}