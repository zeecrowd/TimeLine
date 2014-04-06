import QtQuick 2.0

Rectangle {
    id: eventDesc
    height:50
    width: parent.width
    color:"#F0F8FF"
    Row
    {
        spacing: 10
        Rectangle
        {
            x:1;y:1
            width : 120
            height : eventDesc.height-1
            color : "#F2F3F4"
            Column
            {
                Text
                {
                    x:10
                    text: "XX:YY"
                    font.pixelSize: 18
                    color:"#536872"
                }
                Text
                {
                    x:40
                    text: "- ZZ:AA"
                    font.pixelSize: 18
                    color:"#536872"
                }
            }
        }

        Text
        {
            text:desc
            font.pixelSize: 22
        }
    }
}
