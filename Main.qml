import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "Network.js" as Network

Window {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Subtitle Finder")

    property string downloadLink: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        TextField {
            id: txtSubtitleSearch
            placeholderText: "Movie or Series [year], [session], [episode]"
            Layout.fillWidth: true
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.topMargin: 40
        }

        Button {
            id: btnSearch
            text: "Search"
            Layout.fillWidth: true
            Layout.leftMargin: 40
            Layout.rightMargin: 40

            onClicked: function() {
                var requestBody = JSON.stringify({
                                                     "query": txtSubtitleSearch.text
                                                 })
                Network.fetchData(requestBody, "http://127.0.0.1:8004/search/", function(response) {
                    if (response) {
                        // console.log(response)
                        var responseData = JSON.parse(response);

                        // Clear the model before adding new data
                        foundSubtitlesModel.clear();

                        // Check if the response was successful and has found subtitles
                        if (responseData) {
                            responseData.forEach(function(subtitleData) {
                                foundSubtitlesModel.append({
                                                               "title": subtitleData.releaseName,
                                                               "fullLink": subtitleData.fullLink,
                                                               "lang": "subtitleData.lang",
                                                               "commentary": subtitleData.commentary,
                                                               "id": subtitleData.subId,
                                                               "linkName": subtitleData.linkName,
                                                           });
                            });
                        }
                    }
                });
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: subtitlesListView
                model: foundSubtitlesModel
                delegate: foundSubtitlesDelegate
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: contentItem.childrenRect.height

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }

        ListModel {
            id: foundSubtitlesModel
        }

        Component {
            id: foundSubtitlesDelegate
            Item {
                width: mainWindow.width
                height: txtSubtitleTitle.implicitHeight + 60 // Adjusted for margins and additional fields

                Rectangle {
                    id: rectSubtitleArea
                    width: parent.width - 80 // Adjust width to account for margins
                    height: txtSubtitleTitle.implicitHeight + 40
                    radius: 10
                    color: "#FAEDCE"
                    border.color: "black"
                    border.width: 1

                    anchors.centerIn: parent

                    Column {
                        anchors.fill: parent
                        spacing: 10
                        padding: 10

                        Text {
                            id: txtSubtitleTitle
                            text: title
                            font.pointSize: 14
                            wrapMode: Text.WordWrap
                        }

                        Text {
                            id: txtSubtitleCommentary
                            text: commentary
                            font.pointSize: 14
                            wrapMode: Text.WordWrap
                        }

                        // Text {
                        //     text: "Link: " + fullLink
                        //     font.pointSize: 12
                        //     wrapMode: Text.WordWrap
                        // }

                        // Text {
                        //     text: "Language: " + lang
                        //     font.pointSize: 12
                        //     wrapMode: Text.WordWrap
                        // }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: function() {
                            var itemData = model;
                            var requestBody = JSON.stringify({
                                                                 "movie": itemData.linkName,
                                                                 "id": itemData.id,
                                                                 "lang": "farsi_persian"
                                                             })


                            Network.fetchData(requestBody, "http://127.0.0.1:8004/download-subtitle/", function(response) {
                                if (response) {
                                    var parseResponse= JSON.parse(response)
                                    downloadLink = parseResponse.link
                                    downloadLinkDialog.open()
                                }
                            });
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                MessageDialog {
                    id: downloadLinkDialog
                    title: txtSubtitleTitle.text
                    text: downloadLink
                    buttons: MessageDialog.Ok
                }
            }
        }
    }
}
