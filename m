Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470B31977FB
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgC3Jnl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Mar 2020 05:43:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:29415 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgC3Jnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 05:43:41 -0400
IronPort-SDR: p7Titqo/XMUT0YTs6YIpQZN5jbCP7jQqKJBEWtReFF0xNtkW+NJ6dUPlCuKvdF1YWSpdEz+WYl
 Yh82ncY+aNNA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 02:43:40 -0700
IronPort-SDR: mEqY1RX1MCY6ySvEv+t7Uk7nMQ/U91q84IxfOtjhCSEtFW/RQg57S1z8VdDH+gOiqFfJHqjDy+
 tAefRkn3oyEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,323,1580803200"; 
   d="scan'208";a="251834926"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga006.jf.intel.com with ESMTP; 30 Mar 2020 02:43:39 -0700
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 02:43:39 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 02:43:39 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Mon, 30 Mar 2020 17:43:35 +0800
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
Subject: RE: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Topic: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Index: AQHWAEUdJcZWYB5B3kyVfi4eyRoo06hg6FCA
Date:   Mon, 30 Mar 2020 09:43:35 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF4FF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
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
> This patch reports PASID alloc/free availability to userspace (e.g. QEMU)
> thus userspace could do a pre-check before utilizing this feature.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 28 ++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  8 ++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index e40afc0..ddd1ffe 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2234,6 +2234,30 @@ static int vfio_iommu_type1_pasid_free(struct
> vfio_iommu *iommu,
>  	return ret;
>  }
> 
> +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> +					 struct vfio_info_cap *caps)
> +{
> +	struct vfio_info_cap_header *header;
> +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> +
> +	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
> +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING,
> 1);
> +	if (IS_ERR(header))
> +		return PTR_ERR(header);
> +
> +	nesting_cap = container_of(header,
> +				struct vfio_iommu_type1_info_cap_nesting,
> +				header);
> +
> +	nesting_cap->nesting_capabilities = 0;
> +	if (iommu->nesting) {

Is it good to report a nesting cap when iommu->nesting is disabled? I suppose
the check should move before vfio_info_cap_add...

> +		/* nesting iommu type supports PASID requests (alloc/free)
> */
> +		nesting_cap->nesting_capabilities |=
> VFIO_IOMMU_PASID_REQS;

VFIO_IOMMU_CAP_PASID_REQ? to avoid confusion with ioctl cmd
VFIO_IOMMU_PASID_REQUEST...

> +	}
> +
> +	return 0;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2283,6 +2307,10 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
>  		if (ret)
>  			return ret;
> 
> +		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
> +		if (ret)
> +			return ret;
> +
>  		if (caps.size) {
>  			info.flags |= VFIO_IOMMU_INFO_CAPS;
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 298ac80..8837219 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -748,6 +748,14 @@ struct vfio_iommu_type1_info_cap_iova_range {
>  	struct	vfio_iova_range iova_ranges[];
>  };
> 
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  2
> +
> +struct vfio_iommu_type1_info_cap_nesting {
> +	struct	vfio_info_cap_header header;
> +#define VFIO_IOMMU_PASID_REQS	(1 << 0)
> +	__u32	nesting_capabilities;
> +};
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> 
>  /**
> --
> 2.7.4

