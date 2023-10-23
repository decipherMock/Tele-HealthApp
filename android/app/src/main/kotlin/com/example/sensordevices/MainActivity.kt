package com.example.sensordevices

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.media.metrics.Event
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.example.test/devices"
    private val PRESSURE_CHANNEL = "com.example.test/pressure"

    private val PHYSICAL_DEVICES_CHANNEL = "tesPhysicalDevices"



    private var methodChannel: MethodChannel? = null
    private lateinit var sensorManager: SensorManager
    private var pressureChannel: EventChannel? = null
    private var pressureStreamHandler: StreamHandler? = null

    //physical devices event channel
    private var physicalDevicesChannel: MethodChannel? = null
    private var physicalDevicesChannelHandler: DevicesHandler? = null




    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //Setup Channels
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }


    //physical devices connectivity

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }
    private fun setupChannels(context: Context, messenger: BinaryMessenger){
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager


        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler{
            call, results ->
            if (call.method == "isSensorAvailable"){
                results.success(sensorManager!!.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            } else {
                results.notImplemented()
            }
        }

        //load pressurechannel
        pressureChannel = EventChannel(messenger, PRESSURE_CHANNEL)
        pressureStreamHandler = StreamHandler(sensorManager!!, Sensor.TYPE_PRESSURE)
        pressureChannel!!.setStreamHandler(pressureStreamHandler)

    }

    private fun teardownChannels(){
        methodChannel!!.setMethodCallHandler(null)
        pressureChannel!!.setStreamHandler(null)
    }

    private fun setupBluetoothChannel(context: Context, messenger: BinaryMessenger) {
        physicalDevicesChannel = MethodChannel(messenger, PHYSICAL_DEVICES_CHANNEL)
        physicalDevicesChannel!!.setMethodCallHandler { call, results ->
            if (call.method == "Paired") {
                val value = DevicesHandler.BLUETOOTH_SERVICE
                results.success(value)
            } else {
                results.notImplemented()
            }
        }
    }

}

