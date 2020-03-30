Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B645197CBA
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgC3NTD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Mar 2020 09:19:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:45903 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgC3NTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 09:19:02 -0400
IronPort-SDR: iP6QIpyw9plJgyyPnOr9++p+DDeKyX3jV8aa48kXzoHyCRHWlIS9SfOib3BCtYCTW1VzgkX/Xl
 7EPPrHFHN6wA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 06:18:58 -0700
IronPort-SDR: 8zvPcR0zGQgPmpOR6KG1knCLH24SObnbiA0e3+IOHMEH6j5tnEn9kgbTVzRejVSDev6Z4LwT9+
 1QMwRvbh40wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,324,1580803200"; 
   d="scan'208";a="251881097"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2020 06:18:56 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 06:18:56 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 21:18:53 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
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
Thread-Index: AQHWAEUdPG4ZbiseEk+Utih92ryiRqhhJVeg
Date:   Mon, 30 Mar 2020 13:18:52 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FFA90@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-9-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880325-10561-9-git-send-email-yi.l.liu@intel.com>
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, March 22, 2020 8:32 PM
> 
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> Recent years, mediated device pass-through framework (e.g. vfio-mdev)
> are used to achieve flexible device sharing across domains (e.g. VMs).

are->is

> Also there are hardware assisted mediated pass-through solutions from
> platform vendors. e.g. Intel VT-d scalable mode which supports Intel
> Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
> backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
> In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-
> domain
> concept, which means mdevs are protected by an iommu domain which is
> aux-domain of its physical device. Details can be found in the KVM

"by an iommu domain which is auxiliary to the domain that the kernel
driver primarily uses for DMA API"

> presentation from Kevin Tian. IOMMU-backed equals to IOMMU-capable.
> 
> https://events19.linuxfoundation.org/wp-content/uploads/2017/12/\
> Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf
> 
> This patch supports NESTING IOMMU for IOMMU-backed mdevs by figuring
> out the physical device of an IOMMU-backed mdev and then invoking
> IOMMU
> requests to IOMMU layer with the physical device and the mdev's aux
> domain info.

"and then calling into the IOMMU layer to complete the vSVA operations
on the aux domain associated with that mdev"

> 
> With this patch, vSVA (Virtual Shared Virtual Addressing) can be used
> on IOMMU-backed mdevs.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> CC: Jun Tian <jun.j.tian@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 937ec3f..d473665 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -132,6 +132,7 @@ struct vfio_regions {
> 
>  struct domain_capsule {
>  	struct iommu_domain *domain;
> +	struct vfio_group *group;
>  	void *data;
>  };
> 
> @@ -148,6 +149,7 @@ static int vfio_iommu_for_each_dev(struct
> vfio_iommu *iommu,
>  	list_for_each_entry(d, &iommu->domain_list, next) {
>  		dc.domain = d->domain;
>  		list_for_each_entry(g, &d->group_list, next) {
> +			dc.group = g;
>  			ret = iommu_group_for_each_dev(g->iommu_group,
>  						       &dc, fn);
>  			if (ret)
> @@ -2347,7 +2349,12 @@ static int vfio_bind_gpasid_fn(struct device *dev,
> void *data)
>  	struct iommu_gpasid_bind_data *gbind_data =
>  		(struct iommu_gpasid_bind_data *) dc->data;
> 
> -	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
> +	if (dc->group->mdev_group)
> +		return iommu_sva_bind_gpasid(dc->domain,
> +			vfio_mdev_get_iommu_device(dev), gbind_data);
> +	else
> +		return iommu_sva_bind_gpasid(dc->domain,
> +						dev, gbind_data);
>  }
> 
>  static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> @@ -2356,8 +2363,13 @@ static int vfio_unbind_gpasid_fn(struct device
> *dev, void *data)
>  	struct iommu_gpasid_bind_data *gbind_data =
>  		(struct iommu_gpasid_bind_data *) dc->data;
> 
> -	return iommu_sva_unbind_gpasid(dc->domain, dev,
> +	if (dc->group->mdev_group)
> +		return iommu_sva_unbind_gpasid(dc->domain,
> +					vfio_mdev_get_iommu_device(dev),
>  					gbind_data->hpasid);
> +	else
> +		return iommu_sva_unbind_gpasid(dc->domain, dev,
> +						gbind_data->hpasid);
>  }
> 
>  /**
> @@ -2429,7 +2441,12 @@ static int vfio_cache_inv_fn(struct device *dev,
> void *data)
>  	struct iommu_cache_invalidate_info *cache_inv_info =
>  		(struct iommu_cache_invalidate_info *) dc->data;
> 
> -	return iommu_cache_invalidate(dc->domain, dev, cache_inv_info);
> +	if (dc->group->mdev_group)
> +		return iommu_cache_invalidate(dc->domain,
> +			vfio_mdev_get_iommu_device(dev), cache_inv_info);
> +	else
> +		return iommu_cache_invalidate(dc->domain,
> +						dev, cache_inv_info);
>  }

possibly above could be simplified, e.g. 

static struct device *vfio_get_iommu_device(struct vfio_group *group, 
	struct device *dev)
{
	if  (group->mdev_group)
		return vfio_mdev_get_iommu_device(dev);
	else
		return dev;
}

Then use it to replace plain 'dev' in all three places.

> 
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
> --
> 2.7.4

