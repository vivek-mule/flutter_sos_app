# 🚨 Flutter SOS App

A powerful and lightweight Flutter application designed to quickly alert emergency contacts with your live location through a single tap, volume button sequence, shake gesture, or home screen widget — even in critical situations when time matters most.

---

## 📱 Features

- **Multiple SOS Triggers**  
  Trigger SOS instantly via:
  - On-screen SOS button  
  - Volume button pattern detection  
  - Phone shake detection  
  - Native Android home screen widget

- **Live Location Sharing**  
  Sends a Google Maps link with real-time GPS coordinates using the device's location services.

- **Contact Management**  
  Add, edit, or import emergency contacts manually or via native contact picker. Handeled edge cases for phone number add, pick or edit.

- **Native SMS Integration (Kotlin)**  
  SOS messages are sent via the Android SMS system with delivery status feedback.

- **Persistent Settings & Storage**  
  Stores user preferences and emergency contacts using `sqflite` and `SharedPreferences`, ensuring they remain available across sessions.


---

## 🛠 Tech Stack

- **Frontend**: Flutter, Dart  
- **Backend/Storage**: SQLite (`sqflite`), SharedPreferences  
- **Native Integration**: Kotlin (for widget & SMS)  
- **Device APIs**: Geolocator, Sensors Plus, Permission Handler  
- **UI/UX**: Google Fonts, Custom Dialogs, Material 3

---

## 🧪 Key Functionalities

- Home screen widget with native Kotlin `AppWidgetProvider`
- SMS dispatch via Kotlin using `SmsManager` and `PendingIntent` callbacks
- Shake and volume button detection using device sensors and volume streams
- Custom dialogs for Safety Tips and About Section
- Polished UI with consistent theme and adaptive layouts

---

## 📷 Screenshots

![Screenshot](https://drive.google.com/file/d/1CtWj7XAaHNCLTjUiJ-TWcIDyxlWFzXYV/view?usp=sharing)
![Screenshot](https://drive.google.com/file/d/1-zFGhkefMfEoTTShBfd62nEnAGuHL-wU/view?usp=sharing)
![Screenshot](https://drive.google.com/file/d/19rY9NiKIdq50uiuIKXzGDvWl937ZeZUg/view?usp=sharing)
![Screenshot](https://drive.google.com/file/d/1q5_8zIGCpHHFTe54DO8qko5bPRXF81nb/view?usp=sharing)
![Screenshot](https://drive.google.com/file/d/1ug84OQvdtgQ0VAMPxAHQebaIcwy_Qluy/view?usp=sharing)
![Screenshot](https://drive.google.com/file/d/1Yb5GN9D78AfjQ3OjZRlLzyngc_0vlfUO/view?usp=sharing)

---

## 📦 Installation

1. Clone this repository  
   ```bash
   git clone https://github.com/vivek-mule/flutter_sos_app
   cd flutter_sos_app
