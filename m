Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56C3C7A17
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhGMX1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:27:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:43874 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236951AbhGMX1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:27:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210074379"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="210074379"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 16:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="570877220"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2021 16:24:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 16:24:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 16:24:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 16:24:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JX1Xy56vfmK5Cjuzcqo28WSEJykP8HYg7vPaHQ9Lf+iBI6aQVvLtz3iVYTS4VpTkHN35Mf47VwL3PgU5x6Gjer5lw1NIV+pAAZqYHp9ON/2iZXJ3mUR3WjGbALrXW75u4yJzjIoJVEg+tXaw6zILv7vfuFUBrNG+aQiAGFnRAzxB/FamWYcv9rqs4p8O0UAC+7iPFGZfbEbkHsHlLN4jVzPaHbkS0nWzdkCGOgWv+gi7QzlGXiX2uTFZ2NGtWtk5pjiRFjtbHrIGy3HlLmefdYtF3bcP/FJ18UwiEFmGJcLwjOIZNvsYAZ3l8njnlyorAtyaquEXm76/HmAmJocjPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hYD4QSQszhuVoJ2Dgfq8c+7EU6nqbg/zyGfKBMwgpI=;
 b=oCbiiO6YxbZde7yrAhNHuegdfep2vBsqVZvxaP+pA70IpZkBju9D1JfZ9NvN1w2+DYcIvOl0g+ldEWK0Rj5PZdVIaZuGFAEm0vdZprs/u9ML/Brfm3QQEB4dAeNEUTjFHKCtg+2jXFJPuDmjRhiU5u67EmN1pUGPQ+Ltpxjx5fY76aN9hW5zujulZr3Oa7TiNXPcQjlOpPkbKUiOvLd8yI0Ll+dtskxto895ObJSGqKKVRlzNeGK1R5lhmnGWs6q++q48Y6kmE5vcFESCjfaEdXHhbCvoTAHXiOs6eXtP3HlzVKnIwiucM1oKm5GLktCaBxX2sE0ogLWLR+FhT/Njw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hYD4QSQszhuVoJ2Dgfq8c+7EU6nqbg/zyGfKBMwgpI=;
 b=emSMvDoHLUnfn9Sfgs7roLptl3B1z8mlbv6QEmmT+GEslbbnwoZkOW5f+AX0/Av36Q0HnvRpvK1W1WzaATocgyI7UQ2jELCakJ7vz4pDwGxSikMTVgm9ZpwRbnWpBo6gUqCmnN51TyjBwfFICQYsRoObWfuuSx/aNDzdvGZJ7lQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2337.namprd11.prod.outlook.com (2603:10b6:404:92::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 23:24:45 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 23:24:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQAdcmAAAGvGIGAAJH+YAAAKpxYQABuHCIAAB18VgAAAO+iAAA0EGnAAAJwcAAAAZsfAAABJ8wAAAA+coA==
Date:   Tue, 13 Jul 2021 23:24:45 +0000
Message-ID: <BN9PR11MB543392E18CB0B7746157C3F18C149@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
 <20210713163249.GE136586@nvidia.com>
 <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210713230258.GH136586@nvidia.com>
 <BN9PR11MB54331F80DA135AF3EAD025998C149@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210713232244.GJ136586@nvidia.com>
In-Reply-To: <20210713232244.GJ136586@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e012b453-3c10-4c9a-aa58-08d9465566ae
x-ms-traffictypediagnostic: BN6PR1101MB2337:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB233753130786199BC2EE3B7D8C149@BN6PR1101MB2337.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DOQKcnooBdORQ3cSem2UgJwI6j0jzQVoFDy4DV9AAsQ2feWWtgxcro2MypjChfsplH6+HCGSrwq3s8+Wrljyu95iTaZwZRsXURVQIGD25y1rrPK8HciuCoHSZlVPds4+D7wBJMSVhwkfBjPdm9GGBcovnRxffIHBJVhB9ZaZ874SONNvNd6aAybfPm6zxcyzFHYJd3HjT4fG8WOgFAmwdd5ydcmmp+tSX2nWiAJMm9DRT9lRAEo9n6Lyl617h7iZmCvNPlD3gG6REa2cPAWNd6qn18/Pg7nT9e8FfrvpKPmaj2C882TBTVpgPvOedlGvTf6ItuRY7MmjDaUUK8najlyFnR5rnQSsQzHWLntXz2vutWq5z2VxTM5t9pzsIaOxD06kpyvkhl+3M8nvea3+wj0AGUwJAS6NRO2RQlcfzLTcKkupJpkdAOlRb5zTffatcwAadLlXZcGniBDu9Ia/kCKPQIqkyWZy2KUkSZuFnMjNzNBT8UE7GrvcPSHXExgUFOkgCwMBw5HGhqwP5duku6mX2Z0kFhz/uKe9tFPw9Q7BBCP7Ils5QnKOA0k+ByQzz0UGk5KBED7mXstpHCNwN3L/cEa2vnphnR0V2bATqBbE5rUAEyIuPEZ3xCA/pSl+8B5l5eNY77TwCaQEMzXUgjlNRX0dybFWLy2LOVo65+FpZszIAcJjm8clFqmNDCjp3RJp2aOG+q1AbLxCjtTeaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(33656002)(66556008)(66446008)(64756008)(76116006)(9686003)(54906003)(86362001)(66946007)(478600001)(5660300002)(122000001)(7696005)(4326008)(7416002)(26005)(66476007)(83380400001)(55016002)(8936002)(52536014)(186003)(71200400001)(2906002)(8676002)(316002)(6506007)(6916009)(38100700002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wti5UeM+quGj5f3ZGlXm0CgM53dvlHvCMKC24mDwbuCPl+jOxMMbKCrqKvA2?=
 =?us-ascii?Q?r4bTdGikYcKr+DBzR+mIh3/nTaZfmeRMl6Dok0xTi8AK03xgP6FLWGNWh/v/?=
 =?us-ascii?Q?DyLXckQHE6KXujwFiNaA2ZF4SYwXvCEdtxm0KCw4XZz1LqHN6/x7drtTp0Kt?=
 =?us-ascii?Q?ltwNf0Ecz3zI+tbcvudf5EfjR8fIlB2wxSECyap0eTuENyCMHIwRIaaRHxgj?=
 =?us-ascii?Q?RHSmkvzKKg2OXdCmsJoWeEvgsCyZ7mirrFI1zG+KTIIV9mrxoReJF+aBwAvi?=
 =?us-ascii?Q?08rfauoax9MpCwIyWHNrIiTYiC+ko5/BAlqunIu76tKDn/7IsE/XaUjzG+My?=
 =?us-ascii?Q?p0/wwCATQnkaB4wCvuma7d+ej9A+Wcpda/Qw6LRoYwUjVSdKv5FF1QGe306/?=
 =?us-ascii?Q?GIRDQ1Vg1EaffW3yHH6sjvr+7EvipBwBwTc1SMcAXxewzUbRQLcvw9CiXHFD?=
 =?us-ascii?Q?GIoGIzs252fu64YHRbxlnh1dAR+ySt0fZw5L2CBeUTk0xkVv1sSa/PV+bTv7?=
 =?us-ascii?Q?oYgIdILl1IEFUL9B1oOechF1Ef4450qwBV6K6oGgqfg++RcGa9qakHm6D3Ev?=
 =?us-ascii?Q?54elUIeWkEieMV6v/CNivDifY78CRUKCNk59CZgB345/Y5yrVZ7EwDyYmIuk?=
 =?us-ascii?Q?8uTdY9WTsHAN/ywUnlA8hcDLVLk9xpOHNp6OLcVsheD/Q/hRY6t4h+y1k+ej?=
 =?us-ascii?Q?HhUVUtYs694jETebjzUEvNkbJcy6/IaS1ZFdM6sSvKXiGuLgh48YI3sB5iJ2?=
 =?us-ascii?Q?qey8836KAulT6zledUgaNPW6uNg4sGYAFPK3gwWjsi/5htiLjRYHPK8ngXN8?=
 =?us-ascii?Q?jV3WXSWhE5JhtHXJqx5f0Qvio3a0lVdS+U8h12D63jFSQAMdWJLb15OXsQe1?=
 =?us-ascii?Q?Hfzb5duHBa0/gH3OWc3UuXS5MzyOAUeZ6v/PWXX4AetdwQCG34Xtg3alqhK+?=
 =?us-ascii?Q?cTZQGuopcCVLbmghjWKNCgjNUgQ/BW9l6zIKuvZQaYLbhSobLJL5vUo6+fA0?=
 =?us-ascii?Q?TVsF9WKB3DJrvi7GGrlM1Kmipc32IegxC1p/5tV8+lb+UIV3AUwmVSTsyLX7?=
 =?us-ascii?Q?4G5bKuwL/tobXAKR5a3ketdBur/zZWRA9gxczKYJnlmtT/NVmfnZzJPJoff0?=
 =?us-ascii?Q?RfhI2oBLn9GlU/vyuR4K/DUbLD7tyXdEAMkC1kDJ2EhOD4gHe3DlY6Z5KHib?=
 =?us-ascii?Q?qDuM6MtUKB/nTHlX5pb39dvgpNGKBVdFp1lF6tziyFq3F6+3w1TlCAPrktNe?=
 =?us-ascii?Q?TigBzZRvZwxWqoMBcP+JOAuhY/dIFp3pKAoI1vEEIjnAsczWwNwdWrmM+tKd?=
 =?us-ascii?Q?xx/9BrISIwakJG5EkR6GPcOf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e012b453-3c10-4c9a-aa58-08d9465566ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 23:24:45.7278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHrHr3HbP7ZZYBfNiJpPY3cNUXZe3i3Mhk3OPzXyraVkcCkYgu/g1HB81HYs25e5kFFINolSy0YA1hGV9fy/cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2337
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, July 14, 2021 7:23 AM
>=20
> On Tue, Jul 13, 2021 at 11:20:12PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, July 14, 2021 7:03 AM
> > >
> > > On Tue, Jul 13, 2021 at 10:48:38PM +0000, Tian, Kevin wrote:
> > >
> > > > We can still bind to the parent with cookie, but with
> > > > iommu_register_ sw_device() IOMMU fd knows that this binding
> doesn't
> > > > need to establish any security context via IOMMU API.
> > >
> > > AFAIK there is no reason to involve the parent PCI or other device in
> > > SW mode. The iommufd doesn't need to be aware of anything there.
> > >
> >
> > Yes. but does it makes sense to have an unified model in IOMMU fd
> > which always have a [struct device, cookie] with flags to indicate whet=
her
> > the binding/attaching should be specially handled for sw mdev? Or
> > are you suggesting that lacking of struct device is actually the indica=
tor
> > for such trick?
>=20
> I think you've veered into such micro implementation details that it
> is better to wait and see how things look.
>=20
> The important point here is that whatever physical device is under a
> SW mdev does not need to be passed to the iommufd because there is
> nothing it can do with that information.
>=20

Make sense
