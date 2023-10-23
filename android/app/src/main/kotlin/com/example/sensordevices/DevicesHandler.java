package com.example.sensordevices;

import android.app.Application;
import android.bluetooth.BluetoothClass;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.service.controls.DeviceTypes;

import com.lifesense.plugin.ble.LSBluetoothManager;
import com.lifesense.plugin.ble.OnSearchingListener;
import com.lifesense.plugin.ble.data.LSDeviceInfo;
import com.lifesense.plugin.ble.data.LSDeviceType;
import com.lifesense.plugin.ble.data.LSManagerStatus;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.systemchannels.KeyEventChannel;
import io.flutter.plugin.common.EventChannel;

public class DevicesHandler extends Application{
    private LSDeviceInfo deviceInfo;
    private LSBluetoothManager deviceManager;
    private LSDeviceType deviceType;

    private String conectedDevice;

    public String getBluetoothDevice(){
        return conectedDevice;
    }

    public void conectedDevice(String value) {
        conectedDevice = "Searching...";
    }

    @Override
    public void onCreate() {
        super.onCreate();
        //  LSBleManager.getInstance().initManager(getApplicationContext());
        LSBluetoothManager.getInstance().initManager(getApplicationContext());
        OnSearchingListener listener = new OnSearchingListener() {
            @Override
            public void onSearchResults(LSDeviceInfo lsDeviceInfo) {
                //TODO Handle Search Results
                deviceInfo = lsDeviceInfo;
            }
        };
        // List of device types to scan for (in this case, Blood Pressure Meter)
        List<LSDeviceType> types = new ArrayList<>();
        types.add(LSDeviceType.BloodPressureMeter);

        //State detection to avoid repeated calls to the interface
        LSManagerStatus status = LSBluetoothManager.getInstance().getManagerStatus();
        if (status == LSManagerStatus.Free) {
//Allow Scan
            LSBluetoothManager.getInstance().searchDevice(types, listener);
        } else if (status == LSManagerStatus.Scanning) {
//TODO The scan has been executed, if you need to rescan, you can execute stop and then rescan LSBluetoothManager.getInstance().stopSearch();}
        }


    }
}
