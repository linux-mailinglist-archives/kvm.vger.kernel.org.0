Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB57D19D638
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 13:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403826AbgDCL7o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 3 Apr 2020 07:59:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:7517 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgDCL7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 07:59:44 -0400
IronPort-SDR: J70QR4Peo4ike+5O5wphOcoosiYO8T1nt6tNbVtSE9gA9F2GdCIhfPJTGGdVq6LaX0gI0tpQJ/
 ryG58cCinH/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 04:59:43 -0700
IronPort-SDR: o0hGTbs6M+FhSoPaDbBwvuj5xDfC7yiqYPV98EFZNRQHKrmKTy76BbUYXjXkcxQIQ662A1DZrU
 AlPE0PWz0NdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="268339664"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2020 04:59:42 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 04:59:37 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 04:59:37 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 19:59:33 +0800
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
Subject: RE: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Topic: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
 userspace
Thread-Index: AQHWAEUcqZEEdiOKbEGofjWp2Yic+6hlwM8AgAGcrLA=
Date:   Fri, 3 Apr 2020 11:59:33 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2209FF@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-6-git-send-email-yi.l.liu@intel.com>
 <20200402132012.390a7b54@w520.home>
In-Reply-To: <20200402132012.390a7b54@w520.home>
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
> Sent: Friday, April 3, 2020 3:20 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 5/8] vfio/type1: Report 1st-level/stage-1 format to
> userspace
> 
> On Sun, 22 Mar 2020 05:32:02 -0700
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > VFIO exposes IOMMU nesting translation (a.k.a dual stage translation)
> > capability to userspace. Thus applications like QEMU could support
> > vIOMMU with hardware's nesting translation capability for pass-through
> > devices. Before setting up nesting translation for pass-through devices,
> > QEMU and other applications need to learn the supported 1st-lvl/stage-1
> > translation structure format like page table format.
> >
> > Take vSVA (virtual Shared Virtual Addressing) as an example, to support
> > vSVA for pass-through devices, QEMU setup nesting translation for pass-
> > through devices. The guest page table are configured to host as 1st-lvl/
> > stage-1 page table. Therefore, guest format should be compatible with
> > host side.
> >
> > This patch reports the supported 1st-lvl/stage-1 page table format on the
> > current platform to userspace. QEMU and other alike applications should
> > use this format info when trying to setup IOMMU nesting translation on
> > host IOMMU.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 56
> +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  1 +
> >  2 files changed, 57 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 9aa2a67..82a9e0b 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2234,11 +2234,66 @@ static int vfio_iommu_type1_pasid_free(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static int vfio_iommu_get_stage1_format(struct vfio_iommu *iommu,
> > +					 u32 *stage1_format)
> > +{
> > +	struct vfio_domain *domain;
> > +	u32 format = 0, tmp_format = 0;
> > +	int ret;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (list_empty(&iommu->domain_list)) {
> > +		mutex_unlock(&iommu->lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > +		if (iommu_domain_get_attr(domain->domain,
> > +			DOMAIN_ATTR_PASID_FORMAT, &format)) {
> > +			ret = -EINVAL;
> > +			format = 0;
> > +			goto out_unlock;
> > +		}
> > +		/*
> > +		 * format is always non-zero (the first format is
> > +		 * IOMMU_PASID_FORMAT_INTEL_VTD which is 1). For
> > +		 * the reason of potential different backed IOMMU
> > +		 * formats, here we expect to have identical formats
> > +		 * in the domain list, no mixed formats support.
> > +		 * return -EINVAL to fail the attempt of setup
> > +		 * VFIO_TYPE1_NESTING_IOMMU if non-identical formats
> > +		 * are detected.
> > +		 */
> > +		if (tmp_format && tmp_format != format) {
> > +			ret = -EINVAL;
> > +			format = 0;
> > +			goto out_unlock;
> > +		}
> > +
> > +		tmp_format = format;
> > +	}
> > +	ret = 0;
> > +
> > +out_unlock:
> > +	if (format)
> > +		*stage1_format = format;
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> >  					 struct vfio_info_cap *caps)
> >  {
> >  	struct vfio_info_cap_header *header;
> >  	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> > +	u32 formats = 0;
> > +	int ret;
> > +
> > +	ret = vfio_iommu_get_stage1_format(iommu, &formats);
> > +	if (ret) {
> > +		pr_warn("Failed to get stage-1 format\n");
> > +		return ret;
> 
> Looks like this generates a warning and causes the iommu_get_info ioctl
> to fail if the hardware doesn't support the pasid format attribute, or
> the domain list is empty.  This breaks users on existing hardware.

oops, yes, it should not fail anything as it is just an extended feature.
let me correct it.

Thanks,
Yi Liu

