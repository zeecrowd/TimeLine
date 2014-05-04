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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

import "tools.js" as Tools

Rectangle
{
    id: groupLineDelegate
    width : wholeView.width
    property alias eventModel : plans

    ListModel
    {
        id:plans
    }

    Column
    {
        id: dayLineColumn
        onHeightChanged:
        {
            groupLineDelegate.height = dayLineColumn.height
        }
        Row
        {
            spacing: 10
            id: title
            Image
            {
                id          : newEvent
                source      : "qrc:/TimeLine/Resources/new.png"
                width       : 50
                height      : 50

                /*MouseArea
                {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onClicked:
                    {
                        var id = Tools.generateId()
                        var tmp =
                                {
                                    dayId: dayId,
                                    evtId: id,
                                    desc : "Description de l'event",
                                    from : "08:00",
                                    to   : "08:00"
                                }
                        eventDefinition.setItem(id,JSON.stringify(tmp))
                    }
                }*/
            }
            TextInput
            {
                id:dateInput
                visible: month === "-1"
                font.pixelSize: 22
                font.bold: true
                color: "#800020"
                anchors.verticalCenter: newEvent.verticalCenter
                inputMask:"99/99/9999"
                text:date
                selectByMouse:true
                /*onEditingFinished:
                {
                    if (text === date)
                        return;
                    groupLineDelegate.refreshGroupName()
                    var tmp =
                            {
                                dayId: dayId,
                                date : text
                            }
                    dateDefinition.setItem(dayId,JSON.stringify(tmp))
                }*/
            }
            Text
            {
                font.pixelSize: 22
                text:" - "
                color: "#800020"
                anchors.verticalCenter: newEvent.verticalCenter
            }
            Text
            {
                id: groupFullName
                font.pixelSize: 22
                font.bold: true
                text:"theDay"
                color: "#800020"
                anchors.verticalCenter: newEvent.verticalCenter
            }
        }

        Column
        {
            spacing:3
            width : groupLineDelegate.width
            id : forTheDays
            Repeater
            {
                id: forTheDaysRepeater
                model : plans
                EventDelegate
                {
                }
            }
        }
    }

    function refreshGroupName()
    {
        if (dateInput.visible)
        {
            var split = dateInput.text.split('/')
            var date = new Date(split[2], split[1]*1-1, split[0])
            groupFullName.text = Qt.formatDate( date, "dddd d MMMM yyyy" ).toUpperCase()
        }
        else
        {

        }
    }
}
