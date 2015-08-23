.pragma library

function ListType(header) {
    this.header = header
}

var Search = new ListType(qsTr("Search station"));
var Top100 = new ListType(qsTr("Top 100"));
var Recommended = new ListType(qsTr("Recommended"));
var Local = new ListType(qsTr("Local"));
var Favorites = new ListType(qsTr("Favorites"));

function secToTimeString(sec) {
    var hours = Math.floor(sec / 3600);
    var minutes = Math.floor((sec - (hours * 3600)) / 60);
    var seconds = sec - (hours * 3600) - (minutes * 60);

    hours = hours < 10 ? "0"+hours : hours;
    minutes = minutes < 10 ? "0"+minutes : minutes;
    seconds = seconds < 10 ? "0"+seconds : seconds;

    var time = hours+':'+minutes+':'+seconds;
    return time;
}
