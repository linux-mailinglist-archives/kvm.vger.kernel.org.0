Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39FA3CB05C
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 03:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhGPBXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 21:23:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:27904 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhGPBXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 21:23:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="197840749"
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="197840749"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 18:20:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="562970904"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2021 18:20:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 15 Jul 2021 18:20:17 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 15 Jul 2021 18:20:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 15 Jul 2021 18:20:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 15 Jul 2021 18:20:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlPNAYsNlf6r5R7iqb2CdlHwS41vW8+xhrTHa12iKwseD14/BpcN4qLNxpyv15W+vpUgLcwctdTdkTAuC+GCE11ve4pTaQR1mk50J+u/MfcIWQWyuiQ3XY9NHjWYrBm8X95lXZt0XAT3Z8y0Z7Cuicj/mbrWNuHlbymkb6H9LjKdRJyflqC7QSUifo2JYr96DAa+VekOew0cEkaVEQMXU3wh1g4/jd0IMz0x+4SZfspC7cZ+ZLeyWTzXHeCgn6bI3s8+rnSPx099J16qCgQlnXKxa9yo0Xsr/gpO0xoW3hNfCtvURpGHfM+iqeuumu4V3v22hJ1yisDsIogehrJIRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOSaREEs9e8S//pOCYaadfZEb9MbzpwBp2sE+j6RZcM=;
 b=jPSgiPoch9gKGYhjzkUlyF8dbYNX/2oSjRl4w1Larrir/g1wIOYTXyWCqMGFiRNc6sh9pKeDhzipMkwEMKOKMzoZQOSUdjWOwE52spW7dnKjcKY+XMMb2y1Y5Da/EbqvC+LIduzLaxkFQJ5et46f6p0HfPhFw5y/eMZmZP1ImSuMzcEYXmk376yL9j4i/VjXRAVvQ4EJ6iYl/aIrhkEBlyN2c8NwlZSKOLUQUq0sDn6G/IxPzdORAOyr6a2/A6RBtXqs9VBLN6HbTJh6bL76S2h7VPBUakJTYZx57saY2XwcDMvngFe4aalFLqngGANpNXASFtKNMecFZNgF9H2QGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOSaREEs9e8S//pOCYaadfZEb9MbzpwBp2sE+j6RZcM=;
 b=Xxat95FsHBbPR2TRXYWSbqD/B+LWc1Q4f8egI8Tg4iKCFypx1pCqZcSDNrKiUHOIUpGrEGpNitXIM5ILDzHaBeyAe9ocOWrj0Hd6J+52P+YfbmTlTVEKsoNTHSQFScqkSjb+pn8k8bnPrUdmHtFdS7abA/DHxbA1X+N9FAnWuFU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1459.namprd11.prod.outlook.com (2603:10b6:405:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 01:20:15 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4331.024; Fri, 16 Jul 2021
 01:20:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     Shenming Lu <lushenming@huawei.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQEkayMAAADgu8AABbP/AAAAaVlQAAzVHYAAAm93gAAC/CGAAAII8oAAAftjAAABDbYAAAAstAAAAGyhgAAARNiAAAwRJHA=
Date:   Fri, 16 Jul 2021 01:20:15 +0000
Message-ID: <BN9PR11MB543337BAEA86708470AC1E0C8C119@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com> <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com> <20210715162141.GA593686@otc-nc-03>
 <20210715171826.GG543781@nvidia.com> <20210715174836.GB593686@otc-nc-03>
 <20210715175336.GH543781@nvidia.com> <20210715180545.GD593686@otc-nc-03>
 <20210715181327.GI543781@nvidia.com>
In-Reply-To: <20210715181327.GI543781@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2e2717f-ea96-4d23-1ce8-08d947f7ddcc
x-ms-traffictypediagnostic: BN6PR11MB1459:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1459EEB86409BF18ADBED6298C119@BN6PR11MB1459.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+VAopXdj84963o9S0gjqFx2W5zNLemIX1RRpunyqRK09MxCni4kKL8QKyJetfDCmpM5RE4uZQNj5PSFpSNxGhaad1+f9SeIrbABjdvLxeq47Iey2MrdAqX+9XCl/npiRDobzVGZkPtrRyKNl6R+aSU1FuSzW0+D7vrqilAzIlFLlS2rkrn6xGBWe9LdMCDCD5R5sKt4f/aZr7vvYTBwO2sAr42B16F4gpt34p00WgMzuwy72Q4FG109V5IhyRYJrvD3W2ynpWRdZBIU7TkOZ7pM9uIPzHqUJNKOSMNpCPT7J5NiXdpheYsDkdIRhl5AHr8PrNR2QQuD/H76oiypVv33yMtRqSr9Xuvt7LRL7fuqV2YzVpk57mQvMqOehonhnLe1K+M83OctmmNRnpKzhWOxrNreB6JP5uzBDWRtMmPFeVPaCucs6ZZ28C934MuZX+Dv4CJ7rtTIwUoyDFihGe2HLunO6kYWq5n2qDQIOMa0hwMe7cIImcNLdrbmfvdmeGXnDt+Z6uTuOjjjrmExY1SrZft1DjFByu5fKiH1kJ7So50ZrTkazm8JQU7HvkFXaGsB6BMg4mNZr0DvwutULs9Mg5kfTG8rsRE/YZsDW0fgWuVe49NpLxEox4rXBEBgKZ/qnQGhUAheW61oDihcwWqDd2SfmltgR7VzWXN2dYslC679ofJr1LgFRPdKCEGKi/45CUkiVYM6QhYtoYO0ZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(122000001)(71200400001)(478600001)(26005)(86362001)(6636002)(7416002)(64756008)(38100700002)(52536014)(6506007)(55016002)(316002)(54906003)(186003)(83380400001)(8676002)(7696005)(76116006)(66946007)(33656002)(66556008)(66446008)(2906002)(4326008)(66476007)(9686003)(110136005)(5660300002)(8936002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4r7oLQJXU204YmqEVbcadRMGKoQRx1bhCyGzCLQCCinu5jbIDKjZqulGDJ8q?=
 =?us-ascii?Q?ufC/zEL8Ths8Fd1DqCFN/QiF3fVnbsx2WQjgaNc3jcArV1OkX6V/d+JeHviS?=
 =?us-ascii?Q?6lu/ncdFW54OXQYp2ihznQMwML04lvrAfIsxAv3galNzPrPlpyNGtJJrFhNJ?=
 =?us-ascii?Q?W8CXwTgMBtmiysnK4N1oZnIc/y/32Cbg0ql0e9qkwBP+gXDIqyhpym5iYeha?=
 =?us-ascii?Q?3/qDrMOddgj893C6e9UOBzndquJpltNKoODGWDZXd0lw4OxZST+gBjvfyX+j?=
 =?us-ascii?Q?9aG2rJTAm5RhIAW07jVG9IhIF0+Etu2aG8StufQ6VDKPfkzXZUvtK3KRcr/w?=
 =?us-ascii?Q?SCw9zEtvBWkWukLhuVjMl4mw7IBf2bG8WQdaUA8eGXaWaRbAVyLryl94TeB8?=
 =?us-ascii?Q?K7cZEwxPBvVXVLJOk0Q8hYnlUAVpPsiFCLSKsk7cxD+jJ6qvQAbJ8TKbjvN4?=
 =?us-ascii?Q?mkfM/s2IpZCQnH3Nii7zk88KwZvVgm5kyNGQiNc3KkcupuTXd++LxOtXMH27?=
 =?us-ascii?Q?LP+EN5cfkNH0xx9FTE4uySUQcmRSBQ7jYQoqvxLuoDM7wqXJXfmCaDoUGrII?=
 =?us-ascii?Q?YKm1Iebc7cjR8WUz0g9dEnnEEXXHoEGwxet7DnEd8iYrbCdtxcB7iFUluW+y?=
 =?us-ascii?Q?kjXvZ8HdrU1OEeGBVK4U9mrOAwJd+x/Z+PKMHU1u6iL5Cyuyg9GFtls1UKQy?=
 =?us-ascii?Q?GnZQSrlVRiel4H7eFb3INLVEd0O6M4K6/u+p2xHULKtXrh9MThlL6TlCUAJa?=
 =?us-ascii?Q?8vWT0c9YnA28ae67GKb+fcv1w90fCDLHdpyFXeGUA7QbKzeU+snO+GVgAtxo?=
 =?us-ascii?Q?UUVAT3kYVxnaPutXkC9KzKBGMUhwPdjDfj/VH7TJYsO3QJIHBC7Yp5RsN+ZD?=
 =?us-ascii?Q?uYW84baMjX5AvgRENIkU/Lcoj8Yd8G6RE9aR2V+YYJs+dmALVIPLHtuRUoHa?=
 =?us-ascii?Q?RVefGHVEeFaWRHfLM6XexQo0edP37H0R8z+lTp5Xzf5GLaFhcM7q4wABvJ2/?=
 =?us-ascii?Q?3kdS9We6HlPAUF63d9QTmLDyuWheymsGd2uolI5R1SHOYjVTRF37pYlhEnq9?=
 =?us-ascii?Q?P/d2y9a5Khy5+XxiF8713gH39nVRdVFDBTbjUkpfrAPyc8EKVCWOWkRfboPM?=
 =?us-ascii?Q?NyAhw5BGJIOShfrk6wlic3ApjyueDsdM4Yu5/a7P5CCn9qmM9wOESRDnZY+P?=
 =?us-ascii?Q?5+8uq7Z4fSD4T2STaCMsFYJpnVuALHW+ZVRcAuHEdQDzWh04R/Jg3D7anr9H?=
 =?us-ascii?Q?8GjLzbQnfDybSXQI039wCRFm1a4HWR6KvmOhxlYCOe8hFTwgC6QHgZzreLsr?=
 =?us-ascii?Q?9iJUdRchRqNOxh6JkCESv1a3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e2717f-ea96-4d23-1ce8-08d947f7ddcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 01:20:15.1837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqJ7DoAjfwz+ylP2LCJlpA1o09kvHudxoX4geGvrsDNCRKc9V18AV5IVeNzFaPiXnzPDvPOP/3T1RIpNsqBhIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1459
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 16, 2021 2:13 AM
>=20
> On Thu, Jul 15, 2021 at 11:05:45AM -0700, Raj, Ashok wrote:
> > On Thu, Jul 15, 2021 at 02:53:36PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jul 15, 2021 at 10:48:36AM -0700, Raj, Ashok wrote:
> > >
> > > > > > Do we have any isolation requirements here? its the same proces=
s.
> So if the
> > > > > > page-request it sent to guest and even if you report it for mde=
v1,
> after
> > > > > > the PRQ is resolved by guest, the request from mdev2 from the
> same guest
> > > > > > should simply work?
> > > > >
> > > > > I think we already talked about this and said it should not be do=
ne.
> > > >
> > > > I get the should not be done, I'm wondering where should that be
> > > > implemented?
> > >
> > > The iommu layer cannot have ambiguity. Every RID or RID,PASID slot
> > > must have only one device attached to it. Attempting to connect two
> > > devices to the same slot fails on the iommu layer.
> >
> > I guess we are talking about two different things. I was referring to S=
VM
> > side of things. Maybe you are referring to the mdev.
>=20
> I'm talking about in the hypervisor.
>=20
> As I've said already, the vIOMMU interface is the problem here. The
> guest VM should be able to know that it cannot use PASID 1 with two
> devices, like the hypervisor knows. At the very least it should be
> able to know that the PASID binding has failed and relay that failure
> back to the process.
>=20
> Ideally the guest would know it should allocate another PASID for
> these cases.
>=20
> But yes, if mdevs are going to be modeled with RIDs in the guest then
> with the current vIOMMU we cannot cause a single hypervisor RID to
> show up as two RIDs in the guest without breaking the vIOMMU model.
>=20

To summarize, for vIOMMU we can work with the spec owner to=20
define a proper interface to feedback such restriction into the guest=20
if necessary. For the kernel part, it's clear that IOMMU fd should=20
disallow two devices attached to a single [RID] or [RID, PASID] slot=20
in the first place.

Then the next question is how to communicate such restriction
to the userspace. It sounds like a group, but different in concept.
An iommu group describes the minimal isolation boundary thus all
devices in the group can be only assigned to a single user. But this
case is opposite - the two mdevs (both support ENQCMD submission)
with the same parent have problem when assigned to a single VM=20
(in this case vPASID is vm-wide translated thus a same pPASID will be=20
used cross both mdevs) while they instead work pretty well when=20
assigned to different VMs (completely different vPASID spaces thus=20
different pPASIDs).

One thought is to have vfio device driver deal with it. In this proposal
it is the vfio device driver to define the PASID virtualization policy and
report it to userspace via VFIO_DEVICE_GET_INFO. The driver understands
the restriction thus could just hide the vPASID capability when the user=20
calls GET_INFO on the 2nd mdev in above scenario. In this way the=20
user even doesn't need to know such restriction at all and both mdevs
can be assigned to a single VM w/o any problem.

Does it sound a right approach?

Thanks
Kevin
