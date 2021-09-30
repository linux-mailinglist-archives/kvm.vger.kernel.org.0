Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB041D5AB
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbhI3Iuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:50:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:15625 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348335AbhI3Iuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 04:50:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="225213212"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="225213212"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 01:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="521136575"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Sep 2021 01:49:11 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 01:49:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 01:49:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 01:49:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 01:49:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijCB+WzxJYTKhWrcm4OmUs/MZvVnSvdwnWZrhVeO2VScJr+4X1xJMfAM3xtLzdWO+tg+RpQPmU5gGa6mwi6GyAzft7iUDXz6zuoFLtLL/BtlxeDEzqSyuMFa8fUf5xFzqeLLDRHwk29EB3tTNr8npt69+ifsO4cwB9u/hVBxA/pfdHg6twLFkmo4zoErAvegaqDf/4hIFd9Z+96xNFGNXBeoz3sw+qZ7lPUWo/PD3rlYf/vKcvarQ3yaML4cDwuo5Qnbn7UiaSGxX422cyPUNht+iX9P/1u//GWDb4syL9lO4j/386Bxqxkybs664e7S1lluvrQeBzXhaP2eCatsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5VHI+4DLKk6dWUhNTtcdy6JYDw7zGm7GrQAsXRt2ORY=;
 b=nrOsD+1m73LjCSUmJ06zSPJUa4YQ0J9fLav1rEiM6YfQhcUcmL8+4sFQNsZwgtVKNu0l+FXboM108vBl2OJnt3FLOYbk3roqLXqu8KaHb8gLEEmff2dsH3zS1Hr5OjatAxacXETkcmeRUM3abmx+2eh4817cmZgo+8lQALsS4blJ89ith+JsJJeUNcbmDQiF0C5lLSmhDU2jbcoEjy7xaEVzDXm5Hu5x0nMB5CSW1cibb+R74hiDBQJ/28SPK+HOadnFBZcHku5eZuov2RtuJJVXzu2Dl1DYA6dAas3YvbGhtYD0JNFX6eiqXfMjblWJzFefBqfG47qDD7eiMWX36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VHI+4DLKk6dWUhNTtcdy6JYDw7zGm7GrQAsXRt2ORY=;
 b=wOCbnoqqJYH6dJO3IegxITz+wK37zq452oQ0qYEHCvrnqJ+MqseABD3kyCiLKNbrRzmYJwCJfXu6IdHKzrpz2/F2VViplBup2VF8jdPDZPcrmeVUl2Uxktt/jnbxzJNBShF+kadzdUZAZAj0oJYernteEvTjFdZGExXpVMSfPpc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3764.namprd11.prod.outlook.com (2603:10b6:408:90::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 08:49:03 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 08:49:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Lu, Baolu" <baolu.lu@intel.com>
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
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgArAWrA=
Date:   Thu, 30 Sep 2021 08:49:03 +0000
Message-ID: <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: a9ee9a22-cfb1-43c2-2d72-08d983ef27b8
x-ms-traffictypediagnostic: BN8PR11MB3764:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB376456C48D3F4CA53BEA44288CAA9@BN8PR11MB3764.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3EjEus8CUB63q8uA5K+cM5Aq5qRBg/AN+jvA+M9nNUC1pA2B9N0s4tzKns+qcuItXIc24IHYnAr2t4H/rzdSG1PxuduJkxhUgIEQC1Uv6Uyz20eNJ2a6NfrVkC5LjQy77WPvH5pkugSy89JU64ERBHcRStv8qrxp6SFsY+2eI4OFKQ4cNUOdR+uRfMPm0T/GDCJQKcrk6eOndKS0Q+onigMPLAL2MfFqgWZSI9yBYsQCjD1Io02NiPvGleWN+ZbBYVoMofXCK0ooMXpxi1Zt03tFmC3fGc6hogyhZQVU2Gr5L8N0eWZ1P0jP5nOKvQs98SsX0vNaOA8y4Ut+EliwbNUI/q1pmkzO+F6sCn+c+lJaIccNXoQPL0P1tr5io+E8u4mUfI93j66Fch/13fAOE3VizUGZpJ1uV2z0tkdR6oIUDOvflnCLVjjbd/pFU48QX8nWHoj3K681mwZSEO8Ypni66MCsfLogv1bkqFnFGol4/Kqw8s9QP/3XlB5wcOilFx++0ynKrCRwzuYHLu6VQxGNbxKCnYup0e15HEHRZiQW5VG7o/3Kz1wHBBAG/jfYOIFTh4bkdtIDAiPVB9PyNvzcZ3u0M0T4u1g9UbWgjxVxJS03RyHtgxTzWEazmaJbBhw6qY1R6qm5U8kNGXU5zsxIWTUYPCsHxK1hRf95NY9DumleOCvX+tdUw5Hn3OLEF54Lj7thgWwoPBhGT04GWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(64756008)(7696005)(2906002)(66476007)(86362001)(508600001)(66556008)(38070700005)(66946007)(76116006)(55016002)(9686003)(6506007)(122000001)(316002)(5660300002)(186003)(54906003)(110136005)(7416002)(8676002)(6636002)(38100700002)(52536014)(83380400001)(4326008)(71200400001)(33656002)(8936002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2moWwzX1xIWu3/6sNGSLWS3MTPfxyVfjmjD5JBEFcFLGRIMNQSFBmmj5DCJN?=
 =?us-ascii?Q?ucMEyZlgp0yCcid1xSTyjA6s/K/4DD7I2JVF0lUn6bsyRcHrqC3tigiSaRRl?=
 =?us-ascii?Q?iUGy8/tjCeYldppO61Ylj17LzVpu6nfoC+GDbTC2Z7lzPVG+ixJT2SqQS86/?=
 =?us-ascii?Q?iEEnKzqjdUxaEUDMlaZhL1ahrRY2wMAmGGkVe6lMSRD4ieVdPJnEfDe4OP39?=
 =?us-ascii?Q?Jj5wK4TkIer1acb9MX/29IRZNgZomyU84D/GhMqLVO04d+CdRSToUP1zUwau?=
 =?us-ascii?Q?ELcF2N0hyQDWJHU5uvkFoQ8rIhKS33tMryrMyE+9esekojHX4TUszqF98mQZ?=
 =?us-ascii?Q?0W8CaEHgUiNP4j/SNBMqw/c/40aUXDo+cKMFsgj3vW0yOxPkvTLwTYVGVqx4?=
 =?us-ascii?Q?uzHrWJdGcEeYT9HiUNFBI/Wku8coajhA0gXwJrKEaVmVeKy5T/QEhfBWB2Us?=
 =?us-ascii?Q?uiKKI6QB478quT2qUTmb+9cuOQcDDe4zlmj8lRzOVEogwqTex2qroYjLWyBh?=
 =?us-ascii?Q?rrhUtIiRsomMU5elkeV/zCWpy1LwLDfpY7NcCe0uYEKCn0igLChmjvLSLci4?=
 =?us-ascii?Q?yNV/F2corlLo7y/2MgTKCTPSCGD3BZGyNG5GCb2pj8a3tfcoKXRxnc5oOf8f?=
 =?us-ascii?Q?eDUeZhcK8QjeRtJw2XwjLKdWnttscA9C8HmeB50FqZLTEsYNFEQ5mRdFXN/J?=
 =?us-ascii?Q?CvuY/Uls3xBwXuIYe5vO1blfIojbaDEdB/FIq35G5kIGuTqNeAPiopIL4aoD?=
 =?us-ascii?Q?GvXrVXtQ9zMEYXnbquQU7f0sT6J0E2COd2jDtLJs2M2gEh8fEIaWvzEeo3CK?=
 =?us-ascii?Q?YGvlqo2EOJhNu0iWUKmQoLpkVIAeco3syPgf5P4/4eLenKbs+EZKg10d63mT?=
 =?us-ascii?Q?pp+be2GZwAGIZMDu0GA8A5v1/e8Myps0rnnsJq1l0G1xYXYMggW7MUKdkjbf?=
 =?us-ascii?Q?uK9egLQslusWBETTpkcrsU6vr+ahAEvcGU6mSmKjBpxayy3/6E/kN8Zjvbk+?=
 =?us-ascii?Q?qC1oREXYFxF0NdaSVkQUr7HrK+dPvwlPmdMZwrzqbsnjEF/lzzFiQPCCcFQX?=
 =?us-ascii?Q?zCCRWvcROy/9j26wQJrxknyD5uvzglcjKAjruqIxD7W+3/1CQnegUnIUljY7?=
 =?us-ascii?Q?XPannS9IjDgpNDUtlWpGxkDO1r4qbgoGulPHT+ZffhfjXDeC7o6eG56rYr/D?=
 =?us-ascii?Q?qTZn0yHLDHsjuTqtTY1//rhvJsPJejo5czHXM9DBfrUlrVkCfSOEl3iwXEJv?=
 =?us-ascii?Q?PFbhuhMav+Kv9NZlHtwUGez/z94+NnJbXH1JYQ0kWHuPdJgZ5EHdjh479c8E?=
 =?us-ascii?Q?2sKMYk4seMNs2opXcj1deMpK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ee9a22-cfb1-43c2-2d72-08d983ef27b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 08:49:03.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vjS2p4SHKj55HAS3qBrcTF1uj5Snc7NLwN8lpLyROR3Ak4cu5Rn65H1JdJS95Udhgk8P2ufIs1F5BtUvj4Y3Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3764
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, September 23, 2021 8:22 PM
>=20
> > > These are different things and need different bits. Since the ARM pat=
h
> > > has a lot more code supporting it, I'd suggest Intel should change
> > > their code to use IOMMU_BLOCK_NO_SNOOP and abandon
> IOMMU_CACHE.
> >
> > I didn't fully get this point. The end result is same, i.e. making the =
DMA
> > cache-coherent when IOMMU_CACHE is set. Or if you help define the
> > behavior of IOMMU_CACHE, what will you define now?
>=20
> It is clearly specifying how the kernel API works:
>=20
>  !IOMMU_CACHE
>    must call arch cache flushers
>  IOMMU_CACHE -
>    do not call arch cache flushers
>  IOMMU_CACHE|IOMMU_BLOCK_NO_SNOOP -
>    dot not arch cache flushers, and ignore the no snoop bit.

Who will set IOMMU_BLOCK_NO_SNOOP? I feel this is arch specific
knowledge about how cache coherency is implemented, i.e.=20
when IOMMU_CACHE is set intel-iommu driver just maps it to
blocking no-snoop. It's not necessarily to be an attribute in=20
the same level as IOMMU_CACHE?

>=20
> On Intel it should refuse to create a !IOMMU_CACHE since the HW can't
> do that.=20

Agree. In reality I guess this is not hit because all devices are marked
coherent on Intel platforms...

Baolu, any insight here?

Thanks
Kevin
