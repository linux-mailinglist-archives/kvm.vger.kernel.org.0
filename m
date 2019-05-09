Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F97D18DD4
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfEIQQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 12:16:32 -0400
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:15734
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbfEIQQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 12:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lil6KSikLDLuafqh6xgS8aOiOBaWOhOvKXjzkKBXk2U=;
 b=FqdUwE3FzNokYxsUhUx3TlZuYO42FbAUodJUBty8sh2DII8RK0AToAXqljnVPlvbu6F2vKRXWOEHxPzZZ6ly/2LjSIYUrqQpAsnqIrjX2oBpbhB4+VxAhkeisEexcNlIy3Vb5I6T0D4c5M/gCeNlC8yCGEobyJB72iFg3eBV3ZI=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2864.eurprd05.prod.outlook.com (10.172.12.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Thu, 9 May 2019 16:16:26 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1878.022; Thu, 9 May 2019
 16:16:26 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Thread-Topic: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Thread-Index: AQHU/6cN2gCBUIHpe0O+UYvmhXR8xKZhhEWAgABRkCCAALsigIAAdH9w
Date:   Thu, 9 May 2019 16:16:26 +0000
Message-ID: <VI1PR0501MB22716911D19CBC718B4FEF07D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-10-parav@mellanox.com>
        <20190508191635.05a0f277.cohuck@redhat.com>
        <VI1PR0501MB2271E76A8B5E8D00AFEA8D97D1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190509111817.36ff1791.cohuck@redhat.com>
In-Reply-To: <20190509111817.36ff1791.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32205a9e-5479-4974-498e-08d6d499afbd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2864;
x-ms-traffictypediagnostic: VI1PR0501MB2864:
x-microsoft-antispam-prvs: <VI1PR0501MB28641E8747B16E1F71FA93BDD1330@VI1PR0501MB2864.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(376002)(346002)(51444003)(199004)(189003)(13464003)(7736002)(74316002)(6916009)(2906002)(305945005)(186003)(33656002)(256004)(102836004)(26005)(11346002)(25786009)(14444005)(68736007)(14454004)(316002)(99286004)(53546011)(54906003)(446003)(3846002)(6116002)(6506007)(52536014)(6436002)(81166006)(86362001)(81156014)(4326008)(476003)(486006)(71200400001)(71190400001)(5660300002)(7696005)(66066001)(478600001)(229853002)(64756008)(66446008)(8676002)(66556008)(8936002)(66476007)(9686003)(73956011)(66946007)(76116006)(55016002)(53936002)(6246003)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2864;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RVt5fSQ+aqg5iUpWHC/43g4u4BPsJJ5B/aq9RPexPYHxH/oxeByyIqdLGGbzupLKANLVEMZDo/aSM6C0ooC8Tssp6pjraqEnxt8yLOq450rhBenZZ1dCC8zVxnD7di/gDHatiapo+dcE8Ot7Q8V4fMjlaEaSXEEulw8C4/TCcil9Jv9Wxp+5RUR8LYavyhVpFUCtM9Yku1uPOxMTsbGIULjEx6/h7OyFvF2kZTrdfRP3gamh2aAJq7HvKaoLQYvXXselQMmxJe70EbYFgx+RvBdn2Mv45iNRpJQ2cS0+KTus6C5siaPhsB8x6LZi5YL6QhhzNql0E233ckCUEHUr9t4bsYrYoviAFvNK5z1OkV5yXuxHbMW8ejJnM/coQ1HpsQJVeL7FuWxRN1OdVjs1uo3uPYX4PYrmOC5GfVvdgVg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32205a9e-5479-4974-498e-08d6d499afbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 16:16:26.1475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2864
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Thursday, May 9, 2019 4:18 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove file =
on
> stale device removal
>=20
> On Wed, 8 May 2019 22:13:28 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Wednesday, May 8, 2019 12:17 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> > > Subject: Re: [PATCHv2 09/10] vfio/mdev: Avoid creating sysfs remove
> > > file on stale device removal
> > >
> > > On Tue, 30 Apr 2019 17:49:36 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > If device is removal is initiated by two threads as below, mdev
> > > > core attempts to create a syfs remove file on stale device.
> > > > During this flow, below [1] call trace is observed.
> > > >
> > > >      cpu-0                                    cpu-1
> > > >      -----                                    -----
> > > >   mdev_unregister_device()
> > > >     device_for_each_child
> > > >        mdev_device_remove_cb
> > > >           mdev_device_remove
> > > >                                        user_syscall
> > > >                                          remove_store()
> > > >                                            mdev_device_remove()
> > > >                                         [..]
> > > >    unregister device();
> > > >                                        /* not found in list or
> > > >                                         * active=3Dfalse.
> > > >                                         */
> > > >                                           sysfs_create_file()
> > > >                                           ..Call trace
> > > >
> > > > Now that mdev core follows correct device removal system of the
> > > > linux bus model, remove shouldn't fail in normal cases. If it
> > > > fails, there is no point of creating a stale file or checking for s=
pecific
> error status.
> > >
> > > Which error cases are left? Is there anything that does not indicate
> > > that something got terribly messed up internally?
> > >
> > Few reasons I can think of that can fail remove are:
> >
> > 1. Some device removal requires allocating memory too as it needs to is=
sue
> commands to device.
> > If on the path, such allocation fails, remove can fail. However such fa=
il to
> allocate memory will probably result into more serious warnings before th=
is.
>=20
> Nod. If we're OOM, we probably have some bigger problems anyway.
>=20
> > 2. if the device firmware has crashed, device removal commands will lik=
ely
> timeout and return such error upto user.
>=20
> In that case, I'd consider the device pretty much unusable in any case.
>=20
Right.

> > 3. If user tries to remove a device, while parent is already in removal=
 path,
> this call will eventually fail as it won't find the device in the interna=
l list.
>=20
> This should be benign, I think.
>=20
Right.

> >
> > > >
> > > > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > > > sysfs_create_file_ns+0x7f/0x90
> > > > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > > > 5.1.0-rc6-vdevbus+ #6
> > > > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS
> > > > 2.0b
> > > > 08/09/2016
> > > > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > > > kernel: Call Trace:
> > > > kernel: remove_store+0xdc/0x100 [mdev]
> > > > kernel: kernfs_fop_write+0x113/0x1a0
> > > > kernel: vfs_write+0xad/0x1b0
> > > > kernel: ksys_write+0x5a/0xe0
> > > > kernel: do_syscall_64+0x5a/0x210
> > > > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > >
> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > ---
> > > >  drivers/vfio/mdev/mdev_sysfs.c | 4 +---
> > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > > > b/drivers/vfio/mdev/mdev_sysfs.c index 9f774b91d275..ffa3dcebf201
> > > > 100644
> > > > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > > > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > > > @@ -237,10 +237,8 @@ static ssize_t remove_store(struct device
> > > > *dev,
> > > struct device_attribute *attr,
> > > >  		int ret;
> > > >
> > > >  		ret =3D mdev_device_remove(dev);
> > > > -		if (ret) {
> > > > -			device_create_file(dev, attr);
> > > > +		if (ret)
> > >
> > > Should you merge this into the previous patch?
> > >
> > I am not sure. Previous patch changes the sequence. I think that deserv=
ed
> an own patch by itself.
> > This change is making use of that sequence.
> > So its easier to review? Alex had comment in v0 to split into more logi=
cal
> patches, so...
> > Specially to capture a different call trace, I cut into different patch=
.
> > Otherwise previous patch's commit message is too long.
>=20
> I'm not sure if splitting out this one is worth it... your call.
>=20
Ok. either ways...
> >
> > > >  			return ret;
> > > > -		}
> > > >  	}
> > > >
> > > >  	return count;
> >

