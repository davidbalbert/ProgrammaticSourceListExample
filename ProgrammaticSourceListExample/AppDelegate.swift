//
//  AppDelegate.swift
//  ProgrammaticSourceListExample
//
//  Created by David Albert on 11/10/20.
//

import Cocoa

struct Item: Equatable, Hashable {
    var text: String
    var children: [Item]?
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource {
    var window: NSWindow!
    
    var data = [
        Item(text: "Foo"),
        Item(text: "Bar"),
        Item(text: "Hello", children: [
            Item(text: "Baz"),
            Item(text: "Qux"),
        ]),
        Item(text: "World", children: [
            Item(text: "Quux"),
            Item(text: "Quuux"),
        ])
    ]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")

        let outlineView = NSOutlineView()
        outlineView.translatesAutoresizingMaskIntoConstraints = false
        outlineView.selectionHighlightStyle = .sourceList
        outlineView.rowSizeStyle = .default
        outlineView.floatsGroupRows = false
        
        let col = NSTableColumn(identifier: .init("Main"))
        outlineView.addTableColumn(col)
        outlineView.outlineTableColumn = col
        
        outlineView.delegate = self
        outlineView.dataSource = self
        
        outlineView.expandItem(nil, expandChildren: true)
        
        guard let contentView = window.contentView else {
            return
        }
                
        contentView.addSubview(outlineView)
        
        NSLayoutConstraint.activate([
            outlineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outlineView.heightAnchor.constraint(equalToConstant: 300),
            outlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outlineView.widthAnchor.constraint(equalToConstant: 100),
        ])

        window.makeKeyAndOrderFront(self)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Item, let children = item.children {
            return children[index]
        } else {
            return data[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Item {
            return item.children?.count ?? 0
        } else {
            return data.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Item {
            return item.children != nil
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let item = item as? Item {
            return isGroup(item)
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let item = item as? Item {
            return !isGroup(item)
        } else {
            return true
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? Item else {
            return nil
        }
        
        var view = outlineView.makeView(withIdentifier: .init("Main"), owner: self) as? NSTableCellView
        
        if view == nil {
            let textField = NSTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.drawsBackground = false
            textField.isBezeled = false
            textField.isEditable = false
            textField.isSelectable = false
            
            let v = NSTableCellView()
            v.identifier = .init("Main")
            v.addSubview(textField)
            v.textField = textField
            
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: v.leadingAnchor),
                textField.topAnchor.constraint(equalTo: v.topAnchor),
                textField.bottomAnchor.constraint(equalTo: v.bottomAnchor)
            ])
            
            view = v
        }
        
        view?.textField?.stringValue = item.text
        
        return view
    }
    
    func isGroup(_ item: Item) -> Bool {
        item.children != nil && data.contains(item)
    }
}

