Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725278BBF4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 16:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfHMOs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 10:48:28 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:1146
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbfHMOs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 10:48:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fymU/9Y0AsyTQYxiy+oO5h5FuAW2Y6OcHEAwXyrS1onHR6JmP768vLlMPppafWTWoaUYaQOyKbqep8zDyvO16KJygbaPYZvxzER/c0H9vpCl4OFtfjx6WC4u+LoMPvr03ybUAutwsOcauW8FZlogiWBNpWj2XeiWvVc8Cv5W711GxajqFkHY6CawnZcmdP2XA3svuv3uQ1nucBrVAETvZEoNZnZ1jurSU0mSeQVmn7xzoy04ahqA/KfEuZpu2JOUZpJ2g3jRWZNI0ye599XTyeYCVDSkRTdVqj+wUbWA5XtfECVXLmcsVN7yJS4jv6QDtpHzD6b5kXU5OJTNtLfZaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXsgTrlL01pWM5nixhCcC8kYdjhoKSrAPFH8y0xChxc=;
 b=KDtCrwojRCX4lqET7r6iIUPdmgcK9Nz9MnXhwCDd4br1vfpQ0WtrJPC498npudUKEuFifVk21lYmbixQPiJfnlDpK6KVSsDvnlanyXJeb+ZcncOPjuUik0IxInETg+n+5gMzXQu+Ryx259dDVM7XCIj+iNTsoh6K+gbC0/8N9lWSl6jRbfQISTLYbHFm2rQ8wVBN1qlpnErg16BLWMiyCOJ0r76nzG4/8SIBHvrnGD2/bx3XUhVWjc7H1HnebiNeTTbYmL6yLUztgBhl+yDoHUFK6qwlHMMTX5nUuVjdMdfB7PKgHEF5VwhVPgZDQJUXjQvUKF+ZQJlkwwdUYPiwEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXsgTrlL01pWM5nixhCcC8kYdjhoKSrAPFH8y0xChxc=;
 b=PwzlZ4lFptA1nuWvpPqUD8pIto7uGdw3gMuzgSn5JkiLdfzEDm4f7umVwdkeUYZHaNuA4gRp0vS6h9xk3nFXk/9oBh1IiI2tsJapA87+y4OooJAz2KSH6RZMM60xP9yYi355llX1hWfEL1wh68aKnFY+d73oLOrdZT9ddoXRyf0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5923.eurprd05.prod.outlook.com (20.178.118.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 13 Aug 2019 14:48:24 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 14:48:24 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAdPQrA=
Date:   Tue, 13 Aug 2019 14:48:23 +0000
Message-ID: <AM0PR05MB48661804F69F24B08036E57DD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home>
In-Reply-To: <20190808170247.1fc2c4c4@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8363628b-477e-47ff-e5d2-08d71ffd4b2f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5923;
x-ms-traffictypediagnostic: AM0PR05MB5923:
x-microsoft-antispam-prvs: <AM0PR05MB5923AC459F0A54EF66AF6B53D1D20@AM0PR05MB5923.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(13464003)(54534003)(199004)(26005)(7736002)(33656002)(305945005)(486006)(74316002)(53936002)(25786009)(476003)(14454004)(86362001)(53546011)(6246003)(8936002)(2906002)(54906003)(55236004)(9456002)(7696005)(6506007)(102836004)(76176011)(186003)(3846002)(446003)(11346002)(4326008)(6116002)(316002)(71200400001)(71190400001)(256004)(66476007)(66446008)(66946007)(229853002)(76116006)(64756008)(66556008)(6436002)(99286004)(14444005)(9686003)(55016002)(5660300002)(52536014)(8676002)(81156014)(81166006)(478600001)(66066001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5923;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8nVVktnguPKZzUMiomOhzBc1DwWDIVWM9rxvyPyXqEky2dd7f4mq/k3vT3EW3HDAOVPogKlvwIfTguypLpUF6vdGcJjbfrU3JdCO5XatoaA8HnEI6WEr63XNvUspeLMIHJFss6xAKOtWdxnbX47gSNEf+8l4dbbY4o8bRcJ7ZSvVxHFuKVRX8ex0BDqOF5c7s0byQOo4qwizneUlLXFyLXi5S6j+uIjf1W0tv0mb4irL14I/Dok07dm0FyY5NqYqj1ZBsIpTvx02XTn5afNTGLY8SknWbOgODpHVpMRyFD9jbLxHRjF2CAWTUpuz4dHODKFUk5r5KJGg7/mONHULEEUInhW1UaKvuFOqBRgG2vRHQwKH8rnjaHrtaFUP+U/ZaH+7OnxY50ZXasbqRcRlKYSFXFOb1pb6G3K8oZLayws=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8363628b-477e-47ff-e5d2-08d71ffd4b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 14:48:23.9824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkgMwiwp08LFwHrS3lw9BLZ0Ob0BzeQjcALeWWEB8dtQXOqYw2HglFngZ+GzCRXI1nVzBX5rnwYt9saYHrXg9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5923
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,


> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 9, 2019 4:33 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; kwankhede@nvidia.com; linux-
> kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Thu,  8 Aug 2019 09:12:53 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Currently mtty sample driver uses mdev state and UUID in convoluated
> > way to generate an interrupt.
> > It uses several translations from mdev_state to mdev_device to mdev uui=
d.
> > After which it does linear search of long uuid comparision to find out
> > mdev_state in mtty_trigger_interrupt().
> > mdev_state is already available while generating interrupt from which
> > all such translations are done to reach back to mdev_state.
> >
> > This translations are done during interrupt generation path.
> > This is unnecessary and reduandant.
>=20
> Is the interrupt handling efficiency of this particular sample driver rea=
lly
> relevant, or is its purpose more to illustrate the API and provide a proo=
f of
> concept?  If we go to the trouble to optimize the sample driver and remov=
e this
> interface from the API, what do we lose?
>=20
> This interface was added via commit:
>=20
> 99e3123e3d72 vfio-mdev: Make mdev_device private and abstract interfaces
>=20
> Where the goal was to create a more formal interface and abstract driver
> access to the struct mdev_device.  In part this served to make out-of-tre=
e mdev
> vendor drivers more supportable; the object is considered opaque and acce=
ss is
> provided via an API rather than through direct structure fields.
>=20
This is not the common practice in the kernel to provide exported symbol fo=
r every single field of the structure.

> I believe that the NVIDIA GRID mdev driver does make use of this interfac=
e and
> it's likely included in the sample driver specifically so that there is a=
n in-kernel
> user for it (ie. specifically to avoid it being removed so casually).  An=
 interesting
> feature of the NVIDIA mdev driver is that I believe it has portions that =
run in
> userspace.  As we know, mdevs are named with a UUID, so I can imagine the=
re
> are some efficiencies to be gained in having direct access to the UUID fo=
r a
> device when interacting with userspace, rather than repeatedly parsing it=
 from
> a device name. =20
Can you please point to the kernel code that accesses the UUID?

> Is that really something we want to make more difficult in
> order to optimize a sample driver?  Knowing that an mdev device uses a UU=
ID
> for it's name, as tools like libvirt and mdevctl expect, is it really wor=
thwhile to
> remove such a trivial API?
>=20
Yes. it is worthwhile to not keep any dead code in the kernel when there is=
 no in-kernel driver using it.
Did I miss a caller?
Sample driver is setting wrong example of how/when uuid is used.
There has be better example to show how/when/why to use it.
Out of tree driver doesn't qualify API addition to my understanding.
I like to listen to Greg and others for an API inclusion without user as I =
haven't come across such practice in other subsystems such as nvme, netdev,=
 rdma.

> > Hence,
> > Patch-1 simplifies mtty sample driver to directly use mdev_state.
> >
> > Patch-2, Since no production driver uses mdev_uuid(), simplifies and
> > removes redandant mdev_uuid() exported symbol.
>=20
> s/no production driver/no in-kernel production driver/
>=20
> I'd be interested to hear how the NVIDIA folks make use of this API inter=
face.
> Thanks,
>=20
> Alex
>=20
> > ---
> > Changelog:
> > v1->v2:
> >  - Corrected email of Kirti
> >  - Updated cover letter commit log to address comment from Cornelia
> >  - Added Reviewed-by tag
> > v0->v1:
> >  - Updated commit log
> >
> > Parav Pandit (2):
> >   vfio-mdev/mtty: Simplify interrupt generation
> >   vfio/mdev: Removed unused and redundant API for mdev UUID
> >
> >  drivers/vfio/mdev/mdev_core.c |  6 ------
> >  include/linux/mdev.h          |  1 -
> >  samples/vfio-mdev/mtty.c      | 39 +++++++----------------------------
> >  3 files changed, 8 insertions(+), 38 deletions(-)
> >

