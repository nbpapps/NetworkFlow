# Network Flow
A Swift Package for fetching and parsing data from the network.
You can choose between fetch and parse, only fetch (if the data is not formatted  as a Codable object) or only parse (if the data is not fetched - could be local)


## Using it in your project.
```
- In Xcode navigate to File -> Swift Packages -> Add Package Dependency…
Enter this URL - https://github.com/nbpapps/NetworkFlow 
```

**Setting an image in an ImageView:**
```swift
import UIKit
import ImageLoading

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell, let url = URL(string: "https://www.images.com/myImage") else {
            preconditionFailure()
        }
        cell.imageView?.loadImage(at: url)
    }
```

**Cancel  image loading:**
```swift
import UIKit
import ImageLoading

class MyCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.cancelImageLoad()
        myImageView.image = nil
    }
}
```

