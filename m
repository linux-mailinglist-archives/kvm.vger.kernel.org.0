Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFF133872
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFCSoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:44:22 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:23953
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbfFCSoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUjFXjbaim9xj/aKjNKTBpjR5tGoRGj3DC2bQ1iR0JU=;
 b=DFS2Y02sRq0/8ANQ4aoJ4GDQnS8QP/uXnaqM29BkCaavwK6DCQzkd+C2of/IQcSxj9akq9AsEQhX34VWcS99WHILcwiYtFnVvHM15PYCrutVB67fVPbpC2X6QycEKomscna5K+3Ni4DTnG7p+jLpqx66d5fQe2cKyeJotlh/DUk=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2464.eurprd05.prod.outlook.com (10.168.139.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Mon, 3 Jun 2019 18:44:14 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 18:44:14 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv5 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv5 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVFsjbfUPxgyyRf0a+J6whmOA1uKaKOiIAgAAQWfA=
Date:   Mon, 3 Jun 2019 18:44:14 +0000
Message-ID: <VI1PR0501MB227134DAB079D7BA2FB3A9C3D1140@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190530091928.49724-1-parav@mellanox.com>
        <20190530091928.49724-4-parav@mellanox.com>
 <20190603194328.135205a4.cohuck@redhat.com>
In-Reply-To: <20190603194328.135205a4.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.21.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f9047ba-1923-43c7-a277-08d6e8537a12
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2464;
x-ms-traffictypediagnostic: VI1PR0501MB2464:
x-microsoft-antispam-prvs: <VI1PR0501MB24640E665725599ADDC1AB7AD1140@VI1PR0501MB2464.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(39860400002)(346002)(396003)(199004)(13464003)(189003)(54906003)(76116006)(478600001)(66446008)(64756008)(446003)(76176011)(6506007)(53546011)(2906002)(99286004)(74316002)(186003)(53936002)(7696005)(3846002)(6116002)(486006)(14454004)(11346002)(476003)(66556008)(52536014)(26005)(66476007)(66946007)(73956011)(6436002)(229853002)(78486014)(305945005)(71190400001)(14444005)(256004)(55236004)(102836004)(86362001)(71200400001)(54075001)(316002)(55016002)(5660300002)(9686003)(8676002)(81156014)(81166006)(68736007)(9456002)(7736002)(6246003)(8936002)(4326008)(33656002)(25786009)(66066001)(6916009)(11771555001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2464;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d3k2ehqe33sNuF77E8uiEl9G3eWIKtV8daDNTk2qOTZGMawek5/+9KUma2Vf1BQzdL3mkNXeVp1cZZZVN5TGgzu1aBjckZ8DEPp7HKR8zLCg1Yeu7wuF67cEqL5kU4rh3huotATMx0dlwd+pQmd4UwJvY+q7Xejsn/AgHSvSe3iOpSjB8Tgo1BKp0XwILWHNIAczsMutA38Kmo/wQzEys5EEJCA3/gCcoUY1K7hXw07JDp8AveuMKjgZy0Mk8nfnJxm4qEAUG+GjZ19OwXfq+u9/X52Jvv7FVOicIwyJsDcWfWXvNXhYmAbqhV2NgHf1zKND8QoWTH3V7DB9RlMGA/Ja7FnbxQQNmOzjuGOh2FrBghAuLNmipLNHHNemF2FBg3Lvq1Hi5vljgZxgNF547v6fQ/NXW8RhWjoYbBjQloE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9047ba-1923-43c7-a277-08d6e8537a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 18:44:14.5663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2464
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, June 3, 2019 11:13 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv5 3/3] vfio/mdev: Synchronize device create/remove wi=
th
> parent removal
>=20
> On Thu, 30 May 2019 04:19:28 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > In following sequences, child devices created while removing mdev
> > parent device can be left out, or it may lead to race of removing half
> > initialized child mdev devices.
> >
> > issue-1:
> > --------
> >        cpu-0                         cpu-1
> >        -----                         -----
> >                                   mdev_unregister_device()
> >                                     device_for_each_child()
> >                                       mdev_device_remove_cb()
> >                                         mdev_device_remove()
> > create_store()
> >   mdev_device_create()                   [...]
> >     device_add()
> >                                   parent_remove_sysfs_files()
> >
> > /* BUG: device added by cpu-0
> >  * whose parent is getting removed
> >  * and it won't process this mdev.
> >  */
> >
> > issue-2:
> > --------
> > Below crash is observed when user initiated remove is in progress and
> > mdev_unregister_driver() completes parent unregistration.
> >
> >        cpu-0                         cpu-1
> >        -----                         -----
> > remove_store()
> >    mdev_device_remove()
> >    active =3D false;
> >                                   mdev_unregister_device()
> >                                   parent device removed.
> >    [...]
> >    parents->ops->remove()
> >  /*
> >   * BUG: Accessing invalid parent.
> >   */
> >
> > This is similar race like create() racing with mdev_unregister_device()=
.
> >
> > BUG: unable to handle kernel paging request at ffffffffc0585668 PGD
> > e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
> > Oops: 0000 [#1] SMP PTI
> > CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted
> > 5.1.0-rc6-vdevbus+ #6 Hardware name: Supermicro
> > SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> > RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev] Call Trace:
> >  remove_store+0x71/0x90 [mdev]
> >  kernfs_fop_write+0x113/0x1a0
> >  vfs_write+0xad/0x1b0
> >  ksys_write+0x5a/0xe0
> >  do_syscall_64+0x5a/0x210
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Therefore, mdev core is improved as below to overcome above issues.
> >
> > Wait for any ongoing mdev create() and remove() to finish before
> > unregistering parent device.
> > This continues to allow multiple create and remove to progress in
> > parallel for different mdev devices as most common case.
> > At the same time guard parent removal while parent is being access by
>=20
> s/access/accessed/
>
Done.
=20
> > create() and remove callbacks.
>=20
> s/remove/remove()/ (just to make it consistent)
>=20
Done.

> > create()/remove() and unregister_device() are synchronized by the rwsem=
.
> >
> > Refactor device removal code to mdev_device_remove_common() to avoid
> > acquiring unreg_sem of the parent.
> >
> > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 60 ++++++++++++++++++++++++--------
> >  drivers/vfio/mdev/mdev_private.h |  2 ++
> >  2 files changed, 48 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 0bef0cae1d4b..62be131a22a1
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
>=20
> (...)
>=20
> > @@ -265,6 +294,12 @@ int mdev_device_create(struct kobject *kobj,
> >
> >  	mdev->parent =3D parent;
> >
>=20
> /* Check if parent unregistration has started */
>=20
> > +	ret =3D down_read_trylock(&parent->unreg_sem);
> > +	if (!ret) {
>=20
> Maybe write this as
>=20
> if (!down_read_trylock(&parent->unreg_sem)) {
>=20
> > +		ret =3D -ENODEV;
> > +		goto mdev_fail;
>=20
Done.

> I think this leaves a stale mdev device around (and on the mdev list).
> Normally, giving up the last reference to the mdev will call the release =
callback
> (which will remove it from the mdev list and free it), but the device is =
not yet
> initialized here. I think you either have to remove it from the list and =
free the
> memory manually, or move trying to get the lock just before calling ->cre=
ate().
>
Ah, I missed it.
Fixed. Removing from list and freeing the device.

> > +	}
> > +
> >  	device_initialize(&mdev->dev);
> >  	mdev->dev.parent  =3D dev;
> >  	mdev->dev.bus     =3D &mdev_bus_type;
>=20
> (...)
>=20
> > @@ -329,18 +365,14 @@ int mdev_device_remove(struct device *dev)
> >  	mdev->active =3D false;
> >  	mutex_unlock(&mdev_list_lock);
> >
> > -	type =3D to_mdev_type(mdev->type_kobj);
> > -	mdev_remove_sysfs_files(dev, type);
> > -	device_del(&mdev->dev);
> >  	parent =3D mdev->parent;
> > -	ret =3D parent->ops->remove(mdev);
> > -	if (ret)
> > -		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
> > -
> > -	/* Balances with device_initialize() */
> > -	put_device(&mdev->dev);
> > -	mdev_put_parent(parent);
> > +	/* Check if parent unregistration has started */
> > +	ret =3D down_read_trylock(&parent->unreg_sem);
> > +	if (!ret)
> > +		return -ENODEV;
>=20
> Maybe also condense this one to
>=20
> if (!down_read_trylock(&parent->unreg_sem))
> 	return -ENODEV;
>=20
Done.

> >
> > +	mdev_device_remove_common(mdev);
> > +	up_read(&parent->unreg_sem);
> >  	return 0;
> >  }
> >
>=20
> Otherwise, looks good to me.
Thanks sending v6.
