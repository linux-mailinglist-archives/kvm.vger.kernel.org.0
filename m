Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B340E1AC0C8
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635070AbgDPMJq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Apr 2020 08:09:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:62062 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634901AbgDPMJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 08:09:33 -0400
IronPort-SDR: 9UgL5jWQLPSKZp0vmiHPvjuIREB90tx3CcWpBi0KuU3ny2EPlI7p7j/LYJQ+yMVY8Hq6Q7SL2H
 OroywUm8NZwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 05:09:30 -0700
IronPort-SDR: 7/ajiPgfD/BuSBclgpGNfPwHnIMKHqpR58/pw/L7zRnXqSjCRTatWo3VkclArs9/eogSwWzkF+
 L4fqzsXpsUIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="272049486"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 16 Apr 2020 05:09:29 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Apr 2020 05:09:29 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.209]) with mapi id 14.03.0439.000;
 Thu, 16 Apr 2020 20:09:26 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: RE: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Topic: [PATCH v1 7/8] vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
Thread-Index: AQHWAEUdbUtKvEWiiEiZu1SnRvWegKhl0sQAgAEuFaCAABNDAIAUHAOAgACdTsA=
Date:   Thu, 16 Apr 2020 12:09:25 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D82336C@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-8-git-send-email-yi.l.liu@intel.com>
        <20200402142428.2901432e@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D807C4A@SHSMSX104.ccr.corp.intel.com>
 <20200403093436.094b1928@w520.home>
 <A2975661238FB949B60364EF0F2C25743A231BAA@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A231BAA@SHSMSX104.ccr.corp.intel.com>
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
> Sent: Thursday, April 16, 2020 6:40 PM
> 
> Hi Alex,
> Still have a direction question with you. Better get agreement with you
> before heading forward.
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 3, 2020 11:35 PM
> [...]
> > > > > + *
> > > > > + * returns: 0 on success, -errno on failure.
> > > > > + */
> > > > > +struct vfio_iommu_type1_cache_invalidate {
> > > > > +	__u32   argsz;
> > > > > +	__u32   flags;
> > > > > +	struct	iommu_cache_invalidate_info cache_info;
> > > > > +};
> > > > > +#define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE,
> > VFIO_BASE
> > > > + 24)
> > > >
> > > > The future extension capabilities of this ioctl worry me, I wonder if
> > > > we should do another data[] with flag defining that data as
> CACHE_INFO.
> > >
> > > Can you elaborate? Does it mean with this way we don't rely on iommu
> > > driver to provide version_to_size conversion and instead we just pass
> > > data[] to iommu driver for further audit?
> >
> > No, my concern is that this ioctl has a single function, strictly tied
> > to the iommu uapi.  If we replace cache_info with data[] then we can
> > define a flag to specify that data[] is struct
> > iommu_cache_invalidate_info, and if we need to, a different flag to
> > identify data[] as something else.  For example if we get stuck
> > expanding cache_info to meet new demands and develop a new uapi to
> > solve that, how would we expand this ioctl to support it rather than
> > also create a new ioctl?  There's also a trade-off in making the ioctl
> > usage more difficult for the user.  I'd still expect the vfio layer to
> > check the flag and interpret data[] as indicated by the flag rather
> > than just passing a blob of opaque data to the iommu layer though.
> > Thanks,
> 
> Based on your comments about defining a single ioctl and a unified
> vfio structure (with a @data[] field) for pasid_alloc/free, bind/
> unbind_gpasid, cache_inv. After some offline trying, I think it would
> be good for bind/unbind_gpasid and cache_inv as both of them use the
> iommu uapi definition. While the pasid alloc/free operation doesn't.
> It would be weird to put all of them together. So pasid alloc/free
> may have a separate ioctl. It would look as below. Does this direction
> look good per your opinion?
> 
> ioctl #22: VFIO_IOMMU_PASID_REQUEST
> /**
>   * @pasid: used to return the pasid alloc result when flags == ALLOC_PASID
>   *         specify a pasid to be freed when flags == FREE_PASID
>   * @range: specify the allocation range when flags == ALLOC_PASID
>   */
> struct vfio_iommu_pasid_request {
> 	__u32	argsz;
> #define VFIO_IOMMU_ALLOC_PASID	(1 << 0)
> #define VFIO_IOMMU_FREE_PASID	(1 << 1)
> 	__u32	flags;
> 	__u32	pasid;
> 	struct {
> 		__u32	min;
> 		__u32	max;
> 	} range;
> };
> 
> ioctl #23: VFIO_IOMMU_NESTING_OP
> struct vfio_iommu_type1_nesting_op {
> 	__u32	argsz;
> 	__u32	flags;
> 	__u32	op;
> 	__u8	data[];
> };
> 
> /* Nesting Ops */
> #define VFIO_IOMMU_NESTING_OP_BIND_PGTBL        0
> #define VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL      1
> #define VFIO_IOMMU_NESTING_OP_CACHE_INVLD       2
> 

Then why cannot we just put PASID into the header since the
majority of nested usage is associated with a pasid? 

ioctl #23: VFIO_IOMMU_NESTING_OP
struct vfio_iommu_type1_nesting_op {
	__u32	argsz;
	__u32	flags;
	__u32	op;
	__u32   pasid;
	__u8	data[];
};

In case of SMMUv2 which supports nested w/o PASID, this field can
be ignored for that specific case.

Thanks
Kevin
