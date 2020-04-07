Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAAC1A0A58
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 11:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgDGJn2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 05:43:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:50872 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgDGJn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 05:43:28 -0400
IronPort-SDR: TzGuwU94LtPmKKr66QzMDb8rgkKgSz/9UxMVVIDJB9NMNB55kI48e5ooG6UuH4ztf1YCO1eXvm
 MTx4BV9cxiFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 02:43:27 -0700
IronPort-SDR: ADIj2PgCc549wdNYUg0B2hduccfdQAeDAlMT8s+6H2FSVKNI7E7kVIrh8I1malMuHVE0dlhJV0
 +pqscB6WzwhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="361487857"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 07 Apr 2020 02:43:27 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 02:43:27 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 02:43:27 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 17:43:23 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Auger Eric <eric.auger@redhat.com>
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
Thread-Index: AQHWAEUcqZEEdiOKbEGofjWp2Yic+6hjfq+AgAC/vLD//4YrAIAC1vWAgAbjh1A=
Date:   Tue, 7 Apr 2020 09:43:23 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2249DF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <cb68e9ab-77b0-7e97-a661-4836962041d9@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21DB4E@SHSMSX104.ccr.corp.intel.com>
 <b47891b1-ece6-c263-9c07-07c09c7d3752@redhat.com>
 <20200403082305.GA1269501@myrica>
In-Reply-To: <20200403082305.GA1269501@myrica>
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

Hi Jean,

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Friday, April 3, 2020 4:23 PM
> To: Auger Eric <eric.auger@redhat.com>
> userspace
> 
> On Wed, Apr 01, 2020 at 03:01:12PM +0200, Auger Eric wrote:
> > >>>  	header = vfio_info_cap_add(caps, sizeof(*nesting_cap),
> > >>>  				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> @@ -2254,6 +2309,7
> > >>> @@ static int vfio_iommu_info_add_nesting_cap(struct
> > >> vfio_iommu *iommu,
> > >>>  		/* nesting iommu type supports PASID requests (alloc/free) */
> > >>>  		nesting_cap->nesting_capabilities |= VFIO_IOMMU_PASID_REQS;
> > >> What is the meaning for ARM?
> > >
> > > I think it's just a software capability exposed to userspace, on
> > > userspace side, it has a choice to use it or not. :-) The reason
> > > define it and report it in cap nesting is that I'd like to make the
> > > pasid alloc/free be available just for IOMMU with type
> > > VFIO_IOMMU_TYPE1_NESTING. Please feel free tell me if it is not good
> > > for ARM. We can find a proper way to report the availability.
> >
> > Well it is more a question for jean-Philippe. Do we have a system wide
> > PASID allocation on ARM?
> 
> We don't, the PASID spaces are per-VM on Arm, so this function should consult the
> IOMMU driver before setting flags. As you said on patch 3, nested doesn't
> necessarily imply PASID support. The SMMUv2 does not support PASID but does
> support nesting stages 1 and 2 for the IOVA space.
> SMMUv3 support of PASID depends on HW capabilities. So I think this needs to be
> finer grained:
> 
> Does the container support:
> * VFIO_IOMMU_PASID_REQUEST?
>   -> Yes for VT-d 3
>   -> No for Arm SMMU
> * VFIO_IOMMU_{,UN}BIND_GUEST_PGTBL?
>   -> Yes for VT-d 3
>   -> Sometimes for SMMUv2
>   -> No for SMMUv3 (if we go with BIND_PASID_TABLE, which is simpler due to
>      PASID tables being in GPA space.)
> * VFIO_IOMMU_BIND_PASID_TABLE?
>   -> No for VT-d
>   -> Sometimes for SMMUv3
> 
> Any bind support implies VFIO_IOMMU_CACHE_INVALIDATE support.

good summary. do you expect to see any 

> 
> > >>> +	nesting_cap->stage1_formats = formats;
> > >> as spotted by Kevin, since a single format is supported, rename
> > >
> > > ok, I was believing it may be possible on ARM or so. :-) will rename
> > > it.
> 
> Yes I don't think an u32 is going to cut it for Arm :( We need to describe all sorts of
> capabilities for page and PASID tables (granules, GPA size, ASID/PASID size, HW
> access/dirty, etc etc.) Just saying "Arm stage-1 format" wouldn't mean much. I
> guess we could have a secondary vendor capability for these?

Actually, I'm wondering if we can define some formats to stands for a set of
capabilities. e.g. VTD_STAGE1_FORMAT_V1 which may indicates the 1st level
page table related caps (aw, a/d, SRE, EA and etc.). And vIOMMU can parse
the capabilities.

Regards,
Yi Liu

