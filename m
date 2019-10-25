Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E0AE49BA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfJYLUn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 25 Oct 2019 07:20:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:31278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfJYLUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:20:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 04:20:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="210694329"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga002.jf.intel.com with ESMTP; 25 Oct 2019 04:20:42 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 04:20:42 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 04:20:42 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX152.ccr.corp.intel.com ([10.239.6.52]) with mapi id 14.03.0439.000;
 Fri, 25 Oct 2019 19:20:40 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
Thread-Topic: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
Thread-Index: AQHVimn1O4LuhvsTnkSBp1bprAulHadqjiuAgACo1uA=
Date:   Fri, 25 Oct 2019 11:20:40 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0D7C23@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
 <1571919983-3231-2-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D04AD@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5D04AD@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmZkY2FkMjMtYWM2YS00YTgxLTliMWItZmUyNmY3NzdkNGU4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWTVIcmVmVHR4NUZLUVhIbFloVG95UGRQZEVQOTJxRXJiU3F5Y2o2Y2VyRkFaY1hTeElzbW9GZDFudE5qT1h2ayJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

> From: Tian, Kevin
> Sent: Friday, October 25, 2019 5:14 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> Subject: RE: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
> 
> > From: Liu, Yi L
> > Sent: Thursday, October 24, 2019 8:26 PM
> >
> > From: Liu Yi L <yi.l.liu@linux.intel.com>
> >
> > When the guest "owns" the stage 1 translation structures,  the host
> > IOMMU driver has no knowledge of caching structure updates unless the
> > guest invalidation requests are trapped and passed down to the host.
> >
> > This patch adds the VFIO_IOMMU_CACHE_INVALIDATE ioctl with aims at
> > propagating guest stage1 IOMMU cache invalidations to the host.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@linux.intel.com>
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 55
> > +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       | 13 ++++++++++
> >  2 files changed, 68 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 96fddc1d..cd8d3a5 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -124,6 +124,34 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >
> > +struct domain_capsule {
> > +	struct iommu_domain *domain;
> > +	void *data;
> > +};
> > +
> > +/* iommu->lock must be held */
> > +static int
> > +vfio_iommu_lookup_dev(struct vfio_iommu *iommu,
> > +		      int (*fn)(struct device *dev, void *data),
> > +		      void *data)
> 
> 'lookup' usually means find a device and then return. But the real purpose here is to
> loop all the devices within this container and then do something. Does it make more
> sense to be vfio_iommu_for_each_dev?

yep, I can replace it.

> 
> > +{
> > +	struct domain_capsule dc = {.data = data};
> > +	struct vfio_domain *d;
[...]
> 2315,6 +2352,24 @@
> > static long vfio_iommu_type1_ioctl(void *iommu_data,
> >
> >  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> >  			-EFAULT : 0;
> > +	} else if (cmd == VFIO_IOMMU_CACHE_INVALIDATE) {
> > +		struct vfio_iommu_type1_cache_invalidate ustruct;
> 
> it's weird to call a variable as struct.

Will fix it.

> > +		int ret;
> > +
> > +		minsz = offsetofend(struct
> > vfio_iommu_type1_cache_invalidate,
> > +				    info);
> > +
> > +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (ustruct.argsz < minsz || ustruct.flags)
> > +			return -EINVAL;
> > +
> > +		mutex_lock(&iommu->lock);
> > +		ret = vfio_iommu_lookup_dev(iommu, vfio_cache_inv_fn,
> > +					    &ustruct);
> > +		mutex_unlock(&iommu->lock);
> > +		return ret;
> >  	}
> >
> >  	return -ENOTTY;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 9e843a1..ccf60a2 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -794,6 +794,19 @@ struct vfio_iommu_type1_dma_unmap {
> >  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> >  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> >
> > +/**
> > + * VFIO_IOMMU_CACHE_INVALIDATE - _IOWR(VFIO_TYPE, VFIO_BASE +
> > 24,
> > + *			struct vfio_iommu_type1_cache_invalidate)
> > + *
> > + * Propagate guest IOMMU cache invalidation to the host.
> 
> guest or first-level/stage-1? Ideally userspace application may also bind its own
> address space as stage-1 one day...

Should be first-level/stage-1. Will correct it.

Thanks,
Yi Liu

