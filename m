Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918C419E4B3
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 13:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgDDLgN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 4 Apr 2020 07:36:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:56642 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgDDLgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 07:36:13 -0400
IronPort-SDR: WUN5SoA+jJ1DLr1mWa97sXjX2oEYPgZR8owb+PMDxT1I/O6q991SzLtI/CBAgQnav309ghgM6U
 7cs1gEXhy2Ow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2020 04:36:12 -0700
IronPort-SDR: 2eP0Nt9qDX4mdk6GECzSVxxk+t0i2u3uat50f2AR8lOiwfkAnoRYsiMOQvmhVG4XY9TIOpcVrs
 VQTg5Oe3Crng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,343,1580803200"; 
   d="scan'208";a="253628078"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 04 Apr 2020 04:36:11 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 4 Apr 2020 04:36:11 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 4 Apr 2020 04:36:10 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.146]) with mapi id 14.03.0439.000;
 Sat, 4 Apr 2020 19:36:07 +0800
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
Thread-Index: AQHWAEUdmZ6qeWVhq0GPreoHiPHgtahlqq4AgAF03/CAABRGgIABtdZg
Date:   Sat, 4 Apr 2020 11:36:07 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A221B6E@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
        <20200402120100.19e43c72@w520.home>
        <A2975661238FB949B60364EF0F2C25743A220662@SHSMSX104.ccr.corp.intel.com>
 <20200403112807.30a56c48@w520.home>
In-Reply-To: <20200403112807.30a56c48@w520.home>
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
> Sent: Saturday, April 4, 2020 1:28 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Cc: eric.auger@redhat.com; Tian, Kevin <kevin.tian@intel.com>;
> jacob.jun.pan@linux.intel.com; joro@8bytes.org; Raj, Ashok <ashok.raj@intel.com>;
> Tian, Jun J <jun.j.tian@intel.com>; Sun, Yi Y <yi.y.sun@intel.com>; jean-
> philippe@linaro.org; peterx@redhat.com; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Wu, Hao <hao.wu@intel.com>
> Subject: Re: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
> userspace
> 
> On Fri, 3 Apr 2020 08:17:44 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Alex Williamson < alex.williamson@redhat.com >
> > > Sent: Friday, April 3, 2020 2:01 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free
> > > support to userspace
> > >
> > > On Sun, 22 Mar 2020 05:32:00 -0700
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Liu Yi L <yi.l.liu@intel.com>
> > > >
> > > > This patch reports PASID alloc/free availability to userspace (e.g.
> > > > QEMU) thus userspace could do a pre-check before utilizing this feature.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/vfio_iommu_type1.c | 28 ++++++++++++++++++++++++++++
> > > >  include/uapi/linux/vfio.h       |  8 ++++++++
> > > >  2 files changed, 36 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > > b/drivers/vfio/vfio_iommu_type1.c index e40afc0..ddd1ffe 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -2234,6 +2234,30 @@ static int
> > > > vfio_iommu_type1_pasid_free(struct
> > > vfio_iommu *iommu,
> > > >  	return ret;
> > > >  }
> > > >
> > > > +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> > > > +					 struct vfio_info_cap *caps) {
> > > > +	struct vfio_info_cap_header *header;
> > > > +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> > > > +
> > > > +	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
> > > > +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> > > > +	if (IS_ERR(header))
> > > > +		return PTR_ERR(header);
> > > > +
> > > > +	nesting_cap = container_of(header,
> > > > +				struct vfio_iommu_type1_info_cap_nesting,
> > > > +				header);
> > > > +
> > > > +	nesting_cap->nesting_capabilities = 0;
> > > > +	if (iommu->nesting) {
> > > > +		/* nesting iommu type supports PASID requests (alloc/free) */
> > > > +		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >  				   unsigned int cmd, unsigned long arg)  { @@ -
> > > 2283,6 +2307,10 @@
> > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >  		if (ret)
> > > >  			return ret;
> > > >
> > > > +		ret = vfio_iommu_info_add_nesting_cap(iommu, &caps);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +
> > > >  		if (caps.size) {
> > > >  			info.flags |= VFIO_IOMMU_INFO_CAPS;
> > > >
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 298ac80..8837219 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -748,6 +748,14 @@ struct vfio_iommu_type1_info_cap_iova_range {
> > > >  	struct	vfio_iova_range iova_ranges[];
> > > >  };
> > > >
> > > > +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  2
> > > > +
> > > > +struct vfio_iommu_type1_info_cap_nesting {
> > > > +	struct	vfio_info_cap_header header;
> > > > +#define VFIO_IOMMU_PASID_REQS	(1 << 0)
> > > > +	__u32	nesting_capabilities;
> > > > +};
> > > > +
> > > >  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> > > >
> > > >  /**
> > >
> > > I think this answers my PROBE question on patch 1/.
> > yep.
> > > Should the quota/usage be exposed to the user here?  Thanks,
> >
> > Do you mean report the quota available for this user in this cap info as well?
> 
> Yes.  Would it be useful?

I think so.

> > For usage, do you mean the alloc and free or others?
> 
> I mean how many of the quota are currently in allocated, or alternatively, how
> many remain.  Thanks,

ok, got it, maybe report the remain. thanks.

Regards,
Yi Liu
