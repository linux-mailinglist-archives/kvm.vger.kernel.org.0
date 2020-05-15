Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C771D5CD8
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 01:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgEOXhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 19:37:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:57623 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOXhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 19:37:04 -0400
IronPort-SDR: +Tq9XwoJjWxXKESB0ZXpL5WxZ4L+qX/84wNu4Hmev64BLZP0wVF1Io9wYceYzQIcCF5w0qjGln
 0/M20EJoiJMA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 16:36:05 -0700
IronPort-SDR: wnQHXV9fygL2LUiv08Pt5U1MgRrU8JIbKhoJyTUpqo3hbGiGzcIB52ktyd8foPp1Pe7yN6aHR+
 LrFi3Rpq0Ngg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="410626004"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 15 May 2020 16:36:05 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 15 May 2020 16:36:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 May 2020 16:36:04 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 15 May 2020 16:36:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 15 May 2020 16:36:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLUSdiUwScEJQ7giMh7zA4hlfT3ADXyoykOQHVJcAufUoQSW90afpfvlpEqFCwnsfLb0naxK3G//4XNH3dhQeI9ouQcIyVFHh0hQ+WsoYrWpwe6oDyxWOG733sZB/eXa2PGodVvqmsqvZ8cicUwse0MAspKPEowMmlVa6oE/6Uoai3oN+C3cxqiV1Smi6MZbBm72ICojkI6bfSvjCNFn+rBLsLhmLMskBuvXVtXnTE3B1/73ZVZvXExc4sy+kz1lANKxEf41t9JNu0ifbGPyp+QsW2UB1lMLgH96aVSPziIh9Bp8O/L+k/QFp1E9PmIhGCtXRkaJH25thG6UTUnZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoJfopK+gMuVeZfjWWm47e/NvMM9gr6SUdVRxDCniL8=;
 b=QQSZWzIlT9y1mi356rTX/VJXGC1HytSTzqidgcRcHEZk2xAeGWp+Ai3vTW+CvdP2b1eKaRrByRSKWp+1uJ6oPZ9IK+OuRG3FqjM0aGqbwLKI5dJqrD+Jt1SI2HF1SYUAftwoYptNZGXrK2QXtrN+mSNspB/eEASAyzDvbrr9WNnvdwJO9d3HzsJes9HKAytSIRVXm8/u9mIWMoZNwK1JvLQBoBus+k82Np6iAOBvVmhDeAnJW9LjosyfFQM80/4CrVkJyh+aP033Pme8v/TIESaA5km0j0ZRvIME5PsEQZIBPkcWEYU7/oRovFU834DkA5R2XWeifHz5fgLIIgoG2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoJfopK+gMuVeZfjWWm47e/NvMM9gr6SUdVRxDCniL8=;
 b=rVW5Xm6/wpzBUaRG8HhZC+U/bJPaGwRqHOpD05OmEedIy52IaJXUiCPdqIDH14T05IYBuPMlsNzzhw7ym6H6xj0VpqaJCWdiKH4XwYQwOE3rxonFqc/eVuhp34j95nsYL6oAJqsI0S4qp8+IUGF2RjjVlaxw1Rd43FTBkIb6rBg=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Fri, 15 May
 2020 23:36:01 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 23:36:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: (a design open) RE: [PATCH v1 6/8] vfio/type1: Bind guest page
 tables to host
Thread-Topic: (a design open) RE: [PATCH v1 6/8] vfio/type1: Bind guest page
 tables to host
Thread-Index: AdYqhFEO5GgnrItYSbi06NduB/9LVgAR/foAABEONZA=
Date:   Fri, 15 May 2020 23:36:01 +0000
Message-ID: <MWHPR11MB16451AFC4CF6EAA015D83D0A8CBD0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <MWHPR11MB164538B052C3C6BCFE22D69E8CBD0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200515151953.GA75440@otc-nc-03>
In-Reply-To: <20200515151953.GA75440@otc-nc-03>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77632c57-0898-410c-2a9e-08d7f928ba31
x-ms-traffictypediagnostic: MWHPR11MB0029:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB0029AD1DC5EFAF7BB349E7408CBD0@MWHPR11MB0029.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Hf8pLgi7KpWhoSiXVxLRvhW23Z/o/Ygsy02ri1DTCq4ztCw25VLNa2GE0hYZbi+l/xmFonsvaXQqLCg9WO9/dTQE89n2owe9LV7XxVVtoISod9DJ0Vq3AASksLMvhThEtp1hmUVKHS4l5f2zrDAuaWrj/ZEzEar0l+KHCKQ/brumwHzhg2qxvkwD7dUsfY4mloEEvJ1yXqUqTFeVc/UdHDqA0vdYy+iWMubCdBE6mVroPMRoaulLFWLL9Eiif7ZbXcg1E2iu81SaevDegaqsCuJxqXrLRsD8xmjamtn6DKDY3rfmv/bhXuvsZua+TS09gAIQ8AIUlR+J/VEIr41EuErkDnz7+xywbjcFeQ8tWuyulKcTrc5uPrN3wVxLWcVoSBGCTL6XpKWnv3bi+vBoK/KKRmDToF6y4gCSye2Mj+GUUiLRyIShalcO2P8lysr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(5660300002)(6506007)(76116006)(316002)(66446008)(7696005)(86362001)(6636002)(64756008)(478600001)(66556008)(66476007)(33656002)(66946007)(52536014)(186003)(30864003)(8676002)(71200400001)(26005)(53546011)(54906003)(6862004)(8936002)(55016002)(2906002)(4326008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EpPVSRnQWzBrwTRfOMnA/WHYva+Ko36gfMLFeEM1aZ6RjBuwbgRvfHO41iP+bs4HPvUX2XB868b9iKw8+W97tQn/AzGaKKp3acAyHNkSVw+nmR2dbSr/EoDKBkIqmPPR6ECXuunHdrJzTpC7tV23asayr2wJ9BVKoBDeT5BoMtSXfWz123KzxBGx/tfqJgIlVOdggc1SCJH571wp+wc42pPbtRP1mSNnAP0CJGCQNTJQdTm8eCrGt4MPIrP4fIAxOVDBg2SdtO7JlSJhbX3Ng0GS5+mg+afioeLmw8LmkeUovtljed52L5tIaMmNGI+lYC6PDEkJj3BXBMkBBRbuyuUUFfYA3izJjv3srMDBIrNcoO3WKJMc7WRMkCl4wj3xX1jQECgsk/jJnIp9KXOgL8QN0JvlL0pRQ68DkXUzonYbBvYh1vqei6WK2PtknmUl1dARh8RDzCS8rD3mhZQ/jKL/Rp0E1NSkYV/XkZn4dv6kma+Gip8xoTVRy3eFhqrA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77632c57-0898-410c-2a9e-08d7f928ba31
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 23:36:01.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k7RdrnzbAlkfhUEhA+OzFNkT5UU02je99t/IP+zj0a4Wn/RBhzuBzBn5YFKGM/KF+erH6EeyuB7I53xNCx52qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0029
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Raj, Ashok <ashok.raj@intel.com>
> Sent: Friday, May 15, 2020 11:20 PM
>=20
> On Fri, May 15, 2020 at 12:39:14AM -0700, Tian, Kevin wrote:
> > Hi, Alex,
> >
> > When working on an updated version Yi and I found an design open
> > which needs your guidance.
> >
> > In concept nested translation can be incarnated as one GPA->HPA page
> > table and multiple GVA->GPA page tables per VM. It means one container
> > is sufficient to include all SVA-capable devices assigned to the same g=
uest,
> > as there is just one iova space (GPA->HPA) to be managed by vfio iommu
> > map/unmap api. GVA->GPA page tables are bound through the new api
> > introduced in this patch. It is different from legacy shadow translatio=
n
> > which merges GIOVA->GPA->HPA into GIOVA->HPA thus each device
> requires
> > its own iova space and must be in a separate container.
> >
> > However supporting multiple SVA-capable devices in one container
> > imposes one challenge. Now the bind_guest_pgtbl is implemented as
> > iommu type1 api. From the definition of iommu type 1 any operation
> > should be applied to all devices within the same container, just like
> > dma map/unmap. However this philosophy is incorrect regarding to
> > page table binding. We must follow the guest binding requirements
> > between its page tables and assigned devices, otherwise every bound
> > address space is suddenly accessible by all assigned devices thus creat=
ing
> > security holes.
>=20
> The above 2 paragraphs are bit confusing :-) but what really matters
> is the below:
> >
> > Do you think whether it's possible to extend iommu api to accept
> > device specific cmd? If not, moving it to vfio-pci or vfio-mdev sounds
> > also problematic, as PASID and page tables are IOMMU things which
> > are not touched by vfio device drivers today.
>=20
> All you are referring to is when admin groups multiple devices in a
> single container, you are saying you can't give isolation to them
> for SVA purposes. This is logically equivalent to a single group with
> multiple devices.
>=20
> 	- Such as devices behind p2p bridge
> 	- MFD's or devices behind switches or hieararchies without ACS
> 	  support for instance.
>=20
> By limitation you mean, disable PASID on those devices in a single
> container?

the limitation means disabling nesting capability in such container
and yes it implies not exposing PASID capability to userspace too.

>=20
> what about ATS?

ATS is possibly fine. VFIO exposes it to userspace even today.

Thanks
Kevin

>=20
> >
> > Alternatively can we impose the limitation that nesting APIs can be
> > only enabled for singleton containers which contains only one device?
> > This basically falls back to the state of legacy shadow translation
> > vIOMMU. and our current Qemu vIOMMU implementation actually
> > does this way regardless of whether nesting is used. Do you think
> > whether such tradeoff is acceptable as a starting point?
> >
> > Thanks
> > Kevin
> >
> > > -----Original Message-----
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Sunday, March 22, 2020 8:32 PM
> > > To: alex.williamson@redhat.com; eric.auger@redhat.com
> > > Cc: Tian, Kevin <kevin.tian@intel.com>; jacob.jun.pan@linux.intel.com=
;
> > > joro@8bytes.org; Raj, Ashok <ashok.raj@intel.com>; Liu, Yi L
> > > <yi.l.liu@intel.com>; Tian, Jun J <jun.j.tian@intel.com>; Sun, Yi Y
> > > <yi.y.sun@intel.com>; jean-philippe@linaro.org; peterx@redhat.com;
> > > iommu@lists.linux-foundation.org; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; Wu, Hao <hao.wu@intel.com>
> > > Subject: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> > >
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which is backed by
> > > hardware
> > > IOMMUs that have nesting DMA translation (a.k.a dual stage address
> > > translation). For such hardware IOMMUs, there are two stages/levels o=
f
> > > address translation, and software may let userspace/VM to own the fir=
st-
> > > level/stage-1 translation structures. Example of such usage is vSVA (
> > > virtual Shared Virtual Addressing). VM owns the first-level/stage-1
> > > translation structures and bind the structures to host, then hardware
> > > IOMMU would utilize nesting translation when doing DMA translation fo
> > > the devices behind such hardware IOMMU.
> > >
> > > This patch adds vfio support for binding guest translation (a.k.a sta=
ge 1)
> > > structure to host iommu. And for VFIO_TYPE1_NESTING_IOMMU, not
> only
> > > bind
> > > guest page table is needed, it also requires to expose interface to g=
uest
> > > for iommu cache invalidation when guest modified the first-level/stag=
e-1
> > > translation structures since hardware needs to be notified to flush s=
tale
> > > iotlbs. This would be introduced in next patch.
> > >
> > > In this patch, guest page table bind and unbind are done by using fla=
gs
> > > VFIO_IOMMU_BIND_GUEST_PGTBL and
> > > VFIO_IOMMU_UNBIND_GUEST_PGTBL under IOCTL
> > > VFIO_IOMMU_BIND, the bind/unbind data are conveyed by
> > > struct iommu_gpasid_bind_data. Before binding guest page table to hos=
t,
> > > VM should have got a PASID allocated by host via
> > > VFIO_IOMMU_PASID_REQUEST.
> > >
> > > Bind guest translation structures (here is guest page table) to host
> > > are the first step to setup vSVA (Virtual Shared Virtual Addressing).
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 158
> > > ++++++++++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/vfio.h       |  46 ++++++++++++
> > >  2 files changed, 204 insertions(+)
> > >
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > b/drivers/vfio/vfio_iommu_type1.c
> > > index 82a9e0b..a877747 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -130,6 +130,33 @@ struct vfio_regions {
> > >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)\
> > >  (!list_empty(&iommu->domain_list))
> > >
> > > +struct domain_capsule {
> > > +struct iommu_domain *domain;
> > > +void *data;
> > > +};
> > > +
> > > +/* iommu->lock must be held */
> > > +static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
> > > +      int (*fn)(struct device *dev, void *data),
> > > +      void *data)
> > > +{
> > > +struct domain_capsule dc =3D {.data =3D data};
> > > +struct vfio_domain *d;
> > > +struct vfio_group *g;
> > > +int ret =3D 0;
> > > +
> > > +list_for_each_entry(d, &iommu->domain_list, next) {
> > > +dc.domain =3D d->domain;
> > > +list_for_each_entry(g, &d->group_list, next) {
> > > +ret =3D iommu_group_for_each_dev(g->iommu_group,
> > > +       &dc, fn);
> > > +if (ret)
> > > +break;
> > > +}
> > > +}
> > > +return ret;
> > > +}
> > > +
> > >  static int put_pfn(unsigned long pfn, int prot);
> > >
> > >  /*
> > > @@ -2314,6 +2341,88 @@ static int
> > > vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> > >  return 0;
> > >  }
> > >
> > > +static int vfio_bind_gpasid_fn(struct device *dev, void *data)
> > > +{
> > > +struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > > +struct iommu_gpasid_bind_data *gbind_data =3D
> > > +(struct iommu_gpasid_bind_data *) dc->data;
> > > +
> > > +return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
> > > +}
> > > +
> > > +static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> > > +{
> > > +struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > > +struct iommu_gpasid_bind_data *gbind_data =3D
> > > +(struct iommu_gpasid_bind_data *) dc->data;
> > > +
> > > +return iommu_sva_unbind_gpasid(dc->domain, dev,
> > > +gbind_data->hpasid);
> > > +}
> > > +
> > > +/**
> > > + * Unbind specific gpasid, caller of this function requires hold
> > > + * vfio_iommu->lock
> > > + */
> > > +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu
> > > *iommu,
> > > +struct iommu_gpasid_bind_data *gbind_data)
> > > +{
> > > +return vfio_iommu_for_each_dev(iommu,
> > > +vfio_unbind_gpasid_fn, gbind_data);
> > > +}
> > > +
> > > +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> > > +struct iommu_gpasid_bind_data *gbind_data)
> > > +{
> > > +int ret =3D 0;
> > > +
> > > +mutex_lock(&iommu->lock);
> > > +if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +ret =3D -EINVAL;
> > > +goto out_unlock;
> > > +}
> > > +
> > > +ret =3D vfio_iommu_for_each_dev(iommu,
> > > +vfio_bind_gpasid_fn, gbind_data);
> > > +/*
> > > + * If bind failed, it may not be a total failure. Some devices
> > > + * within the iommu group may have bind successfully. Although
> > > + * we don't enable pasid capability for non-singletion iommu
> > > + * groups, a unbind operation would be helpful to ensure no
> > > + * partial binding for an iommu group.
> > > + */
> > > +if (ret)
> > > +/*
> > > + * Undo all binds that already succeeded, no need to
> > > + * check the return value here since some device within
> > > + * the group has no successful bind when coming to this
> > > + * place switch.
> > > + */
> > > +vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> > > +
> > > +out_unlock:
> > > +mutex_unlock(&iommu->lock);
> > > +return ret;
> > > +}
> > > +
> > > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu
> *iommu,
> > > +struct iommu_gpasid_bind_data *gbind_data)
> > > +{
> > > +int ret =3D 0;
> > > +
> > > +mutex_lock(&iommu->lock);
> > > +if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > > +ret =3D -EINVAL;
> > > +goto out_unlock;
> > > +}
> > > +
> > > +ret =3D vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> > > +
> > > +out_unlock:
> > > +mutex_unlock(&iommu->lock);
> > > +return ret;
> > > +}
> > > +
> > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > >     unsigned int cmd, unsigned long arg)
> > >  {
> > > @@ -2471,6 +2580,55 @@ static long vfio_iommu_type1_ioctl(void
> > > *iommu_data,
> > >  default:
> > >  return -EINVAL;
> > >  }
> > > +
> > > +} else if (cmd =3D=3D VFIO_IOMMU_BIND) {
> > > +struct vfio_iommu_type1_bind bind;
> > > +u32 version;
> > > +int data_size;
> > > +void *gbind_data;
> > > +int ret;
> > > +
> > > +minsz =3D offsetofend(struct vfio_iommu_type1_bind, flags);
> > > +
> > > +if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +return -EFAULT;
> > > +
> > > +if (bind.argsz < minsz)
> > > +return -EINVAL;
> > > +
> > > +/* Get the version of struct iommu_gpasid_bind_data */
> > > +if (copy_from_user(&version,
> > > +(void __user *) (arg + minsz),
> > > +sizeof(version)))
> > > +return -EFAULT;
> > > +
> > > +data_size =3D iommu_uapi_get_data_size(
> > > +IOMMU_UAPI_BIND_GPASID, version);
> > > +gbind_data =3D kzalloc(data_size, GFP_KERNEL);
> > > +if (!gbind_data)
> > > +return -ENOMEM;
> > > +
> > > +if (copy_from_user(gbind_data,
> > > + (void __user *) (arg + minsz), data_size)) {
> > > +kfree(gbind_data);
> > > +return -EFAULT;
> > > +}
> > > +
> > > +switch (bind.flags & VFIO_IOMMU_BIND_MASK) {
> > > +case VFIO_IOMMU_BIND_GUEST_PGTBL:
> > > +ret =3D vfio_iommu_type1_bind_gpasid(iommu,
> > > +   gbind_data);
> > > +break;
> > > +case VFIO_IOMMU_UNBIND_GUEST_PGTBL:
> > > +ret =3D vfio_iommu_type1_unbind_gpasid(iommu,
> > > +     gbind_data);
> > > +break;
> > > +default:
> > > +ret =3D -EINVAL;
> > > +break;
> > > +}
> > > +kfree(gbind_data);
> > > +return ret;
> > >  }
> > >
> > >  return -ENOTTY;
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index ebeaf3e..2235bc6 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -14,6 +14,7 @@
> > >
> > >  #include <linux/types.h>
> > >  #include <linux/ioctl.h>
> > > +#include <linux/iommu.h>
> > >
> > >  #define VFIO_API_VERSION0
> > >
> > > @@ -853,6 +854,51 @@ struct vfio_iommu_type1_pasid_request {
> > >   */
> > >  #define VFIO_IOMMU_PASID_REQUEST_IO(VFIO_TYPE, VFIO_BASE +
> > > 22)
> > >
> > > +/**
> > > + * Supported flags:
> > > + *- VFIO_IOMMU_BIND_GUEST_PGTBL: bind guest page tables to host
> > > for
> > > + *nesting type IOMMUs. In @data field It takes struct
> > > + *iommu_gpasid_bind_data.
> > > + *- VFIO_IOMMU_UNBIND_GUEST_PGTBL: undo a bind guest page
> > > table operation
> > > + *invoked by VFIO_IOMMU_BIND_GUEST_PGTBL.
> > > + *
> > > + */
> > > +struct vfio_iommu_type1_bind {
> > > +__u32argsz;
> > > +__u32flags;
> > > +#define VFIO_IOMMU_BIND_GUEST_PGTBL(1 << 0)
> > > +#define VFIO_IOMMU_UNBIND_GUEST_PGTBL(1 << 1)
> > > +__u8data[];
> > > +};
> > > +
> > > +#define VFIO_IOMMU_BIND_MASK(VFIO_IOMMU_BIND_GUEST_PGTBL
> > > | \
> > > +
> > > VFIO_IOMMU_UNBIND_GUEST_PGTBL)
> > > +
> > > +/**
> > > + * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 23,
> > > + *struct vfio_iommu_type1_bind)
> > > + *
> > > + * Manage address spaces of devices in this container. Initially a T=
YPE1
> > > + * container can only have one address space, managed with
> > > + * VFIO_IOMMU_MAP/UNMAP_DMA.
> > > + *
> > > + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed
> by
> > > both MAP/UNMAP
> > > + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2
> (host)
> > > page
> > > + * tables, and BIND manages the stage-1 (guest) page tables. Other t=
ypes
> of
> > > + * IOMMU may allow MAP/UNMAP and BIND to coexist, where
> > > MAP/UNMAP controls
> > > + * the traffics only require single stage translation while BIND con=
trols
> the
> > > + * traffics require nesting translation. But this depends on the und=
erlying
> > > + * IOMMU architecture and isn't guaranteed. Example of this is the g=
uest
> > > SVA
> > > + * traffics, such traffics need nesting translation to gain gVA->gPA=
 and
> then
> > > + * gPA->hPA translation.
> > > + *
> > > + * Availability of this feature depends on the device, its bus, the
> underlying
> > > + * IOMMU and the CPU architecture.
> > > + *
> > > + * returns: 0 on success, -errno on failure.
> > > + */
> > > +#define VFIO_IOMMU_BIND_IO(VFIO_TYPE, VFIO_BASE + 23)
> > > +
> > >  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU ----=
----
> */
> > >
> > >  /*
> > > --
> > > 2.7.4
> >
