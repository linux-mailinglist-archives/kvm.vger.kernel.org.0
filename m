Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C4843589C
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 04:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhJUC2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 22:28:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:49635 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhJUC2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 22:28:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="216093621"
X-IronPort-AV: E=Sophos;i="5.87,168,1631602800"; 
   d="scan'208";a="216093621"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 19:26:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,168,1631602800"; 
   d="scan'208";a="527301484"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2021 19:26:04 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 20 Oct 2021 19:26:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 20 Oct 2021 19:26:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 20 Oct 2021 19:26:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtzkpmoYfJ3h6RCCyFddEygn0GeWrXUs7aeL88ATfc1RUBgbzcnwA5GIaQdq0kn6BbJ8fU9moK1dEfFL0/8/yZcjoQEJSZqWtrrQRhn7hMuEVVFyjLb3z9JwRZmGzk0aJ9YqO91fKYKwp9h+kYyViJw4LO7wPAASPgbT1EwEh2HdKz1pfMztmLntpKyZxkY3v1TmJ+OzOcyPFcdkA+3yfLSLLMMgXIzYDSvpG7EiEVC9sj8teWNp6D2X+BpW6M79wIwYn6TTdVg8MUSbJr97hkLla4lTiFROiBI9X9EE5Lor8FiJgP/Kl3eDG54dayue9ttgfqW/FiW0dIJ4QEYHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3Bm1s+6Siff5mQPSjKKCBHbXI2uS0sVC36rhrqBJiw=;
 b=NQhqGAIkvIHPo+4J6L2WRJWi+FNOhHY99manI368qcnWDFhRZWUzFS5HFr2JYKrwWKU/mlBQ4Ki64pMur6l0vfKB/Ly6Vu2c+oU8vNjQ3SoLqYrkqWwSqwGyA/rCDc8oFDlYxo04IOmaLo9zNz0C/X3EFV2046btwI3Qwf0AGF+yP0PfTDQVfSfhf6D9jhaMyJnqz6N5i2Vj1pSwcE6sWaLX/7UINtTWFfigilon9Syw5k3MWgnQDmY6337NFo8uIGxD2LQirpPjJ4XW8P2+ZC1Yc3L/Frdb9jAKdgtJHRTfcZJEDvTOwSOSeylFSEO8a/KBvEA1/P/+7pjrK3GDvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3Bm1s+6Siff5mQPSjKKCBHbXI2uS0sVC36rhrqBJiw=;
 b=JoSOWldV2nLc2r/5XDozNNfCcPRK5UDDuJH+PSW3b1i+YD6TvKjNkh26d6WjQKLxGHPZZK+q0IBmlU1oY8TBufmbD283VRBhnSn1LBmwrZgCV9DLO9YIn6ir/TWpMSJKPUaCJuJ8U3A8uzeOXKSst+A9MgiKnIXJYFhKdhXKtKw=
Received: from BL1PR11MB5429.namprd11.prod.outlook.com (2603:10b6:208:30b::13)
 by BL0PR11MB3410.namprd11.prod.outlook.com (2603:10b6:208:33::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 02:26:00 +0000
Received: from BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::9061:212b:2fb5:41d0]) by BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::9061:212b:2fb5:41d0%9]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 02:26:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAEL4QgACKr4CACtdfoIAA3DaAgBUX8GCAAHivgIAAl4FggAl6ZNA=
Date:   Thu, 21 Oct 2021 02:26:00 +0000
Message-ID: <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 073e6cff-0b5a-4b6a-11d7-08d9943a1f82
x-ms-traffictypediagnostic: BL0PR11MB3410:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3410AD8A91795729662D455D8CBF9@BL0PR11MB3410.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cAIPOiaInDILLiUshqlPP9CiuFP57beWIIDyzoQzsoQmUcBSR/snULpReru1XoHmQxjWzXT3vENkeH33J4mfJbHIQp4TQQpHJ3HBGT4caud0vkCQJP7zXqub43Wh4I12Zd6OCo6EuA2pAcnsV5IzGyeNkjpZtHX2nNexuSEUMznN/SjuItk99ESEJNIWbSikzmtoRBo9WuZ1xka/juc8RvrhwM/i7vo0YVHTGbCY92zjj0egWLASVWyB9D6PeyxpZpMs70Llc5tLZ6ZZVt4viRnEoCKago9qQuDfg/naOveVALsXTSTPGPh8s03v/qzQqW/QwJMXWRkePQo0lKb5Yv9L3Dm1JJMKBNwi0lEr8ZjfvrWoiNk0y9Ogmt+HDmwEJg2q8hpdKHLyZS3l2N2iCDfa/De6Sf7JDz5eNt603mSQjMrTq1HNEKMd0VLPqfYkf7Bynu6dU4Uw2S0yI68L4DuBmTKSthcE7BC8+jPrl0qLRsv0gBL9rPGNHSiirFmREPxvyxDFjy1TM/VohrVlral0cg5LJnBlvsYGPrA+F7jhC2Sds9uc2qQvOUp3roxgbWBOu5apS6zozGkAy+xi2Orqn4I5kMa9aJ+FzUEAIbb/hbJ2kli4uUUZQvTsZxFa+9thstNCqZYsebqg5207vcP4/RtMz4vkMI54HOgaku4QVZH8tG/Xafn8VaELB9FrqiNmhDqX5u8pVO/tz8hqzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(76116006)(66556008)(83380400001)(55016002)(9686003)(66476007)(86362001)(8936002)(2906002)(5660300002)(64756008)(38070700005)(4326008)(82960400001)(66446008)(186003)(54906003)(52536014)(71200400001)(6916009)(26005)(122000001)(8676002)(38100700002)(508600001)(316002)(6506007)(7416002)(7696005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Mqu3H7EoYdEdVOB7+ZZWM4NzTUY2FTjHuL2tj/Nh0ILmhl7AF1nDkJDyn64?=
 =?us-ascii?Q?2ry3DacEFIWj6wc+cXmgkCgtB0Dbz4ABx5yrP8w7uYeog8TswoEJAyEyoUZB?=
 =?us-ascii?Q?RUBbov34LuPiAAz0tjWM7xW4AQBsJ6biXtTb5UHskbijQkRo1r+6MBQCjI6I?=
 =?us-ascii?Q?7t+rCFtQ4wQIV4uLwEJ10L8KquboxNOz2/dkY9JW3b3J/ICbpimE8270d2nw?=
 =?us-ascii?Q?yODm7elv94aLj8J5fmXNfVla0FRb2NMuGOryBRXo4Coz6uCneN3NGkACEaib?=
 =?us-ascii?Q?Koh/sHv8e0ixSxoXFZUEn9JkeYpQT+JiV/IDePlN9RLTSdOKKJHdmBrOQKDI?=
 =?us-ascii?Q?fomR8uRAjtpwGQ+N+DC28l6+dxHQwTlfbYDXKo6wLxQ5OSKk3D7a8NoaKf9b?=
 =?us-ascii?Q?EzvkRP6vtI44Yij9smJXdW7slHlJchJFSSFSDhDHny4w812Pk3b6A54g4qgZ?=
 =?us-ascii?Q?NbBEO9e7szQDZXQOG/UBcdl/mfSIc1JWAWWfUOqxDok0L6NxUjAFpEtSliOc?=
 =?us-ascii?Q?bMDYJTN4UqiVr9Eo7X6mlt1ufNJbS0JN6czhrDZElJETv6Yq7M1n7KdwsjWS?=
 =?us-ascii?Q?Qz52qbbgSiwjaXVKGkkR3Y+xXBROAOVfowwcFLD2z8+S/VdG0pSoPc9sfzfh?=
 =?us-ascii?Q?xsIKzAWbZJdUC1ndan/60JtXvH+e+zoNU5gxVZsJb42qDfj4w4T+LlBHwmSI?=
 =?us-ascii?Q?uhGr2F9t35G69+B8k1s2DaWa99L2Ix77PtcTL1KXZLQZlmAr0FGWWzD7iLdF?=
 =?us-ascii?Q?+hNe37EGCXUsPaJFcjaPKxv42uNWiRD+AJZ1224kalrd8IL7trqvi0lc6+8A?=
 =?us-ascii?Q?ZcqM/Xonk4i6oXklxJo+6I7MW6WUkXjNpbUu7QsoErH3/1uY0B5MhsPzBEf6?=
 =?us-ascii?Q?4wa0IS5zo/0LOKE4m/5DdUnjd1GRwRQVCME1lv6Lq12kkxR3u3DBRy4jyu86?=
 =?us-ascii?Q?7tEsO4G8IaaRC0KH1mdDaDOfvO5fwaITvyEnnxdQVCpL6gE32xsDdrU3U/nR?=
 =?us-ascii?Q?4wfUm4Ckg215ibAJaq57L3dVRomDcDXgFsIUXXEhMN9iMgRKuBuofB1u52ZJ?=
 =?us-ascii?Q?SI7U6MmKC7TK14MyVjBmHkyBevRnii/57iXIZZcgSzW4t3cx5ww3F4H/2CRE?=
 =?us-ascii?Q?98ff2NVXnvIR0cUU/rKQv+oun82f95vhnAyZvdpQNjhfybePTwjOFpu+o65l?=
 =?us-ascii?Q?4STsgDTvXRJrUDkpsnmvCE8Scm1ArOJHV5vN7h4/6NhKi6QdV1qZEAPm1MYD?=
 =?us-ascii?Q?L0fzdKv7isW2zTIXo7RI3TH7zee3Yt9+Q2MEHLYmKfmaPXSf9NC8BZtlVjwR?=
 =?us-ascii?Q?rukAz/lcx6aAs5BXYxrSW31u5+nSlSpgKrmcWXgRB54OXgDZFtaCQG3Ao6mn?=
 =?us-ascii?Q?3rUbR8Y+IpLa7qsaOkhNrXBY96X2dmhr5ETztYezI0TwyErLD0RnFiHm9k4D?=
 =?us-ascii?Q?WYk9bNaRZqA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073e6cff-0b5a-4b6a-11d7-08d9943a1f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 02:26:00.4201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin.tian@intel.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3410
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Friday, October 15, 2021 9:02 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, October 14, 2021 11:43 PM
> >
> > > > > I think the key is whether other archs allow driver to decide DMA
> > > > > coherency and indirectly the underlying I/O page table format.
> > > > > If yes, then I don't see a reason why such decision should not be
> > > > > given to userspace for passthrough case.
> > > >
> > > > The choice all comes down to if the other arches have cache
> > > > maintenance instructions in the VM that *don't work*
> > >
> > > Looks vfio always sets IOMMU_CACHE on all platforms as long as
> > > iommu supports it (true on all platforms except intel iommu which
> > > is dedicated for GPU):
> > >
> > > vfio_iommu_type1_attach_group()
> > > {
> > > 	...
> > > 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > > 		domain->prot |=3D IOMMU_CACHE;
> > > 	...
> > > }
> > >
> > > Should above be set according to whether a device is coherent?
> >
> > For IOMMU_CACHE there are two questions related to the overloaded
> > meaning:
> >
> >  - Should VFIO ask the IOMMU to use non-coherent DMA (ARM meaning)
> >    This depends on how the VFIO user expects to operate the DMA.
> >    If the VFIO user can issue cache maintenance ops then IOMMU_CACHE
> >    should be controlled by the user. I have no idea what platforms
> >    support user space cache maintenance ops.
>=20
> But just like you said for intel meaning below, even if those ops are
> privileged a uAPI can be provided to support such usage if necessary.
>=20
> >
> >  - Should VFIO ask the IOMMU to suppress no-snoop (Intel meaning)
> >    This depends if the VFIO user has access to wbinvd or not.
> >
> >    wbinvd is a privileged instruction so normally userspace will not
> >    be able to access it.
> >
> >    Per Paolo recommendation there should be a uAPI someplace that
> >    allows userspace to issue wbinvd - basically the suppress no-snoop
> >    is also user controllable.
> >
> > The two things are very similar and ultimately are a choice userspace
> > should be making.
>=20
> yes
>=20
> >
> > From something like a qemu perspective things are more murkey - eg on
> > ARM qemu needs to co-ordinate with the guest. Whatever IOMMU_CACHE
> > mode VFIO is using must match the device coherent flag in the Linux
> > guest. I'm guessing all Linux guest VMs only use coherent DMA for all
> > devices today. I don't know if the cache maintaince ops are even
> > permitted in an ARM VM.
> >
>=20
> I'll leave it to Jean to confirm. If only coherent DMA can be used in
> the guest on other platforms, suppose VFIO should not blindly set
> IOMMU_CACHE and in concept it should deny assigning a non-coherent
> device since no co-ordination with guest exists today.

Jean, what's your opinion?

>=20
> So the bottomline is that we'll keep this no-snoop thing Intel-specific.
> For the basic skeleton we'll not support no-snoop thus the user
> needs to set enforce-snoop flag when creating an IOAS like this RFC v1
> does. Also need to introduce a new flag instead of abusing
> IOMMU_CACHE in the kernel. For other platforms it may need a fix
> to deny non-coherent device (based on above open) for now.
>=20

Jason, want to check whether another option works here.

The current proposal lets the user to choose whether the I/O page
table should be put in an enforced-snoop format, with the assumption
that the user may have better knowledge than the kernel to know the
no-snoop requirement. This leads to the current design which exposes
whether an IOMMU behind a device supports enforce-snoop via
IOMMU_DEVICE_GET_INFO to the user and then have the user to
set/clear the enforce-snoop flag in IOMMU_IOASID_ALLOC.

This makes sense if there are no-snoop devices behind an IOMMU=20
supporting enforce-snoop.

But in reality only Intel integrated GPUs have this special no-snoop=20
trick (fixed knowledge), with a dedicated IOMMU which doesn't=20
support enforce-snoop format at all. In this case there is no choice
that the user can further make.=20

Also per Christoph's comment no-snoop is not an encouraged=20
usage overall.

Given that I wonder whether the current vfio model better suites=20
for this corner case, i.e. just let the kernel to handle instead of=20
exposing it in uAPI. The simple policy (as vfio does) is to automatically=20
set enforce-snoop when the target IOMMU supports it, otherwise=20
enable vfio/kvm contract to handle no-snoop requirement.

I don't see any interest in implementing an Intel GPU driver fully
in userspace. If just talking about possibility, a separate uAPI can=20
be still introduced to allow the userspace to issue wbinvd as Paolo
suggested.

One side-effect of doing so is that then we may have to support
multiple domains per IOAS when Intel GPU and other devices are
attached to the same IOAS. But this doesn't have to be implemented
in the basic skeleton now. Can be extended later when we start=20
working on Intel GPU support. And overall it also improves=20
performance otherwise the user has to create two duplicated IOAS's=20
(one for GPU, one for other devices) if assuming one domain per=20
IOAS then every map request must be done twice in both IOAS's.

Does this option make sense?=20

btw fixing the abuse of IOMMU_CACHE is orthogonal to this uAPI
open anyway.

Thanks
Kevin
