Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E60415EB9
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhIWMr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 08:47:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:16479 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241153AbhIWMrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 08:47:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="309390302"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="309390302"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 05:45:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="558342703"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 23 Sep 2021 05:45:19 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 05:45:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 05:45:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 23 Sep 2021 05:45:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 23 Sep 2021 05:45:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJcrcSNrpPx7XeBWmLLHyKRvdsCn9Qh3GtWGyJUdMpBDx7Rm+yDF9IUNAyOc/CpUJQyb5KiIuUcdROx1WOahCv/oJNZ94e9G0r0xQXw7Y2maTf9xLiWdUlbw5VIAZy91hNeXZ6bl2h7xfmLy+BQR7wNhlNdXOy9Z16ln92EWCiPGFv7OHFJNPT22h5ROMGb/kTZLbyBMk7MT9rUpnr1BXF5g9v7/593n3X0tSSgfaIxYzv9NZNo1zHOWpEDj4MIc7LWwG811ZKRH+CvCQjO7qs4iX0QNGIVZH5AoVMICUGSFqL4QwP2rYq+rnNBGfWZaL4TvgUpJRYjbOABYB2Htsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cBVlHyW9uWgXl652e79M9irmwfSEFgC4sA5bCmbwg8Q=;
 b=kMkRqyEggAsBcaTrQrmYunGDJyVS5l+1SUk2KoPfy0v8nOvH0NP3F+iF67yvcjh7qe791u16l9ZRIJl9QazJVVYItNjLhMYoSt8cOb8SA86J6kBi5LJkMdM7KxPWoa6dcx+N+twt4LvXD4xMLBxTzhbURYxKp2wYeI9W2oSmzAEvxVgUSvaJLd/z0Eyr1qDLySejb+pNepG2NrD++FjdLipSPM//O3wpC/JFeSojGF95mX98+OdelAbada0OujIa6xkpFa0qTgBGyN1Ql2nsddCHaP4cnHs4g4IUiL8mPiwmKR1cTShKIliq0+jYEZfwYPBD+LpIAENzBUBbcTyM4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBVlHyW9uWgXl652e79M9irmwfSEFgC4sA5bCmbwg8Q=;
 b=vnLj0PdDlKNWgd+2pittoCM7A/MPU1uPz6bhA9O3IczXBeuAPHGf1lnktpWsK3zM7xzKbhH87hz3+xFgEdzvlvqWKSYhOkYcTXP36ZLLtuLAW5u1Z5ZJE2E1oJgvIeYyLieOPqbuvQbYjOqZ06uyRm3AAH6BU1D/ZyzGI+4ikPU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5710.namprd11.prod.outlook.com (2603:10b6:408:14a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 12:45:17 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 12:45:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66uuxm8AgACjoWCAALKBgIABNQdAgAA7IoCAAAByIIAABmEAgAAAUDA=
Date:   Thu, 23 Sep 2021 12:45:17 +0000
Message-ID: <BN9PR11MB5433F297E3FA20DDC05020E18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923120653.GK964074@nvidia.com>
 <BN9PR11MB543309C4D55D628278B95E008CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923123118.GN964074@nvidia.com>
In-Reply-To: <20210923123118.GN964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa10499e-1396-4a0e-3f5e-08d97e8ffef2
x-ms-traffictypediagnostic: BN0PR11MB5710:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB57100D1A27BB9A7820A4D03B8CA39@BN0PR11MB5710.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/glb2DgQv1xpSwV9BY0idjMP5mh5f9OVfX1T/DNjEVp6eflWuUHWsnxFVjnxYVmuSneAD2RroN3m5k7EaWBSsjhwi7Y6PcclLDzsfIZxpLTYFSFjfqIh0v7Mn1RRZf0SLBiJ48xRrQlktNVn066JmPHI++FkeyMepJTnGnuGcNlpIapNKFao9hT342TW50XlGq3o2ZQCubI3lTkbzyebctXILNPmP5k97wR7gm5en740/cs1LrPMRSvSqrny5enjfDlYzqrjK7ilq3wnV3pc5dwcB44vqr47mj0WM7NGdTJllSI3lDKBkM6Frjwq20wwfAPpw78ci2omdnswbxMBfjS/v47Wz7Hb7yoIOj3C5ruFXO94l8zK9PxNypk4sstkkkndMTJrQD0UXZe8tp0Yti0XvKHQ7Ku4kVobt4E01LIDo3SP26O1zEC8hnhg5EIR1m6grusqQhP2H+hi+HOyNUNWoupI6HwUZD2hybbiZEbq8Dh8HaB+dGYayc29CcnM+XbRYwnbs2v8974DCTZPCsJQ9gkXWB4X8wPgB4DCTAS7FY43M0ZFZTFdbZEj0JNdw6ShD//WL29PsVcCoYF8rX0YGfUH9ZqtUFyeLOzu2D0IIgrdEnL+1u91uYXJ9LE6TFAAarhkOsxGAs+hGwzRL4NpPNhQN9C6XzvpduukGFhCh3HcFr3SfattuuJEFAiqLJ/DPbSjdJzZospIpRc3KKcEQmQQvxCFdTcsdIYx0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(84040400005)(26005)(2906002)(316002)(33656002)(5660300002)(66446008)(66946007)(508600001)(54906003)(66556008)(64756008)(8676002)(7416002)(76116006)(66476007)(83380400001)(38070700005)(6506007)(6916009)(52536014)(8936002)(186003)(9686003)(55016002)(7696005)(122000001)(4326008)(86362001)(71200400001)(38100700002)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bKEMgV0mi50ajXgiCxfRkcsfHZNb5Bmnq46zXcp00PKd9k2JeI7xMYn57sWj?=
 =?us-ascii?Q?GYCBQ3UHwISc86efuWblZF+vj0hOUMV1B3q/UVuu5te0RErlPBaRDyeO1U78?=
 =?us-ascii?Q?MzOcndr3V2fLnC5th7l5eP8d+zxfTO1Iy+HTQyPtgcUfLQSliyx26hY1rTi/?=
 =?us-ascii?Q?JA2+PwCx5JfCRFt6O+km3iYk3h1q4sIZm7b6TyJn11CYWd+D8UhIqB78798D?=
 =?us-ascii?Q?+eGbiHj/Kpoo8MekEluUVHcdTFGdMiiCqnsq2GLIa7UuRGLSn8pQ/BOIQOjS?=
 =?us-ascii?Q?1S4Y8pLEeYtOcMB59qOSzldATo0Jba00kpzMpr4c6C9wbmnI3Pel9r0aoi0J?=
 =?us-ascii?Q?l8+9Ha/tlkX+hoHVudLNBQc6K3F4teJY4LB0cqDr7s0znKcAjQnX82D2LZjY?=
 =?us-ascii?Q?jU4K6BO89+yaRp1dvQJPLLztL3/C5D00BFzkmOJQipp47nvCdmI2mRhB5eHy?=
 =?us-ascii?Q?kvK3d43HJ4+HyqWxU8ljfM/ICv1FBDidxD67Sgb7LBz7Q5b2QFSbq22KSZcP?=
 =?us-ascii?Q?EzuR3lj6W6BWj6Sf/cFFx9vYKDEuTsFIZ63Qn4+DrdRGVWVtKMWTxZNEr+yW?=
 =?us-ascii?Q?6Koa83eCcmy4/Vbdk2NnywS71VEea4kJbYI8pnp5Hvtkwb/B5NKlKBDdImKZ?=
 =?us-ascii?Q?AVDdSvBZ+ph/g5YwA4rntF+qzefh+/wrsLVIEIlo+uM0ekrSNk8Wq4yNwbEp?=
 =?us-ascii?Q?+eJanJzIOv/aGURiZBjyXpuu0RcEu5OLjzSntc/5GjnOCoeBT/0UBcqcvMKr?=
 =?us-ascii?Q?qTjtdD7SvIwXuZHL2b/JkxIJDzCEj/x3uty3Lm8CKqPi2gqQ/LDd9VoaFzq+?=
 =?us-ascii?Q?Tou9ir/YqhA/8LvApzC//+hS4zye2kGMb9HDVwBI0lSg3MNWV9AE2yHph81S?=
 =?us-ascii?Q?OjQDIDI5wV6gkm0kqu7qaqI85jvJfVrK3OHRGCWY1q7QcKAzN5c/qbxoWs0l?=
 =?us-ascii?Q?iUyUNlPC2Lr+AHNktdmDk4j/U0df5p8w6Ds7yVeo45FAyoWz94HtApC5xFAV?=
 =?us-ascii?Q?7BXzQtzQUUGz8IDlKTcQLd0Rz5RlY2ECIpRDXYJtTOp/YMr1PaM4PGf28GoE?=
 =?us-ascii?Q?GP/+YGpEoOkSrkjSa/xj5ycIBsuMKMN4juP0X9JFuPNCK/be0ypGI9Ph6y3x?=
 =?us-ascii?Q?AYFy8p/gnlXBQRxrRVWUuXpU6ZSL/uYgEyaD4lZ9yV5PUUvII0W+XTpGqNzu?=
 =?us-ascii?Q?VLsukX5Z/aYGMHfrJ55/3in73i5+CBOrSG9258s1mUaOTPNdzEeb3VrbXAYW?=
 =?us-ascii?Q?vV0eVN74j8zpoDwni55MNj6NOcjZitw9E/x8XE7kxUK7amiaeYOpxcn2KpSc?=
 =?us-ascii?Q?IZAYlNc6irHH3pef7vUHIg2+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa10499e-1396-4a0e-3f5e-08d97e8ffef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 12:45:17.0595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RkQR1wh/4wSJiPbIRYsUEXqe5Db/Eh05nmF39yT1nAd4lRVBSmwKRBmEqsKVQFVlVfI9Xm8MSOWuZvEBy+QYEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5710
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 23, 2021 8:31 PM
>=20
> On Thu, Sep 23, 2021 at 12:22:23PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, September 23, 2021 8:07 PM
> > >
> > > On Thu, Sep 23, 2021 at 09:14:58AM +0000, Tian, Kevin wrote:
> > >
> > > > currently the type is aimed to differentiate three usages:
> > > >
> > > > - kernel-managed I/O page table
> > > > - user-managed I/O page table
> > > > - shared I/O page table (e.g. with mm, or ept)
> > >
> > > Creating a shared ios is something that should probably be a differen=
t
> > > command.
> >
> > why? I didn't understand the criteria here...
>=20
> I suspect the input args will be very different, no?

yes, but can't the structure be extended to incorporate it?=20

>=20
> > > > we can remove 'type', but is FORMAT_KENREL/USER/SHARED a good
> > > > indicator? their difference is not about format.
> > >
> > > Format should be
> > >
> > > FORMAT_KERNEL/FORMAT_INTEL_PTE_V1/FORMAT_INTEL_PTE_V2/etc
> >
> > INTEL_PTE_V1/V2 are formats. Why is kernel-managed called a format?
>=20
> So long as we are using structs we need to have values then the field
> isn't being used. FORMAT_KERNEL is a reasonable value to have when we
> are not creating a userspace page table.
>=20
> Alternatively a userspace page table could have a different API

I don't know. Your comments really confused me on what's the right
way to design the uAPI. If you still remember, the original v1 proposal
introduced different uAPIs for kernel/user-managed cases. Then you
recommended to consolidate everything related to ioas in one allocation
command.

Can you help articulate the criteria first?

>=20
> > yes, the user can query the permitted range using DEVICE_GET_INFO.
> > But in the end if the user wants two separate regions, I'm afraid that
> > the underlying iommu driver wants to know the exact info. iirc PPC
> > has one global system address space shared by all devices. It is possib=
le
> > that the user may want to claim range-A and range-C, with range-B
> > in-between but claimed by another user. Then simply using one hint
> > range [A-lowend, C-highend] might not work.
>=20
> I don't know, that sounds strange.. In any event hint is a hint, it
> can be ignored, the only information the kernel needs to extract is
> low/high bank?

iirc Dave said that the user needs to claim a range explicitly. 'claim'
sounds not a hint to me. Possibly it's time for Dave to chime in.=20

>=20
> > yes PPC can use different format, but I didn't understand why it is
> > related user-managed page table which further requires nesting. sound
> > disconnected topics here...
>=20
> It is just a way to feed through more information if we get stuck
> someday.

You mean that we should define uAPI for all future possible extensions
now to minimize the frequency of changing it?

>=20
> > > ARM *does* need PASID! PASID is the label of the DMA on the PCI bus,
> > > and it MUST be exposed in that format to be programmed into the PCI
> > > device itself.
> >
> > In the entire discussion in previous design RFC, I kept an impression t=
hat
> > ARM-equivalent PASID is called SSID. If we can use PASID as a general
> > term in iommufd context, definitely it's much better!
>=20
> SSID is inside the chip and part of the IOMMU. PASID is part of the
> PCI spec.
>=20
> iommufd should keep these things distinct.
>=20
> If we are talking about a PCI TLP then the name to use is PASID.

If Jean doesn't object...

>=20
> > > All of this should be able to support a userspace, like DPDK, creatin=
g
> > > a PASID on its own without any special VFIO drivers.
> > >
> > > - Open iommufd
> > > - Attach the vfio device FD
> > > - Request a PASID device id
> > > - Create an ios against the pasid device id
> > > - Query the ios for the PCI PASID #
> > > - Program the HW to issue TLPs with the PASID
> >
> > this all makes me very confused, and completely different from what
> > we agreed in previous v2 design proposal:
> >
> > - open iommufd
> > - create an ioas
> > - attach vfio device to ioasid, with vPASID info
> > 	* vfio converts vPASID to pPASID and then call
> iommufd_device_attach_ioasid()
> > 	* the latter then installs ioas to the IOMMU with RID/PASID
>=20
> This was your flow for mdev's, I've always been talking about wanting
> to see this supported for all use cases, including physical PCI
> devices w/ PASID support.

this is not a flow for mdev. It's also required for pdev on Intel platform,
because the pasid table is in HPA space thus must be managed by host=20
kernel. Even no translation we still need the user to provide the pasid inf=
o.

>=20
> A normal vfio_pci userspace should be able to create PASIDs unrelated
> to the mdev stuff.
>=20
> > > AFAICT I think it is the former in the Intel scheme as the "vPASID" i=
s
> > > really about presenting a consistent IOMMU handle to the guest across
> > > migration, it is not the value that shows up on the PCI bus.
> >
> > It's the former. But vfio driver needs to maintain vPASID->pPASID
> > translation in the mediation path, since what guest programs is vPASID.
>=20
> The pPASID definately is a PASID as it goes out on the PCIe wire
>=20
> Suggest you come up with a more general name for vPASID?
>=20

as explained earlier, on Intel platform the user always needs to provide=20
a PASID in the attaching call. whether it's directly used (for pdev)
or translated (for mdev) is the underlying driver thing. From kernel
p.o.v, since this PASID is provided by the user, it's fine to call it vPASI=
D
in the uAPI.

Thanks
Kevin
