Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA1C399C47
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 10:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFCIO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 04:14:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:25046 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhFCIOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 04:14:25 -0400
IronPort-SDR: iGBPdEQ7wnWovGyqkt7ZaPHp1HAkmXRfHZo3oiIzRNd+RserWGM4Q2Nckqzanmuj3QmMtK/3Ie
 1sZfW8piUK+A==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="191103381"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="191103381"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 01:12:40 -0700
IronPort-SDR: cLq0cB5bGbRcLQnlIDqIQnrE1fTa+/k+bdPhvZPGuOfhVMNCSEmthNWlWnjvQKYGpJms841yUU
 RqX5uEJOViQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="549848860"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 01:12:40 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 01:12:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 01:12:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 01:12:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SseoFieHswWI7cMeQS6sv6yLvVbe6O/URyDWDpL+hKC/ITj9WEaB4R7xwN8yOBEysXkY4acXt6Tne6/MimFJ6iZiNW4q9lhOLJl+syq8BctEH6Q8xhySz5rayM2os007qkgXO8VT+VCMWuaumVuDKebFUhxx12AmU0/TTIpBMi9IyL0gTZzkiTOmW9Rm8UwYhilNTIrDAlEWke+8eh5/H1w2/yN7GnNE8nx+UmmATgnFLnt0EVvEcLja3vpOviXjxHmmGWqv/isJEHCLeZdUQehnD27q+AXdhr5aW6kDFGFrg3rnUN0QrcJjSTQvuRW1i1F8GiRYTrVVeKfwOMW+Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+y1mFagC4igd4l7dq7v2cRjWfhSeFUHyEJ3pZjU3JM=;
 b=f4wDIPDTA5ltaKQc3k+a+abtWz0dNCULgQjo4e3iQyyiug0QPRknOtK4GlpsVf2ecfbQrEs10MndnZJZUdoNfi/4Lxiyf4SoC2apNKciaWfBQk+5MEQwPZXxc8PsyKJ8dT5EwGPm1Y85lDRUZN9fD5FUc/mVkSTR4HDvaz7vPcS94ZWxOyfpafzXacOYLvZhJK6x6w0iPAYy5cYW7FvsF2DJClLd52EsICnQFdV3+gSdrxS/ogmnsaXg2hRirtAJxEzwMY3+bKUrbABT26lZa/UOTMNXFSbrPMEnD+0mEe+6fqmxyd8lckAf89YJOOhPg41WKInM1Z4NY72rcPb7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+y1mFagC4igd4l7dq7v2cRjWfhSeFUHyEJ3pZjU3JM=;
 b=Af4c+SBklJNeGCSI8ewkNwE7UlJEfA+KxaNxK3I08aRleXyz/cIVx1qApfKILubU0SojD9hDV+Q0txP3IUAf3amDOI4ninwPXrozFRpEDd99bHgojX717VKZib5+LT61Gx4k6KJmWGaIL0W9/0OEWPiT2ujZv2imygOhvzamhLU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4636.namprd11.prod.outlook.com (2603:10b6:303:5a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 08:12:27 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 08:12:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwEqZK+AADR4pXA=
Date:   Thu, 3 Jun 2021 08:12:27 +0000
Message-ID: <MWHPR11MB188668D220E1BF7360F2A6BE8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
In-Reply-To: <YLch6zbbYqV4PyVf@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cfc4e2d-0d16-4e58-46a4-08d9266753b7
x-ms-traffictypediagnostic: MW3PR11MB4636:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4636855CCB5C68C9A68AFEB08C3C9@MW3PR11MB4636.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwqMJG+J8opSiW1M2nmSK1TekmIPY3uhZYTVZ4yJR1nSPcPiaGSBMMBfLLHXj8FVdIgbAt4JWQPdVEPKElQSh5AlhWXSn2AgqXafO8iCs+YRR9df8s4+RMxG/X3rMf6kWoDpwAzGNKiPz6cy8k9FVnbI3hWV0wMac/usX/IKAX5vZm1lKgcSvZXrqvw3bM3vTb9E43DaLuGgsg6FJ/RLbzxNdMS7w8wIsCSzUxT55hUCkP/LbXlIdB+q+zC3gan486UalYsaD/479R5dDPDsuPjHjNRXhLszdXT/vM1K0y9oYY5fJxmM0pCNJk5yEkBDIqhfckRbGMe0iOxkWjcxuoZ99YP0/bEobZn7ILw7hNiDGAhnyE5/XCowpcZqquK2Djp6HhXd5YZG69SZq2fh3MDGpCW/dUxklviRQ0os27afKwMJzCTdCufDZjM/dpkjzj3+qIvpooFTBYipejWV/Zinc+mn6WrG1IGiEyw1O2aecuQUdNPxF431FnCdiyXAKqBJWEEjfl4qbucNWzAgFabwtnDCA7TYXhUqiifvEZ1zNSN9gUmsmQQ4kDoTCS13c0lv/seJ67bzKnhX0eMs/+pSMalZ3o7mXaj81CLRvqU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(396003)(376002)(366004)(122000001)(186003)(76116006)(86362001)(6506007)(8936002)(55016002)(7416002)(4326008)(26005)(52536014)(7696005)(8676002)(5660300002)(38100700002)(54906003)(83380400001)(316002)(71200400001)(33656002)(66446008)(66476007)(6916009)(64756008)(2906002)(66556008)(478600001)(9686003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?91V35/augQEBQ8n3hRmfF2k4LrENXcjSbMi60Uos0FIFSXohqdPm6bxX9t5e?=
 =?us-ascii?Q?wGYyMdEam/sU71LT5+fyPnT1NucQSUC1d7AP6KdWlPPTE1B7jpwGWoh+66/R?=
 =?us-ascii?Q?gjKU0UKrbmspDFw5mKIssZi/bd3m+y9BKRSuj3+7iArB53jIwHZau+ek2aa9?=
 =?us-ascii?Q?/HJXX0g4QQMtCfJFNj3S9nwh1cFrlUQCbR5ObkaB5he4erOC6bZnCqfrRF20?=
 =?us-ascii?Q?p91MOrNXKlPrgqI6Dqc+6m4/LpPF9gg8P57JuJ4jmG6JvXPfC84aVgAmhedE?=
 =?us-ascii?Q?EQHhy29cXJJsYQi/QXmYsY2Up0BiE1zd4LXiyNEZ37uMgYZ/v7JQqKS/sjry?=
 =?us-ascii?Q?b0Cvh7JAl2DcMriudvEjHHdTAqlgWyP4I/htWQ4JiOaesID4k3W0z/rfjkbA?=
 =?us-ascii?Q?zEqm934KFi4ZEywRelEM4GETn+RbgD1fafJKocBY0Ba9ajFLa/PyfRcocghB?=
 =?us-ascii?Q?j42XM7u5uKEgXLTXmMB27Xzl/m3iIa3gxi6UQBNpVPzC6aKNo53BBki6IqSi?=
 =?us-ascii?Q?74aeNo/raLXD4D0kgWHIfz56Dd3DENjdPtRystddrAwTUQ85kQ/asOKV9Thl?=
 =?us-ascii?Q?Y26x4H30XsMLSxd55OEJSYup92wd9r9oHLYE9ANMwBxIGEhHgjiItbu8C26w?=
 =?us-ascii?Q?tIeb6CQtc3EM0D6TZqPj+bJuqeM9UDa7VO7kWF/RdEIqwTwVtHXygOiQaCBe?=
 =?us-ascii?Q?cFKIDpqAheKPkQIUmVGF04GY7ycV54mWefpwWK9YM47/oeylcIzHxGPFEleF?=
 =?us-ascii?Q?jDuNHcRFiuoYl4RYSqDdOwzDUq+9DaJ4eGMc2lQUPqYjPD3/+XnrfeG9jyKB?=
 =?us-ascii?Q?qIafUvOWpJtpoSR7oa4tUrn0cnlvCeClH4Buvr81kYXzlea2fpiv8edgWlW3?=
 =?us-ascii?Q?0X3p56vyA16FuHQZUSfs29wUEsTKNUNkHsJaOB1SzLuIdn23V604kEyViDg0?=
 =?us-ascii?Q?8E2m1QWdaVfYS/EAJ2FaFaIUOVE/7Nm6csIV0AJKQKece61nEm92gshVqSYN?=
 =?us-ascii?Q?DkMLtiU9xdT1rpFBeUhoFccbkwp8FPXH9H4LCsKYRKKu8JKbShb93gbRSjAg?=
 =?us-ascii?Q?5eLmAc1Vpb8nKDkcXCAbWiQnuYigCpBdIGnZ0dvIGyMo0VxpUh0Z1hdhQ4Tx?=
 =?us-ascii?Q?ncgUaOTyTYWfN7t2tf52712JZCnafxJ6AKVYMJaaKeXnZmxaenwZRJ50+4pp?=
 =?us-ascii?Q?0nKCwDefRSjsqb49ZdmhlQnMSI3XmjqMs8UaFRpTKU5vGxqC8DLjI3HaxuGq?=
 =?us-ascii?Q?PqJ87ixlIQE2JIfCu7SmM64CD16PBpG4B9YATBIs8f+x7er8cSglD4ZHpBSv?=
 =?us-ascii?Q?8mx128fYsPYw+KpKDhYu10eP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfc4e2d-0d16-4e58-46a4-08d9266753b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 08:12:27.6833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewGgrnhu8LD75Wb5p03pc9NnB/cUWpoEGDHV64NWwt8yMYtL821arF9KGsrldteLu8G8mgR8cIlCCWrWISpDXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4636
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Wednesday, June 2, 2021 2:15 PM
>
[...]
=20
> >
> > /*
> >   * Get information about an I/O address space
> >   *
> >   * Supported capabilities:
> >   *	- VFIO type1 map/unmap;
> >   *	- pgtable/pasid_table binding
> >   *	- hardware nesting vs. software nesting;
> >   *	- ...
> >   *
> >   * Related attributes:
> >   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
>=20
> Can I request we represent this in terms of permitted IOVA ranges,
> rather than reserved IOVA ranges.  This works better with the "window"
> model I have in mind for unifying the restrictions of the POWER IOMMU
> with Type1 like mapping.

Can you elaborate how permitted range work better here?

> > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)
>=20
> I'm assuming these would be expected to fail if a user managed
> pagetable has been bound?

yes. Following Jason's suggestion the format will be specified when
creating an IOASID, thus incompatible cmd will be simply rejected.

> > #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE,
> IOASID_BASE + 9)
> > #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)
>=20
> I'm assuming that UNBIND would return the IOASID to a kernel-managed
> pagetable?

There will be no UNBIND call in the next version. unbind will be
automatically handled when destroying the IOASID.

>=20
> For debugging and certain hypervisor edge cases it might be useful to
> have a call to allow userspace to lookup and specific IOVA in a guest
> managed pgtable.

Since all the mapping metadata is from userspace, why would one=20
rely on the kernel to provide such service? Or are you simply asking
for some debugfs node to dump the I/O page table for a given=20
IOASID?

>=20
>=20
> > /*
> >   * Bind an user-managed PASID table to the IOMMU
> >   *
> >   * This is required for platforms which place PASID table in the GPA s=
pace.
> >   * In this case the specified IOASID represents the per-RID PASID spac=
e.
> >   *
> >   * Alternatively this may be replaced by IOASID_BIND_PGTABLE plus a
> >   * special flag to indicate the difference from normal I/O address spa=
ces.
> >   *
> >   * The format info of the PASID table is reported in IOASID_GET_INFO.
> >   *
> >   * As explained in the design section, user-managed I/O page tables mu=
st
> >   * be explicitly bound to the kernel even on these platforms. It allow=
s
> >   * the kernel to uniformly manage I/O address spaces cross all platfor=
ms.
> >   * Otherwise, the iotlb invalidation and page faulting uAPI must be ha=
cked
> >   * to carry device routing information to indirectly mark the hidden I=
/O
> >   * address spaces.
> >   *
> >   * Input parameters:
> >   *	- child_ioasid;
>=20
> Wouldn't this be the parent ioasid, rather than one of the potentially
> many child ioasids?

there is just one child IOASID (per device) for this PASID table

parent ioasid in this case carries the GPA mapping.

> >
> > /*
> >   * Invalidate IOTLB for an user-managed I/O page table
> >   *
> >   * Unlike what's defined in include/uapi/linux/iommu.h, this command
> >   * doesn't allow the user to specify cache type and likely support onl=
y
> >   * two granularities (all, or a specified range) in the I/O address sp=
ace.
> >   *
> >   * Physical IOMMU have three cache types (iotlb, dev_iotlb and pasid
> >   * cache). If the IOASID represents an I/O address space, the invalida=
tion
> >   * always applies to the iotlb (and dev_iotlb if enabled). If the IOAS=
ID
> >   * represents a vPASID space, then this command applies to the PASID
> >   * cache.
> >   *
> >   * Similarly this command doesn't provide IOMMU-like granularity
> >   * info (domain-wide, pasid-wide, range-based), since it's all about t=
he
> >   * I/O address space itself. The ioasid driver walks the attached
> >   * routing information to match the IOMMU semantics under the
> >   * hood.
> >   *
> >   * Input parameters:
> >   *	- child_ioasid;
>=20
> And couldn't this be be any ioasid, not just a child one, depending on
> whether you want PASID scope or RID scope invalidation?

yes, any ioasid could accept invalidation cmd. This was based on
the old assumption that bind+invalidate only applies to child, which
will be fixed in next version.

> > /*
> >   * Attach a vfio device to the specified IOASID
> >   *
> >   * Multiple vfio devices can be attached to the same IOASID, and vice
> >   * versa.
> >   *
> >   * User may optionally provide a "virtual PASID" to mark an I/O page
> >   * table on this vfio device. Whether the virtual PASID is physically =
used
> >   * or converted to another kernel-allocated PASID is a policy in vfio =
device
> >   * driver.
> >   *
> >   * There is no need to specify ioasid_fd in this call due to the assum=
ption
> >   * of 1:1 connection between vfio device and the bound fd.
> >   *
> >   * Input parameter:
> >   *	- ioasid;
> >   *	- flag;
> >   *	- user_pasid (if specified);
>=20
> Wouldn't the PASID be communicated by whether you give a parent or
> child ioasid, rather than needing an extra value?

No. ioasid is just the software handle.=20

> > 	struct ioasid_data {
> > 		// link to ioasid_ctx->ioasid_list
> > 		struct list_head		next;
> >
> > 		// the IOASID number
> > 		u32			ioasid;
> >
> > 		// the handle to convey iommu operations
> > 		// hold the pgd (TBD until discussing iommu api)
> > 		struct iommu_domain *domain;
> >
> > 		// map metadata (vfio type1 semantics)
> > 		struct rb_node		dma_list;
>=20
> Why do you need this?  Can't you just store the kernel managed
> mappings in the host IO pgtable?

A simple reason is that to implement vfio type1 semantics we
need make sure unmap with size same as what is used for map.
The metadata allows verifying this assumption. Another reason
is when doing software nesting, the page table linked into the
iommu domain is the shadow one. It's better to keep the original=20
metadata so it can be used to update the shadow when another=20
level (parent or child) changes the mapping.

> >
> > 5.3. IOASID nesting (software)
> > +++++++++++++++++++++++++
> >
> > Same usage scenario as 5.2, with software-based IOASID nesting
> > available. In this mode it is the kernel instead of user to create the
> > shadow mapping.
>=20
> In this case, I feel like the preregistration is redundant with the
> GPA level mapping.  As long as the gIOVA mappings (which might be
> frequent) can piggyback on the accounting done for the GPA mapping we
> accomplish what we need from preregistration.

yes, preregistration makes more sense when multiple IOASIDs are
used but are not nested together.

> > 5.5. Guest SVA (vSVA)
> > ++++++++++++++++++
> >
> > After boots the guest further create a GVA address spaces (gpasid1) on
> > dev1. Dev2 is not affected (still attached to giova_ioasid).
> >
> > As explained in section 4, user should avoid expose ENQCMD on both
> > pdev and mdev.
> >
> > The sequence applies to all device types (being pdev or mdev), except
> > one additional step to call KVM for ENQCMD-capable mdev:
> >
> > 	/* After boots */
> > 	/* Make GVA space nested on GPA space */
> > 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
>=20
> I'm not clear what gva_ioasid is representing.  Is it representing a
> single vPASID's address space, or a whole bunch of vPASIDs address
> spaces?

a single vPASID's address space.

Thanks
Kevin
