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

Rectangle {
    id: eventDesc
    height:75
    width: parent.width
    color:"#F0F8FF"
    Row
    {
        spacing: 10
        Rectangle
        {
            id: horaire
            x:1;y:1
            width : 120
            height : eventDesc.height-1
            color : "#F2F3F4"
            Column
            {
                TextInput
                {
                    x:10
                    text: from
                    font.pixelSize: 21
                    color:"#536872"
                    inputMask:"99:99"
                    onEditingFinished:
                    {
                        if (text === from)
                            return;
                        var tmp =
                                {
                                    dayId: dayId,
                                    evtId: evtId,
                                    desc : desc,
                                    from : text,
                                    to   : to
                                }
                        eventDefinition.setItem(evtId,JSON.stringify(tmp))
                    }
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
                        text: to
                        font.pixelSize: 21
                        color:"#536872"
                        inputMask:"99:99"
                        onEditingFinished:
                        {
                            if (text === to)
                                return;
                            var tmp =
                                    {
                                        dayId: dayId,
                                        evtId: evtId,
                                        desc : desc,
                                        from : from,
                                        to   : text
                                    }
                            eventDefinition.setItem(evtId,JSON.stringify(tmp))
                        }
                    }
                }
            }
        }

        TextInput
        {
            id: descInput
            width: eventDesc.width - horaire.width - 11
            height: eventDesc.height
            text:desc
            font.pixelSize: 22
            wrapMode: TextInput.Wrap
            selectByMouse:true
            onEditingFinished:
            {
                if (text === desc)
                    return;
                var tmp =
                        {
                            dayId: dayId,
                            evtId: evtId,
                            desc : text,
                            from : from,
                            to   : to
                        }
                eventDefinition.setItem(evtId,JSON.stringify(tmp))
            }
        }
    }
    Image
    {
        id         : removeEvent
        anchors.margins: 5
        source     : "qrc:/TimeLine/Resources/remove.png"
        height     : eventDesc.height/3
        width      : height
        anchors.right: eventDesc.right
        anchors.top: eventDesc.top

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                eventDefinition.deleteItem(evtId)
            }
        }
    }
}
