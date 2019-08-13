Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AD68BE8F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 18:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfHMQ26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 12:28:58 -0400
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:65038
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726802AbfHMQ26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 12:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVaSoN+wojrKq03jm0wocd+sUfg7xYB+rTV/7idhcbztKz7UlBInQ/DMR48hQNsIuJaARcgs/s10ixWkNMpmltqogTZJ6aAnrir5hVs60PoNH+ygZgHmSQ0PKGfk1folEWWcTUqC3WC0UDvu8hKC7hklfxrx4c+Wu/SP+Qmpi0RS+bMqlBu/4i04hZ9W+M7J12CQhFbb1rLupgPast2Hu9MXF6Hz0XqeciR3JvPLBT22RwWUzfDYjGBDKJktc88nF3q0d4ejHbtLA+XQnPRV0SPePEP8oMhrZClJIO5EF4blftKON94O9UJIYOuPG7mbJWcKBDh++r8JquYb62QUjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU0QA95k9HII3T6vLfHeB3UxtruWG+ZYFeTtduuItXA=;
 b=hmlrZ8BGH9zhpNOJt47Ltzt8jG698mup+fB5ljDBR5womIHPWuJspQ3X0AL+dXAdaSp9yQT2rKkdNUcuTI9aF7jrZPlv1jqH+fwVZHIqShpc5cBySMj1abuIinhd0K2NzpZBjJyPZvkXxMOfNLXolPECBntahA5KGde+g9YbrGF7Tpm1nxMuskkslJCCaeqI4EdIKTjmo7QrU0KCLgzj+wuanvlnocgwukOdGWHohkwgs6C+ixsQe3tY44WEtCLn2WZuVMRsaahNB1/yM6JrHNgJoso9lEiv+9KpghqzeWMoSrTuF1wUeQJsBvP5uPYQwRQmlhRltoDlekQM1aTUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU0QA95k9HII3T6vLfHeB3UxtruWG+ZYFeTtduuItXA=;
 b=h02E3+VY8ajZURNISw8BBi7zaMwIQk5OJ8+fLExkj2Y+YDBo3h7DMivZbnF+1WbPWFd1k8eV73WXVGQOwvhwVFYuNvzkU6HwJox4ZUMuQKEIYBYD8epKDVEjgUXf6UTdknM1Vlh1bGBy8gJGb88xhWQSnwQ2PcKKBxazz/K2H1Q=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4963.eurprd05.prod.outlook.com (20.177.42.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 13 Aug 2019 16:28:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 16:28:53 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtA=
Date:   Tue, 13 Aug 2019 16:28:53 +0000
Message-ID: <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>     <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190813085246.1d642ae5@x1.home>
In-Reply-To: <20190813085246.1d642ae5@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd666f7d-acc8-4e0a-9ced-08d7200b54a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4963;
x-ms-traffictypediagnostic: AM0PR05MB4963:
x-microsoft-antispam-prvs: <AM0PR05MB4963E3BDF1B8A517D32FECCED1D20@AM0PR05MB4963.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(13464003)(199004)(53546011)(9456002)(102836004)(53936002)(486006)(14454004)(7736002)(74316002)(33656002)(305945005)(25786009)(86362001)(476003)(54906003)(316002)(55236004)(8936002)(2906002)(186003)(6506007)(3846002)(7696005)(6246003)(26005)(71200400001)(446003)(11346002)(4326008)(76176011)(71190400001)(6116002)(8676002)(66476007)(66946007)(66446008)(229853002)(76116006)(66556008)(64756008)(9686003)(55016002)(99286004)(52536014)(6436002)(14444005)(256004)(5660300002)(81156014)(81166006)(478600001)(6916009)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4963;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rzMq74mzwlCm9jCpyd3LRgxH7y05zUzak0EzXNO5jpfQl2AimPUyYNMKt1l14ZUbAKbbdzt+1opjoEaBj1I4yjw/x0R2UURVRtkyjFlGvi34N3D1CLjeQjbppNG6zX/kE2UU17xLi0kHGTTJY6AFu3zto6vopPNAZA0wkcGh0gZfkjh2P3uE46AozHKnL7oMLV+EkWZTO5+ieuzLQUAs/jDMc9VhyecNSOmSo9NSQDeQMhNwfGtI4Wee3CVkIG9drarlaJ6yLxdymtPQbAE6fcWSD7vY8hEbAnUB3TphOz4sXNhKUsLZDPefoiUh7h78fyecfE6/aQ0S/xYEMyN1RDAdINKy5Vnp9oC3EkJVwhiIe/NllFWlprSa2HIkeGIqnEqB5xwtErymcPgNbLwg1TYFN4nx44uTKo49f8KH6xQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd666f7d-acc8-4e0a-9ced-08d7200b54a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 16:28:53.1733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXfeY8DBT4orCheLI49CjDOh1bJN3aTq3IN1z4lomt+y7JcD2UYl0efGuijOJyV1ljYFcMRIMxaBiCoCkw9Wsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4963
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 13, 2019 8:23 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cohuck@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Tue, 13 Aug 2019 14:40:02 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Kirti Wankhede <kwankhede@nvidia.com>
> > > Sent: Monday, August 12, 2019 5:06 PM
> > > To: Alex Williamson <alex.williamson@redhat.com>; Parav Pandit
> > > <parav@mellanox.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > cohuck@redhat.com; cjia@nvidia.com
> > > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > >
> > >
> > >
> > > On 8/9/2019 4:32 AM, Alex Williamson wrote:
> > > > On Thu,  8 Aug 2019 09:12:53 -0500 Parav Pandit
> > > > <parav@mellanox.com> wrote:
> > > >
> > > >> Currently mtty sample driver uses mdev state and UUID in
> > > >> convoluated way to generate an interrupt.
> > > >> It uses several translations from mdev_state to mdev_device to mde=
v
> uuid.
> > > >> After which it does linear search of long uuid comparision to
> > > >> find out mdev_state in mtty_trigger_interrupt().
> > > >> mdev_state is already available while generating interrupt from
> > > >> which all such translations are done to reach back to mdev_state.
> > > >>
> > > >> This translations are done during interrupt generation path.
> > > >> This is unnecessary and reduandant.
> > > >
> > > > Is the interrupt handling efficiency of this particular sample
> > > > driver really relevant, or is its purpose more to illustrate the
> > > > API and provide a proof of concept?  If we go to the trouble to
> > > > optimize the sample driver and remove this interface from the API, =
what
> do we lose?
> > > >
> > > > This interface was added via commit:
> > > >
> > > > 99e3123e3d72 vfio-mdev: Make mdev_device private and abstract
> > > > interfaces
> > > >
> > > > Where the goal was to create a more formal interface and abstract
> > > > driver access to the struct mdev_device.  In part this served to
> > > > make out-of-tree mdev vendor drivers more supportable; the object
> > > > is considered opaque and access is provided via an API rather than
> > > > through direct structure fields.
> > > >
> > > > I believe that the NVIDIA GRID mdev driver does make use of this
> > > > interface and it's likely included in the sample driver
> > > > specifically so that there is an in-kernel user for it (ie.
> > > > specifically to avoid it being removed so casually).  An
> > > > interesting feature of the NVIDIA mdev driver is that I believe it =
has
> portions that run in userspace.
> > > > As we know, mdevs are named with a UUID, so I can imagine there
> > > > are some efficiencies to be gained in having direct access to the
> > > > UUID for a device when interacting with userspace, rather than
> > > > repeatedly parsing it from a device name.
> > >
> > > That's right.
> > >
> > > >  Is that really something we want to make more difficult in order
> > > > to optimize a sample driver?  Knowing that an mdev device uses a
> > > > UUID for it's name, as tools like libvirt and mdevctl expect, is
> > > > it really worthwhile to remove such a trivial API?
> > > >
> > > >> Hence,
> > > >> Patch-1 simplifies mtty sample driver to directly use mdev_state.
> > > >>
> > > >> Patch-2, Since no production driver uses mdev_uuid(), simplifies
> > > >> and removes redandant mdev_uuid() exported symbol.
> > > >
> > > > s/no production driver/no in-kernel production driver/
> > > >
> > > > I'd be interested to hear how the NVIDIA folks make use of this
> > > > API interface.  Thanks,
> > > >
> > >
> > > Yes, NVIDIA mdev driver do use this interface. I don't agree on
> > > removing
> > > mdev_uuid() interface.
> > >
> > We need to ask Greg or Linus on the kernel policy on whether an API
> > should exist without in-kernel driver. We don't add such API in
> > netdev, rdma and possibly other subsystem. Where can we find this mdev
> > driver in-tree?
>=20
> We probably would not have added the API only for an out of tree driver, =
but
> we do have a sample driver that uses it, even if it's rather convoluted. =
 The
> sample driver is showing an example of using the API, which is rather its
> purpose more so than absolutely efficient interrupt handling. =20
For showing API use, it doesn't have to convoluted that too in interrupt ha=
ndling code.
It could be just dev_info(" UUID print..)
But the whole point is to have useful API that non sample driver need to us=
e.
And there is none.
In bigger objective, I wanted to discuss post this cleanup patch, is to exp=
and mdev to have more user friendly device names.

Before we reach there, I should include a patch that eliminates storing UUI=
D itself in the mdev_device.

> Also, let's not
> overstate what this particular API callback provides, it's simply access =
to the
> uuid of the device, which is a fundamental property of a mediated device.
This fundamental property is available in form of device name already.

> API was added simply to provide data abstraction, allowing the struct
> mdev_device to be opaque to vendor drivers.  Thanks,
>=20
I get that part. I prefer to remove the UUID itself from the structure and =
therefore removing this API makes lot more sense?
