#include "filelistmodeldata.h"

FileListModelData::FileListModelData(QObject *parent) : QObject(parent)
{

}

bool FileListModelData::isBackItem() const
{
    return m_isBackItem;
}

void FileListModelData::setIsBackItem(bool newIsBackItem)
{
    if (m_isBackItem == newIsBackItem)
        return;
    m_isBackItem = newIsBackItem;
    emit isBackItemChanged();
}

const QString &FileListModelData::name() const
{
    return m_name;
}

void FileListModelData::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

int FileListModelData::itemType() const
{
    return m_itemType;
}

void FileListModelData::setItemType(int newItemType)
{
    if (m_itemType == newItemType)
        return;
    m_itemType = newItemType;
    emit itemTypeChanged();
}
