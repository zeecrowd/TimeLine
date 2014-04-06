/*
** Copyright (c) 2014, Jabber Bees
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without modification,
** are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
** in the documentation and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
** INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
