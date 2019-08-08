Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F01863D9
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 16:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbfHHOCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 10:02:21 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:65293
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732866AbfHHOCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 10:02:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWWhsGAUKNO43OS0iim5dPN0AZOlHpOwu+YBRGs/sSHXxGrzr+VxiS8juZ6IUlnpU6U1ljICxyhmuYOuUvQq1TPX6AY81zhq7d+cZe6i/h25vMa4JT/n2Pko86T4BvRuqLNlw7u9ymFxKXBfBnsaOS0mznn2lIHgNamwzkWchxVEg6bX6OVkvOsu2+E2TD5pbc1Y+VR23T5zuftnWO8uzSYs2AADVzLVdl/TwPcw1ap3jlXK98ocieeZ88zL24JW5yyJbv+ePmiDtkopFMWHJFK4ywd/OEIVxPUct6WKjCq3bADX/b9pNeJvFVnc1g1Nq3Z24URNvdZRYRYn1nGcDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOPdR3mV+mb+ay5DmA/YfIe/6Ij5Rr/8SGmSBYQeCQM=;
 b=TbuIMVyis1Fcm8Q7nlFSR+TyhAYTVkRSKT3OlhI5ercgWduYhjGWjc2Udtomfc90BbqpeeCh1bGb0asKqWiBlx3GXXM5F1X/db1HKv/UlM2ipHDCLOzQnhNO5eIuADXTd8S+eDZf6OIJnWAVfU0mVgPjB+C92iQeVvsPbp3EvL4vc9YHruzAlCpN4qikGxdBkFBYasQ7JBJ3xI+RfKOVflIhqRlpGDOjgsGRpmotKYccmjnHYuDLxEzxF+PH5p8IwKXnolkaNbG1L8xIH7qZnSFYAg0JnQ3QMDWc4OoAjDNN2ZEXeox5A2nZGfsKTCgpCEFoZf7tV4cC4s5EkSgcPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOPdR3mV+mb+ay5DmA/YfIe/6Ij5Rr/8SGmSBYQeCQM=;
 b=D3DFGPhamPfVqEgZ2MIJSq5GPf65QfhsR4jZtFqwW3ue6X/nn2halsr9nvc7MDYdGPbrJk2AY+Ue+qRuKKnQd1r+Dw5aQ1oU/b6/EbYpTwfWl6S3kylq7547FmC0LDwF4n++vXnd6rVUghQ6PliH7fwi8XNCE58Ti69dKyhEnwg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5698.eurprd05.prod.outlook.com (20.178.113.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Thu, 8 Aug 2019 14:01:37 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2136.018; Thu, 8 Aug 2019
 14:01:37 +0000
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
Thread-Index: AQHVTGHewj+1neBmdkuk/1V2f0BrWKbvbAyAgAB0EUCAAQ3sgIAAWv7w
Date:   Thu, 8 Aug 2019 14:01:37 +0000
Message-ID: <AM0PR05MB4866E52B0181657A4AFCFF4DD1D70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190806141826.52712-1-parav@mellanox.com>
        <20190806141826.52712-3-parav@mellanox.com>
        <20190807112801.6b2ceb36.cohuck@redhat.com>
        <AM0PR05MB48664379F91C8FA3D0035B41D1D40@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190808102931.40c6b4ae.cohuck@redhat.com>
In-Reply-To: <20190808102931.40c6b4ae.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2401:4900:2732:6c49:c1ba:239a:884f:fc23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe681f7b-f831-4d88-f477-08d71c08ee3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5698;
x-ms-traffictypediagnostic: AM0PR05MB5698:
x-microsoft-antispam-prvs: <AM0PR05MB5698C32443F7CD4686336392D1D70@AM0PR05MB5698.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(51914003)(54534003)(13464003)(189003)(199004)(256004)(6246003)(14444005)(71190400001)(99286004)(478600001)(74316002)(6116002)(71200400001)(33656002)(6916009)(7736002)(76176011)(305945005)(7696005)(186003)(46003)(229853002)(11346002)(54906003)(2906002)(53546011)(446003)(6506007)(25786009)(476003)(486006)(14454004)(86362001)(6436002)(66556008)(66946007)(8676002)(55016002)(66446008)(64756008)(66476007)(76116006)(81156014)(316002)(4326008)(102836004)(81166006)(53936002)(9686003)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5698;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4CdoYh29Whak/l0S2sT23d4g0MyWTf8el0tLvyyMTPchR2wJLfFIoVZuTAj0w0ZqM9Z/qAaHBYO7zwiWERtj1R+294p2mCrGqr7MN43q6oN9YRdTqFUA1IW23483ZN2gLg4rUdZ3lrLENHbbbLiAby+qgHmPk4F84tFGWCqDZ867NK69TQ7U8IKpBjeS6yCMRh/S2wyr7GT9EVsKZKWpU+Jqs59D7I4+9sYnMDEdfn4tUJvHBfbJ3h6j7uHc82u+5NnR0pcYmzGbc77fKOuQ0S0k6tAf1fD/HTrjW5MuDbLenpuRWJvYdAMIkgquWR/5VOtyInJ2qSrhYKXu2rWoW5FiPKtT2csI4j2KoVhIr7cIf9nhUQc5/1vgtYLnPhEcmipItJTY2Rv/Ctr5zvFxQHctnKL6c23PRb6v1A+yM7E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe681f7b-f831-4d88-f477-08d71c08ee3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 14:01:37.7684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5698
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Thursday, August 8, 2019 2:00 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; wankhede@nvidia.com; linux-
> kernel@vger.kernel.org; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant API
> for mdev UUID
>=20
> On Wed, 7 Aug 2019 16:33:11 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Wednesday, August 7, 2019 2:58 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: kvm@vger.kernel.org; wankhede@nvidia.com; linux-
> > > kernel@vger.kernel.org; alex.williamson@redhat.com; cjia@nvidia.com
> > > Subject: Re: [PATCH v1 2/2] vfio/mdev: Removed unused and redundant
> > > API for mdev UUID
> > >
> > > On Tue,  6 Aug 2019 09:18:26 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > There is no single production driver who is interested in mdev
> > > > device uuid. Currently UUID is mainly used to derive a device name.
> > > > Additionally mdev device name is already available using core
> > > > kernel API dev_name().
> > >
> > > Well, the mdev code actually uses the uuid to check for duplicates
> > > before registration with the driver core would fail... I'd just drop
> > > the two sentences
> > Yes, it does the check. But its mainly used to derive a device name.
> > And to ensure that there are no two devices with duplicate name, it
> compares with the uuid.
> >
> > Even this 16 bytes storage is redundant.
> > Subsequently, I will submit a patch to get rid of storing this 16 bytes=
 of
> UUID too.
> > Because for duplicate name check, device name itself is pretty good
> enough.
> >
> > Since I ran out of time and rc-4 is going on, I differed the 3rd simpli=
fication
> patch.
>=20
> I'm not sure why we'd want to ditch the uuid; it's not like it is taking =
up huge
> amounts of space... and I see the device name being derived from the
> unique identifier that is the uuid, and not as the unique identifier itse=
lf.
>
Its just extra storage where ID is already present in device name.
Its redundant. Same functionality can be achieved without its storage, so i=
t's better to simplify.
Anyways, will handle it right after this two patches.

I realized that I had typo in the email of Kirti. So resending it with corr=
ected email.

> >
> > Commit message actually came from the thoughts of 3rd patch, but I see
> that without it, its not so intuitive.
> >
> > > talking about the device name, IMHO they don't really add useful
> > > information; but I'll leave that decision to the maintainers.
> > >
> > > >
> > > > Hence removed unused exported symbol.
> > > >
> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > ---
> > > > Changelog:
> > > > v0->v1:
> > > >  - Updated commit log to address comments from Cornelia
> > > > ---
> > > >  drivers/vfio/mdev/mdev_core.c | 6 ------
> > > >  include/linux/mdev.h          | 1 -
> > > >  2 files changed, 7 deletions(-)
> > >
> > > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > Thanks for the review.

