.pragma library
.import "Storage.js" as DB

var favoritesModel;

function init(model) {
    favoritesModel = model
    updateFavorites()
}

function updateFavorites() {
    if(favoritesModel)
        favoritesModel.clear();

    var stations = DB.loadStations();
    for(var i = 0; i < stations.rows.length; i++) {
        var row = stations.rows.item(i);
        favoritesModel.append(row);
    }
}

function removeFavorite(station) {
    console.log("Removing favorite:", station)
    DB.deleteStation(station)
    updateFavorites()
}

function addFavorite(station) {
    console.log("Saving favorite:", station)
    DB.saveStation(station)
    updateFavorites()
}

function getNextFavorite(currentStation) {
    if(!currentStation)
        return favoritesModel.get(0);

    var currentIndex = getModelIndexFromStation(currentStation);
    if(currentIndex+1 >= favoritesModel.count)
        return favoritesModel.get(0);

    return favoritesModel.get(currentIndex+1);
}

function getPrevFavorite(currentStation) {
    if(!currentStation)
        return favoritesModel.get(0);

    var currentIndex = getModelIndexFromStation(currentStation);
    console.log("currentIndex", currentIndex)
    if(currentIndex-1 < 0)
        return favoritesModel.get(favoritesModel.count-1);

    return favoritesModel.get(currentIndex-1);
}

function isFavorite(station) {
    return DB.stationExists(station);
}

function getModelIndexFromStation(station) {
    console.log("Searching for id:", station.id)
    for (var i=0; i<favoritesModel.count; i++) {
        var s = favoritesModel.get(i);
        console.log("looking at id:", s.id)
        if(s.id === station.id)
            return i;
    }
}
