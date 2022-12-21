#ifndef FILELISTMODELDATA_H
#define FILELISTMODELDATA_H

#include <QObject>

class FileListModelData : public QObject
{
    Q_OBJECT
    bool m_isBackItem;

    QString m_name;

    int m_itemType;

public:
    explicit FileListModelData(QObject *parent = nullptr);

    Q_PROPERTY(bool isBackItem READ isBackItem WRITE setIsBackItem NOTIFY isBackItemChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int itemType READ itemType WRITE setItemType NOTIFY itemTypeChanged)


    bool isBackItem() const;
    void setIsBackItem(bool newIsBackItem);

    const QString &name() const;
    void setName(const QString &newName);

    int itemType() const;
    void setItemType(int newItemType);

signals:

    void isBackItemChanged();
    void nameChanged();
    void itemTypeChanged();
};

#endif // FILELISTMODELDATA_H
