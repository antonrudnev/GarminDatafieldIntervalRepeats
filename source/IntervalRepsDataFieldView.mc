import Toybox.Activity;
import Toybox.Application;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class IntervalRepsDataFieldView extends WatchUi.SimpleDataField {

    hidden var currentTotalDistance = 0;
    hidden var lastIntervalDistance = 0;
    hidden var repeatCounter = 0;
    hidden var lapCounter = 0;
    hidden var isWorkoutStarted = false;
    hidden var workoutStepCounter = 0;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = Properties.getValue("DefaultTag");
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        if (isWorkoutStarted) {
            if ((workoutStepCounter / 2).toNumber() & 1) {
                return getCounterValue();
            }
            return (info.elapsedDistance != null ? info.elapsedDistance : 0).toNumber() - currentTotalDistance;
        }
        if (lapCounter & 1) {
            updateRepeatCounter();
        } else {
            return (info.elapsedDistance != null ? info.elapsedDistance : 0).toNumber() - currentTotalDistance;
        }
        return getCounterValue();
    }

    function getCounterValue() as Numeric or String {
        if (repeatCounter > 1) {
            var frmt = Properties.getValue("RepsValueFormat");
            if (System.getClockTime().sec % 3 == 0) {
                return format(Properties.getValue("RepsValueFormat"), [repeatCounter, lastIntervalDistance]);
            }
            return frmt.find("$1$") == null ? repeatCounter : lastIntervalDistance;
        }
        return lastIntervalDistance;
    }

    function onTimerLap() as Void {
        if (Activity.getActivityInfo().timerState == Activity.TIMER_STATE_ON) {
            isWorkoutStarted = false;
            lapCounter += 1;
            updateRepeatCounter();
        }
    }

    function onTimerStop() as Void {
        if (Properties.getValue("FieldReset")) {
            if (!isWorkoutStarted) {
                lapCounter = 1;
            }
        }
    }

    function onWorkoutStarted() as Void {
        isWorkoutStarted = true;
    }

    function onWorkoutStepComplete() as Void {
        workoutStepCounter += 1;
        updateRepeatCounter();
    }

    function updateRepeatCounter() as Void {
        var elapsedDistance = Activity.getActivityInfo().elapsedDistance.toNumber();
        if (elapsedDistance > currentTotalDistance) {
            if (lastIntervalDistance != elapsedDistance - currentTotalDistance) {
                lastIntervalDistance = elapsedDistance - currentTotalDistance;
                repeatCounter = 1;
            } else {
                repeatCounter += 1;
            }
            currentTotalDistance = elapsedDistance;
        }
    }

}