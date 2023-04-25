import ExpoModulesCore

let OnMenuItemSelectedEvent = "onMenuItemSelected"

public class MacDevToolsModule: Module {
    internal var customMenuItems: [MenuItem] = [] {
        didSet {
            UIMenuSystem.main.setNeedsRebuild()
        }
    }
        
    public required init(appContext: AppContext) {
        super.init(appContext: appContext)

        KDRDevHelper.shared()?.devMenu.menuElementProvider = self
    }
    
    public func definition() -> ModuleDefinition {
        Name("MacDevTools")
        
        Events(OnMenuItemSelectedEvent)
        
        Function("setCustomDevMenuItems") { (items: [MenuItem]) in
            customMenuItems = items
        }
    }
}
