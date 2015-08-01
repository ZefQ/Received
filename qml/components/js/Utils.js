.pragma library

function ListType(header) {
    this.header = header
}

var Search = new ListType("Search station");
var Top100 = new ListType("Top 100");
var Favorites = new ListType("Favorites");
