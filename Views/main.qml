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

import ZcClient 1.0

import "mainPresenter.js" as Presenter


ZcAppView
{
    id : mainView

    anchors
    {
        top : parent.top
        left: parent.left
        leftMargin : 5
        bottom: parent.bottom
        right  : parent.right
    }

    toolBarActions :
    [
        Action {
            id: closeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/TimeLine/Resources/close.png"
            tooltip : "Close Application"
            onTriggered:
            {
                mainView.closeTask();
            }
        },
        Action {
            id: addAction
            shortcut: "Ctrl+T"
            iconSource: "qrc:/TimeLine/Resources/day.png"
            tooltip : "Add Event"
            onTriggered:
            {
                mainView.addDay();
            }
        }
    ]

    onLoaded :
    {
        //activity.start();
    }

    onClosed :
    {
        //activity.stop();
    }

    function closeTask()
    {
        mainView.close();
    }

    function addDay()
    {
        days.append({theDay:"New Day"})
    }

    ListModel
    {
        id:days
    }


    ScrollView
    {
        id: wholeView
        anchors.fill : parent

        Column
        {
            spacing: 5
            id : timeLine
            move: Transition {
                    NumberAnimation { properties: "x,y"; duration: 400 }
                }
            Repeater
            {
                id : bodyRepeaterId
                model: days
                DayLineDelegate
                {
                }
            }
        }
    }

    /*ZcCrowdActivity
    {
        id : activity

        ZcCrowdActivityItems
        {
            ZcQueryStatus
            {
                id : eventDefinitionItemQueryStatus

                onCompleted :
                {
                    eventPosition.loadItems(eventPositionItemQueryStatus);
                }
            }

            id          : eventDefinition
            name        : "EventDefinition"
            persistent  : true

            onItemChanged :
            {
                mainView.createevent(idItem)
                var value = eventDefinition.getItem(idItem,"");
                Presenter.instance[idItem].text = value;
                Presenter.instance[idItem].idItem = idItem;
            }
            onItemDeleted :
            {
                if (Presenter.instance[idItem] === undefined ||
                        Presenter.instance[idItem] === null)
                    return;
                Presenter.instance[idItem].visible = false;
                Presenter.instance[idItem].parent === null;
                Presenter.instance[idItem] = null;
            }
        }

        ZcCrowdActivityItems
        {
            ZcQueryStatus
            {
                id : eventPositionItemQueryStatus

                onCompleted:
                {
                    var allItems = eventDefinition.getAllItems();
                    if (allItems === null)
                        return;
                    Presenter.instance.forEachInArray(allItems,function(idItem)
                    {
                        mainView.createevent(idItem)
                        var value = eventDefinition.getItem(idItem,"");
                        Presenter.instance[idItem].text = value;
                        Presenter.instance[idItem].idItem = idItem;

                        mainView.setPosition(idItem,eventPosition.getItem(idItem,""));
                    });
                }
            }

            id          : eventPosition
            name        : "EventPosition"
            persistent  : true

            onItemChanged :
            {
                var value = eventPosition.getItem(idItem,"");
                mainView.setPosition(idItem,value);
            }
        }

        onStarted :
        {
            eventDefinition.loadItems(eventDefinitionItemQueryStatus);
        }
    }*/
}
