Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 326B019D1F8
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390495AbgDCIRv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 04:17:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:21515 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390467AbgDCIRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 04:17:51 -0400
IronPort-SDR: VqAncYQ/fwR8Wx+LIoRTkBxW0HZ95Jtfuq++7ZO8RLgmm9Grl7AakO/9nPHfSUj/7gUg8m3+9n
 rujJiNe0kiJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 01:17:51 -0700
IronPort-SDR: G6b6slSIE/t2d13pNmA/tIbwsDvao3N24PZCcZsdrf55GWQvM/6MbJhOv+kyDytmBX+dj+aTqQ
 bqYzx7NKrBRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="268289774"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2020 01:17:49 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 01:17:49 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 01:17:49 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 16:17:45 +0800
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
Subject: RE: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Topic: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
 userspace
Thread-Index: AQHWAEUdmZ6qeWVhq0GPreoHiPHgtahlqq4AgAF03/A=
Date:   Fri, 3 Apr 2020 08:17:44 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220662@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
 <20200402120100.19e43c72@w520.home>
In-Reply-To: <20200402120100.19e43c72@w520.home>
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

> From: Alex Williamson < alex.williamson@redhat.com >
> Sent: Friday, April 3, 2020 2:01 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
> userspace
> 
> On Sun, 22 Mar 2020 05:32:00 -0700
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > This patch reports PASID alloc/free availability to userspace (e.g.
> > QEMU) thus userspace could do a pre-check before utilizing this feature.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 28 ++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  8 ++++++++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index e40afc0..ddd1ffe 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2234,6 +2234,30 @@ static int vfio_iommu_type1_pasid_free(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> > +					 struct vfio_info_cap *caps)
> > +{
> > +	struct vfio_info_cap_header *header;
> > +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> > +
> > +	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
> > +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> > +	if (IS_ERR(header))
> > +		return PTR_ERR(header);
> > +
> > +	nesting_cap = container_of(header,
> > +				struct vfio_iommu_type1_info_cap_nesting,
> > +				header);
> > +
> > +	nesting_cap->nesting_capabilities = 0;
> > +	if (iommu->nesting) {
> > +		/* nesting iommu type supports PASID requests (alloc/free) */
> > +		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  				   unsigned int cmd, unsigned long arg)  { @@ -
> 2283,6 +2307,10 @@
> > static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  		if (ret)
> >  			return ret;
> >
> > +		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
> > +		if (ret)
> > +			return ret;
> > +
> >  		if (caps.size) {
> >  			info.flags |= VFIO_IOMMU_INFO_CAPS;
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 298ac80..8837219 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -748,6 +748,14 @@ struct vfio_iommu_type1_info_cap_iova_range {
> >  	struct	vfio_iova_range iova_ranges[];
> >  };
> >
> > +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  2
> > +
> > +struct vfio_iommu_type1_info_cap_nesting {
> > +	struct	vfio_info_cap_header header;
> > +#define VFIO_IOMMU_PASID_REQS	(1 << 0)
> > +	__u32	nesting_capabilities;
> > +};
> > +
> >  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> >
> >  /**
> 
> I think this answers my PROBE question on patch 1/. 
yep.
> Should the quota/usage be exposed to the user here?  Thanks,

Do you mean report the quota available for this user in this cap info as well?
For usage, do you mean the alloc and free or others?

Regards,
Yi Liu
