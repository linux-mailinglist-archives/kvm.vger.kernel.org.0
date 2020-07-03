Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA5213250
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 05:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgGCDr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 23:47:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:61509 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgGCDr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 23:47:56 -0400
IronPort-SDR: XfM7A3AEY2xfrxmhfjmrEsWUvldkCw52mPk1l/MJ7cZSSeA0WMR53cJG/fu4wBVobLGxL0bBrT
 h+bYmJKgbKEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="165143696"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="165143696"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 20:47:55 -0700
IronPort-SDR: NHlSew2WVAObW6PUwpn6BR0RxDE1nGnYjgIdOYdNI1WXq5+oDDCQbOcMtLaDy2Co6qcqvr2Rz0
 X7Fqr/X9QAaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="322296027"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 02 Jul 2020 20:47:55 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 20:47:54 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX159.amr.corp.intel.com (10.22.240.24) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 20:47:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 2 Jul 2020 20:47:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxIQqYduZOymK5ePbSS7KZ7f5J+RI3oMI/5CwLZf5Yxa78/uLO6r01pQeq+xADoA6Yna9T9KxZfxlD1vsd2evGgjJpMoqYiS3/foAD++m2brpY0t23FK18bXDsQOJKLFg4e9Ql9AtvQCkMC26aq9+1ZcvWePKOkYZReJqJqL2cVP9oOJQi/N6pw1HN2+3DL7ZRrtPPJBAgvKr9wOoy0W6sgLghzkHGCzGJLpVHEBmVs+4iIQ8hJtqQN5r3akCnqVJ9FVFuKhYP2FvHNa/MOYlbycbrikCWr2jWdOIhaa6OoLRx4VCeV87mw2HOsDMY1foqNoK52qACCdPq5XbinFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPCx35ypU/85vmciz/rik3BuObPJp1GVePHAzBnEGyY=;
 b=HP5ZV31+T+v4+4Zeibb3bVUCtk2hfLvBOT7LRX6GIbS8GLdUwRO7QFITJyUxYnDWqEH8kp7LuIHUFRiM1LR5sg1rjUDXEEx/EzC6uhsUE/Jxqoa4SCzur+SFRWnzJRj2TYdFE92iVbKg1hyqjzQ6eMSICSGtjTtdr5Z1k39cueCv8C67mTAyfE7xadgq5x+uKJLmLv1pKQA5lJcrH68ofVRuA3+8xGwOjLlOq6dKnZmrZrFkXmLk072B6drMbJuatVS0Cix9hhTgoBqFm6Z2XuZBHgjizkJZ3CDuGErXQSgDzHvSBynXccIp7MvEvBBhL87BHT7tGPGcZlG+SF71cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPCx35ypU/85vmciz/rik3BuObPJp1GVePHAzBnEGyY=;
 b=FFDA2TjLycvLM3jcAMoClv0fycT6Pmeq2TDRBKgR0X9bp36lcadP0StvlH/6erhKKthQZP8GRGgzNzLtfdvZiQroxfVtxQ3A8Kuzuz8hMMPsthYHOcehcwvrTrndltBLqKt+7Pf+H0NMZ78WpF4DSi3MX+lPMfXA7OldTmGSn/U=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4076.namprd11.prod.outlook.com (2603:10b6:5:197::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.28; Fri, 3 Jul 2020 03:47:53 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3131.033; Fri, 3 Jul 2020
 03:47:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 10/14] vfio/type1: Allow invalidating first-level/stage
 IOMMU cache
Thread-Topic: [PATCH v3 10/14] vfio/type1: Allow invalidating
 first-level/stage IOMMU cache
Thread-Index: AQHWSgRSMvsXtUpGHUCWFHE3eZ3aa6j02QoAgABsIQA=
Date:   Fri, 3 Jul 2020 03:47:52 +0000
Message-ID: <DM5PR11MB1435819B92E97F5EC08EBC17C36A0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-11-git-send-email-yi.l.liu@intel.com>
 <20200702151958.430a979d@x1.home>
In-Reply-To: <20200702151958.430a979d@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 204832c0-9804-4b19-d5ac-08d81f03dd53
x-ms-traffictypediagnostic: DM6PR11MB4076:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB407642678A229D9BD1A313C9C36A0@DM6PR11MB4076.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W5BJfzt/O7qE6xXgtyIG0n3aCLyMaBmzH83cc7yLAXLbZyyACFo7MvgrJYQ9WJOfYNhHjcWBY+EDB9INSXLAtGOH+8OJ2yZiTeQbu9w6eM2Wb+ziML3J3WgiEWj5SVmBwQQ3EE/TCiDfYCIPSv0Q1telGjQ4uzfEpHKC1sTApCR9b3HE3Jom0bprQ/rjUlOH1XktjHpLXITPpKyzhg+80pzZ/S1mC4+B3s5tYy832x3y1tF+vkNOJvzgBbH44QPKz07GA285LowfvbEmhZxu9rQsgduMFXbW9rVapJO3TSE1eYmD/as9knWZtEWZaXfUgZA0FhVVzRtHk3wGlV1gkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(52536014)(7696005)(186003)(76116006)(2906002)(54906003)(86362001)(66476007)(5660300002)(316002)(66946007)(478600001)(33656002)(66446008)(64756008)(66556008)(6506007)(26005)(8676002)(6916009)(8936002)(83380400001)(7416002)(55016002)(71200400001)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: n3CDPsyNqjYNAgCE94TlALuXwAWh5fw6+K788pkVt5GvaxAmq48ZLWYACmP2W9gOYjhHN1+eiH1reqly1Xh8rE6P3TKPJa+svc+l+ZLZ2EAIft3cRY3HMpRzC9TaBl+M7KaYqFPCC/PY8dLcrexlZBVKI4/XVIgTLk/IRGeKmq1eDIDoBKYqiLNbHSGnsZMvyxxYA8e4HFPD6ThItRsgnGEymVYEaSHosG8PJvBSICUvh1JkBBwUp6HSq7MQkFxQNIkM9vZ1+BNWaY9vq+Xq/172zMKoUB1Aa/sh24uQgajS6tKQ3bOPkv0kkYw4OXhHjnKgCfkzl9TlWhPpSCJWtImrtJVVeRT9T0r6wJ4hx4zDBdNIW2u02wn+obvpZmqSDq24ahAkfLYXeqdCLTHmOGJVdg6vM9l8B7YLywpsQDMf/YFO5wK8Jso27q3u3OwGZ1qYRWZD3S/MVCqDxanHYPd0X8Cq3Zt4lB+3NA7MBzwAQNTXefGZVg14RJubtYUv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204832c0-9804-4b19-d5ac-08d81f03dd53
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 03:47:52.9817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: la1GVbMa3ImeL5r6UEAuuOgJE6vFWWTLLh8Kclc3Y/2i+zKKD/IJ2i6RN8KJL2qCUMAPrPXYLE6B6lvD58XHGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4076
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Williamson < alex.williamson@redhat.com >
> Sent: Friday, July 3, 2020 5:20 AM
>=20
> On Wed, 24 Jun 2020 01:55:23 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch provides an interface allowing the userspace to invalidate
> > IOMMU cache for first-level page table. It is required when the first
> > level IOMMU page table is not managed by the host kernel in the nested
> > translation setup.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> > v1 -> v2:
> > *) rename from "vfio/type1: Flush stage-1 IOMMU cache for nesting type"
> > *) rename vfio_cache_inv_fn() to vfio_dev_cache_invalidate_fn()
> > *) vfio_dev_cache_inv_fn() always successful
> > *) remove VFIO_IOMMU_CACHE_INVALIDATE, and reuse
> VFIO_IOMMU_NESTING_OP
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 52
> +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  3 +++
> >  2 files changed, 55 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 5926533..4c21300 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -3080,6 +3080,53 @@ static long vfio_iommu_handle_pgtbl_op(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static int vfio_dev_cache_invalidate_fn(struct device *dev, void
> > +*data) {
> > +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > +	unsigned long arg =3D *(unsigned long *) dc->data;
> > +
> > +	iommu_cache_invalidate(dc->domain, dev, (void __user *) arg);
> > +	return 0;
> > +}
> > +
> > +static long vfio_iommu_invalidate_cache(struct vfio_iommu *iommu,
> > +					unsigned long arg)
> > +{
> > +	struct domain_capsule dc =3D { .data =3D &arg };
> > +	struct vfio_group *group;
> > +	struct vfio_domain *domain;
> > +	int ret =3D 0;
> > +	struct iommu_nesting_info *info;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	/*
> > +	 * Cache invalidation is required for any nesting IOMMU,
> > +	 * so no need to check system-wide PASID support.
> > +	 */
> > +	info =3D iommu->nesting_info;
> > +	if (!info || !(info->features & IOMMU_NESTING_FEAT_CACHE_INVLD)) {
> > +		ret =3D -ENOTSUPP;
> > +		goto out_unlock;
> > +	}
> > +
> > +	group =3D vfio_find_nesting_group(iommu);
> > +	if (!group) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	domain =3D list_first_entry(&iommu->domain_list,
> > +				      struct vfio_domain, next);
> > +	dc.group =3D group;
> > +	dc.domain =3D domain->domain;
> > +	iommu_group_for_each_dev(group->iommu_group, &dc,
> > +				 vfio_dev_cache_invalidate_fn);
> > +
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
> >  					unsigned long arg)
> >  {
> > @@ -3102,6 +3149,11 @@ static long vfio_iommu_type1_nesting_op(struct
> vfio_iommu *iommu,
> >  	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
> >  		ret =3D vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
> >  		break;
> > +	case VFIO_IOMMU_NESTING_OP_CACHE_INVLD:
> > +	{
> > +		ret =3D vfio_iommu_invalidate_cache(iommu, arg + minsz);
> > +		break;
> > +	}
>=20
>=20
> Why the {} brackets?  Thanks,

should be removed. will do it.

Regards,
Yi Liu

> Alex
>=20
>=20
> >  	default:
> >  		ret =3D -EINVAL;
> >  	}
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 2c9def8..7f8678e 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1213,6 +1213,8 @@ struct vfio_iommu_type1_pasid_request {
> >   * +-----------------+-----------------------------------------------+
> >   * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
> >   *
> > +-----------------+-----------------------------------------------+
> > + * | CACHE_INVLD     |      struct iommu_cache_invalidate_info       |
> > + *
> > + +-----------------+-----------------------------------------------+
> >   *
> >   * returns: 0 on success, -errno on failure.
> >   */
> > @@ -1225,6 +1227,7 @@ struct vfio_iommu_type1_nesting_op {
> >
> >  #define VFIO_IOMMU_NESTING_OP_BIND_PGTBL	(0)
> >  #define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL	(1)
> > +#define VFIO_IOMMU_NESTING_OP_CACHE_INVLD	(2)
> >
> >  #define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE,
> VFIO_BASE + 19)
> >

