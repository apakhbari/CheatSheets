### Step 1: Identify User and Target Role

Verify the account details and find the role currently assigned to `userId: 1004`:

```
javascript
use appmarket;

// 1. Fetch user profile
db.UserInfo.find({
  $or: [
    { userId: 1004 },
    { userId: NumberLong(1004) }
  ]
}, { userId: 1, userName: 1, status: 1 }).pretty();

// 2. Fetch the user's assigned roleId
db.SysUserRole.find({
  $or: [
    { userId: 1004 },
    { userId: NumberLong(1004) }
  ]
}).pretty();

```

* **Verification:** Confirm the returned document and take note of the `roleId` field (e.g. `1004`, `101`, etc.). If no record exists in `SysUserRole`, assign them a role first:
```javascript
db.SysUserRole.updateOne(
  { userId: NumberLong(1004), roleId: NumberLong(1004) },
  {
    $setOnInsert: {
      userId: NumberLong(1004),
      roleId: NumberLong(1004),
      _class: "com.topwise.tms.system.domain.SysUserRole"
    }
  },
  { upsert: true }
);
```


---

### Step 2: Ensure Menus & Permissions Exist in `SysMenu`

Check whether the customer instance is missing the parent menu, submenu, or action permissions:

```javascript
db.SysMenu.find({
  menuId: { $in: [NumberLong(2037), NumberLong(3010)] }
}, { menuId: 1, menuName: 1 });

```

Run this upsert block to guarantee all menu nodes and action buttons exist with the proper classes:

```javascript
var menuItems = [
  {
    "menuId": NumberLong(2037),
    "menuName": "DEPLOYMENTS",
    "parentId": 0,
    "orderNum": 3,
    "path": "upgrade",
    "isFrame": 1,
    "isCache": 0,
    "menuType": "M",
    "visible": 0,
    "lang": "{\"zh\":\"发布管理\",\"en\":\"DEPLOYMENTS\",\"es\":\"DESPLIEGUES\",\"ru\":\"РАЗВЕРТЫВАНИЯ\"}",
    "status": 0,
    "icon": "deploy_menu_icon",
    "systemType": "TMS",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu"
  },
  {
    "menuId": NumberLong(3010),
    "menuName": "Profiles",
    "parentId": NumberLong(2037),
    "orderNum": 5,
    "path": "fileManagement",
    "component": "fileManagement/index",
    "isFrame": 1,
    "isCache": 0,
    "menuType": "C",
    "visible": 0,
    "lang": "{\"en\":\"Profiles\",\"zh\":\"系统定制\",\"es\":\"El documento\",\"ru\":\"Управление файлами\"}",
    "status": 0,
    "icon": "download",
    "createBy": "admin",
    "children": [],
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3011),
    "menuName": "List",
    "parentId": NumberLong(3010),
    "orderNum": 1,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:list",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3012),
    "menuName": "Add",
    "parentId": NumberLong(3010),
    "orderNum": 2,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:Add",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3013),
    "menuName": "Edit",
    "parentId": NumberLong(3010),
    "orderNum": 3,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:Edit",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3016),
    "menuName": "Release",
    "parentId": NumberLong(3010),
    "orderNum": 4,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:Release",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3017),
    "menuName": "Off Shelves",
    "parentId": NumberLong(3010),
    "orderNum": 5,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:Off Shelves",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3018),
    "menuName": "Delete",
    "parentId": NumberLong(3010),
    "orderNum": 6,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:appFile:Delete",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  },
  {
    "menuId": NumberLong(3056),
    "menuName": "TaskCancel",
    "parentId": NumberLong(3010),
    "orderNum": 7,
    "menuType": "F",
    "visible": 0,
    "perms": "upgrade:app:file:cancelDetail",
    "_class": "com.topwise.tms.common.core.domain.entity.SysMenu",
    "systemType": "TMS"
  }
];

menuItems.forEach(function(item) {
  db.SysMenu.updateOne(
    { menuId: item.menuId },
    { $setOnInsert: item },
    { upsert: true }
  );
});

```

* **Verification:** Run `db.SysMenu.countDocuments({ menuId: { $in: [NumberLong(2037), NumberLong(3010)] } })` and verify it returns `2`.

---

### Step 3: Link Menus to Role in `SysRoleMenu`

Replace `<TARGET_ROLE_ID>` with the `roleId` obtained from Step 1 (e.g. `1004`):

```javascript
var targetRole = NumberLong(<TARGET_ROLE_ID>);

var menuIdsToAssign = [
  NumberLong(2037), // DEPLOYMENTS
  NumberLong(3010), // Profiles
  NumberLong(3011), // List
  NumberLong(3012), // Add
  NumberLong(3013), // Edit
  NumberLong(3016), // Release
  NumberLong(3017), // Off Shelves
  NumberLong(3018), // Delete
  NumberLong(3056)  // TaskCancel
];

menuIdsToAssign.forEach(function(mId) {
  db.SysRoleMenu.updateOne(
    { roleId: targetRole, menuId: mId },
    {
      $setOnInsert: {
        roleId: targetRole,
        menuId: mId,
        _class: "com.topwise.tms.system.domain.SysRoleMenu"
      }
    },
    { upsert: true }
  );
});

```

* **Verification:** Execute:
```javascript
db.SysRoleMenu.countDocuments({
  roleId: targetRole,
  menuId: { $in: menuIdsToAssign }
});

```


Expected return value is `9`.

---

### Step 4: Refresh Permissions

1. Have the user completely sign out and log back in to their web console.
2. If the menu still does not appear, clear the Redis session token store (e.g., keys matching `login_tokens:*`) or restart the backend container so the application rebuilds the active user's permission route tree from MongoDB.