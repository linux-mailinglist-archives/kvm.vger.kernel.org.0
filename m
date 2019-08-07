Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF23F85118
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 18:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbfHGQdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 12:33:16 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:43271
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729278AbfHGQdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 12:33:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI8XiYNBWV1C1INFPS1B5Dqg78+26CDsSSgSHgGnjRETCzA8H0w6gzxUmh28sVIH1gRWqEFUhjDLXb61dRSaOS5XPKts9v4N0fIY+3rAK82ROD9881u8ZZI7ObIQ+aR+0zc0Bw7+AhutNgwf0WPYycL8nXn1G30Q5D20nETQczAy7c5Ah2xbjJKhhKFzcqQkMlYNPJtf/FLhqsxmrXfM3U+123cnHwfuKPnpQFsB0EKKFErrUYShV5urtplVYX3A0r/Mawjva5aDGML+DXB+5BaHkZU47hy8a2kYYDnZ5QnVJC1KeF/QekwxwmqKH4vEmWx3bv0JxIqfnlWoPOuhLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88w4gY0L3azL7ALEln6ts8I11ECPBG3XFvKFxQvLqpo=;
 b=WQLUVakQRAQv287SjHUXOYtXDK6lzLHsemacEMJBpItQaReYAxUDAD1Ql7Jw7UB7y9pvPK3OmGgXyHAWTjJmoGdB7YlZqCaMJu3KDL4iI5aRTbIesLtxPMq3Rp7RioM4XMcC/nfSGvfEiJ1Rw4khokJ6MCRX6BZqrok2e1DAKep2ncgnW0qcI1guJIWxBvna/i1jYZNg8R4iHFB8EYrl3cJ0DvZZ3jDHBMXrJbAgU0MYm8eO0uqxzAg2iyd6WVZwQASIUVEw6mfBFQNiq9sEFiI1ryfBtXSu5xeZcEb7BzUI5MKDpu6MBhYrstE5bpgOhMuHxTSI2/EhqTYoe2/idA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88w4gY0L3azL7ALEln6ts8I11ECPBG3XFvKFxQvLqpo=;
 b=eTmmzRkB/2tz0aT/77gg8UGxIWguLKKIQWgMhnw9EDmtHRawueEeCIXhJXLp1uc8XRAn92dBpwp2cO32BQKLdlLcw3uU4eBSwFRDzgvqkIy5w971UqWL7o7X4yEk5N62dYHgFI+ZJx6POwsAnH3TTMLh61wNuGVlmiDWChyp6io=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4337.eurprd05.prod.outlook.com (52.134.93.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Wed, 7 Aug 2019 16:33:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 16:33:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wankhede@nvidia.com" <wankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API for
 mdev UUID
Thread-Topic: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API for
 mdev UUID
Thread-Index: AQHVTGHewj+1neBmdkuk/1V2f0BrWKbvbAyAgAB0EUA=
Date:   Wed, 7 Aug 2019 16:33:11 +0000
Message-ID: <AM0PR05MB48664379F91C8FA3D0035B41D1D40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190806141826.52712-1-parav@mellanox.com>
        <20190806141826.52712-3-parav@mellanox.com>
 <20190807112801.6b2ceb36.cohuck@redhat.com>
In-Reply-To: <20190807112801.6b2ceb36.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.55.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bee8c9f-da6a-489d-dc8c-08d71b54f02e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB4337;
x-ms-traffictypediagnostic: AM0PR05MB4337:
x-microsoft-antispam-prvs: <AM0PR05MB43379EFCC5A8AEE45BD558E2D1D40@AM0PR05MB4337.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(189003)(199004)(54534003)(13464003)(51914003)(33656002)(6436002)(8936002)(305945005)(74316002)(446003)(7736002)(486006)(476003)(6246003)(52536014)(3846002)(2906002)(5660300002)(54906003)(6116002)(11346002)(55016002)(8676002)(9686003)(229853002)(6506007)(53546011)(55236004)(186003)(76116006)(316002)(66946007)(66476007)(66556008)(66446008)(6916009)(64756008)(66066001)(81166006)(81156014)(68736007)(256004)(4326008)(53936002)(71190400001)(71200400001)(102836004)(76176011)(26005)(86362001)(25786009)(7696005)(14454004)(14444005)(478600001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4337;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lD/TZbcRi0n3mPNnU8O5D1Y8DlnNbsmivONd1ehhM70rO7p+rG/YYVYEYZZtQ/nmyTOO+Mb8P3IGrOtQlRIHi2vHQ4a9q5t2oBVL2WPfOJMoY6ndxyTN4/g5FXChG9sNwdd7JqdXutDOpJ5ssidSi1Zwo5hinaqUa+rhmxghN/1Bhq7vrSJp+m70Exd8SJ8s1CQhNgW3q72UxNzG1R7lysWWPq8NTbSFuMRHeyYbHknr3JRo29W4nGNLPaMwWxWTfIph9ZPsO7Az2Hb4mvQ8Of+PcYjLSxG52B5Tc79tD9Bb87GrKcB7iuM4TTGQ1Ca+lyNwggyLyg61i3d/3H/BwlvNeL4N0M1g1vxItGTJkF3OTLOf8+ZUeYC3Wjg9E/7DAurMnliulxzDmijWutf20PM5xOOGDdYGn/4LpZVapHg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bee8c9f-da6a-489d-dc8c-08d71b54f02e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 16:33:11.6210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4337
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, August 7, 2019 2:58 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; wankhede@nvidia.com; linux-
> kernel@vger.kernel.org; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API f=
or
> mdev UUID
>=20
> On Tue,  6 Aug 2019 09:18:26 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > There is no single production driver who is interested in mdev device
> > uuid. Currently UUID is mainly used to derive a device name.
> > Additionally mdev device name is already available using core kernel
> > API dev_name().
>=20
> Well, the mdev code actually uses the uuid to check for duplicates before
> registration with the driver core would fail... I'd just drop the two sen=
tences
Yes, it does the check. But its mainly used to derive a device name.
And to ensure that there are no two devices with duplicate name, it compare=
s with the uuid.

Even this 16 bytes storage is redundant.
Subsequently, I will submit a patch to get rid of storing this 16 bytes of =
UUID too.
Because for duplicate name check, device name itself is pretty good enough.

Since I ran out of time and rc-4 is going on, I differed the 3rd simplifica=
tion patch.

Commit message actually came from the thoughts of 3rd patch, but I see that=
 without it, its not so intuitive.

> talking about the device name, IMHO they don't really add useful informat=
ion;
> but I'll leave that decision to the maintainers.
>=20
> >
> > Hence removed unused exported symbol.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> > Changelog:
> > v0->v1:
> >  - Updated commit log to address comments from Cornelia
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 6 ------
> >  include/linux/mdev.h          | 1 -
> >  2 files changed, 7 deletions(-)
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Thanks for the review.
