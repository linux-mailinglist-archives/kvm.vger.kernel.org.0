Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C41E4820
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 12:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439350AbfJYKGR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 25 Oct 2019 06:06:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:6532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436905AbfJYKGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 06:06:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 03:06:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="373514129"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 25 Oct 2019 03:06:15 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 03:06:15 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.96]) with mapi id 14.03.0439.000;
 Fri, 25 Oct 2019 18:06:14 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHVimn71ZcxKUHf5k+QWlILVb5kf6drG3OA
Date:   Fri, 25 Oct 2019 10:06:13 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5D05D5@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
 <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2U1MGIzZmQtNTFmNy00YWY0LThlZGQtZjcxNzFhYWRkMzNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVHFmdkM4Q1ZsaWRGbG1kQWlTd1c3eTU1ZzRcLzhCcFZJZjBhMVg4c09DWFV2eWtcL3VTNjJWbGtRQ2xyRTNlb1dFIn0=
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu Yi L
> Sent: Thursday, October 24, 2019 8:26 PM
> 
> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims
> to passdown PASID allocation/free request from the virtual
> iommu. This is required to get PASID managed in system-wide.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 114
> ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  25 +++++++++
>  2 files changed, 139 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index cd8d3a5..3d73a7d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2248,6 +2248,83 @@ static int vfio_cache_inv_fn(struct device *dev,
> void *data)
>  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
>  }
> 
> +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> +					 int min_pasid,
> +					 int max_pasid)
> +{
> +	int ret;
> +	ioasid_t pasid;
> +	struct mm_struct *mm = NULL;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +	mm = get_task_mm(current);
> +	/* Track ioasid allocation owner by mm */
below is purely allocation. Where does 'track' come to play?

> +	pasid = ioasid_alloc((struct ioasid_set *)mm, min_pasid,
> +				max_pasid, NULL);
> +	if (pasid == INVALID_IOASID) {
> +		ret = -ENOSPC;
> +		goto out_unlock;
> +	}
> +	ret = pasid;
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	if (mm)
> +		mmput(mm);
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> +				       unsigned int pasid)
> +{
> +	struct mm_struct *mm = NULL;
> +	void *pdata;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/**
> +	 * REVISIT:
> +	 * There are two cases free could fail:
> +	 * 1. free pasid by non-owner, we use ioasid_set to track mm, if
> +	 * the set does not match, caller is not permitted to free.
> +	 * 2. free before unbind all devices, we can check if ioasid private
> +	 * data, if data != NULL, then fail to free.
> +	 */

Does REVISIT mean that above comment is the right way but
the code doesn't follow yet, or the comment itself should be
revisited?

should we have some notification mechanism, so the guy
who holds the reference to the pasid can be notified to
release its usage?

> +	mm = get_task_mm(current);
> +	pdata = ioasid_find((struct ioasid_set *)mm, pasid, NULL);
> +	if (IS_ERR(pdata)) {
> +		if (pdata == ERR_PTR(-ENOENT))
> +			pr_err("PASID %u is not allocated\n", pasid);
> +		else if (pdata == ERR_PTR(-EACCES))
> +			pr_err("Free PASID %u by non-owner, denied",
> pasid);
> +		else
> +			pr_err("Error searching PASID %u\n", pasid);
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +	if (pdata) {
> +		pr_debug("Cannot free pasid %d with private data\n",
> pasid);
> +		/* Expect PASID has no private data if not bond */
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +	ioasid_free(pasid);
> +
> +out_unlock:
> +	if (mm)
> +		mmput(mm);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2370,6 +2447,43 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
>  					    &ustruct);
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> +
> +	} else if (cmd == VFIO_IOMMU_PASID_REQUEST) {
> +		struct vfio_iommu_type1_pasid_request req;
> +		int min_pasid, max_pasid, pasid;
> +
> +		minsz = offsetofend(struct
> vfio_iommu_type1_pasid_request,
> +				    flag);
> +
> +		if (copy_from_user(&req, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (req.argsz < minsz)
> +			return -EINVAL;
> +
> +		switch (req.flag) {
> +		/**
> +		 * TODO: min_pasid and max_pasid align with
> +		 * typedef unsigned int ioasid_t
> +		 */
> +		case VFIO_IOMMU_PASID_ALLOC:
> +			if (copy_from_user(&min_pasid,
> +				(void __user *)arg + minsz,
> sizeof(min_pasid)))
> +				return -EFAULT;
> +			if (copy_from_user(&max_pasid,
> +				(void __user *)arg + minsz +
> sizeof(min_pasid),
> +				sizeof(max_pasid)))
> +				return -EFAULT;
> +			return vfio_iommu_type1_pasid_alloc(iommu,
> +						min_pasid, max_pasid);
> +		case VFIO_IOMMU_PASID_FREE:
> +			if (copy_from_user(&pasid,
> +				(void __user *)arg + minsz, sizeof(pasid)))
> +				return -EFAULT;
> +			return vfio_iommu_type1_pasid_free(iommu,
> pasid);
> +		default:
> +			return -EINVAL;
> +		}
>  	}
> 
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ccf60a2..04de290 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -807,6 +807,31 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE
> + 24)
> 
> +/*
> + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @min_pasid and
> @max_pasid fields
> + * @flag=VFIO_IOMMU_PASID_FREE, refer to @pasid field
> + */
> +struct vfio_iommu_type1_pasid_request {
> +	__u32	argsz;
> +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> +	__u32	flag;
> +	union {
> +		struct {
> +			int min_pasid;
> +			int max_pasid;
> +		};
> +		int pasid;
> +	};
> +};
> +
> +/**
> + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 27,
> + *				struct vfio_iommu_type1_pasid_request)
> + *
> + */
> +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE
> + 27)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------
> */
> 
>  /*
> --
> 2.7.4

