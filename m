Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4123D3424
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 07:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhGWEzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 00:55:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:13503 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhGWEzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 00:55:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="211871928"
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="211871928"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 22:36:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="502382136"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jul 2021 22:36:24 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 22:36:24 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 22:36:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 22 Jul 2021 22:36:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 22 Jul 2021 22:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8BqKjpGfusf5QGjUlwnAPhS0Fmpklfsxgx3+mpOWcMn+qZXzdmEcoLbHOxyfKfqzMiNwaDncDvOxAV3KovDgdKfM75eM8YHmft0NGSpHBbJFkbWJX08jdrnRKQtiAi19xhnWTCCXwahOW5K5JLVKahadcUWhGNSP7N0OQrgH9v8HuqoGRjmEZICFX5C60OUm0nBqyeB5ZBRoJr3Ts3FC3NbTmPZHMlBOMrWP8BCRFmDTC5y+K0A1dF6qMFqAQmoEDaNrYuDee2fShNuk2NnKrQ/K0ldzrZjVlP89sVYeRVvd+/qFiph5US4Ap/sN/eBefG04carpprfMAlLStnCcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xdvfr45L4oKLxNIykf2fFQ5qCyeOPfAOTSmDqggWI5w=;
 b=jw3vfi8j/g/AwAWcI54RRY4hEJ6Tb1P4hc9PMsDvDtdQoOUJUdj1CXHX207dngBu3BxZ3FONb2hCrrukilgV3HafS7t+RImaEoQVuJwHXqAIVYdLPU3WmiQJZbtxlBLnvCNUwxaKqWFA0vcsjeOJdfLtwpBq9BWyiHy25PgXZ6rDSv1h0ebSD3H5WW2HSF4EcyjbeydCGcQP8Ej32fxyN7Zw5i0CVGa84OhTye7GAg9uiQZoM2JDhWbfxDCqPfJAviIhaqsXafDYVTJVIIsvWHQFci+Bw+dAR1OP1CAkVq24XFVNXU0FIT2X39l8gJOFbhNx+iKP5N2iuYwEb9avYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xdvfr45L4oKLxNIykf2fFQ5qCyeOPfAOTSmDqggWI5w=;
 b=Ht0YnspyjNU3xP6Bi6sXnLd38Dpit2DpqyL9qawdqv7nkXw2QITWMAN+ZYlCXhxFpifS3ItrW45euIVn0j1MTvSeaQXvPR7W/NfK1bNbDK9jw2GQmESgFHDo7oqzdanmkS6/JPcQLH/95XD+IsTvfcN/BfdB66theHWCx7aG7ZM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1940.namprd11.prod.outlook.com (2603:10b6:404:104::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Fri, 23 Jul
 2021 05:36:17 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 05:36:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABJmdggAASuMCAAF5dgIAAAFGAgAAT44CABKOLAIAAAkEAgAAGdACAAAupAIAAIZMAgESRwUCAIwZ+AIABCmGQ
Date:   Fri, 23 Jul 2021 05:36:17 +0000
Message-ID: <BN9PR11MB5433440EED4E291C0DCD44BA8CE59@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org>
 <BN9PR11MB54331FC6BB31E8CBF11914A48C019@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210722133450.GA29155@lst.de>
In-Reply-To: <20210722133450.GA29155@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d30a1f1c-1919-4836-f98b-08d94d9bcb2a
x-ms-traffictypediagnostic: BN6PR11MB1940:
x-microsoft-antispam-prvs: <BN6PR11MB1940672A274813749F0536F48CE59@BN6PR11MB1940.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ceWitNytzc4hQP1OFEJILxozJaG1TwjP44veWXPns0TszStkS5PjfGis+9OqLc37w4w8ZmjmaedmcUxIyIiGXA1354bs2cak51soxVzWu6gIyd5ZP2/cuGi3s/yMYwdRv6OU5R7PplwYeQY3DV8uCWA/MIw1t03/FUE0Gz+NWf9L6m+pl++JBebLqRTx1j3yA9TihHLOTybZfCIdTiPPwOVRiSQxYk1fM6rGREkr+PBKcgDSLra0/V6qVs5voFWrxz7yZ98GMd3cO4u9TMVPVrccG3Eq3PeVYHRq2LLgsw9UiDN4ANji84rnV8ggUhC5dIO+VVDKjG0tkrU4i6o8TTAu6t44YO3dAyTlIgvttk8mprzFojdW/yKLbDXCb01gbSXNK1i3ZylSz0G/uQuWnlv/bCsVtGm7kyrZSQia9UdCB3iD5pIBIL28J1mBewjgkq7/uQ1TF9YuIHP0dU+abgBfJYP0Eaw9sBWBL0MBCaQAnutp0hqgaXMugUBRrtQfhjcV59AG+1eP4iNB0nu5ShZPGTUmctVx59knLmqYlsl0FSxBwP/2jOS2ucdbbLeFQt/oG7NAfvZkQNMcp4YyYelhBO8ldKSZZKzx9m+ZrHubHYLMjwIomJ3QC8SMbfQuOtyGQVs+KCY97sPB/mxCMFjcpFGbhVfk+jYGbq4P2kRzaf7vInLxEd4arJgSmAkw24fUOXtBvxsY+RJmWjNMrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(26005)(55016002)(5660300002)(8676002)(2906002)(9686003)(7416002)(316002)(33656002)(122000001)(6916009)(8936002)(38100700002)(86362001)(83380400001)(54906003)(4744005)(4326008)(7696005)(66946007)(478600001)(52536014)(64756008)(71200400001)(6506007)(76116006)(66476007)(186003)(66446008)(66556008)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ngAd08Ui9PKcaJ64sAwK6llckwQJD0w9f20gyu15MXK6huiSFye2SwLwDDft?=
 =?us-ascii?Q?dh2WUXfYVEV+mLwr3Nt0kZjjnz9nZiEVKh2ROgXqPptUuwOCzye2JSIsc1qc?=
 =?us-ascii?Q?1Crm2udUpIUBEc19TyP67o/3yMxo1x5MTW44tJWIUxVJEVUrX8jvcSpJ00eZ?=
 =?us-ascii?Q?7NYB+8tTONPiMLEMgGO/U8vT/JcN6CETubFf0WBXmlarSBpSEpYL/EYVWXVh?=
 =?us-ascii?Q?plXGkyAIaBh4CYCl9eMZ5NZu6W3kuEpCipt2bhpJoP6AH6fA1BpifLo13qrg?=
 =?us-ascii?Q?lELhA7eLVnxJQZLVaEFSsmRsqvbI0urilMNeG/oJXIXdb3dWsKex0LAD/kwO?=
 =?us-ascii?Q?Xgruo+mrUZ0Qp6+Ld8qvhhIQWXeO5DRBHyPiGZ8H1QnGYfRs6SWcd12HKxFT?=
 =?us-ascii?Q?+8H7uEVv47ac8cJIQmGkeEbV6RczqmRw6bJ9dOpY6bqhF1mfE1Tc40RFL/0c?=
 =?us-ascii?Q?6Ez2H+g5jdRt8l8jB0SXiIKIs8BUd5Nfq2M0IB73yt9ZyIGE+Oyo6Hqllm8N?=
 =?us-ascii?Q?4a4hxEefaRPf90rj0PMf7XjV+3mFP2K/7hb65QnGuBGbNoeC4R8zhpUdc9Ug?=
 =?us-ascii?Q?9MGb1CtWfgQdyE1ZlKy9V+JghUHhYYHFOFj0i6JTWSi3h7B7BGuy2ZxhQJfx?=
 =?us-ascii?Q?bsnurocQ7sk8iIHGQgQbJ4HIi0V8tN+sNvm6sGRP8qOxm2VuS2umk/nE+9wK?=
 =?us-ascii?Q?6+joI6AAEmOoVOszOwx9ATYAZpy0rQYKuFA8/SIgqtGTzp1+/G5l01GBFd/b?=
 =?us-ascii?Q?qJ3Bypq4QtY4JWWnvWsmDXa8EeBy3ITjLbBia3RCSNvTTc6WIqdEYWtYjeSC?=
 =?us-ascii?Q?cY55jC+N16OPaBZGiw7+7gGXWw0Pzcw9vgvz9FBVV4sxQiPs8z1A4dl0OYkt?=
 =?us-ascii?Q?Wr95tSpuvpVgvsqWrwuuBDjFUFE7fpSa7aBDqIpbvdMp6w/Ci4wPV44MSFO+?=
 =?us-ascii?Q?QYsqn/g9JZxwE9DK7KA/xTGVTp6NNP3qiJcSSwzlKhfvFu+8ucxP4Pw32zgT?=
 =?us-ascii?Q?jR06kSUrXl6nVyYMYHhSZ9Bvx8Z2eUsrkp4jg3WulHNee+6EdoXgOs+fcByf?=
 =?us-ascii?Q?/LvO+we3KI3pcPyT/cSQhSELvTH5nm/fFBs71bhE3Iq2NyV9ZGlSLwrexMSO?=
 =?us-ascii?Q?Cxp9MNBlpqOR47oxBvmakKCRLw7e6XiUZrP/eGtOwvKCQ3mDHJW1On8tgGNf?=
 =?us-ascii?Q?PCmsrzoZLCWmg72Lx7DFOBHkJIPcToOi3ZXYBAX8w3AoPwMBIwbMMo8GKSAJ?=
 =?us-ascii?Q?I7PCtMaewgGk0icjk3QANObF3L20vl4HHLB/AbbIJlTZcSdLrdTiaPbpSNIU?=
 =?us-ascii?Q?SnStu2inyM+142KDpihL7ho1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30a1f1c-1919-4836-f98b-08d94d9bcb2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 05:36:17.2272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Af1p1HMNyXGOB4hxAGkZDFkzFll+9z3SZj9jD0kJo8QZySgFQgN6ksbyZGeJVq/vl4FwgvwjpUd8nxPSwWMT5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1940
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, July 22, 2021 9:35 PM
>=20
> On Wed, Jun 30, 2021 at 09:08:19AM +0000, Tian, Kevin wrote:
> > The iommu layer should maintain above attaching status per device and
> per
> > iommu domain. There is no mdev/subdev concept in the iommu layer. It's
> > just about RID or PASID.
>=20
> Yes, I think that makes sense.
>=20
> > And a new set of IOMMU-API:
> >
> >     - iommu_{un}bind_pgtable(domain, dev, addr);
> >     - iommu_{un}bind_pgtable_pasid(domain, dev, addr, pasid);
> >     - iommu_cache_invalidate(domain, dev, invalid_info);
>=20
> What caches is this supposed to "invalidate"?

pasid cache, iotlb or dev_iotlb entries that are related to the bound=20
pgtable. the actual affected cache type and granularity (device-wide,
pasid-wide, selected addr-range) are specified by the caller.

Thanks
Kevin
