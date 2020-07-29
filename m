Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480AA232824
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 01:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgG2XfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:35:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:28720 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgG2XfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 19:35:23 -0400
IronPort-SDR: /397HDHSk5TDii+VoneYERU50ZLWZAKoR2KvPOH1Y3QNhJP1blg43G++cmtKra/UC68k6fpivg
 LQ1WS8MKU9sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169637096"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="169637096"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 16:34:42 -0700
IronPort-SDR: lRByYnKiFa1Bj4mlYYYO388tN5rhxmOO15Pa7uaC4s58pc7idigFd9VOY7Xw6dBh8EvIL/1zho
 pNbvq9ZHUtqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="320897250"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga008.jf.intel.com with ESMTP; 29 Jul 2020 16:34:42 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 16:34:42 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX153.amr.corp.intel.com (10.22.226.247) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 16:34:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 16:34:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRXWNlccxBgEYXACFLjap9dIzz578F8Ga4wkBSBkDBSnCbaz+LwjVuxOHqhsjmer8FIPI2F3Pf1vYGn6FFjRLlM0HxPMqMsBEITirW6AWf1mvkdspC/0+yciRIVQcQb4q5q5+XESEunhJ4Rvd4AgUXpW2sHxQPJ9L6FYNS8WAI072KAb0JE2ejGSOm0SRmMn2Qbs02z0JMydbDSTWAqcWdIX8MNpx/XdUL9uiwOW4kqhMWJTxmrQgfBRcylZ3bHPLouRLyyXd4OKBleh6pj0VOynWijMNja3y4OymLZV6tHaNCH849snu5uG6Q9fR6kMrQQqSb+2m8TzJQLpW99VFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/EmDuC9CR/chjwtQipnBbebgAeAy2qwWaZqH5ofCqU=;
 b=HISEcmWFW6+zQWrKoK+bQmwZx24uVgf+d63V5o5oF4hZCKLGiQiC6pNid9Uo1mi+eD+leLF2zQFBMplUwuOMdI5NufzGa7rLiRPtsRTsrFaU35V2T50wWaGCeKkBPzVKnfQF1863vCxP2ZK8qgI63/w5lNpUOFKJ+WG6KdwitloZh2lwH/h99Z63a0wUE7vAh2ZsXw7ffpuw2Ee7Fp1mxFy2+g5Qt6nmzw4O2Ety1cbvBSkMJiXnLESOVUeaOyprKRQpz298dwPIjyR/T4ykHVdQUZSkekhFU1ifdJTJfqIERzOk64jr3/V/B9YwsJCHx0WF6g4r/LzFKehX6Kh1mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/EmDuC9CR/chjwtQipnBbebgAeAy2qwWaZqH5ofCqU=;
 b=ijqGfzsdUu9JR+UIl1W79uFoYLuMoWbSYPw9yPvD/nzqRI/tNItISUsInE4x1N6/3wW2gWcAMq7AgqBd+K2wLWKHFWpPa0Y0NiCdNwDlQ36+FGbLJ2I50zvM6RYVCQzjQ3zlMTOaSvmOYk0pfn23i27sbCRvBa/CEsgbX/F7WKE=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB0015.namprd11.prod.outlook.com (2603:10b6:301:66::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 29 Jul
 2020 23:34:40 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 23:34:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v3 2/4] iommu: Add iommu_aux_at(de)tach_group()
Thread-Topic: [PATCH v3 2/4] iommu: Add iommu_aux_at(de)tach_group()
Thread-Index: AQHWWaRQ/iShkhawREexh2T3KuYZVKkHR0+AgACIeACAAP9FAIAAmLMAgBWrqACAADjVQA==
Date:   Wed, 29 Jul 2020 23:34:40 +0000
Message-ID: <MWHPR11MB16454283959A365ED7964C488C700@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-3-baolu.lu@linux.intel.com>
        <20200714093909.1ab93c9e@jacob-builder>
        <b5b22e01-4a51-8dfe-9ba4-aeca783740f1@linux.intel.com>
        <20200715090114.50a459d4@jacob-builder>
        <435a2014-c2e8-06b9-3c9a-4afbf6607ffe@linux.intel.com>
 <20200729140336.09d2bfe7@x1.home>
In-Reply-To: <20200729140336.09d2bfe7@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efc08fbd-7c0a-4a8d-0a54-08d83417f6e8
x-ms-traffictypediagnostic: MWHPR11MB0015:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00150735866CA542C9A76F738C700@MWHPR11MB0015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: txI0HcAQwvXFdOXrWaLqmIwbxA0P7vU3OJGlgxSTJWBsAXDNwSlnYaKQIGV4fcx6/PB46YnNefcdmBFS9QqFGMwMOZYh9swat0ojNoapjR/UoAAQjGwE5F1/4uUM+jYdl+hBe4gkwP15LA39RLOYeK3ri4UY1Q8+2o3EeyP14VoT89E/y6u1JypZRC5xazRQI2UfS4kvzD41C9EApbEkdU425G1WtVcHPawx5Aea9D18k69XIWWgJHXSsoUEOgBWXdIfO0rulGj5eXSKoU2QqApPnDpIWYgUQEn3zBt37x5NyNSxzoyAYWAmBqBdVqhRmwzaPX+qC7lEJ2AC/FoBgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(53546011)(66946007)(76116006)(64756008)(66476007)(6506007)(8676002)(66446008)(66556008)(5660300002)(478600001)(9686003)(71200400001)(26005)(7696005)(316002)(52536014)(54906003)(55016002)(4326008)(2906002)(186003)(83380400001)(33656002)(8936002)(7416002)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DPhHZOIW37t5MfsUHlvCQBWvn9XoSMP4/f5JjRwyDrYn0FKdCS2XstAtdKJ9OMzfxFbyoX9/6ZT02q32YcexJ7C5iGF/62Ud0zkDDuooD7XnnIOJ3R4uEBkomi4+Ji3GsyQKTz7nLBzAy4o/N3db12+xvjWKWcq/2RXDCbjqodjdXCZHE60wNrDg6yd+XHozX7sgkmDqzC51Jef/LrcWpPUNRQ05etYUAOVUQq+gvnU+1pWTTnemutk1SFHoiS30URCwQGg7cbb+T0SIjnKGVBNhv9BcAFBB/3R2nVwrZbsO+pdBbx2imvJO4fxiZd+vzrQTxbZ6KWQamZQYroSq2BZ2hLFH0RWxQ7kzh4xYupVW8bxqLTsKkbmjFzloGg8tsKDrsywHYxOW+K2Ljhq3UnJYFhCKdHxW5utTOGHpY+VQfMc5UyXEGhKMDETin1pR6hf5PVWSK12yimeW7lT2Up62kJWiEvL05pO4oT7rnlAA/14WA5FflSN3natHV/kU/7w9JKHQ5PLgBukaa4KAri+kLz1VIaS1+PduDEJaPBl9hhQYcyUFguq5WwXPwETUMUpFvZy7YJpS9OqtQ+bhn3Lll6fgmxo0D3IKkrDhxm3Fgw40WH2u/StIsNZ9BFF2qy5dpsNQJan3lrLjI74JLg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc08fbd-7c0a-4a8d-0a54-08d83417f6e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 23:34:40.3529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctUmX1SXWbzV8/VLAARXOnHpy2R7Y4i4uxbOjxjmUvU7JVl6rupz3F5s04ELB4eBog1Jwsy2q2nPHYeUHrt1rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0015
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, July 30, 2020 4:04 AM
>=20
> On Thu, 16 Jul 2020 09:07:46 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
>=20
> > Hi Jacob,
> >
> > On 7/16/20 12:01 AM, Jacob Pan wrote:
> > > On Wed, 15 Jul 2020 08:47:36 +0800
> > > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> > >
> > >> Hi Jacob,
> > >>
> > >> On 7/15/20 12:39 AM, Jacob Pan wrote:
> > >>> On Tue, 14 Jul 2020 13:57:01 +0800
> > >>> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> > >>>
> > >>>> This adds two new aux-domain APIs for a use case like vfio/mdev
> > >>>> where sub-devices derived from an aux-domain capable device are
> > >>>> created and put in an iommu_group.
> > >>>>
> > >>>> /**
> > >>>>    * iommu_aux_attach_group - attach an aux-domain to an
> iommu_group
> > >>>> which
> > >>>>    *                          contains sub-devices (for example
> > >>>> mdevs) derived
> > >>>>    *                          from @dev.
> > >>>>    * @domain: an aux-domain;
> > >>>>    * @group:  an iommu_group which contains sub-devices derived
> from
> > >>>> @dev;
> > >>>>    * @dev:    the physical device which supports
> IOMMU_DEV_FEAT_AUX.
> > >>>>    *
> > >>>>    * Returns 0 on success, or an error value.
> > >>>>    */
> > >>>> int iommu_aux_attach_group(struct iommu_domain *domain,
> > >>>>                              struct iommu_group *group,
> > >>>>                              struct device *dev)
> > >>>>
> > >>>> /**
> > >>>>    * iommu_aux_detach_group - detach an aux-domain from an
> > >>>> iommu_group *
> > >>>>    * @domain: an aux-domain;
> > >>>>    * @group:  an iommu_group which contains sub-devices derived
> from
> > >>>> @dev;
> > >>>>    * @dev:    the physical device which supports
> IOMMU_DEV_FEAT_AUX.
> > >>>>    *
> > >>>>    * @domain must have been attached to @group via
> > >>>> iommu_aux_attach_group(). */
> > >>>> void iommu_aux_detach_group(struct iommu_domain *domain,
> > >>>>                               struct iommu_group *group,
> > >>>>                               struct device *dev)
> > >>>>
> > >>>> It also adds a flag in the iommu_group data structure to identify
> > >>>> an iommu_group with aux-domain attached from those normal ones.
> > >>>>
> > >>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
> > >>>> ---
> > >>>>    drivers/iommu/iommu.c | 58
> > >>>> +++++++++++++++++++++++++++++++++++++++++++
> include/linux/iommu.h |
> > >>>> 17 +++++++++++++ 2 files changed, 75 insertions(+)
> > >>>>
> > >>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > >>>> index e1fdd3531d65..cad5a19ebf22 100644
> > >>>> --- a/drivers/iommu/iommu.c
> > >>>> +++ b/drivers/iommu/iommu.c
> > >>>> @@ -45,6 +45,7 @@ struct iommu_group {
> > >>>>    	struct iommu_domain *default_domain;
> > >>>>    	struct iommu_domain *domain;
> > >>>>    	struct list_head entry;
> > >>>> +	unsigned int aux_domain_attached:1;
> > >>>>    };
> > >>>>
> > >>>>    struct group_device {
> > >>>> @@ -2759,6 +2760,63 @@ int iommu_aux_get_pasid(struct
> iommu_domain
> > >>>> *domain, struct device *dev) }
> > >>>>    EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
> > >>>>
> > >>>> +/**
> > >>>> + * iommu_aux_attach_group - attach an aux-domain to an
> iommu_group
> > >>>> which
> > >>>> + *                          contains sub-devices (for example
> > >>>> mdevs) derived
> > >>>> + *                          from @dev.
> > >>>> + * @domain: an aux-domain;
> > >>>> + * @group:  an iommu_group which contains sub-devices derived
> from
> > >>>> @dev;
> > >>>> + * @dev:    the physical device which supports
> IOMMU_DEV_FEAT_AUX.
> > >>>> + *
> > >>>> + * Returns 0 on success, or an error value.
> > >>>> + */
> > >>>> +int iommu_aux_attach_group(struct iommu_domain *domain,
> > >>>> +			   struct iommu_group *group, struct
> > >>>> device *dev) +{
> > >>>> +	int ret =3D -EBUSY;
> > >>>> +
> > >>>> +	mutex_lock(&group->mutex);
> > >>>> +	if (group->domain)
> > >>>> +		goto out_unlock;
> > >>>> +
> > >>> Perhaps I missed something but are we assuming only one mdev per
> > >>> mdev group? That seems to change the logic where vfio does:
> > >>> iommu_group_for_each_dev()
> > >>> 	iommu_aux_attach_device()
> > >>>
> > >>
> > >> It has been changed in PATCH 4/4:
> > >>
> > >> static int vfio_iommu_attach_group(struct vfio_domain *domain,
> > >>                                      struct vfio_group *group)
> > >> {
> > >>           if (group->mdev_group)
> > >>                   return iommu_aux_attach_group(domain->domain,
> > >>                                                 group->iommu_group,
> > >>                                                 group->iommu_device)=
;
> > >>           else
> > >>                   return iommu_attach_group(domain->domain,
> > >> group->iommu_group);
> > >> }
> > >>
> > >> So, for both normal domain and aux-domain, we use the same concept:
> > >> attach a domain to a group.
> > >>
> > > I get that, but don't you have to attach all the devices within the
> >
> > This iommu_group includes only mediated devices derived from an
> > IOMMU_DEV_FEAT_AUX-capable device. Different from
> iommu_attach_group(),
> > iommu_aux_attach_group() doesn't need to attach the domain to each
> > device in group, instead it only needs to attach the domain to the
> > physical device where the mdev's were created from.
> >
> > > group? Here you see the group already has a domain and exit.
> >
> > If the (group->domain) has been set, that means a domain has already
> > attached to the group, so it returns -EBUSY.
>=20
> I agree with Jacob, singleton groups should not be built into the IOMMU
> API, we're not building an interface just for mdevs or current
> limitations of mdevs.  This also means that setting a flag on the group
> and passing a device that's assumed to be common for all devices within
> the group, don't really make sense here.  Thanks,
>=20
> Alex

Baolu and I discussed about this assumption before. The assumption is
not based on singleton groups. We do consider multiple mdevs in one
group. But our feeling at the moment is that all mdevs (or other AUX
derivatives) in the same group should come from the same parent=20
device, thus comes with above design. Does it sound a reasonable
assumption to you?

Thanks
Keivn
