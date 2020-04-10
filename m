Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA2F1A4647
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 14:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDJMat convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Apr 2020 08:30:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:2953 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgDJMat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 08:30:49 -0400
IronPort-SDR: Kj9s7qXdJtCDt+xlUDV4weTDnQg9rNkP7N5f55pY5h9v9hWadEEMngD773myqD6B6iAeiy1Nps
 FEEyFQ+TXzCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 05:30:49 -0700
IronPort-SDR: 8U5dWyRhJXN/ddnXJrlJSDkrgG/9EZDnjvNxLZPIWnkU2/9zCVu8jUaF1kp0cpml2hzL/651TU
 9ZwqfiRkD8uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,366,1580803200"; 
   d="scan'208";a="276160967"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 10 Apr 2020 05:30:49 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Apr 2020 05:30:49 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Apr 2020 05:30:48 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Fri, 10 Apr 2020 20:30:45 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Auger Eric <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Topic: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Index: AQHWAEUcqZEEdiOKbEGofjWp2Yic+6hjfq+AgAC/vLD//4YrAIAC1vWAgAbjh1CAARsGAIABbRkAgADQzoCAAYffoA==
Date:   Fri, 10 Apr 2020 12:30:45 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A22A118@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DB4E@SHSMSX104.ccr.corp.intel.com>
 <b47891b1-ece6-c263-9c07-07c09c7d3752@redhat.com>
 <20200403082305.GA1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A2249DF@SHSMSX104.ccr.corp.intel.com>
 <acf8c809-8d29-92d6-2445-3a94fc8b82fd@redhat.com>
 <20200409081442.GD2435@myrica>
 <A2975661238FB949B60364EF0F2C25743A229013@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A229013@SHSMSX104.ccr.corp.intel.com>
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

Hi Jean, Eric,

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, April 9, 2020 8:47 PM
> Subject: RE: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
> userspace
> 
[...]
> > > >>
> > > >> Yes I don't think an u32 is going to cut it for Arm :( We need to
> > > >> describe all sorts
> > of
> > > >> capabilities for page and PASID tables (granules, GPA size, ASID/PASID size,
> HW
> > > >> access/dirty, etc etc.) Just saying "Arm stage-1 format" wouldn't mean
> much. I
> > > >> guess we could have a secondary vendor capability for these?
> > > >
> > > > Actually, I'm wondering if we can define some formats to stands for a set of
> > > > capabilities. e.g. VTD_STAGE1_FORMAT_V1 which may indicates the 1st
> level
> > > > page table related caps (aw, a/d, SRE, EA and etc.). And vIOMMU can parse
> > > > the capabilities.
> > >
> > > But eventually do we really need all those capability getters? I mean
> > > can't we simply rely on the actual call to VFIO_IOMMU_BIND_GUEST_PGTBL()
> > > to detect any mismatch? Definitively the error handling may be heavier
> > > on userspace but can't we manage.
> >
> > I think we need to present these capabilities at boot time, long before
> > the guest triggers a bind(). For example if the host SMMU doesn't support
> > 16-bit ASID, we need to communicate that to the guest using vSMMU ID
> > registers or PROBE properties. Otherwise a bind() will succeed, but if the
> > guest uses 16-bit ASIDs in its CD, DMA will result in C_BAD_CD events
> > which we'll inject into the guest, for no apparent reason from their
> > perspective.
> >
> > In addition some VMMs may have fallbacks if shared page tables are not
> > available. They could fall back to a MAP/UNMAP interface, or simply not
> > present a vIOMMU to the guest.
> >
> 
> Based on the comments, I think it would be a need to report iommu caps
> in detail. So I guess iommu uapi needs to provide something alike vfio
> cap chain in iommu uapi. Please feel free let me know your thoughts. :-)

Consider more, I guess it may be better to start simpler. Cap chain suits
the case in which there are multiple caps. e.g. some vendor iommu driver
may want to report iommu capabilities via multiple caps. Actually, in VT-d
side, the host IOMMU capability could be reported in a single cap structure.
I'm not sure about ARM side. Will there be multiple iommu_info_caps for ARM?

> In vfio, we can define a cap as below:
>
> struct vfio_iommu_type1_info_cap_nesting {
> 	struct  vfio_info_cap_header header;
> 	__u64	iommu_model;
> #define VFIO_IOMMU_PASID_REQS		(1 << 0)
> #define VFIO_IOMMU_BIND_GPASID		(1 << 1)
> #define VFIO_IOMMU_CACHE_INV		(1 << 2)
> 	__u32	nesting_capabilities;
> 	__u32	pasid_bits;
> #define VFIO_IOMMU_VENDOR_SUB_CAP	(1 << 3)
> 	__u32	flags;
> 	__u32	data_size;
> 	__u8	data[];  /*iommu info caps defined by iommu uapi */
> };
> 

If iommu vendor driver only needs one cap structure to report hw
capability, then I think we needn't implement cap chain in iommu
uapi. The @data[] field could be determined by the @iommu_model
and @flags fields. This would be easier. thoughts?

> VFIO needs new iommu APIs to ask iommu driver whether PASID/bind_gpasid/
> cache_inv/bind_gpasid_table is available or not and also the pasid
> bits. After that VFIO will ask iommu driver about the iommu_cap_info
> and fill in the @data[] field.
>
> iommu uapi:
> struct iommu_info_cap_header {
> 	__u16	id;		/* Identifies capability */
> 	__u16	version;		/* Version specific to the capability ID */
> 	__u32	next;		/* Offset of next capability */
> };
> 
> #define IOMMU_INFO_CAP_INTEL_VTD 1
> struct iommu_info_cap_intel_vtd {
> 	struct	iommu_info_cap_header header;
> 	__u32   vaddr_width;   /* VA addr_width*/
> 	__u32   ipaddr_width; /* IPA addr_width, input of SL page table */
> 	/* same definition with @flags instruct iommu_gpasid_bind_data_vtd */
> 	__u64	flags;
> };
> 
> #define IOMMU_INFO_CAP_ARM_SMMUv3 2
> struct iommu_info_cap_arm_smmuv3 {
> 	struct	iommu_info_cap_header header;
> 	...
> };

Regards,
Yi Liu

