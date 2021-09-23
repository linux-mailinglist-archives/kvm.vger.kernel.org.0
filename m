Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4651A415AAB
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 11:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbhIWJQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 05:16:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:5719 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238189AbhIWJQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 05:16:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="211041778"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="211041778"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 02:15:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="653595765"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2021 02:15:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 02:15:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 02:15:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 23 Sep 2021 02:15:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 23 Sep 2021 02:15:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbijrnbErYrLAJxBI+9cvZ0OAFgdUuKpW6gzvE3RVb6vyiSedep/n9Fisk82nAVxHgMYDoONvqEaj/8w7t1S+mZqJIzj1bzwALhMLRFhDrdT2Ke2C4l6fzW4+N5bEG+qvFQ9bYAO60FiTrrExBr9U35bVc5xdovljswT392t3Q5t4mZABHLkA35Jy8nbeo6A4O5iHU6mmekQqDMoEEGbpxWvzOg1NMpptyp7vdEdPw41Htp4V+GlpAvxwJYL+afHo20tix/KRYurRptGCCPJMFtEeX9cl5JOFBtdFPe9qSD7DEkydS0tjh581dVoXj52G8W+mFtPS1zTt10lLoSEpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ykHhi308yYleTiYaxcTjdclWmESQ/EtedYw5h4fczaE=;
 b=lEGutTMTzaGjtNX+jbVrmpmqBEiNLlzp9LCzg/K6QrISJ7v1woT6s9YmsSmxvvxTEmOUL6iQWl34dJgHMC9wkOhQ1vdnS/KNy5HOTFbQDAqYCpAahq662BW7Ez4RYeoQTk/rZlyfk+T11Bw3rcEsv689KTPX7vaX+DgiQqwKIWW7KY06kjWHTVD7jPd+9IS9c+z9ZNekEyup8xYK4i2XR16m8tqx1swLQyu5VOIKGqwvF6lMk0qxISPas+3eNggisRCsFmFCyQ04Oq8Nu7oZBjQpX0t0AM7Cnj2Ssa9xjoqkiD6HOr+LC1yeR+xQTnkX30tLd2Q8lfgLpx3l5GgagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykHhi308yYleTiYaxcTjdclWmESQ/EtedYw5h4fczaE=;
 b=rEWstepvVVq8RifAq1cBVZDeKxYZy3MxYNl+pcPMNBU8ZgeqtdJvL1qFdZBE08xVj7OdqDp3n3ydERjWPdVpGOMLoMrRM8t2Q2alUncQBsVpKbiKNT5HC0X5bxS5Vnsicr6dTR5O5awbfLTmhcCaeN6NG/6H/decuDUCxyHrOxs=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2852.namprd11.prod.outlook.com (2603:10b6:406:a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 09:14:59 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 09:14:59 +0000
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
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66uuxm8AgACjoWCAALKBgIABNQdA
Date:   Thu, 23 Sep 2021 09:14:58 +0000
Message-ID: <BN9PR11MB5433A47FFA0A8C51643AA33C8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
In-Reply-To: <20210922140911.GT327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edaf3c84-45e0-4478-ca6c-08d97e729de6
x-ms-traffictypediagnostic: BN7PR11MB2852:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2852015A11EF47D4AFCFBF538CA39@BN7PR11MB2852.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UZ6d9pMQoD4WqoIIxZrEN+9EpXds6I5cr0KwM3plbsaUX6cIk1ailYpw8vkcMedut+5wr4oGQRSfTiF6ZiIRUmHbSxMPFAhqSPVyZ9ecKrLAdI36KFUXuHC5SHyuxi19wDPBmqQWtmLOoYziEn0MyDwJybJSszuoT23mpCqadaSBsqrLcdPAwgQl5YLfvW2XsW8D/Wghj+I5jy4i6v+n1cPsKCdFM2B9CmSbjNLQrBgK3hpg3J47lnnTQ/yRqj1hqP1ptp0AeJSzRHtw4Hyx3XpePZhhZUnlujMUmmBe0APkpjJ1DTebpbHh3m8T0cZEvH8KPPnCqKwphiFFmisu4VFV1Mvg4wHjFA50+vNa7UjYe+dATPvNMiEnfQNnfYrykPEZkm2ycG2UC8+RWtV+AVdojtkVWvaxq+6kewNWTF75kXNQ6O8LhbOtjUpGowMjRo4jc0xhXnW6Y1ERA3g4S0p0cFzJ6c34vEYesBcqtWcnRaV/DDpZtDekGEIcPPxvNdIFnsSqOEO9MJqQ46RkSlMqrojO69B6aGJEwQa+cGSrMmfIImXDiYPkNTJDtjToaoyustARNV+3dAqITFWRlkBWCkzN4CMJBE48gtxlNkj7lO9mmQgHUfjDvHbBUMEGSjGa6tF4F91tBJjvn7dBZD80CJPwNJbM4d7TWE3sBbzwduZoxHK32a8mWud/rixXji49KqKZYFQ/AgrUmHRLDlLXvPSAMpu6Ad7sZKBLnKWKupqSONfkjMjAbMdPBOCp9JTqITIeAztzKQhqHLL9fYfOl1Msh3aIH4ch1FSG1Lpme8tx1hsxZzvpKWBnrr6n6qD3T1FjCy2Jb6VzXckt9DYFePsuygjWUWBMTKbfmgAxcu7Fw0FcGKcs6J56WXKr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(52536014)(6506007)(26005)(66476007)(6916009)(33656002)(2906002)(5660300002)(122000001)(38100700002)(186003)(7696005)(54906003)(66946007)(55016002)(966005)(83380400001)(76116006)(7416002)(38070700005)(508600001)(4326008)(66446008)(9686003)(64756008)(8676002)(71200400001)(86362001)(316002)(66556008)(21314003)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?op0X2wkq7Tn38SLdQ1CWwRjiVbJuZKB0QBMWJbINVHAj0tkDWa9cziP9e8YZ?=
 =?us-ascii?Q?VQSZNpBs8oZHwXWXkUDTb+2Vys2HOzGSfvlzS0rklZDvzB92D1Cwp+4mkeIN?=
 =?us-ascii?Q?TQ5s2PIE0ZcOYQIS/ycFk/6H/VfHQjcuR4hAlw5R/HIiqSXTanyMq2/VOFpW?=
 =?us-ascii?Q?f5IDvkNGZ7v1HvFSLOZLdT+U3Z6ThTUQ/PVYS9mt0PpCMWYENRxD7xRSg8co?=
 =?us-ascii?Q?6Tv+zk6FiFKXNFk+mp3DdLcYelBkKldfWEwcsXnxAr8sPxecSLVdZ2Bf/HJw?=
 =?us-ascii?Q?eoohAOaadmwZX5xpAYQUqxoblO3HWm/6xHfxMkZiptuEnTlrZeHoBrpG0Ffr?=
 =?us-ascii?Q?XDtCrKEvsAoUPo28WF3IAUarZODV1mZeJZponi2wcN1XrRUUlhiaCG4xce9o?=
 =?us-ascii?Q?tvTroz7Lsqio8MqMym/gMcNEg9Vrd6EHdel5zZ+L6W+xarF6ApvLTokIHBT8?=
 =?us-ascii?Q?QGtW12sysEiNz8KpyqYzPl+mX5HP+4j8TX8LbKUi1Vy4dp5fgI7QuS5eYRLl?=
 =?us-ascii?Q?8RbW6rk1Knyf8UzCF0JAsDRbsRdBmFVh+q+0m8GPnap3kGMWbVxJFl3SXvjf?=
 =?us-ascii?Q?ZWjDUMQXo0dftxvIi5fmshsigOHx9iXcVS3BmfbrU0CR8o3FA52idFGhXFkh?=
 =?us-ascii?Q?OX9AGo7tZ0l0iet2TXQ2Z4/c+SP7BqzgopjTlwdqCdcynLEbbeL2ZAc3VvQP?=
 =?us-ascii?Q?qvBS5sHH3bi59/btyoWTgPT3zbz98Y8q/6N2D9EA9hYlxODH7ebFCvj7DGa/?=
 =?us-ascii?Q?7/nXyxpVuebMh4J7Tu/nlbihtmvi844nI1kBzgd2/XR/M+aYha38YVCZ44ZF?=
 =?us-ascii?Q?oOCaxlnMH0XlNBogPJiSX49R0lxLyRn49mybRkS46O3MHL/LVuDOuhSS73e6?=
 =?us-ascii?Q?tzFGoHS8lu7DcEYAHnZP0w+ecaghc3jYyIVDLnkeLWFJIC5gbXDTwKA+k/1f?=
 =?us-ascii?Q?9IhTh/NPOCME0B3GJOkFs2xZ6TiN4FyYjyly8WmVQXLo8J7xQd8U68x4FmyI?=
 =?us-ascii?Q?yvPdrG8ZVZDx28a0UbLIqQT0NpduipZ+sQ9eeIvazx1jCyNXsNRfFaXAwDfJ?=
 =?us-ascii?Q?av8/tWUHldviIkuWshQbE0uKFm/QsDeBu57GfDAJkp5MmseutJinYOKATS07?=
 =?us-ascii?Q?Q97KnQ97PC8aGwXEPkEt6qDSyAITG32BkjSH77IpWxJrlwvYSZrnhUF+tMgh?=
 =?us-ascii?Q?Hb8hIYvmkv9yXXzk9e9DS/cTerP2oy/JY+dw+z6hfGiWSPqHWSR7raAdW4ur?=
 =?us-ascii?Q?/Z3348gxyNN7jTLbd5IXKTzeO1+lB01D7fWebsAipufcl3IZBYDg/OqIKfFc?=
 =?us-ascii?Q?vL1BL3fJ8Rvmw87iBfxibiZW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edaf3c84-45e0-4478-ca6c-08d97e729de6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 09:14:58.8423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KfIiOm94Qxn3APEya1EscEr5MQ1za8WeXfAkWsgrJuVyM33glgK5Q/7koPiGbo3mPZPR+pGipSZ4eDsQzLSc+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2852
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 10:09 PM
>=20
> On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 1:45 AM
> > >
> > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > This patch adds IOASID allocation/free interface per iommufd. When
> > > > allocating an IOASID, userspace is expected to specify the type and
> > > > format information for the target I/O page table.
> > > >
> > > > This RFC supports only one type
> (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > > semantics. For this type the user should specify the addr_width of
> > > > the I/O address space and whether the I/O page table is created in
> > > > an iommu enfore_snoop format. enforce_snoop must be true at this
> point,
> > > > as the false setting requires additional contract with KVM on handl=
ing
> > > > WBINVD emulation, which can be added later.
> > > >
> > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next
> patch)
> > > > for what formats can be specified when allocating an IOASID.
> > > >
> > > > Open:
> > > > - Devices on PPC platform currently use a different iommu driver in=
 vfio.
> > > >   Per previous discussion they can also use vfio type1v2 as long as=
 there
> > > >   is a way to claim a specific iova range from a system-wide addres=
s
> space.
> > > >   This requirement doesn't sound PPC specific, as addr_width for pc=
i
> > > devices
> > > >   can be also represented by a range [0, 2^addr_width-1]. This RFC
> hasn't
> > > >   adopted this design yet. We hope to have formal alignment in v1
> > > discussion
> > > >   and then decide how to incorporate it in v2.
> > >
> > > I think the request was to include a start/end IO address hint when
> > > creating the ios. When the kernel creates it then it can return the
> >
> > is the hint single-range or could be multiple-ranges?
>=20
> David explained it here:
>=20
> https://lore.kernel.org/kvm/YMrKksUeNW%2FPEGPM@yekko/
>=20
> qeumu needs to be able to chooose if it gets the 32 bit range or 64
> bit range.
>=20
> So a 'range hint' will do the job
>=20
> David also suggested this:
>=20
> https://lore.kernel.org/kvm/YL6%2FbjHyuHJTn4Rd@yekko/
>=20
> So I like this better:
>=20
> struct iommu_ioasid_alloc {
> 	__u32	argsz;
>=20
> 	__u32	flags;
> #define IOMMU_IOASID_ENFORCE_SNOOP	(1 << 0)
> #define IOMMU_IOASID_HINT_BASE_IOVA	(1 << 1)
>=20
> 	__aligned_u64 max_iova_hint;
> 	__aligned_u64 base_iova_hint; // Used only if
> IOMMU_IOASID_HINT_BASE_IOVA
>=20
> 	// For creating nested page tables
> 	__u32 parent_ios_id;
> 	__u32 format;
> #define IOMMU_FORMAT_KERNEL 0
> #define IOMMU_FORMAT_PPC_XXX 2
> #define IOMMU_FORMAT_[..]
> 	u32 format_flags; // Layout depends on format above
>=20
> 	__aligned_u64 user_page_directory;  // Used if parent_ios_id !=3D 0
> };
>=20
> Again 'type' as an overall API indicator should not exist, feature
> flags need to have clear narrow meanings.

currently the type is aimed to differentiate three usages:

- kernel-managed I/O page table
- user-managed I/O page table
- shared I/O page table (e.g. with mm, or ept)

we can remove 'type', but is FORMAT_KENREL/USER/SHARED a good
indicator? their difference is not about format.

>=20
> This does both of David's suggestions at once. If quemu wants the 1G
> limited region it could specify max_iova_hint =3D 1G, if it wants the
> extend 64bit region with the hole it can give either the high base or
> a large max_iova_hint. format/format_flags allows a further

Dave's links didn't answer one puzzle from me. Does PPC needs accurate
range information or be ok with a large range including holes (then let
the kernel to figure out where the holes locate)?

> device-specific escape if more specific customization is needed and is
> needed to specify user space page tables anyhow.

and I didn't understand the 2nd link. How does user-managed page
table jump into this range claim problem? I'm getting confused...

>=20
> > > ioas works well here I think. Use ioas_id to refer to the xarray
> > > index.
> >
> > What about when introducing pasid to this uAPI? Then use ioas_id
> > for the xarray index
>=20
> Yes, ioas_id should always be the xarray index.
>=20
> PASID needs to be called out as PASID or as a generic "hw description"
> blob.

ARM doesn't use PASID. So we need a generic blob, e.g. ioas_hwid?

and still we have both ioas_id (iommufd) and ioasid (ioasid.c) in the
kernel. Do we want to clear this confusion? Or possibly it's fine because
ioas_id is never used outside of iommufd and iommufd doesn't directly
call ioasid_alloc() from ioasid.c?

>=20
> kvm's API to program the vPASID translation table should probably take
> in a (iommufd,ioas_id,device_id) tuple and extract the IOMMU side
> information using an in-kernel API. Userspace shouldn't have to
> shuttle it around.

the vPASID info is carried in VFIO_DEVICE_ATTACH_IOASID uAPI.=20
when kvm calls iommufd with above tuple, vPASID->pPASID is
returned to kvm. So we still need a generic blob to represent
vPASID in the uAPI.

>=20
> I'm starting to feel like the struct approach for describing this uAPI
> might not scale well, but lets see..
>=20
> Jason
