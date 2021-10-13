Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EBA42B843
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbhJMHDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:03:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:33593 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhJMHDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 03:03:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227323353"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="227323353"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="460671542"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 13 Oct 2021 00:01:00 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:01:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 00:01:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 00:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbc84q21I5wPARsIo8l4Wm8HTFQo7GuF1Lnoy3rGDdIPY7o3tcNNEIbjxEcXIVT9CZpQkNufCPZeqZE0bd/IOGe8TpKgiNjajCq81gu6rnzx/zXA4sbVYW2FIL/bv0sn74h4SZNmad+tyG/6bPMEsiUqJ/T7cqV7wEbkrmbtNuOdAqGA9xz8qPAUQL4cRJ4DW3GU53yNm2/SIooZSv8tXdwtDQU68XvED5u/oIkAspS6304bCTbou8Mk2wUUwExNvZIDDR8+uBIbVYVlfpNz3EmzVvdRxRVXeRM8BgzrfeqlQ644mBLZbfcJHzyvGMaFHlY+0dSqH9Fsh6Z6lmKmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JW+2NMQNKskhvkuP73CI9j53M4KPMxy+IfhzO57ZngM=;
 b=Q9cAf/rZNmh+oNYxbd0W9TNsO9cGQUDUKthY79yllUbgpjGGIgrYWZz/66wZpkKAqchZMe0IDIxf945kEHudycTFEblubo0ARZB3G1e74KblpvJcUN05VDOJJ7oDdzAL7Co0JnF7lZbb1sZ3e/8ARAD87s7hRuKtaNUxnf8ITmoYZADm28bFi1nCL56G3aDvYJbGQexT3IkWKswEnyJOm58jMniHimA1FMctFkxO5scNPKaHiCG7C7czUeQSKNvK8kZYSB/pN6+o8duakVHOmgFs07xHCjW7k/H0Sq/rS7Q101+AKI3KM1JcU4xh5vnuP2qJVc+3PQH/YAWeDHVZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW+2NMQNKskhvkuP73CI9j53M4KPMxy+IfhzO57ZngM=;
 b=X6ccnEJudGDqhCO9btSX95dth5CiYJkmYas/g0q2oEodOtMZK9oCdEH4/k9qfuiE8gwOPpSKQi2jLhNpnVqf4u3pycNv9f21C4JFuR3y2VwCX8fI/B2FeqtrLNkcM7tuHkBHnHP0efBFmT5TRgnRyYTRhnO7QrPKmGQM+ugG8NY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2083.namprd11.prod.outlook.com (2603:10b6:405:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 07:00:58 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 07:00:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66u9vAMAgBLi5DA=
Date:   Wed, 13 Oct 2021 07:00:58 +0000
Message-ID: <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com> <YVamgnMzuv3TCQiX@yekko>
In-Reply-To: <YVamgnMzuv3TCQiX@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47aafb7e-c2fc-47bf-47f3-08d98e173597
x-ms-traffictypediagnostic: BN6PR1101MB2083:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB20837AD3C080EAD0C4B7F37D8CB79@BN6PR1101MB2083.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hVVPTUD72EBspZF9CZPjvlODpxytdmV4Aek9UKTV/l6+U8m2hr/zz6xHHVBaAY/TJ0Ll0GhMrgnlyVPJhjIpkL2vblx0R7j4SqzzcY8NG/qdJM4v3VTvfzcV98fmWEa1ZdUZUQVhhpmLnQfObiIdyiIxCtnKl1vTYX5WmMDBFmn7Cubt4ptieb9Y1S1gXcsihHyN3McZXJ8jKCVA4L55vEFvouTHhuZ1DGVdTVeZtr4nOspzLQqtlNi9REJgauZlv1O5Sx/DlQS1i/78g87q34Zh73NZDIam6yDa3cROvI5YkbWV0jSIedzOeTD0LGBUGfY7liBY1gBKOQI8bX9DWJ/ahowFFRFg2xr5vvWYMbok/LxweOxQ6bd11e+03NEH/7y2daJIOOCQh33+f6LWLTIYzg/Yr3jCgEBUiIkW0pNUHS4w2CxqifsCkvVK0wdwd4/6jYAM8up+UBF4OXVTeM6dxb1Nmx4W+ZiM+47Bi/DubwCKZ2ZOZrT5q7FO/o0O+Y+RoZE6CAHTVX4SbIytumrNFInjr6rrZ+AGv+EJH4nS8EuJ6vZLJsLlxCQWYnjzdcf18tnvod8LiokWlTkQ7WdVR6HiO0mWBZB+Lq5LudZvz/Z8At/DR46R3HCmQ1jgwUR+yWFMQui3Q3zgy3vtmeYXXLRxT0Kh6H3ZUTnEmYnf2urkNycZVwt1a2JztGbPb+EPayRrAelXSCtbRXXhDJb6S2mZ75Nidi884LcTd1Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(83380400001)(8936002)(8676002)(5660300002)(26005)(7416002)(4326008)(6636002)(2906002)(122000001)(33656002)(186003)(52536014)(38100700002)(7696005)(86362001)(76116006)(38070700005)(66946007)(64756008)(66556008)(55016002)(66476007)(71200400001)(54906003)(9686003)(110136005)(66446008)(316002)(82960400001)(508600001)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3DEK3PFPGsKawMVkQahLGtGUTsx46P6C6J1NdXAjxGwc9XgN+IWzXezFvYvi?=
 =?us-ascii?Q?gHAn9sFXxIQIhKbxQvVjqA2OYR0sIDcq9rBkWGDhcOATKvP153WXgswBkzCc?=
 =?us-ascii?Q?FKAsFos1979zrKfMO65QnoVJF4AbN5Z9SBFC+SnY1EM3V987Zem2qYP8C/gO?=
 =?us-ascii?Q?uwJAqcJWKjuSFI5wsuylP92xs4xOPA64B2t7eMMVtML+4N1icgldl4z8JUit?=
 =?us-ascii?Q?7r7xstdamX7zO5aB6Su7A5JSP1Gk2x41E0fzPv7zeIUWSK02paN8x/bdwStT?=
 =?us-ascii?Q?o+L1Ynzd9tTfmidStSXj5DFtAcklyIlaSP3RUtM5uUmp9lNhphs6UxPbRZM1?=
 =?us-ascii?Q?fOA7Kdq2SRVJKUW4wK0KIrVY5TtvhGAB5xmh2vKzCTIxmQPpeAG+BR1ZJisa?=
 =?us-ascii?Q?RF1k9TPtvbgo6+VyPl04ndDUAo/pKRU/idJhHaj9b0iu0cGI6vh3pkBp1VKt?=
 =?us-ascii?Q?vHkyI32hwlOS8vltWD19oOrOJs2yKev2zLZFWxTyP+ObeQCBVNLr3NIDhwk6?=
 =?us-ascii?Q?87E1HrkPcKAp7NILxIEpmNZnqKxOH04I0jW5lFIho9tcDLvGpbkPRf5sTbcU?=
 =?us-ascii?Q?DMZqjXFXTFpGeQaT8tYGoI+drKYNBmHDa+DWudlIrpy3yaq8qksTYqSCQypU?=
 =?us-ascii?Q?Ce2TkHRx542Ck9k6XXCunbBYjzzrkkj+eejdkMctU8qwKviX0joHiiTlka8Q?=
 =?us-ascii?Q?EF5F/BQ3IjTvNtgaZrYX45hBosG0YHxNK9Ku2u9xiJGb+uBhI1YSFdo2UY9I?=
 =?us-ascii?Q?39XZO465TbZ0jgQjW1rI8DVpdOtiP3FFsUYlXExUfJABLNvGKYBWYedY1jB6?=
 =?us-ascii?Q?Oo7ql7MDsiYqo1uyOrX8ufJljkDgRRnHZX8mxG6Z7HQCv+9AVVjumb6rsDhm?=
 =?us-ascii?Q?31kNbf9WuzOmsSHQTaGFoE5evwCc94fVis1qP+PuuKH+ZT9a4YdOMQH7BPWH?=
 =?us-ascii?Q?KYhONUiurVH50h/7jwMeFaUCm0gyp9CdjaiG6HHggFcwqta3edZ573co+/f3?=
 =?us-ascii?Q?eSQchmg+SVbwTjxR8nyBdsPZynglRLk97xE3tA5PLGmoEiFJq7Ru2MpG/GDF?=
 =?us-ascii?Q?hBbYtoW89NJHdhcBUDGA65HedTTx0mMcOHJlQLChXL0lbSAzzmabppTq6+9k?=
 =?us-ascii?Q?QkM1oVLtvpGrd/77oIao6ZF3ZRJXXiqh4wDI2ft38Vp5RwnQlRylFWtMHdqJ?=
 =?us-ascii?Q?kueoljmoVESF6kW3nX3xuo+1rG6lvoHW0hlqsk7ZiYO4XZzB0Fpoj5DxYPnP?=
 =?us-ascii?Q?3begKWueTQkREwJpJXCK4UtGMztv2P/eGMyeZ9rcmU+xTpNYt9Z+KWm0rBo4?=
 =?us-ascii?Q?AzAXcxAYxls/V+Upe+qqoQ2B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47aafb7e-c2fc-47bf-47f3-08d98e173597
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 07:00:58.3119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gbNLME2hSi5SBg+5g6mHNYmZzpiPTMrtFy+lqTEzo3mKmwZBuT3Z/SVRjqax0Ur4E+5bO+bVXdX5gZLyXZkag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2083
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Friday, October 1, 2021 2:11 PM
>=20
> On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > This patch adds IOASID allocation/free interface per iommufd. When
> > allocating an IOASID, userspace is expected to specify the type and
> > format information for the target I/O page table.
> >
> > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > semantics. For this type the user should specify the addr_width of
> > the I/O address space and whether the I/O page table is created in
> > an iommu enfore_snoop format. enforce_snoop must be true at this point,
> > as the false setting requires additional contract with KVM on handling
> > WBINVD emulation, which can be added later.
> >
> > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > for what formats can be specified when allocating an IOASID.
> >
> > Open:
> > - Devices on PPC platform currently use a different iommu driver in vfi=
o.
> >   Per previous discussion they can also use vfio type1v2 as long as the=
re
> >   is a way to claim a specific iova range from a system-wide address sp=
ace.
> >   This requirement doesn't sound PPC specific, as addr_width for pci
> devices
> >   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn=
't
> >   adopted this design yet. We hope to have formal alignment in v1
> discussion
> >   and then decide how to incorporate it in v2.
>=20
> Ok, there are several things we need for ppc.  None of which are
> inherently ppc specific and some of which will I think be useful for
> most platforms.  So, starting from most general to most specific
> here's basically what's needed:
>=20
> 1. We need to represent the fact that the IOMMU can only translate
>    *some* IOVAs, not a full 64-bit range.  You have the addr_width
>    already, but I'm entirely sure if the translatable range on ppc
>    (or other platforms) is always a power-of-2 size.  It usually will
>    be, of course, but I'm not sure that's a hard requirement.  So
>    using a size/max rather than just a number of bits might be safer.
>=20
>    I think basically every platform will need this.  Most platforms
>    don't actually implement full 64-bit translation in any case, but
>    rather some smaller number of bits that fits their page table
>    format.
>=20
> 2. The translatable range of IOVAs may not begin at 0.  So we need to
>    advertise to userspace what the base address is, as well as the
>    size.  POWER's main IOVA range begins at 2^59 (at least on the
>    models I know about).
>=20
>    I think a number of platforms are likely to want this, though I
>    couldn't name them apart from POWER.  Putting the translated IOVA
>    window at some huge address is a pretty obvious approach to making
>    an IOMMU which can translate a wide address range without colliding
>    with any legacy PCI addresses down low (the IOMMU can check if this
>    transaction is for it by just looking at some high bits in the
>    address).
>=20
> 3. There might be multiple translatable ranges.  So, on POWER the
>    IOMMU can typically translate IOVAs from 0..2GiB, and also from
>    2^59..2^59+<RAM size>.  The two ranges have completely separate IO
>    page tables, with (usually) different layouts.  (The low range will
>    nearly always be a single-level page table with 4kiB or 64kiB
>    entries, the high one will be multiple levels depending on the size
>    of the range and pagesize).
>=20
>    This may be less common, but I suspect POWER won't be the only
>    platform to do something like this.  As above, using a high range
>    is a pretty obvious approach, but clearly won't handle older
>    devices which can't do 64-bit DMA.  So adding a smaller range for
>    those devices is again a pretty obvious solution.  Any platform
>    with an "IO hole" can be treated as having two ranges, one below
>    the hole and one above it (although in that case they may well not
>    have separate page tables

1-3 are common on all platforms with fixed reserved ranges. Current
vfio already reports permitted iova ranges to user via VFIO_IOMMU_
TYPE1_INFO_CAP_IOVA_RANGE and the user is expected to construct
maps only in those ranges. iommufd can follow the same logic for the
baseline uAPI.

For above cases a [base, max] hint can be provided by the user per
Jason's recommendation. It is a hint as no additional restriction is
imposed, since the kernel only cares about no violation on permitted
ranges that it reports to the user. Underlying iommu driver may use=20
this hint to optimize e.g. deciding how many levels are used for
the kernel-managed page table according to max addr.

>=20
> 4. The translatable ranges might not be fixed.  On ppc that 0..2GiB
>    and 2^59..whatever ranges are kernel conventions, not specified by
>    the hardware or firmware.  When running as a guest (which is the
>    normal case on POWER), there are explicit hypercalls for
>    configuring the allowed IOVA windows (along with pagesize, number
>    of levels etc.).  At the moment it is fixed in hardware that there
>    are only 2 windows, one starting at 0 and one at 2^59 but there's
>    no inherent reason those couldn't also be configurable.

If ppc iommu driver needs to configure hardware according to the=20
specified ranges, then it requires more than a hint thus better be
conveyed via ppc specific cmd as Jason suggested.

>=20
>    This will probably be rarer, but I wouldn't be surprised if it
>    appears on another platform.  If you were designing an IOMMU ASIC
>    for use in a variety of platforms, making the base address and size
>    of the translatable range(s) configurable in registers would make
>    sense.
>=20
>=20
> Now, for (3) and (4), representing lists of windows explicitly in
> ioctl()s is likely to be pretty ugly.  We might be able to avoid that,
> for at least some of the interfaces, by using the nested IOAS stuff.
> One way or another, though, the IOASes which are actually attached to
> devices need to represent both windows.
>=20
> e.g.
> Create a "top-level" IOAS <A> representing the device's view.  This
> would be either TYPE_KERNEL or maybe a special type.  Into that you'd
> make just two iomappings one for each of the translation windows,
> pointing to IOASes <B> and <C>.  IOAS <B> and <C> would have a single
> window, and would represent the IO page tables for each of the
> translation windows.  These could be either TYPE_KERNEL or (say)
> TYPE_POWER_TCE for a user managed table.  Well.. in theory, anyway.
> The way paravirtualization on POWER is done might mean user managed
> tables aren't really possible for other reasons, but that's not
> relevant here.
>=20
> The next problem here is that we don't want userspace to have to do
> different things for POWER, at least not for the easy case of a
> userspace driver that just wants a chunk of IOVA space and doesn't
> really care where it is.
>=20
> In general I think the right approach to handle that is to
> de-emphasize "info" or "query" interfaces.  We'll probably still need
> some for debugging and edge cases, but in the normal case userspace
> should just specify what it *needs* and (ideally) no more with
> optional hints, and the kernel will either supply that or fail.
>=20
> e.g. A simple userspace driver would simply say "I need an IOAS with
> at least 1GiB of IOVA space" and the kernel says "Ok, you can use
> 2^59..2^59+2GiB".  qemu, emulating the POWER vIOMMU might say "I need
> an IOAS with translatable addresses from 0..2GiB with 4kiB page size
> and from 2^59..2^59+1TiB with 64kiB page size" and the kernel would
> either say "ok", or "I can't do that".
>=20

This doesn't work for other platforms, which don't have vIOMMU=20
mandatory as on ppc. For those platforms, the initial address space
is GPA (for vm case) and Qemu needs to mark those GPA holes as=20
reserved in firmware structure. I don't think anyone wants a tedious
try-and-fail process to figure out how many holes exists in a 64bit
address space...

Thanks
Kevin
