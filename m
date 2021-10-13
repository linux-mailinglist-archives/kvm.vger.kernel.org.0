Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BC642B8AC
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhJMHRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:17:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:45882 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230354AbhJMHRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 03:17:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227263332"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="227263332"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:15:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="715467995"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 13 Oct 2021 00:14:59 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:14:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:14:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 00:14:58 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 00:14:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kADTAgs9eHgfHccwrXkLO43UbQ5YsuJL46nkk7YJk1wIwenhsh0kRHtEnI4DBKEWSICHeEe2bRUXriTwKhJJJ2HYdW/HZDVvyScjKkJoCPXxy1KOPqMgtSj9GVkLJuBPsVlW3HtMF3Zo8+dGoTbRIGsEWo6SZJwH9LIFnK1sM/FYZMguMw/ADsC5jvhGT4noTfI93PlXhetVSYKwUMZ0AKDb4UfsnfDFaHkeUNkVxKguufpcVTFBLXS2CURKk6PesRn2uAB4L0b05gcocpB7zG5G/ZTQW+332OpyIJKqHnaIH+iCH65fyhd10d8t8EvHOOo1spkNOKkfS7U/ayy/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2a1YuFccPDuGmCBrG2gmTcDOxxiL8TzfYmyNT8564zA=;
 b=W9TspkZBSNgTGskWfT+FmidYweBNNnTa8B0PEUPQzfJa8Si27JcAP0ed2gwtBKbulSMP5AomMPLDkSrWqW3oHHCFRupoBqJP0BYXC9RN/b5OM5bvX4k8ixEnHthuQUUbYpGBXprjC6cdfb59Vitx7Cl8eddV2icmq7iv0wlZQKbOO92ut11LHIm1oDvA/1mZWY1MA7mjmKDcZqFSkvRNZA0Et0q5XKCGR7HOK3U5iMnQcTTuwLvmNmQXU7v+RcTGwdA4Olufdex5/IMC/ONAuorUwp6CwduXyjoQFLIoRwVRELU9yNhImGtVb9C6QrRIvWKf159MsinrvHon+g/bDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2a1YuFccPDuGmCBrG2gmTcDOxxiL8TzfYmyNT8564zA=;
 b=ZCTznsNvyXx2Hg8g8r0oT4AXpOlAMvii18lG+OcWVXtRNvWBlNj7gS4xuV5MG2GitV8y0ATUbtGMt/bq3fIbxgDtIrdE429idFlq1P2GD+btfZkxnCs45dnhXkbP+7pl/CsNJt4hglV3/aZnS5wjwvz0IqdJcPdM6XRsgacJ2zI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3842.namprd11.prod.outlook.com (2603:10b6:408:82::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 07:14:54 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 07:14:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66uuxm8AgA72WACAAGbxgIAPTQiAgAAu7ICAAPgygIAAlZ0AgAF6T2A=
Date:   Wed, 13 Oct 2021 07:14:54 +0000
Message-ID: <BN9PR11MB5433C0D532DA55D4584216A08CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com> <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com> <YWPTWdHhoI4k0Ksc@yekko>
 <YWP6tblC2+/2RQtN@myrica> <20211011233817.GS2744544@nvidia.com>
 <YWVIagFiOtXTGMQ+@myrica>
In-Reply-To: <YWVIagFiOtXTGMQ+@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e8011f1-f3ba-4428-7982-08d98e1927f5
x-ms-traffictypediagnostic: BN8PR11MB3842:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB38428E39A8183C15F6592B908CB79@BN8PR11MB3842.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lmSQvsOw5VP8PWZACp/Z2XQEEAEvymxhxsDWgq8PhWpaKcZUN87BdpmsZy0Hh+tOLcDuVZxqr1ili+yDq/+q220GdbHyoWs0qqf/nj+xOEJYv9iCAsNgtoSym5Ux4xCH7NcJQrijIIg+RPRX6xKk+tf6iJXlNrEVfBP1oyw0n6wId1dgKESUspb6EABDmw6WcnhIj5Y+hhsEzjVkbUMaL3SCAAzwmoO4k20G8bUA78PwrOrA9+t6BdJiktxTKervLEJejHrEPz+5wjTD4NAib6rZrz21WSULVvCf7nNQcDg2DOp/MOOBkbkZ9HergAncrqebDTTPpfrF7vOYIWKtBl1XwLDRWGDK5oups4yrCb5B6uenK2dP4VJdZ6BSI+sl8NJQRGbPBld6cbrqM0yXGjowul7o8sOVh3ObOtIdj3JbOToxjTkIGowx4bcbv8BMK+nLkBJs2n1/VrWKNs2uv47AOxzJYFYqqVecCoBPABDuqbsgHbDa46HIsb6lEtiOBabc/OBErRMRkNUthmRE45LHpa2FU2N/ZbsUKaR/ndeP3bosNQSkRV4NcGiBN3mOQ2pz4YgOd3K4r17Ovf6muFVlBumImjuRLk9Yk0kz93U3umqaDD/evZskwrMYQphdSvAvIw/0hV/rEpN6a3skI1ylNFt5kICQJluiPCi93zdzamwMLGMj5TuZQQ3paZqm8FIW4gpjkYo5l3bCE2I96Lh9p1Mi7lGvnMg3P3+MWQ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(71200400001)(52536014)(9686003)(8936002)(5660300002)(4326008)(82960400001)(26005)(7696005)(186003)(110136005)(54906003)(55016002)(83380400001)(7416002)(76116006)(508600001)(64756008)(8676002)(38100700002)(122000001)(33656002)(6506007)(2906002)(38070700005)(86362001)(66476007)(66446008)(66556008)(66946007)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?whm1gUAE2WbytMwW/qR0lNMjxIiKb60GJULJaWoKKmvQT5EgMiHD5trQWqQm?=
 =?us-ascii?Q?lSPhrAUrtWuJIXDmEZvj2cNiV3Rndfjn97GK0AtoSGIzP5fCmzMUmeL6I9Do?=
 =?us-ascii?Q?LSIk9UIDg6lelceDYOER3qJxmK9woCJMrp0epScrGJfPMrX7oY7hr5RS12Dc?=
 =?us-ascii?Q?j5fjfPCJX0MpxDjYeGbACADaYbgyfN0M9XKGO+PpHdCD/xc3N5yn2SczSC50?=
 =?us-ascii?Q?57+OMSmHRW29YiKXGJXUrgnYlqmeG7Zw2fAHytXBLSW8pqMH19fFQvruRm5h?=
 =?us-ascii?Q?eiA5T8ceVyyofsYHgf9WtYK1CUxUkKZCyMU97S/M4eS+ko4mjE0vr7CUOkvB?=
 =?us-ascii?Q?avSbZyACcbA5iaXZrSv7LJZtitx1pVAk/rZZhO0R5HQzCiHOX0Ah8LZntTC0?=
 =?us-ascii?Q?gL2WhHs54nXG+sNk9qAOkwoqtpiY3fz7OwfM3z6PcTdt74MX6hDVbkBwSz8d?=
 =?us-ascii?Q?oDSleb0kPB8cSnIkSTFAWN8jUZ8x7Dp3IkgZbvb8t+JnS7fimrzx8S66YMS6?=
 =?us-ascii?Q?0COyZv80NQWrKGUJuTublGb8bkzia4lpfp5ylLYe232jEoOx4cUGnakYX/BR?=
 =?us-ascii?Q?66zs7wZB5gUAkG4/nWBEPT7gRjG0cb5ZRXDteXBw7X4buLUeTZc8sCF1RPxk?=
 =?us-ascii?Q?qQuLSQGa2Tsk3VsC0nttD+jg9L+AOqZxNOhKHHSJ5pGOm/dvfoFdYXr3rdZN?=
 =?us-ascii?Q?lm1WhkUFwEnfdOxoxNRGxTf+sNOeNTRPaHhUHyEZwBBPTgJ1XfSsz2XcAyM7?=
 =?us-ascii?Q?4UhO202j4W3Wi4nRJwr/pWajDt/kHXm4ZhUgoJQ0NyVyncrO2HhXxYucTbb8?=
 =?us-ascii?Q?dr6o9PYhv6hnSqX1LmLSpYQXN4Zk0DFn35pd0CizqfQFJsMDKXzEgExWIGtK?=
 =?us-ascii?Q?RXT1bLyr8P/Zs3LkdO7L12iCY+80sLoOtCEuVRj2EqHCExR6z3Dt3fl1cYJG?=
 =?us-ascii?Q?CWLbsEoRykiOQHSqQ4g3KP36h6XzeKt8GlfI+cxtDDNmfeyqsfHLF3Avvghz?=
 =?us-ascii?Q?bviiZcdS8T/HHtOc7klTv7emDnS7oSVUDEUXT1KZM0pi5MIP5g4OL2o+z0Vm?=
 =?us-ascii?Q?IsUf6IsG+2YlbWv9z26gUgMjtGV+R/rcRazfKIpu6RP6ZqvmhJrhEkEQ4sFu?=
 =?us-ascii?Q?g1leNTjmaHm6Pf/LEsIl/vugDY80lqpPEMq4TAYPuUcbwmUJZaCqqBIEyCKE?=
 =?us-ascii?Q?aRFMf96nddRCdrA6b7cyXX4qjkoGmm3fVFwe0akcWK+SUq2lJKov+Q/q+sx0?=
 =?us-ascii?Q?6JIwbVvi+g1mdZ6lWHecoj34/a7Xj9QKLONjKos1C7LRrb1ZpbMbETp3heUZ?=
 =?us-ascii?Q?nOmvR7MU5cSKHk/3oVxzAyp6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8011f1-f3ba-4428-7982-08d98e1927f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 07:14:54.4744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mhnui/T1d8E4rWegezub3UQQQVmc1/ElVYjIjXCZF4DJDFVmWIo0y0gFRm8Rxewgixf3bO1L9GcOvuSJF21/+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3842
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Tuesday, October 12, 2021 4:34 PM
>=20
> On Mon, Oct 11, 2021 at 08:38:17PM -0300, Jason Gunthorpe wrote:
> > On Mon, Oct 11, 2021 at 09:49:57AM +0100, Jean-Philippe Brucker wrote:
> >
> > > Seems like we don't need the negotiation part?  The host kernel
> > > communicates available IOVA ranges to userspace including holes (patc=
h
> > > 17), and userspace can check that the ranges it needs are within the =
IOVA
> > > space boundaries. That part is necessary for DPDK as well since it ne=
eds
> > > to know about holes in the IOVA space where DMA wouldn't work as
> expected
> > > (MSI doorbells for example).
> >
> > I haven't looked super closely at DPDK, but the other simple VFIO app
> > I am aware of struggled to properly implement this semantic (Indeed it
> > wasn't even clear to the author this was even needed).
> >
> > It requires interval tree logic inside the application which is not a
> > trivial algorithm to implement in C.
> >
> > I do wonder if the "simple" interface should have an option more like
> > the DMA API where userspace just asks to DMA map some user memory
> and
> > gets back the dma_addr_t to use. Kernel manages the allocation
> > space/etc.
>=20
> Agreed, it's tempting to use IOVA =3D VA but the two spaces aren't
> necessarily compatible. An extension that plugs into the IOVA allocator
> could be useful to userspace drivers.
>=20

Make sense. We can have a flag in IOMMUFD_MAP_DMA to tell whether
the user provides vaddr or expects the kernel to allocate and return.

Thanks
Kevin
