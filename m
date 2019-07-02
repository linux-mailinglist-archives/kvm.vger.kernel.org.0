Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2005C9D2
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 09:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfGBHOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 03:14:02 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:27719
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfGBHOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 03:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQs3h1PRAmKz+ixax7S6s8hgqhXz5/kXeqfSF3ruo7Q=;
 b=Pw/76JSV3A8eEv4mHr/ZcKg+KOyumIsG85K8ZrEsqzbU4ALGVkeMwVUi+A8JSh7g8SP9oVNyI3pVKcCJqPF0tbvd1Cop12f64dZYj2dtUwIGqBPiNmAIsKrzV4ASZOUSq33NihYIVHdJ7Iob/8qAZCxNFBXBt3AndaqLP+eeRrk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4723.eurprd05.prod.outlook.com (52.133.56.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 07:13:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 07:13:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] mdev: Send uevents around parent device registration
Thread-Topic: [PATCH v2] mdev: Send uevents around parent device registration
Thread-Index: AQHVMBzx//qnj/BlOkuUZNCZDJfIj6a2AEkAgAADOQCAAAc8gIAAJXEAgACUNgCAAA0egIAAF3hg
Date:   Tue, 2 Jul 2019 07:13:51 +0000
Message-ID: <AM0PR05MB48669DA5993C68765397AF1BD1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
        <08597ab4-cc37-3973-8927-f1bc430f6185@nvidia.com>
        <20190701112442.176a8407@x1.home>
        <3b338e73-7929-df20-ca2b-3223ba4ead39@nvidia.com>
        <20190701140436.45eabf07@x1.home>
        <14783c81-0236-2f25-6193-c06aa83392c9@nvidia.com>
 <20190701234201.47b6f23a@x1.home>
In-Reply-To: <20190701234201.47b6f23a@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41bb474f-9c67-487e-d9df-08d6febcd62e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4723;
x-ms-traffictypediagnostic: AM0PR05MB4723:
x-microsoft-antispam-prvs: <AM0PR05MB47232C7D31585CE538B0A66ED1F80@AM0PR05MB4723.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(13464003)(199004)(189003)(6436002)(68736007)(3846002)(9686003)(5660300002)(6116002)(186003)(53936002)(33656002)(256004)(14444005)(6246003)(9456002)(71200400001)(71190400001)(66556008)(66476007)(76116006)(73956011)(64756008)(66946007)(446003)(99286004)(476003)(11346002)(66446008)(78486014)(14454004)(486006)(229853002)(52536014)(102836004)(8676002)(8936002)(6506007)(66066001)(305945005)(110136005)(76176011)(316002)(2906002)(7696005)(53546011)(81166006)(81156014)(74316002)(54906003)(55236004)(7736002)(4326008)(478600001)(25786009)(55016002)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4723;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RrIXnI87EWeKFkwBQnwI2GN0qbxr9VcZlYyiCLWn/rjCK1UUluOEfnRqL5u4AN+4QQMImR/fMTB2I/721gwrcJvBlg1YUSzSfp4/Rc7pITQwUpqcHleIWO6dAERgwgZiKHkg88UEXJbmkffOzWIHHOh0gIllF9ZnR+0O+y1S9fwQi1/vSiitcaT92zQjzkE1jriKGxyjtTuU1UgTlZbVMyEjMqh7eDNPss0f2g0Osah6SQbCUGAEKTFKQQM5hBqQ+iugSvPaz7M8ahKgB1LcB5C1gqDRSbuxJoZ6v7TfqScfDGJ19BPyZ6qZDsat7GFdsmZtfsi3GhtYe2Gmqdhm9xDslKbO9rBi7gZ2NiQoVyavGcuJ92d7m8f05beEXUggUaAOxCjroBQHYnCon12IlBWCGiwgxQB3eTP9llAp3pg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bb474f-9c67-487e-d9df-08d6febcd62e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 07:13:51.8736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4723
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Alex Williamson
> Sent: Tuesday, July 2, 2019 11:12 AM
> To: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: cohuck@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] mdev: Send uevents around parent device registrat=
ion
>=20
> On Tue, 2 Jul 2019 10:25:04 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>=20
> > On 7/2/2019 1:34 AM, Alex Williamson wrote:
> > > On Mon, 1 Jul 2019 23:20:35 +0530
> > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >
> > >> On 7/1/2019 10:54 PM, Alex Williamson wrote:
> > >>> On Mon, 1 Jul 2019 22:43:10 +0530
> > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >>>
> > >>>> On 7/1/2019 8:24 PM, Alex Williamson wrote:
> > >>>>> This allows udev to trigger rules when a parent device is
> > >>>>> registered or unregistered from mdev.
> > >>>>>
> > >>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >>>>> ---
> > >>>>>
> > >>>>> v2: Don't remove the dev_info(), Kirti requested they stay and
> > >>>>>     removing them is only tangential to the goal of this change.
> > >>>>>
> > >>>>
> > >>>> Thanks.
> > >>>>
> > >>>>
> > >>>>>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
> > >>>>>  1 file changed, 8 insertions(+)
> > >>>>>
> > >>>>> diff --git a/drivers/vfio/mdev/mdev_core.c
> > >>>>> b/drivers/vfio/mdev/mdev_core.c index ae23151442cb..7fb268136c62
> > >>>>> 100644
> > >>>>> --- a/drivers/vfio/mdev/mdev_core.c
> > >>>>> +++ b/drivers/vfio/mdev/mdev_core.c
> > >>>>> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev,
> > >>>>> const struct mdev_parent_ops *ops)  {
> > >>>>>  	int ret;
> > >>>>>  	struct mdev_parent *parent;
> > >>>>> +	char *env_string =3D "MDEV_STATE=3Dregistered";
> > >>>>> +	char *envp[] =3D { env_string, NULL };
> > >>>>>
> > >>>>>  	/* check for mandatory ops */
> > >>>>>  	if (!ops || !ops->create || !ops->remove ||
> > >>>>> !ops->supported_type_groups) @@ -197,6 +199,8 @@ int
> mdev_register_device(struct device *dev, const struct mdev_parent_ops *op=
s)
> > >>>>>  	mutex_unlock(&parent_list_lock);
> > >>>>>
> > >>>>>  	dev_info(dev, "MDEV: Registered\n");
> > >>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> > >>>>> +
> > >>>>>  	return 0;
> > >>>>>
> > >>>>>  add_dev_err:
> > >>>>> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
> > >>>>>  void mdev_unregister_device(struct device *dev)  {
> > >>>>>  	struct mdev_parent *parent;
> > >>>>> +	char *env_string =3D "MDEV_STATE=3Dunregistered";
> > >>>>> +	char *envp[] =3D { env_string, NULL };
> > >>>>>
> > >>>>>  	mutex_lock(&parent_list_lock);
> > >>>>>  	parent =3D __find_parent_device(dev); @@ -243,6 +249,8 @@
> void
> > >>>>> mdev_unregister_device(struct device *dev)
> > >>>>>  	up_write(&parent->unreg_sem);
> > >>>>>
> > >>>>>  	mdev_put_parent(parent);
> > >>>>> +
> > >>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> > >>>>
> > >>>> mdev_put_parent() calls put_device(dev). If this is the last
> > >>>> instance holding device, then on put_device(dev) dev would get fre=
ed.
> > >>>>
> > >>>> This event should be before mdev_put_parent()
> > >>>
> > >>> So you're suggesting the vendor driver is calling
> > >>> mdev_unregister_device() without a reference to the struct device
> > >>> that it's passing to unregister?  Sounds bogus to me.  We take a
> > >>> reference to the device so that it can't disappear out from under
> > >>> us, the caller cannot rely on our reference and the caller
> > >>> provided the struct device.  Thanks,
> > >>>
> > >>
> > >> 1. Register uevent is sent after mdev holding reference to device,
> > >> then ideally, unregister path should be mirror of register path,
> > >> send uevent and then release the reference to device.
> > >
> > > I don't see the relevance here.  We're marking an event, not
> > > unwinding state of the device from the registration process.
> > > Additionally, the event we're trying to mark is the completion of
> > > each process, so the notion that we need to mirror the ordering betwe=
en
> the two is invalid.
> > >
> > >> 2. I agree that vendor driver shouldn't call
> > >> mdev_unregister_device() without holding reference to device. But
> > >> to be on safer side, if ever such case occur, to avoid any
> > >> segmentation fault in kernel, better to send event before mdev relea=
se the
> reference to device.
> > >
> > > I know that get_device() and put_device() are GPL symbols and that's
> > > a bit of an issue, but I don't think we should be kludging the code
> > > for a vendor driver that might have problems with that.  A) we're
> > > using the caller provided device  for the uevent, B) we're only
> > > releasing our own reference to the device that was acquired during
> > > registration, the vendor driver must have other references,
> >
> > Are you going to assume that someone/vendor driver is always going to
> > do right thing?
>=20
> mdev is a kernel driver, we make reasonable assumptions that other driver=
s
> interact with it correctly.
>=20
That is right.
Vendor drivers must invoke mdev_register_device() and mdev_unregister_devic=
e() only once.
And it must have a valid reference to the device for which it is invoking i=
t.
This is basic programming practice that a given driver has to follow.
mdev_register_device() has a loop to check. It needs to WARN_ON there if th=
ere are duplicate registration.
Similarly on mdev_unregister_device() to have WARN_ON if device is not foun=
d.
It was in my TODO list to submit those patches.
I was still thinking to that mdev_register_device() should return mdev_pare=
nt and mdev_unregister_device() should accept mdev_parent pointer, instead =
of WARN_ON on unregister().


> > > C) the parent device
> > > generally lives on a bus, with a vendor driver, there's an entire
> > > ecosystem of references to the device below mdev.  Is this a
> > > paranoia request or are you really concerned that your PCI device sud=
denly
> > > disappears when mdev's reference to it disappears.
> >
> > mdev infrastructure is not always used by PCI devices. It is designed
> > to be generic, so that other devices (other than PCI devices) can also
> > use this framework.
>=20
> Obviously mdev is not PCI specific, I only mention it because I'm asking =
if you
> have a specific concern in mind.  If you did, I'd assume it's related to =
a PCI
> backed vGPU.  Any physical parent device of an mdev is likely to have som=
e sort
> of bus infrastructure behind it holding references to the device (ie. a p=
robe and
> release where an implicit reference is held between these points).  A vir=
tual
> device would be similar, it's created as part of a module init and destro=
yed as
> part of a module exit, where mdev registration would exist between these
> points.
>=20
> > If there is a assumption that user of mdev framework or vendor drivers
> > are always going to use mdev in right way, then there is no need for
> > mdev core to held reference of the device?
> > This is not a "paranoia request". This is more of a ideal scenario,
> > mdev should use device by holding its reference rather than assuming
> > (or relying on) someone else holding the reference of device.
>=20
> In fact, at one point Parav was proposing removing these references entir=
ely,
> but Connie and I both felt uncomfortable about that.  I think it's good p=
ractice
> that mdev indicates the use of the parent device by incrementing the refe=
rence
> count, with each child mdev device also taking a reference, but those
> references balance out within the mdev core.  Their purpose is not to mai=
ntain
> the device for outside callers, nor should outside callers assume mdev's =
use of
> references to release their own.  I don't think it's unreasonable to assu=
me that
> the caller should have a legitimate reference to the object it's providin=
g to this
> function and therefore we should be able to use it after mdev's internal
> references are balanced out.  Thanks,
>=20
Yes, I also agree with Alex comment here to hold and release reference to m=
dev's parent device during reg/unreg routines.

> Alex
