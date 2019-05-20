Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A370F24194
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfETTzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 15:55:07 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:54276
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfETTzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 15:55:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWOiq682iGAXLRj9G0ymbsh40L9Fuwjt+yCKKOL6Kuw=;
 b=eptz8QMMtdQfILzmKNitZDHRzyskpPw1vGYsZVbO1zlYlxHXL/NkuUg23vFVQL4bK6+zTJs+vzrZm20NDPSN8uAsD93dkyRYHG0NcP9j6Jf/WYLOQQc9ABixFrRpGrt1UWI4MgzDxznxKfkVlfWJHwhxpeFjx+ZkE5PvAzvAfHI=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2384.eurprd05.prod.outlook.com (10.168.135.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Mon, 20 May 2019 19:54:59 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 19:54:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Thread-Topic: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Thread-Index: AQHVDD9o/mxSVG1oh0uHfLZmDCQyjKZ0ckdQ
Date:   Mon, 20 May 2019 19:54:59 +0000
Message-ID: <VI1PR0501MB2271652CB38FC0C33656DC89D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
 <20190516233034.16407-2-parav@mellanox.com>
In-Reply-To: <20190516233034.16407-2-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a618e63b-1a28-4489-5707-08d6dd5d0a4a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2384;
x-ms-traffictypediagnostic: VI1PR0501MB2384:
x-microsoft-antispam-prvs: <VI1PR0501MB23843185867417F279652C58D1060@VI1PR0501MB2384.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(366004)(396003)(376002)(199004)(189003)(13464003)(6436002)(6506007)(64756008)(4326008)(14444005)(76116006)(102836004)(476003)(256004)(53546011)(305945005)(11346002)(74316002)(66946007)(73956011)(7696005)(66446008)(14454004)(66476007)(486006)(66556008)(2906002)(68736007)(110136005)(26005)(33656002)(76176011)(3846002)(6116002)(66066001)(446003)(229853002)(7736002)(186003)(6246003)(86362001)(478600001)(2201001)(81166006)(81156014)(8676002)(25786009)(55016002)(9686003)(99286004)(71190400001)(71200400001)(8936002)(52536014)(2501003)(53936002)(5660300002)(316002)(30864003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2384;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c6VhegxgdnrCffgd6dGw4JuKBaYZ6IHgFXoYtpQgd0Ev84pH9LZmXTFbNIHlcTFiIsvTr5XbMlKgKlRpaVwe4BeY9m3UD+/wxQB2f2Dc7B9P87v1MG2k8o8Exidqy29ZDk0s3Qq7HiK0fCa+BSZfnPeQQUjRvFiprJv0YPpnxl5Cx9jPR2aeubY9ssLaIrNAQodIaM3Y5+Mby+VUbjsxy9hb2+RX2sO6OBpOkRgOd462FEUTokTisO6BCdp16pTRC7ID1LTIPofvlwjLacvtYf8kViJfdrCd56GvlGDwqMMXs4mrdAJgKKpICmSrF2rrk1tPVZszHn1nB6vlQzIUKzrrr+T8D5OU+QOIL2MJ24yIV66TAkIEhWsEWl7Ughok3SUNj83G4cWKuG8qoula4U8eEm03BXHFKP/Euu/+rrI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a618e63b-1a28-4489-5707-08d6dd5d0a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 19:54:59.2724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia,


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Parav Pandit
> Sent: Thursday, May 16, 2019 6:31 PM
> To: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cohuck@redhat.com;
> kwankhede@nvidia.com; alex.williamson@redhat.com
> Cc: cjia@nvidia.com; Parav Pandit <parav@mellanox.com>
> Subject: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
>=20
> This patch addresses below two issues and prepares the code to address 3r=
d
> issue listed below.
>=20
> 1. mdev device is placed on the mdev bus before it is created in the vend=
or
> driver. Once a device is placed on the mdev bus without creating its
> supporting underlying vendor device, mdev driver's probe() gets triggered=
.
> However there isn't a stable mdev available to work on.
>=20
>    create_store()
>      mdev_create_device()
>        device_register()
>           ...
>          vfio_mdev_probe()
>         [...]
>         parent->ops->create()
>           vfio_ap_mdev_create()
>             mdev_set_drvdata(mdev, matrix_mdev);
>             /* Valid pointer set above */
>=20
> Due to this way of initialization, mdev driver who wants to use the mdev,
> doesn't have a valid mdev to work on.
>=20
> 2. Current creation sequence is,
>    parent->ops_create()
>    groups_register()
>=20
> Remove sequence is,
>    parent->ops->remove()
>    groups_unregister()
>=20
> However, remove sequence should be exact mirror of creation sequence.
> Once this is achieved, all users of the mdev will be terminated first bef=
ore
> removing underlying vendor device.
> (Follow standard linux driver model).
> At that point vendor's remove() ops shouldn't fail because taking the dev=
ice
> off the bus should terminate any usage.
>=20
> 3. When remove operation fails, mdev sysfs removal attempts to add the fi=
le
> back on already removed device. Following call trace [1] is observed.
>=20
> [1] call trace:
> kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> sysfs_create_file_ns+0x7f/0x90
> kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted 5.1.0-rc6-
> vdevbus+ #6
> kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
> 08/09/2016
> kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> kernel: Call Trace:
> kernel: remove_store+0xdc/0x100 [mdev]
> kernel: kernfs_fop_write+0x113/0x1a0
> kernel: vfs_write+0xad/0x1b0
> kernel: ksys_write+0x5a/0xe0
> kernel: do_syscall_64+0x5a/0x210
> kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
> Therefore, mdev core is improved in following ways.
>=20
> 1. Split the device registration/deregistration sequence so that some thi=
ngs
> can be done between initialization of the device and hooking it up to the
> bus respectively after deregistering it from the bus but before giving up=
 our
> final reference.
> In particular, this means invoking the ->create and ->remove callbacks in
> those new windows. This gives the vendor driver an initialized mdev devic=
e
> to work with during creation.
> At the same time, a bus driver who wish to bind to mdev driver also gets
> initialized mdev device.
>=20
> This follows standard Linux kernel bus and device model.
>=20
> 2. During remove flow, first remove the device from the bus. This ensures
> that any bus specific devices are removed.
> Once device is taken off the mdev bus, invoke remove() of mdev from the
> vendor driver.
>=20
> 3. The driver core device model provides way to register and auto unregis=
ter
> the device sysfs attribute groups at dev->groups.
> Make use of dev->groups to let core create the groups and eliminate code =
to
> avoid explicit groups creation and removal.
>=20
> To ensure, that new sequence is solid, a below stack dump of a process is
> taken who attempts to remove the device while device is in use by vfio
> driver and user application.
> This stack dump validates that vfio driver guards against such device rem=
oval
> when device is in use.
>=20
>  cat /proc/21962/stack
> [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio] [<0>] mdev_remove+0x21/0x40
> [mdev] [<0>] device_release_driver_internal+0xe8/0x1b0
> [<0>] bus_remove_device+0xf9/0x170
> [<0>] device_del+0x168/0x350
> [<0>] mdev_device_remove_common+0x1d/0x50 [mdev] [<0>]
> mdev_device_remove+0x8c/0xd0 [mdev] [<0>] remove_store+0x71/0x90
> [mdev] [<0>] kernfs_fop_write+0x113/0x1a0 [<0>] vfs_write+0xad/0x1b0
> [<0>] ksys_write+0x5a/0xe0 [<0>] do_syscall_64+0x5a/0x210 [<0>]
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [<0>] 0xffffffffffffffff
>=20
> This prepares the code to eliminate calling device_create_file() in subsq=
uent
> patch.
>=20
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
>  drivers/vfio/mdev/mdev_private.h |  2 +-
>  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
>  3 files changed, 27 insertions(+), 71 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 3cc1a05fde1c..0bef0cae1d4b 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -102,55 +102,10 @@ static void mdev_put_parent(struct mdev_parent
> *parent)
>  		kref_put(&parent->ref, mdev_release_parent);  }
>=20
> -static int mdev_device_create_ops(struct kobject *kobj,
> -				  struct mdev_device *mdev)
> -{
> -	struct mdev_parent *parent =3D mdev->parent;
> -	int ret;
> -
> -	ret =3D parent->ops->create(kobj, mdev);
> -	if (ret)
> -		return ret;
> -
> -	ret =3D sysfs_create_groups(&mdev->dev.kobj,
> -				  parent->ops->mdev_attr_groups);
> -	if (ret)
> -		parent->ops->remove(mdev);
> -
> -	return ret;
> -}
> -
> -/*
> - * mdev_device_remove_ops gets called from sysfs's 'remove' and when
> parent
> - * device is being unregistered from mdev device framework.
> - * - 'force_remove' is set to 'false' when called from sysfs's 'remove' =
which
> - *   indicates that if the mdev device is active, used by VMM or userspa=
ce
> - *   application, vendor driver could return error then don't remove the
> device.
> - * - 'force_remove' is set to 'true' when called from
> mdev_unregister_device()
> - *   which indicate that parent device is being removed from mdev device
> - *   framework so remove mdev device forcefully.
> - */
> -static int mdev_device_remove_ops(struct mdev_device *mdev, bool
> force_remove) -{
> -	struct mdev_parent *parent =3D mdev->parent;
> -	int ret;
> -
> -	/*
> -	 * Vendor driver can return error if VMM or userspace application is
> -	 * using this mdev device.
> -	 */
> -	ret =3D parent->ops->remove(mdev);
> -	if (ret && !force_remove)
> -		return ret;
> -
> -	sysfs_remove_groups(&mdev->dev.kobj, parent->ops-
> >mdev_attr_groups);
> -	return 0;
> -}
> -
>  static int mdev_device_remove_cb(struct device *dev, void *data)  {
>  	if (dev_is_mdev(dev))
> -		mdev_device_remove(dev, true);
> +		mdev_device_remove(dev);
>=20
>  	return 0;
>  }
> @@ -310,41 +265,43 @@ int mdev_device_create(struct kobject *kobj,
>=20
>  	mdev->parent =3D parent;
>=20
> +	device_initialize(&mdev->dev);
>  	mdev->dev.parent  =3D dev;
>  	mdev->dev.bus     =3D &mdev_bus_type;
>  	mdev->dev.release =3D mdev_device_release;
>  	dev_set_name(&mdev->dev, "%pUl", uuid);
> +	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
> +	mdev->type_kobj =3D kobj;
>=20
> -	ret =3D device_register(&mdev->dev);
> -	if (ret) {
> -		put_device(&mdev->dev);
> -		goto mdev_fail;
> -	}
> +	ret =3D parent->ops->create(kobj, mdev);
> +	if (ret)
> +		goto ops_create_fail;
>=20
> -	ret =3D mdev_device_create_ops(kobj, mdev);
> +	ret =3D device_add(&mdev->dev);
>  	if (ret)
> -		goto create_fail;
> +		goto add_fail;
>=20
>  	ret =3D mdev_create_sysfs_files(&mdev->dev, type);
> -	if (ret) {
> -		mdev_device_remove_ops(mdev, true);
> -		goto create_fail;
> -	}
> +	if (ret)
> +		goto sysfs_fail;
>=20
> -	mdev->type_kobj =3D kobj;
>  	mdev->active =3D true;
>  	dev_dbg(&mdev->dev, "MDEV: created\n");
>=20
>  	return 0;
>=20
> -create_fail:
> -	device_unregister(&mdev->dev);
> +sysfs_fail:
> +	device_del(&mdev->dev);
> +add_fail:
> +	parent->ops->remove(mdev);
> +ops_create_fail:
> +	put_device(&mdev->dev);
>  mdev_fail:
>  	mdev_put_parent(parent);
>  	return ret;
>  }
>=20
> -int mdev_device_remove(struct device *dev, bool force_remove)
> +int mdev_device_remove(struct device *dev)
>  {
>  	struct mdev_device *mdev, *tmp;
>  	struct mdev_parent *parent;
> @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev, bool
> force_remove)
>  	mutex_unlock(&mdev_list_lock);
>=20
>  	type =3D to_mdev_type(mdev->type_kobj);
> +	mdev_remove_sysfs_files(dev, type);
> +	device_del(&mdev->dev);
>  	parent =3D mdev->parent;
> +	ret =3D parent->ops->remove(mdev);
> +	if (ret)
> +		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
>=20
> -	ret =3D mdev_device_remove_ops(mdev, force_remove);
> -	if (ret) {
> -		mdev->active =3D true;
> -		return ret;
> -	}
> -
> -	mdev_remove_sysfs_files(dev, type);
> -	device_unregister(dev);
> +	/* Balances with device_initialize() */
> +	put_device(&mdev->dev);
>  	mdev_put_parent(parent);
>=20
>  	return 0;
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 36cbbdb754de..924ed2274941 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -60,6 +60,6 @@ void mdev_remove_sysfs_files(struct device *dev, struct
> mdev_type *type);
>=20
>  int  mdev_device_create(struct kobject *kobj,
>  			struct device *dev, const guid_t *uuid); -int
> mdev_device_remove(struct device *dev, bool force_remove);
> +int  mdev_device_remove(struct device *dev);
>=20
>  #endif /* MDEV_PRIVATE_H */
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysf=
s.c
> index cbf94b8165ea..9f774b91d275 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -236,7 +236,7 @@ static ssize_t remove_store(struct device *dev, struc=
t
> device_attribute *attr,
>  	if (val && device_remove_file_self(dev, attr)) {
>  		int ret;
>=20
> -		ret =3D mdev_device_remove(dev, false);
> +		ret =3D mdev_device_remove(dev);
>  		if (ret) {
>  			device_create_file(dev, attr);
>  			return ret;
> --
> 2.19.2

Seems 3rd patch will take few more days to settle down with new flag and it=
s review.
Given that fix of 3rd patch is fixing a different race condition, if patch =
1 and 2 look ok, shall we move forward with those 2 fixes it in 5.2-rc?
Fixes 1,2 prepare mdev to be usable for non vfio use case for the series we=
 are working on.
