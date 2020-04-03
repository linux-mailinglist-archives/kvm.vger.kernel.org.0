Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDF419D7CB
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390909AbgDCNjb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 09:39:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:36619 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgDCNjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 09:39:31 -0400
IronPort-SDR: W7XAZGV9hPoJJcQU78XW7S08SS+/U9gLbS6m8Fg+F2lvuZRBV2QzMxU+jjmYWxNd3izKyZBum3
 Du8+KDs6etjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 06:39:30 -0700
IronPort-SDR: 8GigXOadN4Q1oxFpOj79P+I8YV4QiER2FMPqfIQPp/S4zJTejr2TmdkwG9/FItHsUKUdrfzqzW
 Apt8v/rBmVtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="238885929"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 03 Apr 2020 06:39:29 -0700
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 06:39:29 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 06:39:29 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 21:39:27 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 8/8] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Topic: [PATCH v1 8/8] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Index: AQHWAEUdm3FJ38v7KEeZ+HXvm2TTUKhl1VgAgAGinHA=
Date:   Fri, 3 Apr 2020 13:39:26 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220BCF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-9-git-send-email-yi.l.liu@intel.com>
 <20200402143342.1e10c498@w520.home>
In-Reply-To: <20200402143342.1e10c498@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 3, 2020 4:34 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 8/8] vfio/type1: Add vSVA support for IOMMU-backed
> mdevs
> 
> On Sun, 22 Mar 2020 05:32:05 -0700
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > Recent years, mediated device pass-through framework (e.g. vfio-mdev)
> > are used to achieve flexible device sharing across domains (e.g. VMs).
> > Also there are hardware assisted mediated pass-through solutions from
> > platform vendors. e.g. Intel VT-d scalable mode which supports Intel
> > Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
> > backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
> > In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-domain
> > concept, which means mdevs are protected by an iommu domain which is
> > aux-domain of its physical device. Details can be found in the KVM
> > presentation from Kevin Tian. IOMMU-backed equals to IOMMU-capable.
> >
> > https://events19.linuxfoundation.org/wp-content/uploads/2017/12/\
> > Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf
> >
> > This patch supports NESTING IOMMU for IOMMU-backed mdevs by figuring
> > out the physical device of an IOMMU-backed mdev and then invoking IOMMU
> > requests to IOMMU layer with the physical device and the mdev's aux
> > domain info.
> >
> > With this patch, vSVA (Virtual Shared Virtual Addressing) can be used
> > on IOMMU-backed mdevs.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > CC: Jun Tian <jun.j.tian@intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 937ec3f..d473665 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -132,6 +132,7 @@ struct vfio_regions {
> >
> >  struct domain_capsule {
> >  	struct iommu_domain *domain;
> > +	struct vfio_group *group;
> >  	void *data;
> >  };
> >
> > @@ -148,6 +149,7 @@ static int vfio_iommu_for_each_dev(struct vfio_iommu
> *iommu,
> >  	list_for_each_entry(d, &iommu->domain_list, next) {
> >  		dc.domain = d->domain;
> >  		list_for_each_entry(g, &d->group_list, next) {
> > +			dc.group = g;
> >  			ret = iommu_group_for_each_dev(g->iommu_group,
> >  						       &dc, fn);
> >  			if (ret)
> > @@ -2347,7 +2349,12 @@ static int vfio_bind_gpasid_fn(struct device *dev, void
> *data)
> >  	struct iommu_gpasid_bind_data *gbind_data =
> >  		(struct iommu_gpasid_bind_data *) dc->data;
> >
> > -	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
> > +	if (dc->group->mdev_group)
> > +		return iommu_sva_bind_gpasid(dc->domain,
> > +			vfio_mdev_get_iommu_device(dev), gbind_data);
> 
> But we can't assume an mdev device is iommu backed, so this can call
> with NULL dev, which appears will pretty quickly segfault
> intel_svm_bind_gpasid.

I don't think the non-iommu backed mdev will not be in the
iommu->domain_list. right? But, yeah, from this function p.o.v
, it is still necessary to do a check. How about adding a check
on the return of vfio_mdev_get_iommu_device(dev)? If iommu_device
is fetch, the mdev should be iommu-backed. does it make sense?

Regards,
Yi Liu

> 
> > +	else
> > +		return iommu_sva_bind_gpasid(dc->domain,
> > +						dev, gbind_data);
> >  }
> >
> >  static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> > @@ -2356,8 +2363,13 @@ static int vfio_unbind_gpasid_fn(struct device *dev,
> void *data)
> >  	struct iommu_gpasid_bind_data *gbind_data =
> >  		(struct iommu_gpasid_bind_data *) dc->data;
> >
> > -	return iommu_sva_unbind_gpasid(dc->domain, dev,
> > +	if (dc->group->mdev_group)
> > +		return iommu_sva_unbind_gpasid(dc->domain,
> > +					vfio_mdev_get_iommu_device(dev),
> >  					gbind_data->hpasid);
> 
> Same
> 
> > +	else
> > +		return iommu_sva_unbind_gpasid(dc->domain, dev,
> > +						gbind_data->hpasid);
> >  }
> >
> >  /**
> > @@ -2429,7 +2441,12 @@ static int vfio_cache_inv_fn(struct device *dev, void
> *data)
> >  	struct iommu_cache_invalidate_info *cache_inv_info =
> >  		(struct iommu_cache_invalidate_info *) dc->data;
> >
> > -	return iommu_cache_invalidate(dc->domain, dev, cache_inv_info);
> > +	if (dc->group->mdev_group)
> > +		return iommu_cache_invalidate(dc->domain,
> > +			vfio_mdev_get_iommu_device(dev), cache_inv_info);
> 
> And again
> 
> > +	else
> > +		return iommu_cache_invalidate(dc->domain,
> > +						dev, cache_inv_info);
> >  }
> >
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,

