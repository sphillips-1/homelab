#include <Arduino.h>
#include <HTTPClient.h>
#include <WiFi.h>

#include "wifi_config.h"

struct PlayerStatus {
    String book = "Unknown";
    int chapter = 0;
    int positionSeconds = 0;
    int durationSeconds = 0;
    bool playing = false;
    int batteryPercent = 0;
};

static PlayerStatus currentStatus;
static unsigned long lastFetchMillis = 0;

String formatDuration(int seconds) {
    int hours = seconds / 3600;
    int minutes = (seconds % 3600) / 60;
    int secs = seconds % 60;

    char buffer[24];
    if (hours > 0) {
        snprintf(buffer, sizeof(buffer), "%02d:%02d:%02d", hours, minutes, secs);
    } else {
        snprintf(buffer, sizeof(buffer), "%02d:%02d", minutes, secs);
    }

    return String(buffer);
}

String extractStringField(const String &payload, const String &key) {
    String pattern = "\"" + key + "\"";
    int start = payload.indexOf(pattern);
    if (start < 0) {
        return String();
    }

    int valueStart = payload.indexOf(':', start) + 1;
    int valueEnd = payload.indexOf(',', valueStart);
    if (valueEnd < 0) {
        valueEnd = payload.indexOf('}', valueStart);
    }

    if (valueEnd < 0 || valueStart >= valueEnd) {
        return String();
    }

    String value = payload.substring(valueStart, valueEnd);
    value.trim();
    value.remove(0, 1);
    value.remove(value.length() - 1);
    return value;
}

int extractIntField(const String &payload, const String &key) {
    String pattern = "\"" + key + "\"";
    int start = payload.indexOf(pattern);
    if (start < 0) {
        return 0;
    }

    int valueStart = payload.indexOf(':', start) + 1;
    int valueEnd = payload.indexOf(',', valueStart);
    if (valueEnd < 0) {
        valueEnd = payload.indexOf('}', valueStart);
    }

    if (valueEnd < 0 || valueStart >= valueEnd) {
        return 0;
    }

    String value = payload.substring(valueStart, valueEnd);
    value.trim();
    return value.toInt();
}

bool extractBoolField(const String &payload, const String &key) {
    String pattern = "\"" + key + "\"";
    int start = payload.indexOf(pattern);
    if (start < 0) {
        return false;
    }

    int valueStart = payload.indexOf(':', start) + 1;
    int valueEnd = payload.indexOf(',', valueStart);
    if (valueEnd < 0) {
        valueEnd = payload.indexOf('}', valueStart);
    }

    if (valueEnd < 0 || valueStart >= valueEnd) {
        return false;
    }

    String value = payload.substring(valueStart, valueEnd);
    value.trim();
    return value.equalsIgnoreCase("true");
}

void printStatus(const PlayerStatus &status) {
    Serial.println("=== Player Status ===");
    Serial.printf("Book: %s\n", status.book.c_str());
    Serial.printf("Chapter: %d\n", status.chapter);
    Serial.printf("Position: %s / %s\n", formatDuration(status.positionSeconds).c_str(), formatDuration(status.durationSeconds).c_str());
    Serial.printf("Playing: %s\n", status.playing ? "yes" : "no");
    Serial.printf("Battery: %d%%\n", status.batteryPercent);
    Serial.println("====================");
}

bool fetchStatus(PlayerStatus &status) {
    if (WiFi.status() != WL_CONNECTED) {
        return false;
    }

    HTTPClient http;
    String url = String("http://") + PI_HOST + ":" + PI_PORT + "/api/status";
    Serial.printf("Requesting: %s\n", url.c_str());

    http.begin(url);
    int responseCode = http.GET();
    if (responseCode != HTTP_CODE_OK) {
        http.end();
        return false;
    }

    String payload = http.getString();
    http.end();

    status.book = extractStringField(payload, "book");
    status.chapter = extractIntField(payload, "chapter");
    status.positionSeconds = extractIntField(payload, "position");
    status.durationSeconds = extractIntField(payload, "duration");
    status.playing = extractBoolField(payload, "playing");
    status.batteryPercent = extractIntField(payload, "battery");

    return true;
}

void setup() {
    Serial.begin(115200);
    delay(1000);

    Serial.println("ESP32 audiobook controller starting...");
    Serial.println("Target: WiFi + Raspberry Pi API status polling");

    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASS);

    Serial.printf("Connecting to WiFi SSID: %s\n", WIFI_SSID);
    unsigned long startTime = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - startTime < 20000) {
        delay(500);
        Serial.print(".");
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.println();
        Serial.print("WiFi connected. IP address: ");
        Serial.println(WiFi.localIP());
    } else {
        Serial.println();
        Serial.println("WiFi connection failed. Update wifi_config.h and retry.");
    }

    if (fetchStatus(currentStatus)) {
        printStatus(currentStatus);
    } else {
        Serial.println("Unable to fetch player status from the Raspberry Pi API yet.");
    }
}

void loop() {
    if (millis() - lastFetchMillis >= 5000) {
        lastFetchMillis = millis();
        if (fetchStatus(currentStatus)) {
            printStatus(currentStatus);
        } else {
            Serial.println("Polling failed; check WiFi and the Raspberry Pi API endpoint.");
        }
    }

    delay(100);
}
