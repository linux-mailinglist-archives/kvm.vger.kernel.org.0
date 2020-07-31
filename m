Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3E233D2D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbgGaCRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:17:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:3570 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbgGaCRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:17:38 -0400
IronPort-SDR: koheKiP57+dNHR7H7q014pdUuoetHH1q7zTlTFTyno3jvAxknzJVwhXLjhr/kiMfu39v4PgAsE
 Ojy5l9xZjtXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="151690537"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="151690537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:17:38 -0700
IronPort-SDR: o6FQcQTYgHSTAeR0MKWsujW518DcDxoncJQV/uAlCMuv8PgMBHJpKdT/ftKE9JFuOv3izITqIx
 6RTFNeFAZVSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="329126482"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jul 2020 19:17:38 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jul 2020 19:17:37 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jul 2020 19:17:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 30 Jul 2020 19:17:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBoIbptA8HftHcbDMZW4rIPq5U1KxqE4twU1FKTwBO8UvOmzcJiLJMOu7l8DZFuynp3ohK8Ia86pfZM5tRuTTKDuBN9alFTEo/VAVwpAGux74t0ZRnF+I2kydiSa36zmPY81vUTkBSaSEiBL2yXzqPWdYx5nVTbvwfrggRjs0kKYF3p0g0WKrBwOsUl8dq6+IMzUEGdu4gM0AKNinFmeWB4iw4uM2VzJWEivdzKX+HMfyYc60PW8KjoQxARCudK9ug5TZH4kAzzPaxkKOdP5dQuwzznEtqefIR/nqBcMim1QhsveprLbI0y3htciSqkAIq+H1LzKIuOf1hfXZxG9YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5Hd0VOanbh5wNV6djVF1hlilBXYBwCUanf85L0Y37g=;
 b=m4Muf+GGZGcRVIgptuSWdp5ILWFEyMgZayOQ6KSFmWwRbbPzsmnFy9HcYa80SqLoNd3gRrB2VlqoULpOq2VrBF89bldSOY5cIHk8EOle6kwA9Y5ZRcjCxto+SjcgR7x+rCR8w6BMZyRINDXCkb5LP2wzIua/OlLh8PJwzgdA4LgxQpIbdHV/xMx0Q2SkvSDBZ8Jj6iDqywWISp1EX49ngewIj+yBRzgELA4ZT1IUXeUJcKx5bKmQSiBUY2QZC8BZQABKTPjarf0xihg8GL4S80cyyIZTltD7tpee21NGkHmxxZSP/GXJyiYApSW/hAhmzWYsw8fT4xHLdoJZHpVOFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5Hd0VOanbh5wNV6djVF1hlilBXYBwCUanf85L0Y37g=;
 b=Dm3P2Tob7oshAOtL+UJW63GXhXsD4tcLS3R2bJcVbbK3tEQvWQr34R5BMPedl4o0lrq85L+P2cTMpWzViztJ0j8Uln0z8K4UUTsUjYdQNir6lqADyEx+vMgl9ql0o2az0M8a3HAcxxKDoA9lZ0IvN0lsmDYUQ+EYNJh+yVAK00M=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1341.namprd11.prod.outlook.com (2603:10b6:300:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Fri, 31 Jul
 2020 02:17:35 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 02:17:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
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
Thread-Index: AQHWWaRTwLJlmIhIiUK0CZQgQ7WVGKkfGWqAgAA12uCAAVpUgIAAQGTwgAAj6YA=
Date:   Fri, 31 Jul 2020 02:17:35 +0000
Message-ID: <MWHPR11MB1645E578E14085A0E11A538A8C4E0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-4-baolu.lu@linux.intel.com>
        <20200729142507.182cd18a@x1.home>
        <MWHPR11MB1645736D9ED91A95D1D4519A8C700@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200730141725.5f63b508@x1.home> 
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
x-ms-office365-filtering-correlation-id: 94014ddc-b300-45f0-b828-08d834f7e3dd
x-ms-traffictypediagnostic: MWHPR11MB1341:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB13418165F72164751B5C9B438C4E0@MWHPR11MB1341.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXpv7ZzrlmPgHGRM6N7sMjq0d8SduYQgIX4JUufd+zDO2a7mMFNJLCW9ErNn5HoGReujCe15gtJ03bvVnnIdo2+LVphCz2NkY0bSrx/p4xIM/DLIKGYLEbQikNcSdxlON0aiGlQmolMCH5OVl3HxUBYDD9B2iiEWC2hQvYKSy/xenbl4q/NKUpot1uQMC1ErRVK8l63bepcTGvThmLgCQtsEpP/m4VuSvT6I8qNCxhOwatv+wrxfvaMrMs3VJrsDSJJxHhp/PBO1lqItJA4pIXB8Oez/T5H0Ft4r5301CfZS1H7wWzTQwtf7AvyjhJ5MU38hYayGtzvZh9pjnzFnhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(66446008)(186003)(64756008)(66476007)(76116006)(66946007)(33656002)(6916009)(54906003)(478600001)(86362001)(2906002)(26005)(66556008)(71200400001)(316002)(55016002)(9686003)(52536014)(5660300002)(7696005)(6506007)(4326008)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KW/uUc9Asaaoss0LA7Dvpu+qFmjZGEJW1eyYqCpfd+cdYa+a8OrxTy9u2BiM3VhwonRUCC0rVhwvOcelizl6e0JQGmTwBSgNkyJwZGMzqKrJ2jb1soNjrv533R/BIZ37z+iaaA5NQqNlnNuUlXAp6bkuO+FzmYPAjmURS8CX4T28+Z3fYu/sBTG3EaptlzNbTaJHTGk2FsyyDvSCTnSYBaBEuQuX45k5S2azhqo9sFd0lF20KVRy2Id6eKDdm7tJK/bqtaUMnrVDhr9DEidKrxWQzyBCukpz2xBmA/PrtivUGMb3SOOfDwmDwaGn+0VlAxtCuq+XKeI7/M/OuRM0OmJ4bCpUgnwtba18hsxu2Z/foiAneUmjmHTlB0J506Fw/CLnA4PSrBu9sbjmatC47e6F7Y3QdlyJxGmkDqlNqED0nLbQaffJV3pBrUcyn1pZcfRmb06rHvwI73S7u/bOuh1bpwiS7o8uNwMQQ1dV2msMvPw4nW7qjoJIL4VYMuAzDASaesWkOHQO0Au9CfF4PfxmXi89PlUhSMqOhFpbAE/VV9l8gRmCkR2zV8AKAoLU/q/d8f29YnqYTX7onfxNitD1YwXRI120mmuOx09IjxJ0d1oOJk22Zl3EbnYDr2rt936tzS/7IhFhcnPtZKaiLg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94014ddc-b300-45f0-b828-08d834f7e3dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 02:17:35.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0bPb5iMMhYz/qviKuQzvxhyieVCeUX63aZpiHyec9En6AWJJPQRdg4huTgubJErACfDtNDK9NGycwnGgFmgrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1341
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Friday, July 31, 2020 8:26 AM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, July 31, 2020 4:17 AM
> >
> > On Wed, 29 Jul 2020 23:49:20 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, July 30, 2020 4:25 AM
> > > >
> > > > On Tue, 14 Jul 2020 13:57:02 +0800
> > > > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> > > >
> > > > > The device driver needs an API to get its aux-domain. A typical u=
sage
> > > > > scenario is:
> > > > >
> > > > >         unsigned long pasid;
> > > > >         struct iommu_domain *domain;
> > > > >         struct device *dev =3D mdev_dev(mdev);
> > > > >         struct device *iommu_device =3D
> vfio_mdev_get_iommu_device(dev);
> > > > >
> > > > >         domain =3D iommu_aux_get_domain_for_dev(dev);
> > > > >         if (!domain)
> > > > >                 return -ENODEV;
> > > > >
> > > > >         pasid =3D iommu_aux_get_pasid(domain, iommu_device);
> > > > >         if (pasid <=3D 0)
> > > > >                 return -EINVAL;
> > > > >
> > > > >          /* Program the device context */
> > > > >          ....
> > > > >
> > > > > This adds an API for such use case.
> > > > >
> > > > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > > > ---
> > > > >  drivers/iommu/iommu.c | 18 ++++++++++++++++++
> > > > >  include/linux/iommu.h |  7 +++++++
> > > > >  2 files changed, 25 insertions(+)
> > > > >
> > > > > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > > > > index cad5a19ebf22..434bf42b6b9b 100644
> > > > > --- a/drivers/iommu/iommu.c
> > > > > +++ b/drivers/iommu/iommu.c
> > > > > @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct
> > > > iommu_domain *domain,
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
> > > > >
> > > > > +struct iommu_domain *iommu_aux_get_domain_for_dev(struct
> > device
> > > > *dev)
> > > > > +{
> > > > > +	struct iommu_domain *domain =3D NULL;
> > > > > +	struct iommu_group *group;
> > > > > +
> > > > > +	group =3D iommu_group_get(dev);
> > > > > +	if (!group)
> > > > > +		return NULL;
> > > > > +
> > > > > +	if (group->aux_domain_attached)
> > > > > +		domain =3D group->domain;
> > > >
> > > > Why wouldn't the aux domain flag be on the domain itself rather tha=
n
> > > > the group?  Then if we wanted sanity checking in patch 1/ we'd only
> > > > need to test the flag on the object we're provided.
> > > >
> > > > If we had such a flag, we could create an iommu_domain_is_aux()
> > > > function and then simply use iommu_get_domain_for_dev() and test
> that
> > > > it's an aux domain in the example use case.  It seems like that wou=
ld
> > >
> > > IOMMU layer manages domains per parent device. Here given a
> >
> > Is this the IOMMU layer or the VT-d driver?  I don't see any notion of
> > managing domains relative to a parent in the IOMMU layer.  Please point
> > to something more specific if I'm wrong here.
>=20
> it's maintained in VT-d driver (include/linux/intel-iommu.h)
>=20
> struct device_domain_info {
>         struct list_head link;  /* link to domain siblings */
>         struct list_head global; /* link to global list */
>         struct list_head table; /* link to pasid table */
>         struct list_head auxiliary_domains; /* auxiliary domains
>                                              * attached to this device
>                                              */
> 	...
>=20
> >
> > > dev (of mdev), we need a way to find its associated domain under its
> > > parent device. And we cannot simply use iommu_get_domain_for_dev
> > > on the parent device of the mdev, as it will give us the primary doma=
in
> > > of parent device.
> >
> > Not the parent device of the mdev, but the mdev_dev(mdev) device.
> > Isn't that what this series is enabling, being able to return the
> > domain from the group that contains the mdev_dev?  We shouldn't need
> to
> > leave breadcrumbs on the group to know about the domain, the domain
> > itself should be the source of knowledge, or provide a mechanism/ops to
> > learn that knowledge.  Thanks,
> >
> > Alex
>=20
> It's the tradeoff between leaving breadcrumb in domain or in group.
> Today the domain has no knowledge of mdev. It just includes a list
> of physical devices which are attached to the domain (either due to
> the device is assigned in a whole or as the parent device of an assigned
> mdev). Then we have two choices. One is to save the mdev_dev info
> in device_domain_info and maintain a mapping between mdev_dev
> and related aux domain. The other is to record the domain info directly
> in group. Earlier we choose the latter one as it looks simpler. If you
> prefer to the former one, we can think more and have a try.
>=20

Please skip this comment. I have a wrong understanding of the problem
and is discussing with Baolu. He will reply with our conclusion later.

Thanks
Kevin
