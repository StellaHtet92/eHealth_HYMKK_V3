String apiUrl = "http://192.168.1.3:8080";

enum HomeMenu { Profile , Logout }

enum Gender{
  Male,
  Female
}

enum DisplayType{
  Chart,
  List
}

List<String> questionList = [
  "What is your blood type?",
  "Do you have any underlying Disease?",
  "Do you have allergies? Please describe here.",
  "Your weight and height.",
  "Do you smoke?"
];

const String EWS_CHART = "EWS";
const String TEMP_CHART = "Temperature (°C)";
const String BLOOD_PRESSURE_CHART = "Blood Pressure (mmHg)";
const String SPO2_CHART = "SPO2 (%)";
const String PULSE_CHART = "Pulse Rate (bpm)";
const String GLUCO_CHART = "Glucometer (mmol/L)";
const String COL_CHART = "Cholesterol (mg)";
const String HEART_RATE_CHART = "Heart Rate (bpm)";
