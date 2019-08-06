Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6338326E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 15:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfHFNMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 09:12:40 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:48738
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfHFNMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 09:12:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzglXFjZxyQUNmj7Uxm3udkExNUiCLDB7PKwYRvJSbSW7YeYngCyDea62QNguSVBQe2fOejJ1U3EoL/5foiIpdzGHEpo6U2LFAU6Psm/G4Ttwu0KA4IpfIGP2eqfFsFN+AeHW2hA0Wo9J6QsjGMJlzNMNvHfQk0+oA9Xk6rlwNbtkAHtROtdjf6R+kEYzx8LCghlAntUCrs2EMftcEkBWHlAYM1YqltU5d2N6UItkvXAVtRCUr5eA3EOEWwxG+ctvhuq+q2A+Gg181Bm/ecUejLal8bfg/bTbhh2k/lCscneocIlcdpbq9HVhgsVLEzFO265sKIIbn6dG2fEAX/0kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeMmudaMUqQ5IJ0+pC5ogZGMHboSLx7AbsdLyY0ow20=;
 b=DAZloUUcj3Z48LoyaS78vz//Tks7bFML288FNV2VoBWEcOZ7WAHriJIAgdTFePDYi1Q3dJGeMfsigh1EyscA2U44PjTuq3Z6fFRtI0afeyZlqtIR4f2+V8ge79+AclQT3m4bvskB5bZckiotZBmnizDkUZLj7o3Iut40APkeUWCXRNYDzF/YjMh0XsvGPUhyrIAKxCuoVWPaO7DbGg+dFcfH8tUOfAajJK+Lju4qXRWBklPovTnpiUsFdXkSr6BxYGhiAyhvW11e/tluQtCrCdaqH4WQZ/tA8X+3s832XIvvAoU1kRXjutHtOeoikNs43Docb+J7vErrwcPBtC3p6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeMmudaMUqQ5IJ0+pC5ogZGMHboSLx7AbsdLyY0ow20=;
 b=MrT1TCyGCxMHj7xwGiF+h6WzAWDIIAwtB4ZZ4Lhnok36whdKLBispWY4Xdb0cCzTOcAR5bpzMya0S+8yOMwsdznO3QI63y4+KQoTNPK+dqnEE6dxVJ2Vp6hfCcHfBDGuRTxYqZEl69wJq6IRriGfjYkhH08KLfhSNq7+sU7IxUE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4881.eurprd05.prod.outlook.com (20.177.41.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Tue, 6 Aug 2019 13:12:35 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 13:12:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wankhede@nvidia.com" <wankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH 2/2] vfio/mdev: Removed unused and redundant API for mdev
 name
Thread-Topic: [PATCH 2/2] vfio/mdev: Removed unused and redundant API for mdev
 name
Thread-Index: AQHVSP/QXfYHLfQ+90+o58PtGykLpqbt0AEAgABO5sA=
Date:   Tue, 6 Aug 2019 13:12:35 +0000
Message-ID: <AM0PR05MB4866138959913DE9979E3688D1D50@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190802065905.45239-3-parav@mellanox.com>
 <20190806102902.3e09ab1a.cohuck@redhat.com>
In-Reply-To: <20190806102902.3e09ab1a.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.55.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5906d4dd-da53-44df-373c-08d71a6fbfb8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4881;
x-ms-traffictypediagnostic: AM0PR05MB4881:
x-microsoft-antispam-prvs: <AM0PR05MB488165E9C7694C8D45D30325D1D50@AM0PR05MB4881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(13464003)(189003)(199004)(55016002)(9686003)(7696005)(76176011)(229853002)(66066001)(102836004)(71200400001)(71190400001)(55236004)(99286004)(68736007)(6506007)(53546011)(256004)(76116006)(66476007)(66556008)(64756008)(66446008)(66946007)(5660300002)(86362001)(14444005)(53936002)(6246003)(6436002)(52536014)(74316002)(6916009)(4326008)(8676002)(81166006)(81156014)(11346002)(14454004)(8936002)(476003)(478600001)(316002)(446003)(6116002)(3846002)(305945005)(486006)(7736002)(54906003)(25786009)(186003)(2906002)(33656002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4881;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rf/+lZfKo2Vh29kZJZQaR6Y+/JSJsDEHOEx71R4C0qY0lRyaeXDqaMNQYtolOVjtbfoGAmlGO+BS8NJB7IGW0/3AttBuWPbooL1EK/O8jEowXDtQLVHYHRHG/0R4PZ2ZT92LWzoq/KQZUWUozPYOz1o07wm8YhUFEKS2mW1yjlU6tbDcumB8Sxmt4aDIEtRmhTt5cLcGBhj5/r4949RvHsS/BDassgnlL0tW76JavX/KLCYE8NihjBhkTuBb9N5tg/p098BDJVtEEVgX14UxCUbQzY9VAxV7QZViaMr9AGqM090ieI24kwpLCWKdJIUtotUo1daQ7CEufvAEdGYtJ0Q3q6/oSKmVvt4iNERkuZ6hE0IA5fKyr4giN9V+K+DT1HI3obTg2v1Ki33D351w7YK8961fUE6a2LNgKnwiQD4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5906d4dd-da53-44df-373c-08d71a6fbfb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 13:12:35.5168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4881
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 6, 2019 1:59 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; wankhede@nvidia.com; linux-
> kernel@vger.kernel.org; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH 2/2] vfio/mdev: Removed unused and redundant API for
> mdev name
>=20
> On Fri,  2 Aug 2019 01:59:05 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > There is no single production driver who is interested in mdev device
> > name.
> > Additionally mdev device name is already available using core kernel
> > API dev_name().
>=20
> The patch description is a bit confusing: You talk about removing an api =
to
> access the device name, but what you are actually removing is the api to =
access
> the device's uuid. That uuid is, of course, used to generate the device n=
ame, but
> the two are not the same. Using
> dev_name() gives you a string containing the uuid, not the uuid.
>=20
> >
> > Hence removed unused exported symbol.
>=20
> I'm not really against removing this api if no driver has interest in the=
 device's
> uuid (and I'm currently not seeing why they would need it; we can easily =
add it
> back, should the need arise); but this needs a different description.
>=20

Ok. I understand that uuid and dev_name() are not same.
I will update the commit description.
Sending v1.

> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 6 ------
> >  include/linux/mdev.h          | 1 -
> >  2 files changed, 7 deletions(-)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index b558d4cfd082..c2b809cbe59f
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -57,12 +57,6 @@ struct mdev_device *mdev_from_dev(struct device
> > *dev)  }  EXPORT_SYMBOL(mdev_from_dev);
> >
> > -const guid_t *mdev_uuid(struct mdev_device *mdev) -{
> > -	return &mdev->uuid;
> > -}
> > -EXPORT_SYMBOL(mdev_uuid);
> > -
> >  /* Should be called holding parent_list_lock */  static struct
> > mdev_parent *__find_parent_device(struct device *dev)  { diff --git
> > a/include/linux/mdev.h b/include/linux/mdev.h index
> > 0ce30ca78db0..375a5830c3d8 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -131,7 +131,6 @@ struct mdev_driver {
> >
> >  void *mdev_get_drvdata(struct mdev_device *mdev);  void
> > mdev_set_drvdata(struct mdev_device *mdev, void *data); -const guid_t
> > *mdev_uuid(struct mdev_device *mdev);
> >
> >  extern struct bus_type mdev_bus_type;
> >

