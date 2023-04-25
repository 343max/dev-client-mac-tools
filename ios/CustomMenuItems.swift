import ExpoModulesCore

enum ModifierKey: String, Enumerable {
    case Command
    case Shift
    case Option
    case Control
}

struct KeyCombo: Record {
    @Field
    var modifiers: [ModifierKey]

    @Field
    var key: String
}

struct MenuItem: Record {
    @Field
    var actionId: String?

    @Field
    var title: String

    @Field
    var enabled: Bool

    @Field
    var shortcut: KeyCombo?

    @Field
    var subitems: [MenuItem]?
}

extension KeyCombo {
    var modifierFlags: UIKeyModifierFlags {
        return UIKeyModifierFlags(modifiers.map { modifier in
            switch modifier {
            case .Command:
                return UIKeyModifierFlags.command
            case .Control:
                return UIKeyModifierFlags.control
            case .Option:
                return UIKeyModifierFlags.alternate
            case .Shift:
                return UIKeyModifierFlags.shift
            }
        })
    }
}

@objc(KDRMenuElementProviderDelegate)
public protocol MenuElementProviderDelegate {
    @objc func setupMenu(didSelectSelectorGenerator: (_ menuItemId: String) -> Selector) -> [UIMenuElement]
    @objc func didSelect(menuItemId: String)
}

extension KeyCombo: CustomDebugStringConvertible {
    var debugDescription: String {
        return (modifiers.map { $0.rawValue } + [key]).joined(separator: "-")
    }
}

enum MacDevToolsError: Error {
    case missingActionId
}

extension MacDevToolsModule: MenuElementProviderDelegate {
    public func didSelect(menuItemId: String) {
        sendEvent(OnMenuItemSelectedEvent, ["menuItemId": menuItemId])
    }

    private func submenu(items: [MenuItem], didSelectSelectorGenerator: (_ menuItemId: String) -> Selector) throws -> [UIMenuElement] {
        return try items.map { item throws in
            if let subitems = item.subitems, !subitems.isEmpty {
                return UIMenu(
                    title: item.title,
                    children: try submenu(items: subitems, didSelectSelectorGenerator: didSelectSelectorGenerator)
                )
            }
            
            guard let actionId = item.actionId else {
                throw MacDevToolsError.missingActionId
            }
            
            let action = didSelectSelectorGenerator(actionId)
            
            if let shortcut = item.shortcut {
                
                return UIKeyCommand(title: item.title,
                                    action: action,
                                    input: shortcut.key,
                                    modifierFlags: shortcut.modifierFlags)
            } else {
                return UICommand(title: item.title, action: action)
            }
        }
    }

    public func setupMenu(didSelectSelectorGenerator: (_ menuItemId: String) -> Selector) -> [UIMenuElement] {
        do {
            return try submenu(items: customMenuItems, didSelectSelectorGenerator: didSelectSelectorGenerator)
        } catch {
            return []
        }
    }
}
