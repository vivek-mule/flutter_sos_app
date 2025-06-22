package com.example.emergency_v1

import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.telephony.SmsManager
import com.folksable.volume_listener.VolumeListenerActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : VolumeListenerActivity() {
    private val SMS_CHANNEL = "com.example.emergency_v1/sms"
    private val WIDGET_CHANNEL = "com.example.sosapp/widget"

    private var pendingSosTrigger = false
    private var flutterReady = false
    private lateinit var widgetChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // SMS sending logic
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "sendSms") {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")
                    if (phoneNumber != null && message != null) {
                        try {
                            val smsManager = SmsManager.getDefault()

                            val sentIntent = PendingIntent.getBroadcast(this, 0, Intent("SMS_SENT"), PendingIntent.FLAG_IMMUTABLE)

                            registerReceiver(object : BroadcastReceiver() {
                                override fun onReceive(context: Context?, intent: Intent?) {
                                    when (resultCode) {
                                        Activity.RESULT_OK -> {
                                            result.success("SMS_SENT")
                                        }
                                        SmsManager.RESULT_ERROR_GENERIC_FAILURE,
                                        SmsManager.RESULT_ERROR_NO_SERVICE,
                                        SmsManager.RESULT_ERROR_NULL_PDU,
                                        SmsManager.RESULT_ERROR_RADIO_OFF -> {
                                            result.error("SMS_FAILED", "SMS failed to send", null)
                                        }
                                        else -> {
                                            result.error("SMS_UNKNOWN", "Unknown error", null)
                                        }
                                    }
                                    unregisterReceiver(this)
                                }
                            }, IntentFilter("SMS_SENT"))

                            smsManager.sendTextMessage(phoneNumber, null, message, sentIntent, null)
                        } catch (e: Exception) {
                            result.error("SMS_ERROR", "Error sending SMS: ${e.localizedMessage}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Missing phoneNumber or message", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        // Widget channel for SOS trigger
        widgetChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)
        widgetChannel.setMethodCallHandler { call, result ->
            if (call.method == "ackTrigger") {
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        flutterReady = true

        // Trigger SOS if pending
        if (pendingSosTrigger) {
            widgetChannel.invokeMethod("triggerSos", null)
            pendingSosTrigger = false
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == "TRIGGER_SOS_FROM_WIDGET") {
            if (flutterReady && ::widgetChannel.isInitialized) {
                widgetChannel.invokeMethod("triggerSos", null)
            } else {
                pendingSosTrigger = true
            }
        }
    }

    override fun onStart() {
        super.onStart()
        if (intent?.action == "TRIGGER_SOS_FROM_WIDGET") {
            if (flutterReady && ::widgetChannel.isInitialized) {
                widgetChannel.invokeMethod("triggerSos", null)
            } else {
                pendingSosTrigger = true
            }
        }
    }
}
