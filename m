Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C144711E080
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 10:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfLMJXT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 13 Dec 2019 04:23:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:57593 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfLMJXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 04:23:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 01:23:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="211393966"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga008.fm.intel.com with ESMTP; 13 Dec 2019 01:23:18 -0800
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Dec 2019 01:23:18 -0800
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Dec 2019 01:23:18 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.164]) with mapi id 14.03.0439.000;
 Fri, 13 Dec 2019 17:23:16 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
Thread-Topic: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
Thread-Index: AQHVr8iyIh/47oarrk2lLODWaUc1kqe3zByg
Date:   Fri, 13 Dec 2019 09:23:15 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1309A9@SHSMSX104.ccr.corp.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-5-baolu.lu@linux.intel.com>
In-Reply-To: <20191211021219.8997-5-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzQxZGNkNzItOTI2OC00OGJmLWExYzMtODFlZjE2ODZmOTI3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiU0ptUHhqUkVidllOY0lhMzJsdm1ZTnR1em9jbEdza0FDNW9wQ05RbnhGTHQrbHNjb2FzMjNYbStkZ3FMMHBlMiJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Allen,

> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
> Of Lu Baolu
> Sent: Wednesday, December 11, 2019 10:12 AM
> Subject: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over first level
> 
> Intel VT-d in scalable mode supports two types of page tables for IOVA translation:
> first level and second level. The IOMMU driver can choose one from both for IOVA
> translation according to the use case. This sets up the pasid entry if a domain is
> selected to use the first-level page table for iova translation.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c | 48 +++++++++++++++++++++++++++++++++++--
>  include/linux/intel-iommu.h | 10 ++++----
>  2 files changed, 52 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index
> 2b5a47584baf..83a7abf0c4f0 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -571,6 +571,11 @@ static inline int domain_type_is_si(struct dmar_domain
> *domain)
>  	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;  }
> 
> +static inline bool domain_use_first_level(struct dmar_domain *domain) {
> +	return domain->flags & DOMAIN_FLAG_USE_FIRST_LEVEL; }
> +
>  static inline int domain_pfn_supported(struct dmar_domain *domain,
>  				       unsigned long pfn)
>  {
> @@ -2288,6 +2293,8 @@ static int __domain_mapping(struct dmar_domain
> *domain, unsigned long iov_pfn,
>  		return -EINVAL;
> 
>  	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
> +	if (domain_use_first_level(domain))
> +		prot |= DMA_FL_PTE_PRESENT;

For DMA_PTE_SNP bit, I think there needs some work. The bit 11 of prot
should be cleared when FLPT is used for IOVA.

Also, we need to set bit 63 "XD" properly. e.g. If bit 11 of prot is set, it
means snoop required, then "XD" bit is "0". If bit 11 of prot is "0", it means
this domain is not snooping, so you may want to set "XD" bit as "1". With
such enhancement, I think IOVA over FLPT would have as less difference
with IOVA over SLPT.

Regards,
Yi Liu
