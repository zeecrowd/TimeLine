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

import ZcClient 1.0 as Zc

import "mainPresenter.js" as Presenter
import "tools.js" as Tools

Zc.AppView
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

    toolBarActions:
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
            iconSource: "qrc:/TimeLine/Resources/add.png"
            tooltip : "Add New Event"
            onTriggered:
            {
                mainView.addEvent();
            }
        },
        Action {
            id: groupByDay
            iconSource: "qrc:/TimeLine/Resources/day.png"
            tooltip : "Group by day"
            onTriggered:
            {
                console.log("************** groupedByDay : " + timeLine.state)
                if (timeLine.state === "groupedByDay")
                    return;
                timeLine.state = "groupedByDay";
            }
        },
        // TODO : activate week view
        /*Action {
            id: groupByWeek
            iconSource: "qrc:/TimeLine/Resources/day.png"
            tooltip : "Group by week"
            onTriggered:
            {
                if (timeLine.state === "groupedByWeek")
                    return;
                timeLine.state = "groupedByWeek"
            }
        },*/
        Action {
            id: groupByMonth
            iconSource: "qrc:/TimeLine/Resources/month.png"
            tooltip : "Group by month"
            onTriggered:
            {
                console.log("************** groupedByMonth : " + timeLine.state)
                if (timeLine.state === "groupedByMonth")
                    return;
                timeLine.state = "groupedByMonth"
            }
        }
    ]

    onLoaded :
    {
        activity.start();
    }

    onClosed :
    {
        activity.stop();
    }

    function closeTask()
    {
        mainView.close();
    }

    function groupByDay()
    {
        Tools.cleanAllListModels(groupModel, bodyRepeaterId)
        var allItems = eventDefinition.getAllItems()
        Tools.forEachInArray(allItems,function(idItem)
                {
                    var val = eventDefinition.getItem(idItem,"");
                    var o = Tools.parseDatas(val)
                    mainView.addNewEventInDayView(idItem, o)
                });
    }
    function groupByWeek()
    {
        Tools.cleanAllListModels(groupModel, bodyRepeaterId)
        var allItems = eventDefinition.getAllItems()
    }
    function groupByMonth()
    {
        Tools.cleanAllListModels(groupModel, bodyRepeaterId)
        var allItems = eventDefinition.getAllItems()
        Tools.forEachInArray(allItems,function(idItem)
                {
                    var val = eventDefinition.getItem(idItem,"");
                    var o = Tools.parseDatas(val)
                    var splittedDate = o.date.split('/')
                    var newMonth = splittedDate[1] + "/" + splittedDate[2]
                    mainView.addNewEventInMonthView(idItem, o, newMonth)
                });
    }

    function addEvent()
    {
        var id = Tools.generateId()
        var allItems = eventDefinition.getAllItems() // TEMP
        Tools.forEachInArray(allItems,function(idItem)
                {
                });
        var myDate = new Date()
        var tmp =
                {
                    date : Qt.formatDate( myDate, "dd/MM/yyyy" ),
                    from : "08:00",
                    to   : "08:00",
                    desc : "Description"
                }
        eventDefinition.setItem(id,JSON.stringify(tmp))
    }

    ListModel
    {
        id:groupModel
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
                    NumberAnimation { properties: "x,y"; duration: 450 }
                }
            Repeater
            {
                id : bodyRepeaterId
                model: groupModel
                GroupDelegate
                {
                }
            }

            states:[
                State
                {
                    name: "groupedByDay"
                    StateChangeScript {script: mainView.groupByDay()}
                },
                State
                {
                    name: "groupedByWeek"
                    StateChangeScript {script: mainView.groupByWeek()}
                },
                State
                {
                    name: "groupedByMonth"
                    StateChangeScript {script: mainView.groupByMonth()}
                }]
        }
    }

    Zc.CrowdActivity
    {
        id : activity

        onStarted:
        {
            eventDefinition.loadItems(eventDefinitionItemQueryStatus)
        }

        Zc.CrowdActivityItems
        {
            Zc.QueryStatus
            {
                id : eventDefinitionItemQueryStatus

                onCompleted:
                {
                    timeLine.state = "groupedByDay"
                }

                onErrorOccured:
                {
                    console.log("*************** >> ERRROR  : " + error)
                    console.log("*************** >> ERRROR CAUSE : " + errorCause)
                    console.log("*************** >> ERRROR MESSAGE : " + errorMessage)
                }
            }

            id          : eventDefinition
            name        : "EventDefinition"
            persistent  : true

            onItemChanged:
            {
                var val = getItem(idItem,"")
                var o = Tools.parseDatas(val)
                var splittedDate = o.date.split('/')
                var newMonth = splittedDate[1] + "/" + splittedDate[2]
                var groupIndex = Tools.getUpperModelIndexForLowerElement(groupModel, bodyRepeaterId, function(x) {return x.evtId === idItem});
                if (groupIndex[0] !== -1)
                {
                    var elt = bodyRepeaterId.itemAt(groupIndex[0])
                    var evtIndex = groupIndex[1]
                    var eltEvent = elt.eventModel.get(evtIndex)
                    if (timeLine.state === "groupedByDay")
                    {
                        if (groupModel.get(groupIndex[0]).date !== o.date)
                        {
                            elt.eventModel.remove(evtIndex)
                            if (elt.eventModel.count === 0)
                            {
                                groupModel.remove(groupIndex[0])
                            }
                            mainView.addNewEventInDayView(idItem, o)
                        }
                        else
                        {
                            elt.eventModel.setProperty(evtIndex,"desc",o.desc)
                            elt.eventModel.setProperty(evtIndex,"from",o.from)
                            elt.eventModel.setProperty(evtIndex,"to",o.to)
                        }
                    }
                    else if (timeLine.state === "groupedByMonth")
                    {
                        if (groupModel.get(groupIndex[0]).month !== newMonth)
                        {
                            elt.eventModel.remove(evtIndex)
                            mainView.addNewEventInMonthView(idItem, o, newMonth)
                        }
                        else
                        {
                            elt.eventModel.setProperty(evtIndex,"desc",o.desc)
                            elt.eventModel.setProperty(evtIndex,"from",o.from)
                            elt.eventModel.setProperty(evtIndex,"to",o.to)
                        }
                    }
                }
                else
                {
                    if (timeLine.state === "groupedByDay")
                    {
                        mainView.addNewEventInDayView(idItem, o)
                    }
                    else if (timeLine.state === "groupedByMonth")
                    {
                        mainView.addNewEventInMonthView(idItem, o, newMonth)
                    }
                }
            }
            onItemDeleted:
            {
                Tools.removeInDeeperListModel(groupModel, bodyRepeaterId, function(x) {return x.evtId === idItem})
            }
        }
    }

    function addNewEventInDayView(idItem, item)
    {
        var newGroupIndex = Tools.findInListModel(groupModel, function(x) {return x.date === item.date})
        if (newGroupIndex === -1)
        {
            var tmpGroup = {
                date  : item.date,
                month : "-1"
            }
            groupModel.append(tmpGroup)
            newGroupIndex = groupModel.count-1
        }
        var newElt = bodyRepeaterId.itemAt(newGroupIndex)
        var tmpEvent = {
            view : "d",
            evtId: idItem,
            dayId: item.date,
            desc : item.desc,
            from : item.from,
            to   : item.to
        }
        newElt.eventModel.append(tmpEvent)
    }

    function addNewEventInWeekView()
    {
        // TODO
    }

    function addNewEventInMonthView(idItem, item, newMonth)
    {
        var newGroupIndex = Tools.findInListModel(groupModel, function(x) {return x.month === newMonth})
        if (newGroupIndex === -1)
        {
            var tmpGroup = {
                date  : item.date,
                month : newMonth
            }
            groupModel.append(tmpGroup)
            newGroupIndex = groupModel.count-1
        }
        var newElt = bodyRepeaterId.itemAt(newGroupIndex)
        var tmpEvent = {
            view : "m",
            evtId: idItem,
            dayId: item.date,
            desc : item.desc,
            from : item.from,
            to   : item.to
        }
        newElt.eventModel.append(tmpEvent)
    }
}
