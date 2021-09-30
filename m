Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE341D672
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 11:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349438AbhI3Jhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 05:37:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:19122 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235235AbhI3Jhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 05:37:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="224803076"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="224803076"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 02:35:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="655835552"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 30 Sep 2021 02:35:57 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 02:35:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 02:35:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 02:35:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 02:35:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpk09vFQZg6lDN8QFyMRFaKhjzxM/gb5NGbfaGjgdlg75Jh5YqyDIB8Byufh6E0gdkSIWZIkNyy1UoXuA5U8yYhV5eCwRYo6TKnbRytI9z8QmGbcaDUjqa6CzHxQNEzGAVysNlUv/MLnBGT6xK0CRPXYTKQ4hAkQUlrat1mssoeiY0KkFu67xvE+mQSgrItE8qjQzzMXG7SqXnU3rC92d7+hh4aC4evVdMk5iq1sc/M1XO6q8u1HVDjUgesFiYjhRDcTWJ6UlgJbZ660F4ZLC9B034j2ZB/IY72B1DMHbd+xbSUwoKA/SG3wpZUaZkSNaBwu2o0PbqtRnVjXbSV79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jtu7wxfllsgfVSJIEE/4cjRjaZo74CzX+qxSB+xf9uM=;
 b=Jb33Ysf38lpy63lxXYb3u6bVfJ1Puck9aKNEEZ48c9NlvtJ6psiAg7k+RHrHjaCmaPxVX4G5/eGuXYaYAF0Otq0O+A+hk8FdxE/NZ5QWllTwyKiFsN12UIE0zwxpkbp3r2CXS10I12imm/AtLBRglF6Cp5Tz6cmUakQAjEsAej7pD0K0hgg9mYa+27aLuIlZ6zkO4WR2ShUxiCY4+FBi5Bw48VGG4Dnbg0EBjoK5K/s3vVlHaQDVOUQRKvZMaHEZKrlkjbOglc9t3S4xdM/AFvfS1jojwWoEelxyXjlv1X/7eb5MPSn+maUSAL1upBaqNgWOwTUsD5Zcdn3nbQGkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtu7wxfllsgfVSJIEE/4cjRjaZo74CzX+qxSB+xf9uM=;
 b=xWUQTj/ttwDfg0QRECgBGQ4EA+Jn86LyNl3UlfJtLvtipRypkB0z2jShO7sBvim8m0191nu37x3P1fNViijlU9+04ppSY1gjudif84iGrLaB5NUvxJ/tqKEiHYEmnBvudzuvSbBku8d65T0gokqvoIhlNBqBFXZkD4w8asdL2LM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4100.namprd11.prod.outlook.com (2603:10b6:405:7a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 09:35:45 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 09:35:45 +0000
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
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAEL4QgACKr4CACtdfoA==
Date:   Thu, 30 Sep 2021 09:35:45 +0000
Message-ID: <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
In-Reply-To: <20210923114219.GG964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96c83a2c-bf75-435e-2857-08d983f5adf1
x-ms-traffictypediagnostic: BN6PR11MB4100:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB4100260F0470FC261ED19A5C8CAA9@BN6PR11MB4100.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hqaPdq4gvBxqqB35DzxC3VPdOu1DSsvCAzZXKD9k99ZKE7MCewPpf6Ls39A/018Ea8UQPh9mThC7fkZ1y3wrV6wUaS6GYSWHHYw/+YFoBDLuRiP1Nev//K2jRHb1pug6IRi2iLPbQiuQHTEyRxYnsCU+00EauFXKLwKpxx6t/cUfPH5oZtCt/RPqeWu97sQuI9Z0vMxSta9PM6XQh+a002AeAf8365Hk7L1SK4mQgTD9UtyZpwxmHge+6ck5LmU3x6ThCQGPJn9v+0rx9qgH6lXLQHu6rX7OWBUaxaMuzrjcwfXm9XqkrAM9KfnMgp3ZWguICxHjDUZH0BzPAfSq3TQ2PdPmp5/CWoR62eXBuPKxYiX01uhuv6Gh4nto/Yjv/JPKQ3LiWHOV8cxGX4rtSmrC7fOHd5mlpk+qPJeuhQj2VH2leJ0J0wPr3K8/a7zudbw10pG03Q3w428U74HbNMmmzUyQKVysogIS1iLUNEhDU2jeoIWKeT5AIANWg/ChmB1E1TB8zaDqNaKkjOn6LhTxOgfnPL0pwsQ4pmqzRsjsYwk9Nre+sQJkAsQY/+BqHpdxRTDKJT/UnDDvMZKqslZEBPgLtwFQOnAFrahDcVxRXXcQXnSpU6YKDZtoNAJ6ze1xt4uHIKMWF/mE/Z35UdtUOVNZCQBf1bvB/ddtNMTe7ynKZdhb+dZUZdDa9Tepq9M6X9WlkwxX7bCpwxWh2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(66476007)(66946007)(66556008)(4326008)(33656002)(38070700005)(52536014)(86362001)(6916009)(64756008)(76116006)(5660300002)(66446008)(71200400001)(508600001)(54906003)(8676002)(26005)(7696005)(38100700002)(186003)(9686003)(2906002)(316002)(8936002)(122000001)(83380400001)(7416002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ehAwFmgAUQOcaKPxTSiKuk3npF7GnmteAKEA38X7JoT2tlgrFfUYLoa9Ej+7?=
 =?us-ascii?Q?22GI2acfCf0qblH7c3mM2aSpaTi1G3frf7haL7gmdP6/dV++ALllXiUYMWsd?=
 =?us-ascii?Q?LiTJYiWiHZzKxioL1ACKUlrj+UZ+uJYmA8K8u9FjmZZIBfHeC+hNwHbOJwbw?=
 =?us-ascii?Q?sVpsCbt2cBYAcFEWfjsIVbkm6G1eyg9RtJnHqTaHHPFHFLBkqMYSjdJdEUiy?=
 =?us-ascii?Q?efNkdxKgxbzqTTKF1lBIu5NxAnIFDQKMx03q2cxtXcGqVkVxTdHmyFm/oUes?=
 =?us-ascii?Q?UaRZU3aWNuHys/beO6aVAhmU/otenTB2xG1FG1csFqcG+NvaioEeZ40zs8FG?=
 =?us-ascii?Q?XzNuVc/CvHHIyHmdHDQwRx85KBIdJqo3Rge30hR/kI/atWDgxV1EhzIaWVt3?=
 =?us-ascii?Q?OWtyV0TiqssUEPAsMRK+3YhW1qHLnS8CsMGXz6TxgiOZE/IbIcvXtE8Q2fxg?=
 =?us-ascii?Q?u7B6Ojd55k9rFpFyLSFpCqroJExprYiagIbVuCNkwo7EAQczcG/pqQ+bzSiU?=
 =?us-ascii?Q?dc7+FcDZmuWLuBLsR++bgh8oAH16iui3GNRik4yJJRhsoaG9un9oKB4oFBDj?=
 =?us-ascii?Q?lG/bsFYMEqxN6XvrEpijUm900tjHIC0BWuqxE72Q9L+QGqR2Cea7J3hKUY20?=
 =?us-ascii?Q?fBNQ5ZBLG23vO/ZgenCzDKTsxHRvmRI6QKCMWEIRlc0wtlfZRqbhmNX1e3xq?=
 =?us-ascii?Q?TyhvuOUJCdLiQXHY7PIkLXfHwjsAWBi9SQsQUKGr1SnGXeGICnGXIUsZ3Y+E?=
 =?us-ascii?Q?AcFqBrLk82ohncSsyh3wm34jODqH4hBWRDre0ZWjhmxRHfrcxWm05OnhthXO?=
 =?us-ascii?Q?r6C9UggnPgB67aZjt+npZiqXpYsMHvx0OhAU/bMseXRH2eonVxjjvGIUQVTt?=
 =?us-ascii?Q?DTaLK61x0K3RPmefwWJymkKgJWw5Jlbyk8hVjCxdFWhlTzIQk6sXJjaRPXhk?=
 =?us-ascii?Q?9sZQUogrG6fU3pZeIQXibx506Nj2jxoP0o+4u7paFI5w49ziGj+ZvlsO0ZPq?=
 =?us-ascii?Q?Z4PJOqkLx9p7Lty4WuKb6zbr8e/Z3nt3Tn9mOO4uNNnw+cxnuvXiNJnzvSs/?=
 =?us-ascii?Q?Hhzb6SMDg6ojKOPnuK/U1WbyNBZWu3s46Hlnm0hQMBjqJpxOdS+FR2e6Relg?=
 =?us-ascii?Q?mSNcwuCHgcQ6Qcgt1LZo6emTVZCvEQvJUQLg1Ie508wM4llwcTrL9L2HcMxH?=
 =?us-ascii?Q?37ZVgfxeHcG90HGcRy3ZLu1XyihrhRhiCq3lzri+tdbscEYCSUOdVxiKQ5go?=
 =?us-ascii?Q?PiCLeYg8qwA43EmIjFghc5j3I+4cvpfLa3hfUeisFb3XgqFJkZXMqFecF0/0?=
 =?us-ascii?Q?+ORXdLiSRWShIdewRCY8gwme?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c83a2c-bf75-435e-2857-08d983f5adf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 09:35:45.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Ty21Z5IRl20xc8vQBI9Dtic2iB0l3SbAoWwUJaokamRqs6ZeKW7+gkgbvoKXQNnCAP1DSwgJDKOj4dUAILqVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4100
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 23, 2021 7:42 PM
>=20
> On Thu, Sep 23, 2021 at 03:38:10AM +0000, Tian, Kevin wrote:
> > > From: Tian, Kevin
> > > Sent: Thursday, September 23, 2021 11:11 AM
> > >
> > > >
> > > > The required behavior for iommufd is to have the IOMMU ignore the
> > > > no-snoop bit so that Intel HW can disable wbinvd. This bit should b=
e
> > > > clearly documented for its exact purpose and if other arches also h=
ave
> > > > instructions that need to be disabled if snoop TLPs are allowed the=
n
> > > > they can re-use this bit. It appears ARM does not have this issue a=
nd
> > > > does not need the bit.
> > >
> > > Disabling wbinvd is one purpose. imo the more important intention
> > > is that iommu vendor uses different PTE formats between snoop and
> > > !snoop. As long as we want allow userspace to opt in case of isoch
> > > performance requirement (unlike current vfio which always choose
> > > snoop format if available), such mechanism is required for all vendor=
s.
> > >
> >
> > btw I'm not sure whether the wbinvd trick is Intel specific. All other
> > platforms (amd, arm, s390, etc.) currently always claim OMMU_CAP_
> > CACHE_COHERENCY (the source of IOMMU_CACHE).
>=20
> This only means they don't need to use the arch cache flush
> helpers. It has nothing to do with no-snoop on those platforms.
>=20
> > They didn't hit this problem because vfio always sets IOMMU_CACHE to
> > force every DMA to snoop. Will they need to handle similar
> > wbinvd-like trick (plus necessary memory type virtualization) when
> > non-snoop format is enabled?  Or are their architectures highly
> > optimized to afford isoch traffic even with snoop (then fine to not
> > support user opt-in)?
>=20
> In other arches the question is:
>  - Do they allow non-coherent DMA to exist in a VM?

And is coherency a static attribute per device or could be opted
by driver on such arch? If the latter, then the same opt path from
userspace sounds also reasonable, since driver is in userspace now.

>  - Can the VM issue cache maintaince ops to fix the decoherence?

As you listed the questions are all about non-coherent DMA, not
how non-coherent DMAs are implemented underlyingly. From this
angle focusing on coherent part as Alex suggested is more forward
looking than tying the uAPI to a specific coherency implementation
using snoop?

>=20
> The Intel functional issue is that Intel blocks the cache maintaince
> ops from the VM and the VM has no way to self-discover that the cache
> maintaince ops don't work.

the VM doesn't need to know whether the maintenance ops=20
actually works. It just treats the device as if those ops are always
required. The hypervisor will figure out whether those ops should
be blocked based on whether coherency is guaranteed by iommu
based on iommufd/vfio.

>=20
> Other arches don't seem to have this specific problem...

I think the key is whether other archs allow driver to decide DMA
coherency and indirectly the underlying I/O page table format.=20
If yes, then I don't see a reason why such decision should not be=20
given to userspace for passthrough case.

Thanks
Kevin
