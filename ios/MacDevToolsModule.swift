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
    var id: String
    
    @Field
    var title: String
    
    @Field
    var enabled: Bool
    
    @Field
    var shortcut: KeyCombo?
    
    @Field
    var subItems: [MenuItem]?
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

@objc
protocol MenuElementProviderDelegate {
    @objc
    func setupMenu(didSelectSelectorGenerator: (_ callback: () -> Void) -> Selector) -> [UIMenuElement]
}

let OnMenuItemSelectedEvent = "onMenuItemSelected"

public class MacDevToolsModule: Module {
    private var customMenuItems: [MenuItem] = [] {
        didSet {
            UIMenuSystem.main.setNeedsRebuild()
        }
    }
        
    public required init(appContext: AppContext) {
        super.init(appContext: appContext)
        
        self.customMenuItems = [
            MenuItem(
                id: Field("h"),
                title: Field("Hello")
            ),
            MenuItem(
                id: Field("w"),
                title: Field("World!")
            )
        ]
    }
    
    public func definition() -> ModuleDefinition {
        Name("MacDevTools")
        
        Function("setCustomDevMenuItems") { (items: [MenuItem]) in
            customMenuItems = items
        }
        
        Events(OnMenuItemSelectedEvent)
    }
}

extension KeyCombo: CustomDebugStringConvertible {
    var debugDescription: String {
        return (modifiers.map { $0.rawValue } + [key]).joined(separator: "-")
    }
}

extension MacDevToolsModule: MenuElementProviderDelegate {
    private func didSelect(menuId: String) {
        print("didSelect(menuId: \(menuId)")
        sendEvent(OnMenuItemSelectedEvent, ["menuId": menuId])
    }

    private func submenu(items: [MenuItem], didSelectSelectorGenerator: (() -> Void) -> Selector) -> [UIMenuElement] {
        return items.map { item in
            let action = didSelectSelectorGenerator { [weak self] in
                self?.didSelect(menuId: item.id)
            }
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
    
    func setupMenu(didSelectSelectorGenerator: (() -> Void) -> Selector) -> [UIMenuElement] {
        return submenu(items: customMenuItems, didSelectSelectorGenerator: didSelectSelectorGenerator)
    }
}
