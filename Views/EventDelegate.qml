/**
* Copyright (c) 2010-2014 "Jabber Bees"
*
* This file is part of the TimeLine application for the Zeecrowd platform.
*
* Zeecrowd is an online collaboration platform [http://www.zeecrowd.com]
*
* TimeLine is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.2
import QtQuick.Controls 1.1

Rectangle {
    id: eventDesc
    height:80
    width: parent.width
    color:"#F0F8FF"

    Component.onCompleted:
    {
        displayDesc.state = "overview"
    }

    Row
    {
        id : displayDesc
        states:[
            State
            {
                name: "overview"
                StateChangeScript {script: eventDesc.overviewView()}
            },
            State
            {
                name: "details"
                StateChangeScript {script: eventDesc.detailsView()}
            }]

        Rectangle
        {
            id: horaire
            width : 120
            height : eventDesc.height
            color : "#F2F3F4"
            Column
            {
                TextInput
                {
                    visible:false
                    id:dateInput
                    x:10
                    font.pixelSize: 19
                    color:"#536872"
                    inputMask:"99/99/9999" // MM dd YYYY
                    onEditingFinished:
                    {
                        eventDesc.refreshDateFullName()
                    }
                }
                Text
                {
                    visible: view !== "d"
                    height:30
                    id:dateInputFullName
                    x:10
                    font.pixelSize: 19
                    color:"#536872"
                }
                TextInput
                {
                    id: fromInput
                    x:10
                    text: from
                    font.pixelSize: 19
                    color:"#536872"
                    inputMask:"99:99"
                }
                Row
                {
                    x:30
                    spacing: 5
                    Text
                    {
                        x:40
                        text : "-"
                    }
                    TextInput
                    {
                        id: toInput
                        text: to
                        font.pixelSize: 19
                        color:"#536872"
                        inputMask:"99:99"
                    }
                }
            }
        }

        TextArea
        {
            id                : descInput
            width             : eventDesc.width - horaire.width
            height            : eventDesc.height
            text              : desc
            font.pixelSize    : 22
            wrapMode          : TextInput.Wrap
            selectByMouse     : true
            backgroundVisible : false
        }
    }

    MouseArea
    {
        id : mouseAreaDetails
        anchors.fill: parent
        onClicked:
        {
            if (displayDesc.state === "details")
            {
                displayDesc.state = "overview"
            }
            else
            {
                displayDesc.state = "details"
            }
        }
    }

    Image
    {
        id              : backToOverview
        anchors.margins : 5
        source          : "qrc:/TimeLine/Resources/up.png"
        height          : 30
        width           : height
        anchors.right   : eventDesc.right
        anchors.top     : eventDesc.top
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                displayDesc.state = "overview"
            }
        }
    }


    Row
    {
        id : buttonsRow
        anchors.right   : eventDesc.right
        anchors.bottom  : eventDesc.bottom
        Rectangle
        {
            height : 33
            width  : 100
            color : "transparent"
            Image
            {
                id              : saveEvent
                anchors.margins : 5
                source          : "qrc:/TimeLine/Resources/save.png"
                height          : 30
                width           : height
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    var split = dateInput.text.split('/')
                    var newdate = new Date(split[2], split[1]*1-1, split[0])
                    var tmp =
                            {
                                date : Qt.formatDate( newdate, "dd/MM/yyyy" ),
                                desc : descInput.text,
                                from : fromInput.text,
                                to   : toInput.text
                            }
                    displayDesc.state = "overview"
                    eventDefinition.setItem(evtId,JSON.stringify(tmp))
                }
            }
            Text
            {
                x:32
                font.pixelSize: 17
                text: "Save"
                anchors.verticalCenter: saveEvent.verticalCenter
            }
        }

        Rectangle
        {
            height : 33
            width  : 100
            color : "transparent"
            Image
            {
                id              : removeEvent
                anchors.margins : 5
                source          : "qrc:/TimeLine/Resources/remove.png"
                height          : 30
                width           : height
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    displayDesc.state = "overview"
                    eventDefinition.deleteItem(evtId)
                }
            }
            Text
            {
                x:32
                font.pixelSize: 17
                text: "Remove"
                anchors.verticalCenter: removeEvent.verticalCenter
            }
        }
    }

    function overviewView()
    {
        dateInput.visible = false
        dateInput.text = dayId
        refreshDateFullName()
        eventDesc.height = 75
        eventDesc.color = "#F0F8FF"
        descInput.readOnly = true
        fromInput.readOnly = true
        toInput.readOnly = true
        fromInput.color = "#536872"
        dateInput.color = "#536872"
        toInput.color = "#536872"
        descInput.textColor = "black"
        mouseAreaDetails.enabled = true
        buttonsRow.visible = false
        backToOverview.visible = false
    }

    function detailsView()
    {
        dateInput.visible = true
        dateInput.text = dayId
        refreshDateFullName()
        eventDesc.height = 250
        eventDesc.color = "#FFF5DB"
        descInput.readOnly = false
        fromInput.readOnly = false
        toInput.readOnly = false
        fromInput.color = "#000099"
        toInput.color = "#000099"
        dateInput.color = "#000099"
        mouseAreaDetails.enabled = false
        buttonsRow.visible = true
        backToOverview.visible = true
    }

    function refreshDateFullName()
    {
        var split = dateInput.text.split('/')
        var newdate = new Date(split[2], split[1]*1-1, split[0])
        dateInputFullName.text = Qt.formatDate( newdate, "ddd d" ).toUpperCase()
    }
}
