Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C381564C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 01:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfEFXXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 19:23:20 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:6725
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbfEFXXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 19:23:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RlZGz41/6LFN19mE+glFBYRIdzFYwtXyP51LiHXdDo=;
 b=jHbMQV8pwpw9T6JncqVr5c6X2ochYForsFkt0/EboUJP3sn2yQZ/gVPyxzOPNBBZ6rNCZKwq9R6fE3+8cbaXH2fWhkCfnwURGJrFURFM5X/JDE140XUkSr/eXdeqHBIO1laPbyJS/muu8Xqpb815JPJTkeJClQZIkx3Yk7XTCxw=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2656.eurprd05.prod.outlook.com (10.172.11.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Mon, 6 May 2019 23:22:35 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 23:22:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 00/10] vfio/mdev: Improve vfio/mdev core module
Thread-Topic: [PATCHv2 00/10] vfio/mdev: Improve vfio/mdev core module
Thread-Index: AQHU/6cFvQ1Fd1iab0yOAUJ2GpUJZ6Zer7GAgAAVpQA=
Date:   Mon, 6 May 2019 23:22:35 +0000
Message-ID: <VI1PR0501MB22712E3790529A64EC2F9213D1300@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
 <20190506160313.41c189f0@x1.home>
In-Reply-To: <20190506160313.41c189f0@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50286676-82c2-48ee-d27a-08d6d279b91e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2656;
x-ms-traffictypediagnostic: VI1PR0501MB2656:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <VI1PR0501MB2656B12D811793BAFD809CE7D1300@VI1PR0501MB2656.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(366004)(136003)(396003)(346002)(189003)(199004)(54534003)(13464003)(4326008)(2906002)(33656002)(74316002)(6246003)(305945005)(53936002)(102836004)(71190400001)(66066001)(68736007)(71200400001)(86362001)(26005)(5660300002)(76116006)(73956011)(6506007)(76176011)(66946007)(66476007)(7696005)(64756008)(14454004)(6306002)(66446008)(66556008)(54906003)(478600001)(6436002)(6916009)(966005)(486006)(11346002)(81166006)(55016002)(476003)(229853002)(446003)(99286004)(25786009)(7736002)(186003)(81156014)(8676002)(52536014)(53546011)(316002)(256004)(3846002)(14444005)(8936002)(6116002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2656;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6w4c2rpiGXo6Kj88hYMX2qxyRmVlYbkvL3PUanaUxAasgyvY92qJgCNGcSxcxwFTkOWLdqdKLd6NSm7OeUgVA02kvb9Xod83Ej1hsFwxdJ54Wbdnpp8ZoVTtlH3OswT77WB5F+6hsQTRyomWQtD/ngQPyUEO3Wr50X+cTFwOUoBsJNfoDkgyvKBL3nMAY2tDHDfFqp0Tjmyc+SOyYbaVakpOtl+DfJoUGi5R9xBA/wvPOzafpvTuB0tmsDCtrOaW7gvXoNSZ0uEllQG2ZsKi3K1b7uZsx1rTxPBA1brenrfoqCdQyg7iZU1+0+QZn1Gui69u5kTWvL7Jv4EhBfw++7cpS3/+wyyKlYOUCW9nZpDfcc0jZ/wiCItcF4VrM4VHdD4KxXnSEesurS+CZs41uyxCkcctB168np4ex/JyV0A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50286676-82c2-48ee-d27a-08d6d279b91e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 23:22:35.6573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2656
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, May 6, 2019 5:03 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 00/10] vfio/mdev: Improve vfio/mdev core module
>=20
> On Tue, 30 Apr 2019 17:49:27 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > As we would like to use mdev subsystem for wider use case as discussed
> > in [1], [2] apart from an offline discussion.
> > This use case is also discussed with wider forum in [4] in track
> > 'Lightweight NIC HW functions for container offload use cases'.
> >
> > This series is prep-work and improves vfio/mdev module in following way=
s.
> >
> > Patch-1 Fixes releasing parent dev reference during error unwinding
> >         mdev parent registration.
> > Patch-2 Simplifies mdev device for unused kref.
> > Patch-3 Drops redundant extern prefix of exported symbols.
> > Patch-4 Returns right error code from vendor driver.
> > Patch-5 Fixes to use right sysfs remove sequence.
> > Patch-6 Fixes removing all child devices if one of them fails.
> > Patch-7 Remove unnecessary inline
> > Patch-8 Improve the mdev create/remove sequence to match Linux
> >         bus, device model
> > Patch-9 Avoid recreating remove file on stale device to
> >         eliminate call trace
> > Patch-10 Fix race conditions of create/remove with parent removal This
> > is improved version than using srcu as srcu can take seconds to
> > minutes.
> >
> > This series is tested using
> > (a) mtty with VM using vfio_mdev driver for positive tests and device
> > removal while device in use by VM using vfio_mdev driver
> >
> > (b) mlx5 core driver using RFC patches [3] and internal patches.
> > Internal patches are large and cannot be combined with this prep-work
> > patches. It will posted once prep-work completes.
> >
> > [1] https://www.spinics.net/lists/netdev/msg556978.html
> > [2] https://lkml.org/lkml/2019/3/7/696
> > [3] https://lkml.org/lkml/2019/3/8/819
> > [4] https://netdevconf.org/0x13/session.html?workshop-hardware-offload
> >
> > ---
> > Changelog:
> > ---
> > v1->v2:
> >  - Addressed comments from Alex
> >  - Rebased
> >  - Inserted the device checking loop in Patch-6 as original code
> >  - Added patch 7 to 10
> >  - Added fixes for race condition in create/remove with parent removal
> >    Patch-10 uses simplified refcount and completion, instead of srcu
> >    which might take seconds to minutes on busy system.
> >  - Added fix for device create/remove sequence to match
> >    Linux device, bus model
> > v0->v1:
> >  - Dropped device placement on bus sequence patch for this series
> >  - Addressed below comments from Alex, Kirti, Maxim.
> >  - Added Review-by tag for already reviewed patches.
> >  - Dropped incorrect patch of put_device().
> >  - Corrected Fixes commit tag for sysfs remove sequence fix
> >  - Split last 8th patch to smaller refactor and fixes patch
> >  - Following coding style commenting format
> >  - Fixed accidental delete of mutex_lock in mdev_unregister_device
> >  - Renamed remove helped to mdev_device_remove_common().
> >  - Rebased for uuid/guid change
> >
> > Parav Pandit (10):
> >   vfio/mdev: Avoid release parent reference during error path
> >   vfio/mdev: Removed unused kref
> >   vfio/mdev: Drop redundant extern for exported symbols
> >   vfio/mdev: Avoid masking error code to EBUSY
> >   vfio/mdev: Follow correct remove sequence
> >   vfio/mdev: Fix aborting mdev child device removal if one fails
> >   vfio/mdev: Avoid inline get and put parent helpers
> >   vfio/mdev: Improve the create/remove sequence
> >   vfio/mdev: Avoid creating sysfs remove file on stale device removal
> >   vfio/mdev: Synchronize device create/remove with parent removal
> >
> >  drivers/vfio/mdev/mdev_core.c    | 162 +++++++++++++------------------
> >  drivers/vfio/mdev/mdev_private.h |   9 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   |   8 +-
> >  include/linux/mdev.h             |  21 ++--
> >  4 files changed, 89 insertions(+), 111 deletions(-)
> >
>=20
> Hi Parav,
>=20
> I applied 1-7 to the vfio next branch for v5.2 since these are mostly
> previously reviewed or trivial.  I'm not ruling out the rest for v5.2 as =
bug fixes
> yet, but they require a bit more to digest and hopefully we'll get some
> feedback from others as well.  Thanks,
>=20
Ok. Great.
Yes, these are important for us to make use of mdev.
We should address them in 5.2 window.
I will look for any comments this week and address them as required.
