package com.example.emergency_v1

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class SosWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val remoteViews = RemoteViews(context.packageName, R.layout.sos_widget)

            // Create the intent to open MainActivity with SOS action
            val intent = Intent(context, MainActivity::class.java).apply {
                action = "TRIGGER_SOS_FROM_WIDGET"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            // Set the PendingIntent to your SOS button in widget layout
            remoteViews.setOnClickPendingIntent(R.id.sos_widget_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
        }
    }
}