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
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

Rectangle
{
    id: dayLineDelegate
    width : wholeView.width

    ListModel
    {
        id:plans
    }
    Column
    {
        id: dayLineColumn
        onHeightChanged:
        {
            dayLineDelegate.height = dayLineColumn.height
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

                MouseArea
                {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onClicked:
                    {
                        plans.append({desc:"Description de l'event"})
                    }
                }
            }
            TextInput
            {
                font.pixelSize: 22
                font.bold: true
                color: "#800020"
                anchors.verticalCenter: newEvent.verticalCenter
                inputMask:"99/99/9999"
                text:"25/12/2000"
                selectByMouse:true
                onAccepted:
                {
                    var test = text.split('/')
                    var date = new Date(test[2], test[1]*1-1, test[0])
                    dayFullName.text = Qt.formatDate( date, "dddd d MMMM yyyy" )
                }
                onFocusChanged:
                {
                    var test = text.split('/')
                    var date = new Date(test[2], test[1]*1-1, test[0])
                    dayFullName.text = Qt.formatDate( date, "dddd d MMMM yyyy" )
                }
                /*onEditingFinished:
                {

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
                id: dayFullName
                font.pixelSize: 22
                font.bold: true
                text:theDay
                color: "#800020"
                anchors.verticalCenter: newEvent.verticalCenter
                MouseArea
                {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked:
                    {
                        days.remove(index)
                    }
                }
            }
        }

        Column
        {
            spacing:3
            width : dayLineDelegate.width
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
}
