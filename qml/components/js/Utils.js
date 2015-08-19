.pragma library

function ListType(header) {
    this.header = header
}

var Search = new ListType(qsTr("Search station"));
var Top100 = new ListType(qsTr("Top 100"));
var Recommended = new ListType(qsTr("Recommended"));
var Local = new ListType(qsTr("Local"));
var Favorites = new ListType(qsTr("Favorites"));
