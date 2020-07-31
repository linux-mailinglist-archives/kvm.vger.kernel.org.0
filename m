Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51D233C8E
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 02:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgGaA0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 20:26:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:12386 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730781AbgGaA0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 20:26:15 -0400
IronPort-SDR: B61kyDO2A7zr1XEZTLKXTGJvJG6hUT/agHBYjywVBnGhrx3No1FrLOaiBS1D1232D6ykDfgRvb
 yXFH8fdezE+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149542940"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="149542940"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 17:26:10 -0700
IronPort-SDR: +rrzfOuU21xdQgYoO4zzH87MA5bD/Ub2rRq54X7cINi/lOcGKsk8Xv/Ss07HKhQDQXAMp2zIOp
 5nZmNhhXvymg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="291061474"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 30 Jul 2020 17:26:09 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 30 Jul 2020 17:26:08 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 30 Jul 2020 17:26:08 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 30 Jul 2020 17:26:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEziJD9Xen+qnZgM2ULewexHMoy9Am1owOGzttZjZtbH2ZJ/9PJ0dy0aMZeKtoy80I/pxZ0r7Ew/McOZ+2dWEt0rFd/YjxMrr/BuWSc7XYl18+K9YL/0iZjctzGGZ3P76wDZbEJkGdj6CtXyUKZ+Hk/tv25QjTiTXZ/RxvNTH0J5n6d9Q5yrNBbNx5r5Pb3Jyy/KaWtJHlysDXRJnxzVpjv6b6yhMQiJ2HlUNG5rk2V3M2eho4y4a3hY1tlwszIyGL/BBCm1kw2mi91SpxRragjWMRvGya5ysiBhlHUDL6ieR706V6t567SRL7gAAkmmecPOwyKGCDyFNIQqd4acLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VRWk4byTnHwy2eZ1o2Zt8gFM9RgXPcn04hcOlgUcHU=;
 b=UZ+7KRtYkcY3/FCOxoOw1wN9clMS6UE/sTQUZJEeSH2eUcLEMKZ4MsXpFEHKbqIxcSRgDECwcaWR7LHO0+sZd7T7Hfj5FuOk0/ZngEVfGSaIFJI1aGzpfeVtsgYW0GXv5BN8TcT9YonW/1vHL6qkWnokzCZStyW0fXvCxt9pKQlp9lt9BRc8bd/f5+QQOP1BJb8kiCK82unhZ5QriujNVNPE9q2SgnZWCjcxPl1jrnAub0WNT7rLuZDozy+VqGB8zn2N2cBhMya88p1hzd4Kw2FKjKmZt7H+n+tEwHHQFnkZ4pAu7S7mW/Fnh4OzHIQwcZ/1dJEfvcNoEdylviqFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VRWk4byTnHwy2eZ1o2Zt8gFM9RgXPcn04hcOlgUcHU=;
 b=S1LZpTa7UkiSchVFGckxM4Ui931KNfdXi3xwRXXv/WAp3ZhuskF8tkL+3ZdqVjE6X2R14qjVRZ+QFWfLGmC0eNcTJjeWbgN80dN15Zi08twWTcoP95TTe8WFdMBjHBXaUCQOYpJlw3mHsepwFsHVvuPMf+VgJlIqfEm8FyFqAIs=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Fri, 31 Jul
 2020 00:26:06 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 00:26:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
Thread-Topic: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
Thread-Index: AQHWWaRTwLJlmIhIiUK0CZQgQ7WVGKkfGWqAgAA12uCAAVpUgIAAQGTw
Date:   Fri, 31 Jul 2020 00:26:06 +0000
Message-ID: <MWHPR11MB16452F5E657F26B1137B80C98C4E0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-4-baolu.lu@linux.intel.com>
        <20200729142507.182cd18a@x1.home>
        <MWHPR11MB1645736D9ED91A95D1D4519A8C700@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200730141725.5f63b508@x1.home>
In-Reply-To: <20200730141725.5f63b508@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1250e37-90cb-4004-b3e9-08d834e8509f
x-ms-traffictypediagnostic: MWHPR11MB1599:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1599D2F67FCA648CC3138A7F8C4E0@MWHPR11MB1599.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HilnXslHMvTRVwCYj8JsVZ4fvg3hPNLo3x2f2P7JLutDqFa6QRxz9BwC+kPJgr1P2qrP5R69ic03gDsX8NyeM5yunN50QiDTffbD1EA9TIdzQf6kGqG6G23NJn1OAyCFTCwihaNuGtgLYoj159D7RTrccoMlrec0gp69IYCIaO8ZmIx8Z7ih1aTM2q8NTMfleo3H0q6Vh0cekkBUUHfrAWOfLE67AaYDQJx2PZ563kzdTxgbOeTRdwDM21HuDCLZJP+9ckQd5WCw0+6Mp/D88n0s/uHln01fS4efkmFHBI2A3+PbE0bRX8rqDTIDSvafelPecftD5I/ELkJ5SzsB4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(6506007)(6916009)(76116006)(5660300002)(4326008)(54906003)(2906002)(64756008)(55016002)(66946007)(52536014)(66476007)(7696005)(66446008)(66556008)(8676002)(316002)(9686003)(71200400001)(8936002)(26005)(478600001)(186003)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: D9OZTaJkdTN4ge7+ejD4g2R60MZlrW1qd83Cu4wEHTAHIq9Kw7zQ96Bip7IVdhL7Ix8J6M82qitRbmyTDpsQPxML8hYr2I3ll3hi7oBN0eY2r4UyfTRPuNArA1c0LKQP0lPxMbtOkpVIuQjs0WN4MhOv1yo/6175pQ9/0EONqYyn1dD98Yr5zp2Yk8F3B5if598/xTn4etpvUX3vPiHujcOSkcOxVJd7jcyza9LeVW2VnSQJWeNw4u32zGiFU4BHGLTWUvBlr1IP+93TQbtCLF4nv16U16HW0m44i233/wsMSjseOo4jEE0fqkeXMUpYyozL2xZZXHE0Sm+V3zOIS7o3VB3AfWr8V71xBEq3S1xPlHQOkaUQh9XFbXRNuDYpK5NHx4VgSehMmE3Qvyi9qbj17BvrHCYrrr+tmkrhLnDPzxTWglwNgL3P09q9b3/4Zt7+idnhq/fsDU7tLVARjGfLlBy03ou2fShjRrWHqxTTXxH6On0cOgNuF4F9MkmO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1250e37-90cb-4004-b3e9-08d834e8509f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 00:26:06.1606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WnP98AdjfvhDfFatzazqCzG6Bu2xZo6e32bduGqkilW+1OEDIwYGQr6uKtOfbsqQR6kOcT2lR9tDBxEnEi2YbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, July 31, 2020 4:17 AM
>=20
> On Wed, 29 Jul 2020 23:49:20 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, July 30, 2020 4:25 AM
> > >
> > > On Tue, 14 Jul 2020 13:57:02 +0800
> > > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> > >
> > > > The device driver needs an API to get its aux-domain. A typical usa=
ge
> > > > scenario is:
> > > >
> > > >         unsigned long pasid;
> > > >         struct iommu_domain *domain;
> > > >         struct device *dev =3D mdev_dev(mdev);
> > > >         struct device *iommu_device =3D vfio_mdev_get_iommu_device(=
dev);
> > > >
> > > >         domain =3D iommu_aux_get_domain_for_dev(dev);
> > > >         if (!domain)
> > > >                 return -ENODEV;
> > > >
> > > >         pasid =3D iommu_aux_get_pasid(domain, iommu_device);
> > > >         if (pasid <=3D 0)
> > > >                 return -EINVAL;
> > > >
> > > >          /* Program the device context */
> > > >          ....
> > > >
> > > > This adds an API for such use case.
> > > >
> > > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > > ---
> > > >  drivers/iommu/iommu.c | 18 ++++++++++++++++++
> > > >  include/linux/iommu.h |  7 +++++++
> > > >  2 files changed, 25 insertions(+)
> > > >
> > > > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > > > index cad5a19ebf22..434bf42b6b9b 100644
> > > > --- a/drivers/iommu/iommu.c
> > > > +++ b/drivers/iommu/iommu.c
> > > > @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct
> > > iommu_domain *domain,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
> > > >
> > > > +struct iommu_domain *iommu_aux_get_domain_for_dev(struct
> device
> > > *dev)
> > > > +{
> > > > +	struct iommu_domain *domain =3D NULL;
> > > > +	struct iommu_group *group;
> > > > +
> > > > +	group =3D iommu_group_get(dev);
> > > > +	if (!group)
> > > > +		return NULL;
> > > > +
> > > > +	if (group->aux_domain_attached)
> > > > +		domain =3D group->domain;
> > >
> > > Why wouldn't the aux domain flag be on the domain itself rather than
> > > the group?  Then if we wanted sanity checking in patch 1/ we'd only
> > > need to test the flag on the object we're provided.
> > >
> > > If we had such a flag, we could create an iommu_domain_is_aux()
> > > function and then simply use iommu_get_domain_for_dev() and test that
> > > it's an aux domain in the example use case.  It seems like that would
> >
> > IOMMU layer manages domains per parent device. Here given a
>=20
> Is this the IOMMU layer or the VT-d driver?  I don't see any notion of
> managing domains relative to a parent in the IOMMU layer.  Please point
> to something more specific if I'm wrong here.

it's maintained in VT-d driver (include/linux/intel-iommu.h)

struct device_domain_info {
        struct list_head link;  /* link to domain siblings */
        struct list_head global; /* link to global list */
        struct list_head table; /* link to pasid table */
        struct list_head auxiliary_domains; /* auxiliary domains
                                             * attached to this device
                                             */
	...

>=20
> > dev (of mdev), we need a way to find its associated domain under its
> > parent device. And we cannot simply use iommu_get_domain_for_dev
> > on the parent device of the mdev, as it will give us the primary domain
> > of parent device.
>=20
> Not the parent device of the mdev, but the mdev_dev(mdev) device.
> Isn't that what this series is enabling, being able to return the
> domain from the group that contains the mdev_dev?  We shouldn't need to
> leave breadcrumbs on the group to know about the domain, the domain
> itself should be the source of knowledge, or provide a mechanism/ops to
> learn that knowledge.  Thanks,
>=20
> Alex

It's the tradeoff between leaving breadcrumb in domain or in group.=20
Today the domain has no knowledge of mdev. It just includes a list
of physical devices which are attached to the domain (either due to
the device is assigned in a whole or as the parent device of an assigned
mdev). Then we have two choices. One is to save the mdev_dev info
in device_domain_info and maintain a mapping between mdev_dev
and related aux domain. The other is to record the domain info directly
in group. Earlier we choose the latter one as it looks simpler. If you
prefer to the former one, we can think more and have a try.

Thanks
Kevin
