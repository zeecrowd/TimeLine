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
                    text: "12:00"
                    font.pixelSize: 21
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
                        text: "12:00"
                        font.pixelSize: 21
                        color:"#536872"
                        inputMask:"99:99"
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
            onAccepted:
            {
            }
            onFocusChanged:
            {
            }
            /*onEditingFinished:
            {

            }*/
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
                plans.remove(index)
            }
        }
    }
}
