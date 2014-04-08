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
            tooltip : "Add New Day"
            onTriggered:
            {
                mainView.addDay();
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

    function addDay()
    {
        var id = Tools.generateId()
        var tmp =
                {
                    dayId: id,
                    date : "28/03/2005"
                }
        dateDefinition.setItem(id,JSON.stringify(tmp))
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

    Zc.CrowdActivity
    {
        id : activity

        onStarted:
        {
            dateDefinition.loadItems(dateDefinitionItemQueryStatus)
        }

        Zc.CrowdActivityItems
        {
            Zc.QueryStatus
            {
                id : eventDefinitionItemQueryStatus

                onCompleted:
                {
                    var allDateItems = dateDefinition.getAllItems();
                    if (allDateItems === null)
                        return;
                    Tools.forEachInArray(allDateItems,function(idItem)
                            {
                                var val = dateDefinition.getItem(idItem,"");
                                var o = Tools.parseDatas(val)
                                days.append({
                                                dayId: o.dayId,
                                                date : o.date
                                            })
                                var elt = bodyRepeaterId.itemAt(days.count - 1)
                                elt.refreshDate()
                            });

                    var allEventItems = eventDefinition.getAllItems();
                    if (allEventItems === null)
                        return;
                    Tools.forEachInArray(allEventItems,function(idItem)
                            {
                                var val = eventDefinition.getItem(idItem,"");
                                var o = Tools.parseDatas(val)
                                var dayIndex = Tools.getIndexInListModel(days, function(x) {return x.dayId === o.dayId})
                                if (dayIndex !== -1)
                                {
                                    var elt = bodyRepeaterId.itemAt(dayIndex)
                                    elt.eventModel.append({
                                                         dayId: o.dayId,
                                                         evtId: o.evtId,
                                                         desc : o.desc,
                                                         from : o.from,
                                                         to   : o.to
                                                     })
                                }
                            });

                }

                onErrorOccured:
                {
                    console.log(">> ERRROR  : " + error)
                    console.log(">> ERRROR CAUSE : " + errorCause)
                    console.log(">> ERRROR MESSAGE : " + errorMessage)
                }
            }

            id          : eventDefinition
            name        : "EventDefinition"
            persistent  : true

            onItemChanged:
            {
                var val = getItem(idItem,"")
                var o = Tools.parseDatas(val)
                var dayIndex = Tools.getIndexInListModel(days, function(x) {return x.dayId === o.dayId})
                if (dayIndex !== -1)
                {
                    var elt = bodyRepeaterId.itemAt(dayIndex)
                    var evtIndex = Tools.getIndexInListModel(elt.eventModel, function(x) {return x.evtId === idItem})
                    if (evtIndex === -1)
                    {
                        elt.eventModel.append({
                                             dayId: o.dayId,
                                             evtId: o.evtId,
                                             desc : o.desc,
                                             from : o.from,
                                             to   : o.to
                                         })
                    }
                    else
                    {
                        elt.eventModel.setProperty(evtIndex,"desc",o.desc)
                        elt.eventModel.setProperty(evtIndex,"from",o.from)
                        elt.eventModel.setProperty(evtIndex,"to",o.to)
                    }
                }
            }
            onItemDeleted:
            {
                Tools.removeInDeeperListModel(days, bodyRepeaterId, function(x) {return x.evtId === idItem})
            }
        }

        Zc.CrowdActivityItems
        {
            Zc.QueryStatus
            {
                id : dateDefinitionItemQueryStatus

                onCompleted:
                {
                    eventDefinition.loadItems(eventDefinitionItemQueryStatus)
                }

                onErrorOccured:
                {
                    console.log(">> ERRROR  : " + error)
                    console.log(">> ERRROR CAUSE : " + errorCause)
                    console.log(">> ERRROR MESSAGE : " + errorMessage)
                }
            }

            id          : dateDefinition
            name        : "DateDefinition"
            persistent  : true

            onItemChanged:
            {
                var val = getItem(idItem,"")
                var index = Tools.getIndexInListModel(days, function(x) {return x.dayId === idItem})
                var o = Tools.parseDatas(val)
                if (index === -1)
                {
                    days.append({
                                    dayId: o.dayId,
                                    date : o.date
                                })
                    var elt = bodyRepeaterId.itemAt(days.count - 1)
                    elt.refreshDate()
                }
                else
                {
                    days.setProperty(index,"date",o.date)
                    var elt = bodyRepeaterId.itemAt(index)
                    elt.refreshDate()
                }
            }
            onItemDeleted:
            {
                Tools.removeInListModel(days, function(x) {return x.dayId === idItem})
            }
        }
    }
}
