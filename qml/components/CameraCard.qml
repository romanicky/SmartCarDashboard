import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtMultimedia
import QtCore
import "../themes"

Rectangle {
    id: cameraCard
    color: "#000000"
    border.color: Theme.colors.cardBorder
    border.width: 1
    radius: 15
    clip: true

    // Camera permission
    CameraPermission {
        id: cameraPermission

        Component.onCompleted: {
            console.log("Camera permission status:", cameraPermission.status);
            if (cameraPermission.status === Qt.PermissionStatus.Undetermined) {
                console.log("Requesting camera permission...");
                cameraPermission.request();
            }
        }

        onStatusChanged: {
            console.log("Camera permission changed to:", cameraPermission.status);
            if (cameraPermission.status === Qt.PermissionStatus.Granted) {
                console.log("Camera permission granted!");
                cameraDevice.active = true;
            } else if (cameraPermission.status === Qt.PermissionStatus.Denied) {
                console.log("Camera permission denied!");
            }
        }
    }

    // Camera setup
    CaptureSession {
        id: captureSession
        camera: cameraDevice
        videoOutput: videoOutput
    }

    Camera {
        id: cameraDevice
        active: cameraPermission.status === Qt.PermissionStatus.Granted

        Component.onCompleted: {
            console.log("Available cameras:", MediaDevices.videoInputs.length);
            if (MediaDevices.videoInputs.length > 0) {
                console.log("Using camera:", MediaDevices.videoInputs[0].description);
                cameraDevice.cameraDevice = MediaDevices.videoInputs[0];
            } else {
                console.log("No camera devices found!");
            }
        }

        onErrorOccurred: function (error, errorString) {
            console.log("Camera error:", errorString);
        }
    }

    // Status text for debugging
    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        text: "Camera: " + (cameraDevice.cameraDevice ? cameraDevice.cameraDevice.description : "None") + " | Active: " + cameraDevice.active + " | Available: " + MediaDevices.videoInputs.length
        color: "#00FF00"
        font.pixelSize: 10
        z: 100
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Camera title
        Text {
            text: "REAR CAMERA"
            color: "#FF6B6B"
            font.pixelSize: 16
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Camera feed area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colors.buttonBackground
            border.color: "#FF6B6B"
            border.width: 2
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                // Camera video output
                VideoOutput {
                    id: videoOutput
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        // Grid overlay for parking guide
                        Canvas {
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d");
                                var centerX = width / 2;

                                // Distance lines - curved parking guide lines
                                // Green zone (safe - far)
                                ctx.strokeStyle = "#4CAF50";
                                ctx.lineWidth = 3;
                                ctx.globalAlpha = 0.7;
                                ctx.beginPath();
                                var farY = height * 0.25;
                                var farCurve = width * 0.35;
                                ctx.moveTo(0, farY);
                                ctx.quadraticCurveTo(centerX, farY + farCurve, width, farY);
                                ctx.stroke();

                                // Distance label
                                ctx.fillStyle = "#4CAF50";
                                ctx.font = "bold 12px sans-serif";
                                ctx.fillText("2.0m", 10, farY - 5);
                                ctx.fillText("2.0m", width - 45, farY - 5);

                                // Yellow zone (caution - medium)
                                ctx.strokeStyle = "#FFC107";
                                ctx.lineWidth = 3;
                                ctx.globalAlpha = 0.7;
                                ctx.beginPath();
                                var medY = height * 0.5;
                                var medCurve = width * 0.25;
                                ctx.moveTo(0, medY);
                                ctx.quadraticCurveTo(centerX, medY + medCurve, width, medY);
                                ctx.stroke();

                                ctx.fillStyle = "#FFC107";
                                ctx.fillText("1.0m", 10, medY - 5);
                                ctx.fillText("1.0m", width - 45, medY - 5);

                                // Red zone (danger - close)
                                ctx.strokeStyle = "#FF6B6B";
                                ctx.lineWidth = 3;
                                ctx.globalAlpha = 0.7;
                                ctx.beginPath();
                                var closeY = height * 0.75;
                                var closeCurve = width * 0.15;
                                ctx.moveTo(0, closeY);
                                ctx.quadraticCurveTo(centerX, closeY + closeCurve, width, closeY);
                                ctx.stroke();

                                ctx.fillStyle = "#FF6B6B";
                                ctx.fillText("0.5m", 10, closeY - 5);
                                ctx.fillText("0.5m", width - 45, closeY - 5);

                                // Vertical center guide lines
                                ctx.strokeStyle = "#FFFFFF";
                                ctx.lineWidth = 2;
                                ctx.globalAlpha = 0.4;
                                ctx.setLineDash([10, 5]);

                                // Left guide
                                ctx.beginPath();
                                ctx.moveTo(centerX - width * 0.15, height * 0.9);
                                ctx.lineTo(centerX - width * 0.25, 0);
                                ctx.stroke();

                                // Right guide
                                ctx.beginPath();
                                ctx.moveTo(centerX + width * 0.15, height * 0.9);
                                ctx.lineTo(centerX + width * 0.25, 0);
                                ctx.stroke();

                                ctx.setLineDash([]);

                                // Center crosshair
                                ctx.strokeStyle = "#00FF00";
                                ctx.lineWidth = 2;
                                ctx.globalAlpha = 0.6;
                                var crossSize = 20;

                                ctx.beginPath();
                                ctx.moveTo(centerX - crossSize, height * 0.9);
                                ctx.lineTo(centerX + crossSize, height * 0.9);
                                ctx.stroke();

                                ctx.beginPath();
                                ctx.moveTo(centerX, height * 0.9 - crossSize);
                                ctx.lineTo(centerX, height * 0.9 + crossSize);
                                ctx.stroke();
                            }
                        }
                    }
                }

                // Camera info bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Text {
                        text: "Distance: 0.5m"
                        color: "#FF6B6B"
                        font.pixelSize: 13
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Safety: OK ✓"
                        color: "#4CAF50"
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }
    }

    Component.onDestruction: {
        cameraDevice.stop();
    }
}
