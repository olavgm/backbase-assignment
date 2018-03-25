# City Search assignment

## Project

The project is an iOS app using Xcode 9.2 and Swift 4. Please note the [Binary Search](#binary-search) section since it's the key part of the project.

## View Controllers

There are two view controllers, **CitiesViewController** and **MapViewController**.

To keep the view controllers more manageable, I wrote extensions for each extra protocol in the controllers. For example, the CitiesViewController includes these extensions to separate the code blocks:

* ```extension CitiesViewController: UITableViewDataSource```
* ```extension CitiesViewController: UITableViewDelegate```
* ```extension CitiesViewController: UISearchResultsUpdating```

### CitiesViewController

It contains a _SearchController_ to perform the searches and a _TableView_ to show the results. It performs a segue to the **MapViewController** to show the map of the selected city. It takes the data from **CitiesController**.

### MapViewController

Standard _ViewController_ with a MKMapView. It gets the city as a parameter passed from **CitiesViewController**.

## Data Controllers

There is one data controller, _CitiesController_.

### CitiesController

It uses a _shared_ instance since there is need for initialization.

The initial idea was to return an array of results to _CitiesViewController_, but due to the performance optimizations required for 200,000+ items, all the cities are stored in the _items_ array, and the results to show are in the range stored in _resultsIndex_.

The default implementation of just filtering the _items_ array was really slow, around 0.4 seconds per search. I modified the code to keep all the cities in the _items_ array and using _resultsIndex_ to keep the indexes of the first and last elements valid for the search. There was some improvement, but it was still around 0.25 seconds per search using the ```Array.index```.

### Binary Search

The ```Array.index``` method goes through the items secuentially, so it is very slow and unnecessary since the _items_ array is sorted. So, I decided to implement a binary search that is, in this case, **3 orders of magnitude** faster (around 0.0001-0.0003 seconds per search). That makes the user experience so much better because now **results are shown instantly while typing**.

## Data Classes

There are two data clases: **City** and **Coordinates**:
* **City** is a _Decodable_ struct that contains the necessary fields for the project. It also contains the property _nameAndCountry_ which returns the format needed for the cell and _searchValue_, which is a lowercased version of _nameAndCountry_. It is not a getter because it is read multiple times during sorting and it slowed down the load of the app from around 6 seconds to around 25 seconds. To avoid that, the value is set by ```CitiesController.parseSearchValues()``` after all cities are loaded from the _JSON_ file.
* **Coordinates** is in a struct that contains the latitude and longitude of the city. _City_ contains a property ```coordinate``` that uses the _lat_ and _lon_ values to return a proper ```CLLocationCoordinate2D``` object.

## Tests

There are tests for the _CitiesController_ class with searches that return valid results and searches that return no results.

## Dependencies

There are no external dependencies to the project.

Thank you!

