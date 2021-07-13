Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466FF3C79CE
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhGMWvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:51:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:53627 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhGMWvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:51:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="232060030"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="232060030"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 15:48:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="570701491"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2021 15:48:41 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 15:48:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 15:48:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 15:48:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 15:48:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4sytzhk+zp90SLhU1yyZuXU1++KRfblUFFHI5JX1YuZPvmjFumk6VUTYe5A0rsSyl6vJ+6bDf8HvLFCL9S7hWtn+zIUOJv6TduelKGR6eabdsz1dYaK4hjkpxhi5LeoaPiD8YcXLW1tLBnSyniZSUKx1sbMP8uaxZ2uWxCmjpzNPeYa+W4pFpU5T1RWJb6YE/ywvHB0SXTre2arSds8psdw1ZYf/W0d94psfpPdrF+1sl6ILLVh5R40plf7CSf5ua/ugjgwahzerJMkaVXym5zJIZnC4X9rKyk5Cr19U/69v4bPkin7fEticNuQ5Rn3p6vPsRPD80ezag4DloyiEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rrs2zVNkrtIoJTpCfC+iXQ14LMQoKssZddPVFW4ynAs=;
 b=VM0Ih0Fxex8qUhAKSaM+dsPICayqhB64otaruVfNj1lYZbJXwagTu4sArDBHEVfP4Ls8tO23yfJowxFQ4RdelD8sM7UkrZWzdiOWB2g6KQmTpCHwq7I3RjrX65Qs0egGikLr2A3CEx1HR3em3q/kmpJib20ucUrVfi3PvscTCurY4IaNHANG2DrVxXJ75Is8zR2JaS5LZGnoC/hWWoOB+u/0VF3hm1ZNxCE5IMoX/M8AChh8yOV8gWKv9+wnGHaj3XIO4fXvnNNl7orz7LGoC5n14MRVLhMCBT6b2j3JsvbM4Y/GRMnawXIfCU2FRFYzmeGLtHaixMqn9HgkvDzp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rrs2zVNkrtIoJTpCfC+iXQ14LMQoKssZddPVFW4ynAs=;
 b=GADPAv1HLR2d0ms0P25gjX+fbjyiuuH/eMa9EAVA+zCeZ9T5zz4HdiVFiRV5HYGw22KcR+eF7Wa+a56Zel+7wZ0lxDC2rwDDlf4T+FWQErZfA0AvvR64U9Lef6RplelWSsOu+CXU1WobV91e75sK6lKXH5sTU1L0lg8SFKrflRY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5420.namprd11.prod.outlook.com (2603:10b6:408:101::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 13 Jul
 2021 22:48:38 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 22:48:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQAdcmAAAGvGIGAAJH+YAAAKpxYQABuHCIAAB18VgAAAO+iAAA0EGnA=
Date:   Tue, 13 Jul 2021 22:48:38 +0000
Message-ID: <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
 <20210713163249.GE136586@nvidia.com>
In-Reply-To: <20210713163249.GE136586@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 6790f8af-046e-467b-8afa-08d946505b1d
x-ms-traffictypediagnostic: BN9PR11MB5420:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB5420F4487AF5EF85DF683DA18C149@BN9PR11MB5420.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OCcg8bC8sD6I9bgPEVSMuX8wa7BHCvvoZtdo/d7qJMDh9TTtnh31chR3NhqgnkHEytiSwyF7PJygo/GT5NIQTCzeimAkO+yBk+gfaGU2FaC4xQKK8GBsl2/yWpEOUHvU0IqM0M4dlX3AWP4mXBA58ouCuRlIp0BTgYYjWeAU7yI1qHOvqp7YPCwcJxWYAj7V9q4PCJ/mpwqOgJ8ih1dovxiA3J90JgO6d2d9AisxmRIxXTCoke/anGGqrbM2kYg339SLx2Li6sVETmwn2kwA7/JpniQMY50KGVmLltv2aaZXg05W92ZxkPtd74van5NeHu4a8ZD3F9QCBQkoOdcOwiOxhWBE+Cq5QzUdHCjtYkyL+HImYkZ3JASoEM/TPoKU2cvHijJz2aPWrWSdfZUa3RXyxLXIhHail3F6wn1FehPBIAmehe9ZWg+4F4O3Y1Kl/LourqT65Yg35dudceuSYLqdZ6NHoEQsgqf9BZRsB2SdhhD5uMlkE1wwHLo6rttnmpk6QPR1Fg0LPApxe8rOwcOlfY72Wl3VISmyBrq8EzDRtD6W7s/VDhDQpIU0MCCT/TDrGyRpoQOgTKSFCNBtX7utI/lGG1FTdxQVVhuNVL8uH1a97qmTBuXmmA/9W821wiKjILZpP3PO5yVsvOy2jAIHHPNrXps4kuu6q0Cqz1rb26cYtgnfnCz1gah3eN3MpqSc1HoqjvwzhzT3v1z0LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(316002)(71200400001)(66446008)(64756008)(76116006)(478600001)(52536014)(186003)(110136005)(33656002)(26005)(5660300002)(54906003)(66556008)(6506007)(7696005)(66476007)(83380400001)(66946007)(8936002)(9686003)(4326008)(8676002)(38100700002)(2906002)(7416002)(86362001)(122000001)(55016002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DjLOGv85biAQfjo4qCG4s2kcVImDvYnn/F+1mDa3/dwlHNOLOFx024w7kUMY?=
 =?us-ascii?Q?6QtBER+XHBl/zXXLd+RoLAZygrsCEWRAkN1FxXGkJJOFyhHE5jjtwCtxtjDK?=
 =?us-ascii?Q?vdtsnOtzlQnBBYmTTwpDPXo6j7WlDZilCnmKmsAtOvO0juVais4i3/ro79hn?=
 =?us-ascii?Q?f7ijfht4XhkRI3RPc4ok9ex8HXxzEYmYfXd7aZNJbHtrRX5+4HLsfJX5tFhF?=
 =?us-ascii?Q?Tx9sOBIxkXpreBsdgBnjwcXzXO+OXdj4ZWvhVGuazb/QD4DXONlGExZGPncl?=
 =?us-ascii?Q?W/cfK+Ly0pJIEKiTMDhtCdi//SSfeFBR8TGamCQgSY93156Su5SRTvmSU3/X?=
 =?us-ascii?Q?N0JwsnOd+nOYNpvCdSQsMGb0iLDPx0zwJVRwoGScYeljYDdl/sC1gOUdRIUM?=
 =?us-ascii?Q?Uub1gRwfZdhU/L6MonncefgMsdr4rGEmgh8u96ne9CFP8CAu2XoK2Ah2u839?=
 =?us-ascii?Q?ZQRR1dv6sIGJTNP9vukGPTlqHhRYsgGMjtpWccZxRuOlilR3pzJdpt/8u2Eb?=
 =?us-ascii?Q?N4JAXIzWh5iUHIxWo1PNwXjB97WiY+2TrKlzwOzY/owEi/zZ+FkrvQ9Q1jg+?=
 =?us-ascii?Q?B83XpEpwA49Tf7lHLud5T7FIx4M1XjXItS10vBIrP+TIQPN5JNxh5Cm/T9qe?=
 =?us-ascii?Q?zwPF61/b4IOCJYQOen2pqCNRpZIIE6vmJOuqUL7di051obZzbHT8kly/wc6H?=
 =?us-ascii?Q?TeS4w8zjUthL5lGs8+GRFVOrIxg4BnO0TgHXXnXrBBKePOScPscP9yyGaWPP?=
 =?us-ascii?Q?6YXdSrn60DjN2ajfL06FTzUecZE00iW8wDIYrIiX6OLmx4buV5pet6ySogGM?=
 =?us-ascii?Q?pNMeodrqxdQof97rn4cggkuu/01Gjlu5FBx0mrjZFbhkzXc2gtWQua06ip2e?=
 =?us-ascii?Q?pc1oN/W2KAEggxuKuHYO9Mi49GKaDJlkphxHzJ+S0QbKXQkB45LkOQaAw1Dz?=
 =?us-ascii?Q?tWq32F1qJxIviYFaoU0FKg+TstaOu0DyJ+l9HMMVOHRj712ZMm/6wA54VWYE?=
 =?us-ascii?Q?oKRmt7GV04FLUi/LEqD/+ZD5FvsUvDQB+9kvoaju+C9hOiw7VHKiF/kqfQAD?=
 =?us-ascii?Q?Hdj4O1f7wbqfu/XtMsYwPfMXBaiY2EaspQI+Voub8oliWpLPs9r+sI8tISGF?=
 =?us-ascii?Q?NifAPYvObhpQA4QEymvyS7pLw34zh8IgzHGzWUhKmdhckH0a84+vB5cGD27g?=
 =?us-ascii?Q?tvE2kwOohOwkJLhjWNvhonXlt1VCYlTxHA+T7yxkD3tq7SJ2LlWFBWudNyFG?=
 =?us-ascii?Q?TJ5WY1ekdaq5AkFF8DVdrJWP8y+FjnAACJWnhJb7cTe2GWFaXJfVaPYfMeHw?=
 =?us-ascii?Q?A0SRfTJGdmY/KrcHW/+K8zwa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6790f8af-046e-467b-8afa-08d946505b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 22:48:38.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3wuA2yOZQVMZzFUbliVtjEI1YsUkz6JOUxQ4Vm3AiRk8AMYBAg00hhJhBPEpQfWI2Q3gMcN5s7Ch/O1sAdnxkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5420
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, July 14, 2021 12:33 AM
>=20
> On Tue, Jul 13, 2021 at 10:26:07AM -0600, Alex Williamson wrote:
> > Quoting this proposal again:
> >
> > > 1)  A successful binding call for the first device in the group creat=
es
> > >     the security context for the entire group, by:
> > >
> > >     * Verifying group viability in a similar way as VFIO does;
> > >
> > >     * Calling IOMMU-API to move the group into a block-dma state,
> > >       which makes all devices in the group attached to an block-dma
> > >       domain with an empty I/O page table;
> > >
> > >     VFIO should not allow the user to mmap the MMIO bar of the bound
> > >     device until the binding call succeeds.
> >
> > The attach step is irrelevant to my question, the bind step is where
> > the device/group gets into a secure state for device access.
>=20
> Binding is similar to attach, it will need to indicate the drivers
> intention and a SW driver will not attach to the PCI device underneath
> it.

Yes. I need to clarify this part in next version. In v1 the binding operati=
on
was purely a software operation within IOMMU fd thus there was no
intention to differentiate device types in this step. But now with v2 the
binding actually involves calling IOMMU API for devices other than sw
mdev. Then we do need similar per-type binding wrappers as defined
for attaching calls.

>=20
> > AIUI the operation of VFIO_DEVICE_BIND_IOMMU_FD looks like this:
> >
> > 	iommu_ctx =3D iommu_ctx_fdget(iommu_fd);
> >
> > 	mdev =3D mdev_from_dev(vdev->dev);
> > 	dev =3D mdev ? mdev_parent_dev(mdev) : vdev->dev;
> >
> > 	iommu_dev =3D iommu_register_device(iommu_ctx, dev, cookie);
>=20
> A default of binding to vdev->dev might turn out to be OK, but this
> needs to be an overridable op in vfio_device and the SW mdevs will
> have to do some 'iommu_register_sw_device()' and not pass in a dev at
> all.
>=20

We can still bind to the parent with cookie, but with iommu_register_
sw_device() IOMMU fd knows that this binding doesn't need to
establish any security context via IOMMU API.=20

Thanks
Kevin
