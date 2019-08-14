Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6728CB70
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 07:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfHNFyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 01:54:43 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:49123
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727593AbfHNFym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 01:54:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJNyb+c3ClEepcPEhzjgCvO9+jwaRYSy4m5m0UguuHGsaeVFsX9PQrZpRkg1wuoM9QkSae285kY4LytiYdmbbZMCz4XySejXPKrBsfoyW4Y27QBlkpL3mZBNoFO9qob1iOPiq+Oj38biCiXDD8764jugSFvBFQn1oQQufxhghXUQewvT6uY8cBommpnHxgvtUN8tJWrotCfcLULabXoLQ5u+02qBmqCIHhX4zOCWP99q1dc4j23L3cObzdva3Y6x8WvwJJndarHdO+cF3s+xh9FFH+y/1SED2DyB4m/RsyRUQD9KE3iXfMTOyekKLZcQdTQrQp0njthntpqcGQ/jqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skldPkjx3qcicxyDug/W1CSCYV38sz3vSvUPRp+DelQ=;
 b=QkXXe9tbLs7QbnQDjEgk4pbBOpp45qzQYNuvNPtee1grLx1AGe/l1Lwuklq3TZWi0ULp6jJomUyyFCrr2re81RUsXfWxbqjFMsKoOS6Ez9Rm1GuL5nT6Kv2h0YrKiO0NdAeB/3Wa+N+155YAs8CADXM1eDMvviYMVJKcIXBOqSDHM4RNaRkd7yk/q76iMsJV/bVOwIds0g6P19PJtHOQU1h/NYjLD8dMYzSGpGN7CT7MwHMdOxUV0KMGbOwqZdapkMcfIwreYia+Clio4Nge9NG5mqKeXHNyuJyyoj0SdLQkc4jZ7djquemjyg427YUMT8IRgQlYIMN2r7yu5Ki6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skldPkjx3qcicxyDug/W1CSCYV38sz3vSvUPRp+DelQ=;
 b=b9vJ8/ZomU9QE3u5bsC64unvHw2XEBjYYPpO64SGF2y4NtGNl9hlRvJPNoE1ErKYv8EYCOYyzqX74+hqAx7T8YmkbVdrd42kV3GzdBjnLeZ99aG4yxioqy2j/C3fzpliCfSc/BNDBsfpeWDZDxjW3cnbx827TK94g6DW6xFN0E8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5970.eurprd05.prod.outlook.com (20.178.119.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 05:54:36 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 05:54:36 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoew
Date:   Wed, 14 Aug 2019 05:54:36 +0000
Message-ID: <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>     <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813111149.027c6a3c@x1.home>
In-Reply-To: <20190813111149.027c6a3c@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f77ee97-082e-4d66-c6d1-08d7207be34f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5970;
x-ms-traffictypediagnostic: AM0PR05MB5970:
x-microsoft-antispam-prvs: <AM0PR05MB5970F28EDAB6B35B11A9E5A1D1AD0@AM0PR05MB5970.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(199004)(189003)(13464003)(74316002)(7736002)(305945005)(71190400001)(9686003)(71200400001)(55016002)(52536014)(6436002)(86362001)(99286004)(33656002)(6916009)(54906003)(316002)(5660300002)(229853002)(53936002)(4326008)(9456002)(186003)(25786009)(14444005)(26005)(446003)(8936002)(66476007)(81166006)(8676002)(2906002)(476003)(81156014)(11346002)(486006)(14454004)(256004)(55236004)(102836004)(76176011)(6246003)(53546011)(6116002)(76116006)(66446008)(478600001)(3846002)(64756008)(6506007)(66556008)(66066001)(7696005)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5970;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n6nCYY1NI61h+FAqly9wOnEFaPwgY3t6Q77F7SaxAeYXvWDxK+FQs3LrCaiiX0YDPY2x1Vtsais8AIQ8eWc0dKmzOSROljkPC21UrZLYgp4UvxLnzKhrTj3TXLLvLGQkdAIPf9ktAFAOLJKu3OvyQoC1WzXzo+U/bwAm+E9Hm3Qk9NnD13Xzh/MHRGCTN2H6b1tAN5QNQNLwsallygI/2z1i0imts5gTWW8ffiFT8wXf2oWskMWYjm4Y76ogwlT+lgAzF+U6wNGhMXo16LaOhkH7VZJ88YXVGKXZYXyzUD5KieBXcSEaEG052++NAweaGItpdL68gFshdFq+mYXnPTR3kR5UCoaC0QJD7b1nzBuL3d/a3Pu6lRAa2BSjcUyMT6phcrVwXqd9WNhsy8uttx0oEQdwJy0RiCsJl3SuYk4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f77ee97-082e-4d66-c6d1-08d7207be34f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 05:54:36.1877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pCri7l0U3X02/tuq8j8Eoz+Aj15o8+29Q9dXb71vafeVq9ZqVwIITQwFhoPQOJM7vYWM/z6sWgUxAAgMC/k9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5970
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 13, 2019 10:42 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Tue, 13 Aug 2019 16:28:53 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, August 13, 2019 8:23 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Kirti Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > > On Tue, 13 Aug 2019 14:40:02 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Kirti Wankhede <kwankhede@nvidia.com>
> > > > > Sent: Monday, August 12, 2019 5:06 PM
> > > > > To: Alex Williamson <alex.williamson@redhat.com>; Parav Pandit
> > > > > <parav@mellanox.com>
> > > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > > cohuck@redhat.com; cjia@nvidia.com
> > > > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > > > >
> > > > >
> > > > >
> > > > > On 8/9/2019 4:32 AM, Alex Williamson wrote:
> > > > > > On Thu,  8 Aug 2019 09:12:53 -0500 Parav Pandit
> > > > > > <parav@mellanox.com> wrote:
> > > > > >
> > > > > >> Currently mtty sample driver uses mdev state and UUID in
> > > > > >> convoluated way to generate an interrupt.
> > > > > >> It uses several translations from mdev_state to mdev_device
> > > > > >> to mdev
> > > uuid.
> > > > > >> After which it does linear search of long uuid comparision to
> > > > > >> find out mdev_state in mtty_trigger_interrupt().
> > > > > >> mdev_state is already available while generating interrupt
> > > > > >> from which all such translations are done to reach back to
> mdev_state.
> > > > > >>
> > > > > >> This translations are done during interrupt generation path.
> > > > > >> This is unnecessary and reduandant.
> > > > > >
> > > > > > Is the interrupt handling efficiency of this particular sample
> > > > > > driver really relevant, or is its purpose more to illustrate
> > > > > > the API and provide a proof of concept?  If we go to the
> > > > > > trouble to optimize the sample driver and remove this
> > > > > > interface from the API, what
> > > do we lose?
> > > > > >
> > > > > > This interface was added via commit:
> > > > > >
> > > > > > 99e3123e3d72 vfio-mdev: Make mdev_device private and abstract
> > > > > > interfaces
> > > > > >
> > > > > > Where the goal was to create a more formal interface and
> > > > > > abstract driver access to the struct mdev_device.  In part
> > > > > > this served to make out-of-tree mdev vendor drivers more
> > > > > > supportable; the object is considered opaque and access is
> > > > > > provided via an API rather than through direct structure fields=
.
> > > > > >
> > > > > > I believe that the NVIDIA GRID mdev driver does make use of
> > > > > > this interface and it's likely included in the sample driver
> > > > > > specifically so that there is an in-kernel user for it (ie.
> > > > > > specifically to avoid it being removed so casually).  An
> > > > > > interesting feature of the NVIDIA mdev driver is that I
> > > > > > believe it has
> > > portions that run in userspace.
> > > > > > As we know, mdevs are named with a UUID, so I can imagine
> > > > > > there are some efficiencies to be gained in having direct
> > > > > > access to the UUID for a device when interacting with
> > > > > > userspace, rather than repeatedly parsing it from a device name=
.
> > > > >
> > > > > That's right.
> > > > >
> > > > > >  Is that really something we want to make more difficult in
> > > > > > order to optimize a sample driver?  Knowing that an mdev
> > > > > > device uses a UUID for it's name, as tools like libvirt and
> > > > > > mdevctl expect, is it really worthwhile to remove such a trivia=
l API?
> > > > > >
> > > > > >> Hence,
> > > > > >> Patch-1 simplifies mtty sample driver to directly use mdev_sta=
te.
> > > > > >>
> > > > > >> Patch-2, Since no production driver uses mdev_uuid(),
> > > > > >> simplifies and removes redandant mdev_uuid() exported symbol.
> > > > > >
> > > > > > s/no production driver/no in-kernel production driver/
> > > > > >
> > > > > > I'd be interested to hear how the NVIDIA folks make use of
> > > > > > this API interface.  Thanks,
> > > > > >
> > > > >
> > > > > Yes, NVIDIA mdev driver do use this interface. I don't agree on
> > > > > removing
> > > > > mdev_uuid() interface.
> > > > >
> > > > We need to ask Greg or Linus on the kernel policy on whether an
> > > > API should exist without in-kernel driver. We don't add such API
> > > > in netdev, rdma and possibly other subsystem. Where can we find
> > > > this mdev driver in-tree?
> > >
> > > We probably would not have added the API only for an out of tree
> > > driver, but we do have a sample driver that uses it, even if it's
> > > rather convoluted.  The sample driver is showing an example of using =
the
> API, which is rather its
> > > purpose more so than absolutely efficient interrupt handling.
> > For showing API use, it doesn't have to convoluted that too in interrup=
t
> handling code.
> > It could be just dev_info(" UUID print..)
>=20
> I was thinking we could have the mtty driver expose a vendor sysfs attrib=
ute
> providing the UUID if you insist on cleaning up the interrupt path.
>=20
A vendor driver can add its own sysfs file per device.
A while back I refactored rdma system to simplify all of such sysfs entries=
 for several drivers.
We had hurdle when we introduced namespaces to it.
So I do not recommend adding it in the vendor driver.
Rather, mdev code can add sysfs entry per device exposing its UUID.
This will be unified across the vendors.
And for below discussion, if the device is not based on UUID, this sysfs en=
try won't exist.
More below.

> > But the whole point is to have useful API that non sample driver need t=
o use.
> > And there is none.
>=20
> Kirti has already indicated this API was useful and it's not a burden to =
maintain
> it.  The trouble is that we don't have any in-kernel mdev drivers sophist=
icated
> enough to have the same kernel/user split as the NVIDIA driver, but that'=
s a
> feature that I believe we wish to continue to support.  The kernel expose=
s the
> device by UUID, userspace references the device by UUID, so it seems intu=
itive
> to provide a core API to retrieve the UUID for a device without parsing i=
t from a
> device name string.  We can continue to add trivial sample driver use cas=
es or
But mdev or any vendor drivers are not parsing it anywhere today.
That is why I was asking for an example production driver that explains why=
/how it uses it.

> we can just agree that this is a useful interface for UUID based device.
>=20
> > In bigger objective, I wanted to discuss post this cleanup patch, is
> > to expand mdev to have more user friendly device names.
>=20
> "Friendly" is a matter of opinion.  UUIDs provide us with consistent name=
s,
> effectively avoids name collisions which in turn effectively avoids races=
 in
> device creation, they're easy to deal with, and they're well known.  Nami=
ng
> things is hard. Dealing with arbitrary user generated names or defining a=
 policy
> around acceptable naming is hard.
>=20
> > Before we reach there, I should include a patch that eliminates
> > storing UUID itself in the mdev_device.
> >
> > > Also, let's not
> > > overstate what this particular API callback provides, it's simply
> > > access to the uuid of the device, which is a fundamental property of
> > > a mediated device.
> > This fundamental property is available in form of device name already.
>=20
> So you're wanting to optimize a sample driver interrupt handler in order =
to
> eliminate an API which makes the UUID available without parsing it from a
> string?
Yes. because none production driver needs this and it can be derived from t=
he device name.

> And the complexity grows when you later propose that the string is now
> arbitrary?  It doesn't seem like a good replacement.
>=20
Well sample driver shouldn't use the API the way it uses in convoluted appr=
oach.
Just a UUID print during create() call using mdev_uuid() is good enough for=
 sake of showing example of an API.

If we want to uniquely identify mdev using UUID, but not derive their names=
 from UUID, by having additional parameter for its name,
It makes sense to me.
In this approach, mdev_uuid() can be added/kept if a vendor driver is inter=
ested in the UUID.
At present there is none.

> > > API was added simply to provide data abstraction, allowing the
> > > struct mdev_device to be opaque to vendor drivers.  Thanks,
> > >
> > I get that part. I prefer to remove the UUID itself from the structure
> > and therefore removing this API makes lot more sense?
>=20
> Mdev and support tools around mdev are based on UUIDs because it's define=
d
> in the documentation. =20
When we introduce newer device naming scheme, it will update the documentat=
ion also.
May be that is the time to move to .rst format too.

> I don't think it's as simple as saying "voila, UUID
> dependencies are removed, users are free to use arbitrary strings".  We'd=
 need
> to create some kind of naming policy, what characters are allows so that =
we
> can potentially expand the creation parameters as has been proposed a cou=
ple
> times, how do we deal with collisions and races, and why should we make s=
uch
> a change when a UUID is a perfectly reasonable devices name.  Thanks,
>
Sure, we should define a policy on device naming to be more relaxed.
We have enough examples in-kernel.
Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot more), rdma =
etc which has arbitrary device names and ID based device names.
=20
Collisions and race is already taken care today in the mdev core. Same uniq=
ue device names continue.
