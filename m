Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1A41C0F3
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 10:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbhI2IuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 04:50:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:58034 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244640AbhI2IuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 04:50:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224933999"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="224933999"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:48:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="486843474"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 29 Sep 2021 01:48:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 01:48:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 01:48:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 01:48:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 01:48:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKOFwumdWcHE7rwZTXUoiARya2WMq9KQl1HXdXvV3eDFtHQghZ7Tx8aHmguiTyFvxEouwAKylkqPm84U07nb8JVQJSG9VTszTXDN8/dI8hD5ahYhM9yhmSoWB2kc9CUSbu+TQ7vQQF/zcO72+1X6HtiZciLuIEIy6alyxf3GUKkbe6L5PZejX+2tYfJM4yPe3mXYU3JUNHufEZ3vAzCODNI3VW2x8BwGOMrSH4BhC51tuqMQ12nfV+u/3X+VGEIPKw0xUcKe/w3IWAMTQN5zlOKREc6hJ41kj2qs/GCghMOSCrg1kwJ+aP1B+INGtQCEqPMZrJCxIaKkkZdxGNuAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ljpw3bqQKHcRDOUizb/kBk8Z7VOBaPv27EdkKVRN5Zo=;
 b=CSbHCyEPJGINCSJXLofRJqgL7xGMA8VpVF1ZV4h+XJ9jR38dqLcw57tmx+7qIN6GSNaxR1zsoweA1ElS1Uq1By9/7nyj1UbLw6ije0TOc/u3iv6AT40f40PdbjT1KlIQNndQ5WMK3cooyQ1PW4n0VTuYVO/cu/Y28VtgxAMa3xzbqc3sPIxdvyK6nfZuCzGHIKydwS3EmnxBXHycrstea+wJSw5yhoOANRAPBdVLT8NV6+Zc/MufSxVGKAuF5jMHvsNlLF4j91v6hA5pKh4v/ujen84t84BxEVpgMi4xiKmxwoPf+sD+2/+awMzj3liN+GzdjiuFbF1/0DpuFimtqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ljpw3bqQKHcRDOUizb/kBk8Z7VOBaPv27EdkKVRN5Zo=;
 b=USGjn3CWzQt7D7sHGLzskIJy70y53wuAifKJky6IO/z8EgjQetDmWaOUDYgvDm4QCT7GBnpTXbWmISpZE/ehvEbu++ETtHeEoHrpyfFh/NUUFGuPsu6Jv+k8zIu54C3cJPwqvUa/HmaBEvXdx8TOuEKF1H5Kp4THXeEh3L0ujCY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2594.namprd11.prod.outlook.com (2603:10b6:406:b5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 08:48:28 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 08:48:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgAkqbYA=
Date:   Wed, 29 Sep 2021 08:48:28 +0000
Message-ID: <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
In-Reply-To: <20210923122220.GL964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4785c995-aeb6-4cf3-e78b-08d98325e83e
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2594EDCBD597B08F6632D6138CA99@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ke5DtxN7BpPnONMjQUYXmwTjfdYyzarRQL5g2Nkma8Fna8cKmXEeBmc1+3iduHCL0zYy/VCYosU97w5eyF/vOZfhkgeLmtqN19s1fpGsvaflOUHpehU1/13cJZfYk3PQlKR0SeV1e5/nxGz8qCAFOVtibnU4OSRikABzG8iGMrWbDFIPc1JqSVsdI5OUD0rTKZIlziG1MFJ/kSaqFS1w3tjbmI9ifTGtTc7JD1+hag9h3ZbpnFI7lyLZN3mL2gOgOTcItdOG4+Y/gM6iqzrNcnjA7NkVuVx1ZBKL3m3qNYQFb4PGfJ0s3qEfLCJ5Qk7vwj6ipVngsGCK3NwvDdazpAnnrU9UWy36ZT3+CAKkCLhYSskXZRbwq6bDC64wN4Jfm553pyLGfOLcU1rmv0Rw0NI040wGX6c9TuyFBWFpd768I+p7hjFuCaHxgDALxg4szQG2y6XPv3BiQX+AL6+HeKqm6OcPOLVyEbRzbalz4+QhL9Y+jsgyWErKt1ufHnI9FHKZvy4sNHOrdsRBc9NiYrhD7b27iLcYvDNBd74jWqVtLB12GbES6/Tutik+cL0TvZfz+NjZtpMyNANg33IwKmbFvpast0ZnZwJmPgXrQH1bGYGWGwNrIrlvGEs6Ozs76gFhPG/8TjV/qRF9OB91Ba5R72irSLdqJG58uj8BtJNVda9y2XQgnooQ2a0P9Jilvx6fLbkq5ykHr+fW5r9PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(66476007)(64756008)(5660300002)(26005)(86362001)(66556008)(110136005)(66446008)(76116006)(7416002)(4326008)(9686003)(2906002)(52536014)(55016002)(122000001)(8936002)(8676002)(186003)(508600001)(33656002)(6506007)(71200400001)(54906003)(66946007)(83380400001)(7696005)(38100700002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oTUszFfXuzYcI8Fpmrarkb0ifhipruO7YE70A9eKwg1CkQ4gEFbMQaY3pJGM?=
 =?us-ascii?Q?HB73VNnoMnQfjHZJDsCaXZjcpkKzc9vzszjKy6O0Ww/o44dK8ld/rkQU0BOq?=
 =?us-ascii?Q?gLZIyLyTkzXOOftLGJiFMEDpNV9bAIrVt2emrZvTe9Fw8wptkxtbfF5L+vI1?=
 =?us-ascii?Q?g6ycF6MrZjo7qsbeT3LI7xKuvjq63VHOmtfRslv7OnvBGgP5KEk6qvmKsgpH?=
 =?us-ascii?Q?H3ngTlurInu1+28wiNiYf3Dnuyi36XaHqzvrKZ9/TCV2BAJFC8tCdlGWU6Ul?=
 =?us-ascii?Q?fejUFzAD+qykqatY8IerMfohnximC4G2HQtOEYKjEETvejS0yF7PuS/62Nba?=
 =?us-ascii?Q?XqkWVDg+YZPZCnLXsmciYEhHD1+yeq0+rYH2XnaCsJJE8eW7oqYQDzZDCBhS?=
 =?us-ascii?Q?1mkJV78mrfRa6Y/DYtrra/XgH+3PqsvL/MAGbgal92xPJsNS9bjenZZQl296?=
 =?us-ascii?Q?33+tBIrgj4O9r7xa4sqklnGkxaq+YuKLfJ6v9XG4ykfPRGEZZtqydx65twpm?=
 =?us-ascii?Q?CxhqlaM5/HgsY7oedNZ9qsWmFtgzPHMGE77dLGiYjJDTUgYNPKSG6I3QhaMv?=
 =?us-ascii?Q?3v0J0GJaaqef0pZcknjwxs6s2EgbV1l5hlGpDrLgj2cLxKa25bs8T78AHi0x?=
 =?us-ascii?Q?r1gynX8f32SRTEd3TeSPT0MMi7C4gacKyudwf6oNY/UZ0DuTGUDR8iuwpsru?=
 =?us-ascii?Q?mPdr8my1nh+txxgocw19A8tSwJwdibo+VAh348XRzgnlRZx/kjQ9UAwJhQoj?=
 =?us-ascii?Q?cQqlwmYwz7an1jI0ptqtH6bgmnQomMCkKdxMS6JBjPBDURksmC8UlTh+9IOU?=
 =?us-ascii?Q?VB37syNNSfdhjaqT7Xv7DT2D2dycWmbFxlC6q+znMl25yta9BN9qZDoJd84N?=
 =?us-ascii?Q?Dic0at9I/zoy/N/vATdVMcGQ+wsgDmWTLFfRp3jEITdhVk4TEK5/JIkzoukG?=
 =?us-ascii?Q?5mhm2dQ0T76DTy7awsl+xrMsumaC0EAKDBO+KOqd+5rllSW1kf0nEFnK7l5I?=
 =?us-ascii?Q?eB2ECKcXSzlK72NSaQOy7iQah1wwaMQxHw5K6PxkMPMtJt2cKn6uCNhKdgD9?=
 =?us-ascii?Q?WXGNCphvMDXxAqLRmKHjIYIppJImSo+iER+5Qxm8OypRqzmlH/x3dY5AqMnp?=
 =?us-ascii?Q?0nI/1PYGdqJf5/35OvUjrCEiUacrJUY7Q8XLcP/Y345T65C6JN8IgcS5/0SR?=
 =?us-ascii?Q?p1zrU7Is7AKN71FOZ8KYMLKcMU0YVrDThXXSsAC8jgXaWbsgpgq7Liqht0GY?=
 =?us-ascii?Q?n8d5txvkw+fRLrD8VXL4B4ems4EENJOPmb7kBpM0PdlK2VskFHVmmfA+fIQN?=
 =?us-ascii?Q?Qv1f0jw6xxpH8omgDtBeyRPH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4785c995-aeb6-4cf3-e78b-08d98325e83e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 08:48:28.1428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qBIIu2XHN3COhkmo28i25aC+prjyjnmnGN08ecdKUc7XR2Krodp3AFj0pBr+iXTBdlmqKlTMX9Dm7yynXy5WVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Robin.

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 23, 2021 8:22 PM
>=20
> On Thu, Sep 23, 2021 at 12:05:29PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, September 23, 2021 7:27 PM
> > >
> > > On Thu, Sep 23, 2021 at 11:15:24AM +0100, Jean-Philippe Brucker wrote=
:
> > >
> > > > So we can only tell userspace "No_snoop is not supported" (provided
> we
> > > > even want to allow them to enable No_snoop). Users in control of
> stage-1
> > > > tables can create non-cacheable mappings through MAIR attributes.
> > >
> > > My point is that ARM is using IOMMU_CACHE to control the overall
> > > cachability of the DMA
> > >
> > > ie not specifying IOMMU_CACHE requires using the arch specific DMA
> > > cache flushers.
> > >
> > > Intel never uses arch specifc DMA cache flushers, and instead is
> > > abusing IOMMU_CACHE to mean IOMMU_BLOCK_NO_SNOOP on DMA
> that
> > > is always
> > > cachable.
> >
> > it uses IOMMU_CACHE to force all DMAs to snoop, including those which
> > has non_snoop flag and wouldn't snoop cache if iommu is disabled.
> Nothing
> > is blocked.
>=20
> I see it differently, on Intel the only way to bypass the cache with
> DMA is to specify the no-snoop bit in the TLP. The IOMMU PTE flag we
> are talking about tells the IOMMU to ignore the no snoop bit.
>=20
> Again, Intel arch in the kernel does not support the DMA cache flush
> arch API and *DOES NOT* support incoherent DMA at all.
>=20
> ARM *does* implement the DMA cache flush arch API and is using
> IOMMU_CACHE to control if the caller will, or will not call the cache
> flushes.

I still didn't fully understand this point after reading the code. Looking
at dma-iommu its cache flush functions are all coded with below as
the first check:

        if (dev_is_dma_coherent(dev) && !dev_is_untrusted(dev))
                return;

dev->dma_coherent is initialized upon firmware info, not decided by=20
IOMMU_CACHE.

i.e. it's not IOMMU_CACHE to decide whether cache flushes should
be called.

Probably the confusion comes from __iommu_dma_alloc_noncontiguous:

        if (!(ioprot & IOMMU_CACHE)) {
                struct scatterlist *sg;
                int i;

                for_each_sg(sgt->sgl, sg, sgt->orig_nents, i)
                        arch_dma_prep_coherent(sg_page(sg), sg->length);
        }

Here it makes more sense to be if (!coherent) {}.

with above being corrected, I think all iommu drivers do associate=20
IOMMU_CACHE to the snoop aspect:

Intel:
    - either force snooping by ignoring snoop bit in TLP (IOMMU_CACHE)
    - or has snoop decided by TLP (!IOMMU_CACHE)

ARM:
    - set to snoop format if IOMMU_CACHE
    - set to nonsnoop format if !IOMMU_CACHE
(in both cases TLP snoop bit is ignored?)

Other archs
    - ignore IOMMU_CACHE as cache is always snooped via their IOMMUs

>=20
> This is fundamentally different from what Intel is using it for.
>=20
> > but why do you call it abuse? IOMMU_CACHE was first introduced for
> > Intel platform:
>=20
> IMHO ARM changed the meaning when Robin linked IOMMU_CACHE to
> dma_is_coherent stuff. At that point it became linked to 'do I need to
> call arch cache flushers or not'.
>=20

I didn't identify the exact commit for above meaning change.

Robin, could you help share some thoughts here?

Thanks
Kevin
