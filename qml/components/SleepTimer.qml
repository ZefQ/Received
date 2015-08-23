import QtQuick 2.0

Timer {
    property int count: 0
    property int sleepSec: 0
    signal sleepTriggered()

    id: sleepTimer
    running: false
    repeat: true
    onTriggered: {
        count++;
        if(count >= sleepSec) {
            sleepTriggered()
        }
    }

    function stopTimer() {
        stop();
        count = 0;
    }

    function startTimer(sec) {
        console.log("Sleep timer set: " + sec);
        stopTimer();
        sleepSec = sec;
        start();
    }
}
