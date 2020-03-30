Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCBE1976C7
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 10:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgC3IlM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Mar 2020 04:41:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:25475 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728994AbgC3IlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 04:41:12 -0400
IronPort-SDR: N4Ah5x9e8fGgy48tKitjM6i1kpQBZ8+OA9aHZxa36L6+vmVzjD6CrnD+ldSXulj9XtoyoFvWx4
 Hpe9yAnhsmSw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 01:41:11 -0700
IronPort-SDR: wGVeRflbVpIH9JGxfzE+chG8cDJEH2vJJukJndIH4VToaUYWtUGnyBgb5ToVkdYz99P+KrnrCz
 RqZPZB/2TjIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,323,1580803200"; 
   d="scan'208";a="237283947"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2020 01:41:10 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 01:40:59 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 01:40:59 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 16:40:55 +0800
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
Subject: RE: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for
 quota tuning
Thread-Topic: [PATCH v1 2/8] vfio/type1: Add vfio_iommu_type1 parameter for
 quota tuning
Thread-Index: AQHWAEUbX2o9koiJmUSoQpAjbhigyahg28IA
Date:   Mon, 30 Mar 2020 08:40:55 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF3C5@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-3-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880325-10561-3-git-send-email-yi.l.liu@intel.com>
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
> This patch adds a module option to make the PASID quota tunable by
> administrator.
> 
> TODO: needs to think more on how to  make the tuning to be per-process.
> 
> Previous discussions:
> https://patchwork.kernel.org/patch/11209429/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c             | 8 +++++++-
>  drivers/vfio/vfio_iommu_type1.c | 7 ++++++-
>  include/linux/vfio.h            | 3 ++-
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index d13b483..020a792 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2217,13 +2217,19 @@ struct vfio_mm *vfio_mm_get_from_task(struct
> task_struct *task)
>  }
>  EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> 
> -int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
> +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int quota, int min, int max)
>  {
>  	ioasid_t pasid;
>  	int ret = -ENOSPC;
> 
>  	mutex_lock(&vmm->pasid_lock);
> 
> +	/* update quota as it is tunable by admin */
> +	if (vmm->pasid_quota != quota) {
> +		vmm->pasid_quota = quota;
> +		ioasid_adjust_set(vmm->ioasid_sid, quota);
> +	}
> +

It's a bit weird to have quota adjusted in the alloc path, since the latter might
be initiated by non-privileged users. Why not doing the simple math in vfio_
create_mm to set the quota when the ioasid set is created? even in the future
you may allow per-process quota setting, that should come from separate 
privileged path instead of thru alloc...

>  	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
>  	if (pasid == INVALID_IOASID) {
>  		ret = -ENOSPC;
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 331ceee..e40afc0 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -60,6 +60,11 @@ module_param_named(dma_entry_limit,
> dma_entry_limit, uint, 0644);
>  MODULE_PARM_DESC(dma_entry_limit,
>  		 "Maximum number of user DMA mappings per container
> (65535).");
> 
> +static int pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> +module_param_named(pasid_quota, pasid_quota, uint, 0644);
> +MODULE_PARM_DESC(pasid_quota,
> +		 "Quota of user owned PASIDs per vfio-based application
> (1000).");
> +
>  struct vfio_iommu {
>  	struct list_head	domain_list;
>  	struct list_head	iova_list;
> @@ -2200,7 +2205,7 @@ static int vfio_iommu_type1_pasid_alloc(struct
> vfio_iommu *iommu,
>  		goto out_unlock;
>  	}
>  	if (vmm)
> -		ret = vfio_mm_pasid_alloc(vmm, min, max);
> +		ret = vfio_mm_pasid_alloc(vmm, pasid_quota, min, max);
>  	else
>  		ret = -EINVAL;
>  out_unlock:
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 75f9f7f1..af2ef78 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -106,7 +106,8 @@ struct vfio_mm {
> 
>  extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
>  extern void vfio_mm_put(struct vfio_mm *vmm);
> -extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> +extern int vfio_mm_pasid_alloc(struct vfio_mm *vmm,
> +				int quota, int min, int max);
>  extern int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid);
> 
>  /*
> --
> 2.7.4

