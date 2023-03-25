#include <Wire.h>
#include <MPU6050.h>
#include <Math.h>
#include <time.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <string.h>


const int MPU_addr = 0x68;  // I2C address of the MPU-6050
int16_t AcX, AcY, AcZ, Tmp, GyX, GyY, GyZ;
float ax = 0, ay = 0, az = 0, gx = 0, gy = 0, gz = 0;

int amplitude = 0, acc_time, accident = 0;



#define samples 10

#define maxVal 7


BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("disconnected");
  }
};

void setup() {
  // int amplitude=0;
  float raw_amplitude;

  Serial.begin(115200);

  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);

  for (int i = 0; i < samples; i++) {
    mpu_read();
    ax = (AcX - 2050) / 16384.00;
    ay = (AcY - 77) / 16384.00;
    az = (AcZ - 1947) / 16384.00;
    // Serial.print(ax);
    // Serial.print(" ");
    // Serial.print(ay);
    // Serial.print(" ");
    // Serial.print(az);
    // Serial.println("");

    raw_amplitude = pow(pow(ax, 2) + pow(ay, 2) + pow(az, 2), 0.5);
    amplitude += raw_amplitude * 10;  // Mulitiplied by 10 bcz values are between 0 to 1
    // Serial.println(amplitude);

    // xsample+=ax;
    // ysample+=ay;
    // zsample+=az;
  }

  amplitude = amplitude / samples;
  Serial.println(amplitude);

  // Create the BLE Device
  BLEDevice::init("MyDevice");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService* pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_INDICATE);

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}



void loop() {
  while (deviceConnected) {
    // pCharacteristic->setValue((uint8_t*)&value, 4);
    // pCharacteristic->notify();
    // value++;

    // --------Accident Detection-------
    int cur_time;
    mpu_read();
    ax = (AcX - 2050) / 16384.00;
    ay = (AcY - 77) / 16384.00;
    az = (AcZ - 1947) / 16384.00;
    gx = (GyX + 270) / 131.07;
    gy = (GyY - 351) / 131.07;
    gz = (GyZ + 136) / 131.07;

    // Serial.print(ax);
    // Serial.print(" ");
    // Serial.print(ay);
    // Serial.print(" ");
    // Serial.print(az);
    // Serial.println("");

    int old_amplitude = amplitude;
    // char response[20];

    // calculating Amplitude vactor for 3 axis
    float raw_amplitude = pow(pow(ax, 2) + pow(ay, 2) + pow(az, 2), 0.5);
    int amplitude = raw_amplitude * 10;  // Mulitiplied by 10 bcz values are between 0 to 1
    Serial.println(amplitude);
    Serial.print("Difference : ");
    Serial.println(abs(amplitude - old_amplitude));

    // Triggering------------------------------------------------------------------
    if (abs(amplitude - old_amplitude) > maxVal) {
      Serial.println("Accident Detected");

      // sending accident trigger message to Phone
      pCharacteristic->setValue("accident");
      pCharacteristic->notify();
      Serial.println("Trigger message was sent");
      delay(20000);  // waiting for response, 20 sec


      // receiving response from Phone
      std::string value = pCharacteristic->getValue();
      Serial.print("Received message: ");
      Serial.println(value.c_str());
      // Deal 3 cases, 1. Successfully sent message, 2. Accident is ignored by User, 3. Failed to send message
      //break;
    }
    delay(100);
    // --------Accident Detection-------

    // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  }

  if (!deviceConnected && oldDeviceConnected) {
    delay(500);                   // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising();  // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }

  // disconnecting


  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    // do stuff here on connecting
    Serial.println("Connected");
    oldDeviceConnected = deviceConnected;
  }

  // delay(100);
}


// function to read data from accelero gyro
void mpu_read() {
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr, 14, true);  // request a total of 14 registers
  AcX = Wire.read() << 8 | Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
  AcY = Wire.read() << 8 | Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ = Wire.read() << 8 | Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp = Wire.read() << 8 | Wire.read();  // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX = Wire.read() << 8 | Wire.read();  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY = Wire.read() << 8 | Wire.read();  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ = Wire.read() << 8 | Wire.read();  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
}


// void send_event(const char *event) {
//   Serial.print("Connecting to ");
//   Serial.println(host);
//   WiFiClient client;
//   const int httpPort = 80;
//   if (!client.connect(host, httpPort)) {
//     Serial.println("Connection failed");
//     return;
//   }
//   String url = "/trigger/";
//   url += event;
//   url += "/with/key/";
//   url += privateKey;
//   Serial.print("Requesting URL: ");
//   Serial.println(url);
//   client.print(String("GET ") + url + " HTTP/1.1\r\n" + "Host: " + host + "\r\n" + "Connection: close\r\n\r\n");
//   while (client.connected()) {
//     if (client.available()) {
//       String line = client.readStringUntil('\r');
//       Serial.print(line);
//     } else {
//       delay(50);
//     };
//   }
//   Serial.println();
//   Serial.println("closing connection");
//   client.stop();
// }
