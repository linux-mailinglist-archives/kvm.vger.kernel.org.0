Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD903D8666
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 06:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhG1EEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 00:04:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:54967 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhG1EEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 00:04:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10058"; a="212606603"
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="212606603"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 21:04:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="517262869"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jul 2021 21:04:27 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 27 Jul 2021 21:04:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 27 Jul 2021 21:04:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 27 Jul 2021 21:04:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 27 Jul 2021 21:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgeXgdipEtFcac3d2N2orMS1+izrlnWEnQrYo6gG/18a2kBTR4Uk2MJR66Sp+XOzl23Jz3iih4bkJW4nFPe5ziN3Z6A/7moRJqtn4n+D8ZHIi9BPAXJUII1S/GR5pOkgFH3gNY/RJU5uq9fgnoPs060CQE23XK00Il2F1TNroVQbkZwtvZ+igAV6XIt05C1FjWPGlpE0kBvIhYlyJ31mCcKgHSWQ5qbt5CCtaKoL8KCJxr94H/APzEjYImjgStutlomAZpynTglyTMHt/hmZGdYy35BVbtk4aFzemLfM4anFu8aAbXpmjwVp9Mhyl7t86QUS0U9u7dCOidJy7L+rYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FofmPf18syokba3guXAqg1aqGNzDsLAAvdof8PZ9osI=;
 b=e7VJ+wT6F+EV7/5p7NsN9HhaD7AW657M9NizIlYOA8qZAMt3kO0yRNbEYhpRTemPMyM8a4ZTxo5H3P1LUT4WfOPA1CIkRaCHtjXoW68GoULKdhZasHJl6YaAXv6Chr33YJuR79oPgToO0wooSTc8EI5q6/SvJJ1rfq4tK3GdCAEwgNFBL5suJizeCcNly9/HiZUA59gMJva/XvZL2qA71LeS5dIuoAkyF1cSQpwIgUVUXuq3+Lb5dEqGP889Tf7WONl6fosvXvW95vaz4B/rXKyBN4MDf/9GDeyo445/pU5Gap+HVg+GHFfxNkY3jHCU6AOpIaI+/FeBAPdHB1nljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FofmPf18syokba3guXAqg1aqGNzDsLAAvdof8PZ9osI=;
 b=y6FpWomKd5u1CiZz/W4ZMlSNStJF5O2DxnNjOdwNa4Ud0jqLS+aRqkOfHnmSUFwWTBcuCKh1phFS2lxVTFtek/Mo6o8I5scIEHu25Rbm4oACRQMz95lTvnjE3op8knOsnSIsaoMU3v5e7EHA3E7jypZPEDzeekPav7e5Mi9HmFw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2594.namprd11.prod.outlook.com (2603:10b6:406:b5::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 04:04:24 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 04:04:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAGGEwqA=
Date:   Wed, 28 Jul 2021 04:04:24 +0000
Message-ID: <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
In-Reply-To: <YP4/KJoYfbaf5U94@yekko>
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
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18a4c536-2b7e-4e1a-f513-08d9517cc956
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB25940637AC0B97D9AD3271F18CEA9@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pquOqmBXwRC5Gb43L4LbikfzyzvnHPR9s3ARvQ5KHaMZ2yLLhY1ufmeUSdc/A0ft9fSaHrYCdaJbbGDPF0gilqOs7x23R02AvaPH9MkoRgpm8v1hlLVf2lfu0oLY3yQtMhwBx4tNpurwg6b8zz9S6ocJEZ6bondryDJd2hj82T+t5jeBgMlh13m+z/SgDaoo5h9PyuJTmEV0BrWTRVhtlTjrteUWrsGhuYXbDSKJ+Pd32sigGmYUg66yjYDkvUgYA+2NbHn9zo0dHe4RNHTrXuWUzq7xJM9S6E8FdJ5oYWzjNeMZYgsLGZCmyHSqew/TUXAxdpPHWoT5iVZOA1woFQjevoFaaa6s6Js2Gm4E+V15l/i3r8rgepCaHs9QvBnaRkydGwt9MZjAXYDGP3O60KOWIJ1v7ccPlSTw0Ly51btEV53gEBWEyePLcsvUZt1YoTNrXuhDyrC9KGEnGAM2KV3oB980lwI0NnhaNIGM5yiBqVCDuXsScxO0hiXhK4lANWmbwubplrYEEt1RW055qO2NBuZ7uFV7MWMptry9bj4oPufayrQ4jzzFmsRB/OtB3LvHtfe/HWJwc1SKu6ghRbw+X1vfQ85Bh3+2492Jm2DFrBPlSJ64fJIg/xF0QD9t9UBmCPdV9UCTE+bUWWrL5kvjfuIMly3gYB4uDvtcN3YdJim1xAcomc3SEqPjv5sVqBZOm5veN4B8E9CVJT6sj5Vd3EIgYqWbjvrevL0poGorYgH9Vm+hKfRa2Ksl47jebEybeapKYmliRV1UiDfoyxsybtUIwKEg4fEJVzmF/o4XkOOFZqQjCl3kKZrMjF/ADWhIpNOVAbsCedqKxlLDRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(76116006)(64756008)(66556008)(316002)(66476007)(71200400001)(55016002)(6506007)(9686003)(66446008)(7696005)(45080400002)(8936002)(86362001)(26005)(478600001)(66946007)(52536014)(2906002)(83380400001)(30864003)(5660300002)(54906003)(38100700002)(122000001)(6916009)(186003)(33656002)(4326008)(966005)(7416002)(8676002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?riZRiIrTlDh8PbsyX62k0BLcdqMv4+Mo0DWHEyJb50q8Jmm/funxWODT3DBk?=
 =?us-ascii?Q?d/17ELh8DVdN/wqCEMHKdVl0Mi0ziptC14Fz9pMw6fjNff9Lfoum65yOnv0R?=
 =?us-ascii?Q?46E+vp0r4IewDNbf6nNkI1LRFJIpCN1pLjJZqXBma073pI25xzhdtaBZ4CfU?=
 =?us-ascii?Q?7OFCEnVmvQHwmlnAgVYrZKOH4DPELj7f9lZJhVFqrtdRXbm+1Qu98exxpJSQ?=
 =?us-ascii?Q?+/V7j4eLo/KLlZalpJvLQkmCiTZ86OkApBeU8l+5KqhC0UNUURm9sCsyOZvJ?=
 =?us-ascii?Q?sM3T5uVqKgvUm+riuhG2SFL/KmqcvWDejXWYuoeM1uu/L5F7Fmw/0hYQmsjv?=
 =?us-ascii?Q?SKkeLmLrvFF3mWmZtNTiM3o1oqQ2Rupmr9jCb8HI2JlFTVdId80lJMwm8x+0?=
 =?us-ascii?Q?0/lMECnhMf7ljGwy0P5hyPGlXQW5ycJEub1hFMG1PhWyhIsT552Xgo8ViZrk?=
 =?us-ascii?Q?DsIwn4vCmAJGZvA/fLdiCrKaU8zBQRELeYqdk1qXNzRk752uFL0kOoizJZ+t?=
 =?us-ascii?Q?GTqWiHp33tvBbl5nvzKPZklP6ETwDLT/C4WU0TlrLj2Q5UftCaBcoo+omV7W?=
 =?us-ascii?Q?HqZsUIhlEyYHGsiz6tOeqKBWUW8tnEOB7R+fM3D2H9KJxmDkrQ9vmHqWdXFp?=
 =?us-ascii?Q?zqPO29ORm8qhLUnVILT2A7hr8PYAp1YoMHLreQ3zwMmN/CnIgCrUj8aUTuk4?=
 =?us-ascii?Q?QR5VMN7abCwRPptzJjwmrHMnKUzgSvNMyJx6hCqo1rUhbNjxM/eEKA8jXjEE?=
 =?us-ascii?Q?qSc9W8zP1J8W98tFY5kI6JGAa2jLPh6/zpj9hDPKCrD9nwq+ArdpepvRzDUE?=
 =?us-ascii?Q?TGdoMSg83aCCuxJC5D8ANiNgjFC+7A5c4dlHPVX6uPs6cbuwIYwuYouXBXgD?=
 =?us-ascii?Q?xBLJLB3fZTghBrKopFR6F1y2iEOZDJEBYVYP5/W9LqwnDsHvlxNXxaOEtycE?=
 =?us-ascii?Q?3SgDyMyDRLFiX9vFs/I5jZJ47h3SRhA3AlsaUNlRUkUFDp8qBeS1EOcny4dZ?=
 =?us-ascii?Q?Onfb6j7e5cD0uUNnXlq8Hbb78p6tBWTOJq4H7/Xn9vpgK9/jrCuJw9gJjhoG?=
 =?us-ascii?Q?rTj+YSmMhnb24NLHjGwxPkVqakkHcoeJWWZZpnMjlsl0lQkMHNNCnOH308lq?=
 =?us-ascii?Q?OywZcP3WZHMxofyYeTXiJI4chDtV4xhTpwrGzNalI9zZGRUfshdOk/15sRrD?=
 =?us-ascii?Q?Hd7CF4yIx9pfR7hAKw5XqeRa0Ra+fF4aeKZ0H4NA5H4O1WXXF8Z8WpUd50sp?=
 =?us-ascii?Q?9S4T3N50Mjh15xw4+YFhnYAEP5FZ4YwRiWurxC5fts653qxclK0EFim/davv?=
 =?us-ascii?Q?9mIQpkmQZyJyqugwuqv4w8g7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a4c536-2b7e-4e1a-f513-08d9517cc956
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2021 04:04:24.4224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gf/l35O7r/75d56MSCuY+0PHnBKOCot3C2OKC6vO6/ng1MhZtJiOwJZhIYXjMtAYzFaZ7zyL3hcf0uVd23Kx+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, David,

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Monday, July 26, 2021 12:51 PM
>=20
> On Fri, Jul 09, 2021 at 07:48:44AM +0000, Tian, Kevin wrote:
> > /dev/iommu provides an unified interface for managing I/O page tables f=
or
> > devices assigned to userspace. Device passthrough frameworks (VFIO,
> vDPA,
> > etc.) are expected to use this interface instead of creating their own =
logic to
> > isolate untrusted device DMAs initiated by userspace.
> >
> > This proposal describes the uAPI of /dev/iommu and also sample
> sequences
> > with VFIO as example in typical usages. The driver-facing kernel API
> provided
> > by the iommu layer is still TBD, which can be discussed after consensus=
 is
> > made on this uAPI.
> >
> > It's based on a lengthy discussion starting from here:
> > 	https://lore.kernel.org/linux-
> iommu/20210330132830.GO2356281@nvidia.com/
> >
> > v1 can be found here:
> > 	https://lore.kernel.org/linux-
> iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.n
> amprd12.prod.outlook.com/T/
> >
> > This doc is also tracked on github, though it's not very useful for v1-=
>v2
> > given dramatic refactoring:
> > 	https://github.com/luxis1999/dev_iommu_uapi
>=20
> Thanks for all your work on this, Kevin.  Apart from the actual
> semantic improvements, I'm finding v2 significantly easier to read and
> understand than v1.
>=20
> [snip]
> > 1.2. Attach Device to I/O address space
> > +++++++++++++++++++++++++++++++++++++++
> >
> > Device attach/bind is initiated through passthrough framework uAPI.
> >
> > Device attaching is allowed only after a device is successfully bound t=
o
> > the IOMMU fd. User should provide a device cookie when binding the
> > device through VFIO uAPI. This cookie is used when the user queries
> > device capability/format, issues per-device iotlb invalidation and
> > receives per-device I/O page fault data via IOMMU fd.
> >
> > Successful binding puts the device into a security context which isolat=
es
> > its DMA from the rest system. VFIO should not allow user to access the
> > device before binding is completed. Similarly, VFIO should prevent the
> > user from unbinding the device before user access is withdrawn.
> >
> > When a device is in an iommu group which contains multiple devices,
> > all devices within the group must enter/exit the security context
> > together. Please check {1.3} for more info about group isolation via
> > this device-centric design.
> >
> > Successful attaching activates an I/O address space in the IOMMU,
> > if the device is not purely software mediated. VFIO must provide device
> > specific routing information for where to install the I/O page table in
> > the IOMMU for this device. VFIO must also guarantee that the attached
> > device is configured to compose DMAs with the routing information that
> > is provided in the attaching call. When handling DMA requests, IOMMU
> > identifies the target I/O address space according to the routing
> > information carried in the request. Misconfiguration breaks DMA
> > isolation thus could lead to severe security vulnerability.
> >
> > Routing information is per-device and bus specific. For PCI, it is
> > Requester ID (RID) identifying the device plus optional Process Address
> > Space ID (PASID). For ARM, it is Stream ID (SID) plus optional Sub-Stre=
am
> > ID (SSID). PASID or SSID is used when multiple I/O address spaces are
> > enabled on a single device. For simplicity and continuity reason the
> > following context uses RID+PASID though SID+SSID may sound a clearer
> > naming from device p.o.v. We can decide the actual naming when coding.
> >
> > Because one I/O address space can be attached by multiple devices,
> > per-device routing information (plus device cookie) is tracked under
> > each IOASID and is used respectively when activating the I/O address
> > space in the IOMMU for each attached device.
> >
> > The device in the /dev/iommu context always refers to a physical one
> > (pdev) which is identifiable via RID. Physically each pdev can support
> > one default I/O address space (routed via RID) and optionally multiple
> > non-default I/O address spaces (via RID+PASID).
> >
> > The device in VFIO context is a logic concept, being either a physical
> > device (pdev) or mediated device (mdev or subdev). Each vfio device
> > is represented by RID+cookie in IOMMU fd. User is allowed to create
> > one default I/O address space (routed by vRID from user p.o.v) per
> > each vfio_device. VFIO decides the routing information for this default
> > space based on device type:
> >
> > 1)  pdev, routed via RID;
> >
> > 2)  mdev/subdev with IOMMU-enforced DMA isolation, routed via
> >     the parent's RID plus the PASID marking this mdev;
> >
> > 3)  a purely sw-mediated device (sw mdev), no routing required i.e. no
> >     need to install the I/O page table in the IOMMU. sw mdev just uses
> >     the metadata to assist its internal DMA isolation logic on top of
> >     the parent's IOMMU page table;
> >
> > In addition, VFIO may allow user to create additional I/O address space=
s
> > on a vfio_device based on the hardware capability. In such case the use=
r
> > has its own view of the virtual routing information (vPASID) when marki=
ng
> > these non-default address spaces. How to virtualize vPASID is platform
> > specific and device specific. Some platforms allow the user to fully
> > manage the PASID space thus vPASIDs are directly used for routing and
> > even hidden from the kernel. Other platforms require the user to
> > explicitly register the vPASID information to the kernel when attaching
> > the vfio_device. In this case VFIO must figure out whether vPASID shoul=
d
> > be directly used (pdev) or converted to a kernel-allocated pPASID (mdev=
)
> > for physical routing. Detail explanation about PASID virtualization can
> > be found in {1.4}.
> >
> > For mdev both default and non-default I/O address spaces are routed
> > via PASIDs. To better differentiate them we use "default PASID" (or
> > defPASID) when talking about the default I/O address space on mdev.
> When
> > vPASID or pPASID is referred in PASID virtualization it's all about the
> > non-default spaces. defPASID and pPASID are always hidden from
> userspace
> > and can only be indirectly referenced via IOASID.
>=20
> That said, I'm still finding the various ways a device can attach to
> an ioasid pretty confusing.  Here are some thoughts on some extra
> concepts that might make it easier to handle [note, I haven't thought
> this all the way through so far, so there might be fatal problems with
> this approach].

Thanks for sharing your thoughts.

>=20
>  * DMA address type
>=20
>     This represents the format of the actual "over the wire" DMA
>     address.  So far I only see 3 likely options for this 1) 32-bit,
>     2) 64-bit and 3) PASID, meaning the 84-bit PASID+address
>     combination.
>=20
>  * DMA identifier type
>=20
>     This represents the format of the "over the wire"
>     device-identifying information that the IOMMU receives.  So "RID",
>     "RID+PASID", "SID+SSID" would all be DMA identifier types.  We
>     could introduce some extra ones which might be necessary for
>     software mdevs.
>=20
> So, every single DMA transaction has both DMA address and DMA
> identifier information attached.  In some cases we get to choose how
> we split the availble information between identifier and address, more
> on that later.
>=20
>  * DMA endpoint
>=20
>     An endpoint would represent a DMA origin which is identifiable to
>     the IOMMU.  I'm using the new term, because while this would
>     sometimes correspond one to one with a device, there would be some
>     cases where it does not.
>=20
>     a) Multiple devices could be a single DMA endpoint - this would
>     be the case with non-ACS bridges or PCIe to PCI bridges where
>     devices behind the bridge can't be distinguished from each other.
>     Early versions might be able to treat all VFIO groups as single
>     endpoints, which might simplify transition
>=20
>     b) A single device could supply multiple DMA endpoints, this would
>     be the case with PASID capable devices where you want to map
>     different PASIDs to different IOASes.
>=20
>     **Caveat: feel free to come up with a better name than "endpoint"
>=20
>     **Caveat: I'm not immediately sure how to represent these to
>     userspace, and how we do that could have some important
>     implications for managing their lifetime
>=20
> Every endpoint would have a fixed, known DMA address type and DMA
> identifier type (though I'm not sure if we need/want to expose the DMA
> identifier type to userspace).  Every IOAS would also have a DMA
> address type fixed at IOAS creation.
>=20
> An endpoint can only be attached to one IOAS at a time.  It can only
> be attached to an IOAS whose DMA address type matches the endpoint.
>=20
> Most userspace managed IO page formats would imply a particular DMA
> address type, and also a particular DMA address type for their
> "parent" IOAS.  I'd expect kernel managed IO page tables to be able to
> be able to handle most combinations.
>=20
> /dev/iommu would work entirely (or nearly so) in terms of endpoint
> handles, not device handles.  Endpoints are what get bound to an IOAS,
> and endpoints are what get the user chosen endpoint cookie.
>=20
> Getting endpoint handles from devices is handled on the VFIO/device
> side.  The simplest transitional approach is probably for a VFIO pdev
> groups to expose just a single endpoint.  We can potentially make that
> more flexible as a later step, and other subsystems might have other
> needs.
>=20

I wonder what is the real value of this endpoint concept. for SVA-capable=20
pdev case, the entire pdev is fully managed by the guest thus only the=20
guest driver knows DMA endpoints on this pdev. vfio-pci doesn't know
the presence of an endpoint until Qemu requests to do ioasid attaching
after identifying an IOAS via vIOMMU. If we want to build /dev/iommu
uAPI around endpoint, probably vfio has to provide an uAPI for user to=20
request creating an endpoint in the fly before doing the attaching call.
but what goodness does it bring with additional complexity, given what=20
we require is just the RID or RID+PASID routing info which can be already=20
dig out by vfio driver w/o knowing any endpoint concept...

In concept I feel the purpose of DMA endpoint is equivalent to the routing=
=20
info in this proposal. But making it explicitly in uAPI doesn't sound bring=
=20
more value...

Thanks
Kevin
