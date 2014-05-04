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

function forEachInArray(array, delegate)
{
    for (var i=0;i<array.length;i++)
    {
        delegate(array[i]);
    }
}

function findInListModel(listModel, findDelegate)
{
    for (var i=0;i<listModel.count;i++)
    {
        if (findDelegate(listModel.get(i)))
            return i;
    }
    return -1;
}

function getIndexInListModel(listModel, findDelegate)
{
    for (var i=0;i<listModel.count;i++)
    {
        if ( findDelegate(listModel.get(i)) )
            return i;
    }
    return -1;
}

function removeInListModel(listModel, findDelegate)
{
    var index = getIndexInListModel(listModel, findDelegate);
    if (index === -1)
        return
    listModel.remove(index)
}

function removeInDeeperListModel(listModel, repeater, findDelegate)
{
    for (var i=0;i<listModel.count;i++)
    {
        var elt = repeater.itemAt(i)
        if (elt !== null && elt !== undefined)
        {
            var index = getIndexInListModel(elt.eventModel, findDelegate)
            if (index !== -1)
            {
                elt.eventModel.remove(index)
                return;
            }
        }
    }
}

function getUpperModelIndexForLowerElement(listModel, repeater, findDelegate)
{
    for (var i=0;i<listModel.count;i++)
    {
        var elt = repeater.itemAt(i)
        if (elt !== null && elt !== undefined)
        {
            var index = getIndexInListModel(elt.eventModel, findDelegate)
            if (index !== -1)
            {
                return [i, index];
            }
        }
    }
    return [-1,-1];
}

function cleanAllListModels(mainListModel, repeater)
{
    for (var i=mainListModel.count-1;i>=0;i--)
    {
        var elt = repeater.itemAt(i)
        if (elt !== null && elt !== undefined)
        {
            for (var j=elt.eventModel.count-1; j>=0; j--)
            {
                elt.eventModel.remove(j)
            }
            mainListModel.remove(i)
        }
    }
}

function parseDatas(datas)
{
    if (datas === null || datas === undefined)
        return {}

    var objectDatas = null;

    try
    {

        objectDatas = JSON.parse(datas);
    }
    catch (e)
    {
        objectDatas = {}
    }

    if (objectDatas === null)
        return {};

    if (objectDatas === undefined)
        return {};

    objectDatas.testparse = "testparse"
    if (objectDatas.testparse !== "testparse")
    {
        return {}
    }

    objectDatas.testparse = undefined;
    return objectDatas;
}

function generateId()
{
    var d = new Date();
    return mainView.context.nickname + "_" + d.toLocaleTimeString() + "_" + d.getMilliseconds();
}
