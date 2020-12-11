import UIKit

/// Defines an interface for UIViews defined in .xib files.
public protocol NibLoadable {

    // the name of the associated nib file
    static var nibName: String { get }

    // loads the view from the nib
    func loadFromNib(owner: Any?)
}

public extension NibLoadable where Self: UIView {

    /// Specifies the name of the associated .xib file.
    /// Defaults to the name of the class implementing this protocol.
    /// Provide an override in your custom class if your .xib file has a different name than it's associated class.
    static var nibName: String {
        return String(describing: Self.self)
    }

    /// Provides an instance of the UINib for the conforming class.
    /// Uses the bundle for the conforming class and generates the UINib using the name of the .xib file specified in the nibName property.
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }

    /// Tries to instantiate the UIView class from the .xib file associated with the UIView subclass conforming to this protocol using the owner specified in the function call.
    /// The xib views frame is set to the size of the parent classes view and constraints are set to make the xib view the same size as the parent view. The loaded xib view is then added as a subview.
    /// This should be called from the UIView's initializers "init(frame: CGRect)" for instantiation in code, and "init?(coder aDecoder: NSCoder)" for use in storyboards.
    ///
    /// - Parameter owner: The file owner. Is usually an instance of the class associated with the .xib.
    func loadFromNib(owner: Any? = nil) {
        guard let view = Self.nib.instantiate(withOwner: owner, options: nil).first as? UIView else {
            fatalError("Error loading \(Self.nibName) from nib")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
