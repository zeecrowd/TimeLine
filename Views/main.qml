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
