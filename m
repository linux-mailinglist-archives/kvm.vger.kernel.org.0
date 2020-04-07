Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932461A05F7
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 06:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgDGEw0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 00:52:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:50047 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGEw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 00:52:26 -0400
IronPort-SDR: 722cifAgA0tgTBfTdLBExAjKFHHYGJVaGFFV/q9Cfc6YF/EqrSku2WT2F8nHlt2lSthW1AypxS
 yH3QMxLGHoYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 21:52:25 -0700
IronPort-SDR: FTxUwEUs3eOU6i7RBbl/xIx6wFG834NqWr7HAU1exjUF7hwWbXMMlKhcgnr2ClgxUW4nv3ou2w
 Ptp0dN70hD2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="451087974"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2020 21:52:25 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 21:52:25 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 21:52:25 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.214]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 12:52:22 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbvuzF5+3jpEaYhihTFzMRG6hlp7CAgAFE0ACAAE19gIAF9Qaw
Date:   Tue, 7 Apr 2020 04:52:21 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D80E1DA@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
 <20200402115017.0a0f55e2@w520.home>
 <A2975661238FB949B60364EF0F2C25743A220B62@SHSMSX104.ccr.corp.intel.com>
 <20200403115011.4aba8ff3@w520.home>
In-Reply-To: <20200403115011.4aba8ff3@w520.home>
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

> From: Alex Williamson
> Sent: Saturday, April 4, 2020 1:50 AM
[...]
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 9e843a1..298ac80 100644
> > > > --- a/include/uapi/linux/vfio.h
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -794,6 +794,47 @@ struct vfio_iommu_type1_dma_unmap {
> > > >  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> > > >  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> > > >
> > > > +/*
> > > > + * PASID (Process Address Space ID) is a PCIe concept which
> > > > + * has been extended to support DMA isolation in fine-grain.
> > > > + * With device assigned to user space (e.g. VMs), PASID alloc
> > > > + * and free need to be system wide. This structure defines
> > > > + * the info for pasid alloc/free between user space and kernel
> > > > + * space.
> > > > + *
> > > > + * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @alloc_pasid
> > > > + * @flag=VFIO_IOMMU_PASID_FREE, refer to @free_pasid
> > > > + */
> > > > +struct vfio_iommu_type1_pasid_request {
> > > > +	__u32	argsz;
> > > > +#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> > > > +#define VFIO_IOMMU_PASID_FREE	(1 << 1)
> > > > +	__u32	flags;
> > > > +	union {
> > > > +		struct {
> > > > +			__u32 min;
> > > > +			__u32 max;
> > > > +			__u32 result;
> > > > +		} alloc_pasid;
> > > > +		__u32 free_pasid;
> > > > +	};
> > >
> > > We seem to be using __u8 data[] lately where the struct at data is
> > > defined by the flags.  should we do that here?
> >
> > yeah, I can do that. BTW. Do you want to let the structure in the
> > lately patch share the same structure with this one? As I can foresee,
> > the two structures would look like similar as both of them include
> > argsz, flags and data[] fields. The difference is the definition of
> > flags. what about your opinion?
> >
> > struct vfio_iommu_type1_pasid_request {
> > 	__u32	argsz;
> > #define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
> > #define VFIO_IOMMU_PASID_FREE	(1 << 1)
> > 	__u32	flags;
> > 	__u8	data[];
> > };
> >
> > struct vfio_iommu_type1_bind {
> >         __u32           argsz;
> >         __u32           flags;
> > #define VFIO_IOMMU_BIND_GUEST_PGTBL     (1 << 0)
> > #define VFIO_IOMMU_UNBIND_GUEST_PGTBL   (1 << 1)
> >         __u8            data[];
> > };
> 
> 
> Yes, I was even wondering the same for the cache invalidate ioctl, or
> whether this is going too far for a general purpose "everything related
> to PASIDs" ioctl.  We need to factor usability into the equation too.
> I'd be interested in opinions from others here too.  Clearly I don't
> like single use, throw-away ioctls, but I can find myself on either
> side of the argument that allocation, binding, and invalidating are all
> within the domain of PASIDs and could fall within a single ioctl or
> they each represent different facets of managing PASIDs and should have
> separate ioctls.  Thanks,
> 

Looking at uapi/linux/iommu.h:

* Invalidations by %IOMMU_INV_GRANU_DOMAIN don't take any argument other than
 * @version and @cache.

Although intel-iommu handles only PASID-related invalidation now, I
suppose other vendors (or future usages?) may allow non-pasid
based invalidation too based on above comment. 

Thanks
Kevin
