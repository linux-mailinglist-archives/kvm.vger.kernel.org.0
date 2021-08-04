Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D43E0AA7
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhHDW7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:59:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:42364 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhHDW7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:59:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193621630"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="193621630"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 15:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="585636034"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 04 Aug 2021 15:59:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 15:59:23 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 15:59:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 4 Aug 2021 15:59:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 15:59:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPQ/Z0EnyUdmXDjnweCTRLuHeDwJ9vG1KNhHfe5kzWWVS1JpoVNM2b5sv9mZJi/SOrxOcrhuZ85wJRTw1r18KCHKavPowJih3pYcnAt/BdASThcawGeVieA/VuPD9OgYiC0eA6mX2TSsMq5Xr31iQsAz5UGV+Kb99mXm7sUBKbg8kMGK2WzNntlIXdQbHOeCDoKQuaEW1ojuQg2uGK4Y+pw9valQq/YIw0f+7yiXej7wM3GUFgaeBFJNMJceykUvY/IZ3vvI5ID5eLy+pN7YyWd2Nf7ca4NmkoxckAu2ciC4+Ipq7AFVN2WzocjJvXr5y5MqNFqk9xv0z9pYYk2fWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZrcJCeitRCH5jgid9d13pjhsm7qhwIirIkJVC2QBnw=;
 b=ho6abTqZ/s7S03B2VDhq/eHviIs7Y4fqxrhBuHKZy8goFeV+Awfv59hy9JncS2O4EFv//V49BOQuUCMA2ByL/hP8qnAJo9mBkDgh5oTqyohZjrRc8B206wE1ayrOFyX2gaVAC8phCbQ5tDwOMqIJV3m1JITpUvhkmyRbxy0np5gO0hbe2UYH8lpGcpAJAAzdtRjLqIN1JGS5/FpmlZQlxAauTZvxPZG+JcmXgEaD12lWECFW1Ciq0VKFu5UASw8vMFs0bXrYs1FDpAJdmk0+cytLDdyS0boEX72PgkxOrNZEomRovoAFn2M9w3gMRSN+UExMDaKpe87+b220P1D65g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZrcJCeitRCH5jgid9d13pjhsm7qhwIirIkJVC2QBnw=;
 b=ZbM8L77Nhb6QQQOR6Wd2rEkmXQJi0Hri3WqbQLLDk3lxRSGuQNYPHo6ePIkxw/0uAHExcfji99rM4VA+TQ073zy4QlWtwpw6SyYQe/+opAeR6pjLiCzF4xZKHKAJDmvLWJOhljeekp/LivWxifL+uXwmRApXrxYEhsRaqIkWhGE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1939.namprd11.prod.outlook.com (2603:10b6:404:ff::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 22:59:21 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%8]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 22:59:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAN4kDIAAfDtbgAB9mQaAABKIGhA=
Date:   Wed, 4 Aug 2021 22:59:21 +0000
Message-ID: <BN9PR11MB54330D97D0935F1C1E0E346C8CF19@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko> <20210730145123.GW1721383@nvidia.com>
 <BN9PR11MB5433C34222B3E727B3D0E5638CEF9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210804140447.GH1721383@nvidia.com>
In-Reply-To: <20210804140447.GH1721383@nvidia.com>
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
x-ms-office365-filtering-correlation-id: efd97a3e-4a7f-445f-4880-08d9579b7f04
x-ms-traffictypediagnostic: BN6PR11MB1939:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1939E4C25BAB20B1656FAF7C8CF19@BN6PR11MB1939.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xVqr9GqStib1Td09hvp5CBk779FM1YUCj/wfdSfDnuq/mt/vn9s/0H5xROTc36duvwRHH/tj9/ioL4xHc+YquI34rTbHL6Coe6RiGjjZYktQceey1rjz0peIdP+vMmb9DHrfyPpUc72YlcWDKGRTuZWRY0mld7PpnRkWjax0xC5sL2LeWBo1Aly7Akkacbximfbx4kQJtBKQwtPdOmNbUzuV0o8PcBOD7acpOwI64jm0/38QP91GxqjqfbA+MXrAxN58jG5eejbUw0w/NIC1I9F2IAop/W48jxndNbTp7Xg76bKVbe2V3QYoy8+YHg5dBZbzDv4LuELRUEWHmmSAw1nFOQDeDzp+FkY5Vt/tpRV5yHJ0VHeJ3c/dlQrt81nFEMygbyfnC4UBQf7/11ttaulC4Bx1QUMxV6gx7yV6Vci9ZKVYW5c3lEwe3o9xm0TaZVb+xQjQrQ3ZYS1m7P8tn9fzNGsMdAICJRL/y/iB+Q/mSsHwcCwBNwDV8uZiJRHg63a6B8gI1ghecfN15iEYFtIXEcc7JIMNfcYjq/wb2DgoS1KQcIFt1zQo7wBe1/d6x0NY0sIxu1YPIYkIoCrf9dfZXiDtz7Cz5kdC/Ni5xl5unNKwmYZ16u2c7YfiZGXWcCJKyG0z2BBMW+aM4yrxwjqCF/Xh3Vbgio25RbSAaFJCiJZsdx1iZzVN7S4A89clhMXp7FnUElqU8h8qMi5D8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(7416002)(38100700002)(6506007)(55016002)(8936002)(26005)(9686003)(54906003)(38070700005)(86362001)(186003)(122000001)(316002)(66556008)(76116006)(4326008)(2906002)(66946007)(66446008)(478600001)(66476007)(52536014)(33656002)(8676002)(6916009)(5660300002)(64756008)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rp52oQGL0XlNVvHU9QV+hjIt+KTTJxUpwuOL8vvAXhzHl9i3KKfiRnWWaS/v?=
 =?us-ascii?Q?uV1Ly9jLzN4pBKwFAtTOTFKpMPlV/QYMYvYzcVMmlmgsa5oI+aT7xWAWCGa8?=
 =?us-ascii?Q?I45r8yEqxZ2KudsNrF+USTBZkT5qE+ahDNe8oISwK3HvulwcfBcZA4XUbbmo?=
 =?us-ascii?Q?hWJl58pvVn4ABwTe2VbaImcK4dUZulSygUhYkYovfK2/5Khxrdy+6H7QXrTW?=
 =?us-ascii?Q?ggBhebxHX3H629HExZ4nmMkXOgqFrOqt3CcAgrhmqnUjF5+7RUMZsCA+riAV?=
 =?us-ascii?Q?Y9WVFbWkq8sHAMM0HOVIu54Gc6FmWKEvftA6xByjL8HQ0t05NrDWBdVADMe5?=
 =?us-ascii?Q?RTYIlgzRmAiKQ83dbzQxA7Ilm2pyVNSJZZE+UWQTKnGH/gMILBzPsDebofjH?=
 =?us-ascii?Q?eLxVv0Rh5ZcKjCb/nqhXnKwEWuIIFpEVmt3tARw/gp7i3/fOyWGnXAZk+VbQ?=
 =?us-ascii?Q?43xJZvzwW4F27TYbDO0CKoMl6K21uOjLmWbWKTBcRqovkstFcBFBDzqfK75L?=
 =?us-ascii?Q?BDa0BFlbj4h2RTnK/0ebhaoZiY3tktphXz7gBl2preMxZDapXB9x/FbGlfOj?=
 =?us-ascii?Q?NLuUfJew2VPDAWfe4CETsj+1VzlFfyYGcnr9sXsSDZTUqX8Ml8sJ07HE1ry3?=
 =?us-ascii?Q?dxDgIraNpFvXLWwslC54E5fYWdO5vkiXU+GvPr7W/SudEwocVIUImJDlPBIA?=
 =?us-ascii?Q?XeNDk/I/SKwuU8Qa2dL8fudGdsbU2DrT5ddH5VELMX1QByyl7F3Is0zkjlIB?=
 =?us-ascii?Q?9mzNcIqSKfy0c6jK8lcUuDVzFpB90NJjF/3SQSE3woKUD4hvQPLAlwXVu0Jj?=
 =?us-ascii?Q?XlgqqpNNE1ZXgahbzg0UVAezRnK4eGEoKZ0BfpYloPfcXAQ4w2ZgeIY3qMii?=
 =?us-ascii?Q?MUcUJF0hW5nhRDvtUVMi3pyK24YULPhXYBHxi5SgtSjA6kXFOioZQK0Go7dP?=
 =?us-ascii?Q?gJr+bO3REUmxIg67n9tH2CADjLWWTn+7DZW3DtqiNsA0xGWZq0MszgstJzSp?=
 =?us-ascii?Q?quy0QerG7Ev6GJNJFYvAN2ENGMqsSQGDDb4f/vFgrRbf121ZSg0Z4lF2wHBl?=
 =?us-ascii?Q?pTva2iZOuFLO5tJGaikoNpXAP2mgw4rlDTMtczlIJ1cA+UGTiazeheqJKzer?=
 =?us-ascii?Q?yLp5Le8+Ls5uQXHRI1Gpum2JVSGVXJ84tyoOiP+uzqjJ/4WizHn93kuqfjBx?=
 =?us-ascii?Q?AhdXh3H79Hsp4gfo3Ypk918U3zIJgWrPoZlfly6QyemiESXo7c0bL/zOSjc8?=
 =?us-ascii?Q?Lfh+E12hu1W5MfK1pR3u6HlunBJGn3x3fj6fc26CIfmOOCyCPiRPmaFDGnmM?=
 =?us-ascii?Q?0SIDTgjt9bRlHeiNsukX6rYq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd97a3e-4a7f-445f-4880-08d9579b7f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 22:59:21.0716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PcGdw2I7KL2bJanRu76jxNoLoTxJViQlBur0E4U/vyQbdUA29gloaopnlTh39OkEhnH+FiupELKQIyGbmxM7IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1939
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 4, 2021 10:05 PM
>=20
> On Mon, Aug 02, 2021 at 02:49:44AM +0000, Tian, Kevin wrote:
>=20
> > Can you elaborate? IMO the user only cares about the label (device cook=
ie
> > plus optional vPASID) which is generated by itself when doing the attac=
hing
> > call, and expects this virtual label being used in various spots (inval=
idation,
> > page fault, etc.). How the system labels the traffic (the physical RID =
or RID+
> > PASID) should be completely invisible to userspace.
>=20
> I don't think that is true if the vIOMMU driver is also emulating
> PASID. Presumably the same is true for other PASID-like schemes.
>=20

I'm getting even more confused with this comment. Isn't it the
consensus from day one that physical PASID should not be exposed
to userspace as doing so breaks live migration? with PASID emulation
vIOMMU only cares about vPASID instead of pPASID, and the uAPI
only requires user to register vPASID instead of reporting pPASID
back to userspace...

Thanks
Kevin
