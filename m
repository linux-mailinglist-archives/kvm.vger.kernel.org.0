Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FB241401F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhIVDl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:41:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:47904 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:41:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223154260"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="223154260"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:40:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="533547058"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2021 20:40:28 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:40:27 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:40:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:40:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:40:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPg38DYW9+RAtFh+awZZKYPyU01UJDF7gdtVI6Mz3UpUOGpPDi7u3KMY+DKvog6f4wVp5yk8F2AaGpz0StSZ71qpLGZJGKalknVQMT0yadPXCVA/zMXpcL3AxO6Sml1tfSn7tdgjEb8MgTm+6mLtw+7fJsNhVtkXPde8bTmPqW4J39k2YqBOyAnWbGlQdVg4cMYmyFR8smqAJnDpoAI+Hjo00sITWB1OciAxhalqoD3KaSu/Z8Zr85+dJ0ErDbv/hDuhnXg1HZzbfbsj3VkGbb45//sPt1FRHrgfkuaopUut570x9yXJA9Fn5/g92DZa36LIxggqpFwLux0uscKyXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xlR9/eyDhL1NoZ3GWdGOztiW5lVTU40QTCNsqzom4Ts=;
 b=LAKobqcvizmnXts+7vJtxXYGJuwynzmQQ79eMdAs2qLyp/u2zEIJFjTimlgZpPm9Rg5KMP+w3puObOnQzZrHgVQqoNv7pE7RSYfFvwpJxdX4unRKq///B0I2oYb9W2WFZ/tac+CPZg+12C4iyhmbmUlN0Kst9mKvTabtOT32yxbz+PixHovlz7oQNSE9VdTlI7MqqcqutUJjC2C1/shoQCTeg3gQIsbZXxN/lIu9iSMmdh//U+AIOJYTnfF8gROnRFIoywslF8/EFq27HGZuKB4EtEGw6CN2iv/P6rCZZuc4Hh+43JzFrawCk/Pr/a9APhXzotxKCMzcfyZEYAMB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlR9/eyDhL1NoZ3GWdGOztiW5lVTU40QTCNsqzom4Ts=;
 b=gIZh44iBDrbQ+zxEZTcN93tZV4488VMLmo7Rlmcg13ZBlwyhomBsllP+9pKBEDeKhIKi2T3BTbY47kPfdbqcHuNjn08+eHH559EGfERqWHEXe+XdxR70+9ghIS/e7d2+f8byUqMCJIaJam1rvkEN9uDoH/6itJKYdQg9RMNDuk8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1796.namprd11.prod.outlook.com (2603:10b6:404:103::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 03:40:25 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:40:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66uuxm8AgACjoWA=
Date:   Wed, 22 Sep 2021 03:40:25 +0000
Message-ID: <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
In-Reply-To: <20210921174438.GW327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 350d763d-b841-4f20-f418-08d97d7ab6d3
x-ms-traffictypediagnostic: BN6PR11MB1796:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17963E6D08F8170D668B7B208CA29@BN6PR11MB1796.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6L5XqJ2yByOGgi88JKe6Uem+0EKel7+t6XWv/HUcKB8lJBdVbp/+nQ5EjorksZ37H1vLRceZQPm2i2A93F/jttZGHYppVRtjqkVfag1DELfjY9gfPCWBpylVusCXXIFEULdZo33oYGpYf05fHmg3mt4PiBOzyLPc03/vrVd7pKNri3fvOoBwDKOR4J+rXsK//O3YWsHZ8cJ3fOJasJEnCmeRCEeJJUMjNkOYWSYl27K1sv/dotVRhMoxtjPi2bxJkoiU49mjoVk8MoFjEBtTNurWvCa/MuAslhhSFq/LYk6wyFVcwPPCZ1Yt66O9LxnlQAMOnFpKQ3JZaKoMk3PFUvEWYld0NXKZzLjc9MnDcoKQh1PkZQ3Gn9vnZx9xukP/FcQx5rz77bf6Clam0CJ+xLVYiEy88R1eaxoRwa9FkBaGJlOdUz4Ig7mzn/GY2+yDAm+x96vPsrdQja6CngVIevLzYamCr4s62eT8CEL96ARbmQV19LKaPOYYsxk+TMm6BJuJaBllGnecM5cHYCDp7k9eSo2f/sdF/EjjkZzlVPwMuJSHasmOfXLbMUaqXn44kgxqrmgOd35LYKkct/MQa1EXsDZF3KfbLzSzw1OaPqUUYIuTcroxnb6duXi2koVZTLTmBY6nQcarmjqwoka/+qWCFZ4h2o0JDZV5GQcYRtjOd5L0d+M33Y/NEPfZCX4lHlFAMiCnUBI5Rc3PYFAiMwpA9zM7+NzUn9NgGw3fM+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66476007)(38070700005)(26005)(508600001)(186003)(64756008)(52536014)(66946007)(8936002)(9686003)(76116006)(7696005)(5660300002)(83380400001)(6506007)(66446008)(55016002)(66556008)(8676002)(54906003)(122000001)(110136005)(4326008)(33656002)(6636002)(38100700002)(7416002)(71200400001)(316002)(86362001)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DtEiMaJXGWkp70BTVO2i3AwTIU3RzAlPH8w7SzUWoIpt3ZTZRrp89WvpUkO4?=
 =?us-ascii?Q?Fp0y4mvh9l+QhhrLbs92nB0ih695UK1u/+yJnx8gPkIZwUZ/QnqmS/NKA8v7?=
 =?us-ascii?Q?tIz7jds84jDEjSqN6oV5kRDiay76v9GhxnsHTLw8l+22r9CrwCVtjAd79JBN?=
 =?us-ascii?Q?Xtwe92EEZkQ+RaZ6DdMn8t9hkcJemQrJxVRwfvM4YtIUVYEYeP5bcyIjb3/u?=
 =?us-ascii?Q?tzEBIsAkahDtK+Ruxm49sz/6VJKXJBreU3IxMcvzm6B/0A9d7O2vZ1Sssqco?=
 =?us-ascii?Q?h2h0AcyQbwvgiLSLMSh5Ydy3GKV3h/0LWi0UPn7yp54TsDOZqRXkEpwp4uyb?=
 =?us-ascii?Q?eok81JG+79yM1fPeHwq04nzhjQOTBkEqW1WC0iGIUBodzQ6iqF3GttN0UBdB?=
 =?us-ascii?Q?914+AALNQTHOgyHrUw6AlDhTXnmCL5SyoNxRZ2zdhr8/F1zTHuXciUGGb7sq?=
 =?us-ascii?Q?lOHJx3PVpu5ubD82c//FDUTmtbWqb/GOXFzBGJ5iduKf06QQPWraVYuM3MS2?=
 =?us-ascii?Q?1fpBSVgzSywo3UjUBkhDEWCnFmZ2ncQDy6+DApJQkOxHHL3EK8bBpCRjVwY8?=
 =?us-ascii?Q?5WobKt9rwUu+VuUOxCZA6jBUKr2y7CcE+CjB3jn/KWBqh3XfGFlSh6pWr5rf?=
 =?us-ascii?Q?Sukdgk+JwjDv/RY4kuKH7q1yui2SXvEcmIbmRX6PwUaHsOwUgzYeZPwkCtC8?=
 =?us-ascii?Q?fkLOAlGlyWXRn1LRWuGV9fxPnC1NJDDtl0uxSK1Xy4r0lwYBmJH33DsrFA/I?=
 =?us-ascii?Q?vwP3Ck99SgSHNM1BwCOCANBPMqgCAQJFUeJ1nw6jxWgODoYU3rCghvHZDdSR?=
 =?us-ascii?Q?GHRzkp9VJHt4s8F8swYgdoAvwl8PgbaRPzQeLWVC6f0WJrO7K3kPnUvVGbfM?=
 =?us-ascii?Q?MTvskS47tRckjl6a/jeH7ZJjZNd7KLqRU4wQrc1+76CBqv+BZh8m1N/KvhsQ?=
 =?us-ascii?Q?ceoFYrVw1ffWxTc/K7gqIymx7WkaH7ldIICsEoGr2z/pw441JwS6irBc5nMP?=
 =?us-ascii?Q?6O6nBTgmQ+gHnx50O84usAq2jvcyQ3LFvz7NhPlO+xX+5eb/40im+k+7sYgY?=
 =?us-ascii?Q?lk1t58UACf9n/dP4wRna1HEkFBPTuCOgyH0Gw9PT8epxwhj2+ES+cU9X7y/J?=
 =?us-ascii?Q?qVSE7rfPInoLcxn5jA0+UEdyHYl8KrpxZTy8QATg0A/2GUJMpJ1wT3RZtJN7?=
 =?us-ascii?Q?8+/0f1fBnP+APyhfkE6f5ijZ+FiWJmJRzoI6TyjFjkrPsI7sqccx9weqC3xD?=
 =?us-ascii?Q?PnptdgIWTVc1tA/IL0VbpbszG8lc3irngXbiEuxAFULgkOcDcNxDO8eL9sm5?=
 =?us-ascii?Q?GSmKmKTPBg+xfVVjkVNyjq5g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350d763d-b841-4f20-f418-08d97d7ab6d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:40:25.5287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SHoDSITaiWkFfcPFGbcvi84aH+tGIdXrYU3mM/f5yeqaijdTQYqtMzGkqii2NS04SvXzLAGMgZOqhtqzSsQtvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1796
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 1:45 AM
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
> I think the request was to include a start/end IO address hint when
> creating the ios. When the kernel creates it then it can return the

is the hint single-range or could be multiple-ranges?

> actual geometry including any holes via a query.

I'd like to see a detail flow from David on how the uAPI works today with
existing spapr driver and what exact changes he'd like to make on this
proposed interface. Above info is still insufficient for us to think about =
the
right solution.

>=20
> > - Currently ioasid term has already been used in the kernel
> (drivers/iommu/
> >   ioasid.c) to represent the hardware I/O address space ID in the wire.=
 It
> >   covers both PCI PASID (Process Address Space ID) and ARM SSID (Sub-
> Stream
> >   ID). We need find a way to resolve the naming conflict between the
> hardware
> >   ID and software handle. One option is to rename the existing ioasid t=
o be
> >   pasid or ssid, given their full names still sound generic. Appreciate=
 more
> >   thoughts on this open!
>=20
> ioas works well here I think. Use ioas_id to refer to the xarray
> index.

What about when introducing pasid to this uAPI? Then use ioas_id
for the xarray index and ioasid to represent pasid/ssid? At this point
the software handle and hardware id are mixed together thus need
a clear terminology to differentiate them.


Thanks
Kevin
