package com.example.sensordevices

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class StreamHandler(private val sensorManager: SensorManager, sensorType: Int, private var interval: Int = SensorManager.SENSOR_DELAY_NORMAL): EventChannel.StreamHandler, SensorEventListener {

    private val sensor = sensorManager.getDefaultSensor(sensorType)
    private var eventsink: EventChannel.EventSink? = null


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (sensor != null){
            eventsink = events
            sensorManager.registerListener(this, sensor, interval)
        }
    }

    override fun onCancel(arguments: Any?) {
       sensorManager.unregisterListener(this)
        eventsink = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        //println()
        //get actual readings from sensor
        val sensorValues = event!!.values[0]
        eventsink?.success(sensorValues)
    }

    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }


}