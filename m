Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1392F19A676
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbgDAHrE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Apr 2020 03:47:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:53302 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbgDAHrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 03:47:04 -0400
IronPort-SDR: V9cWGyKGoKxV05Gg2SzgpLY5xUr8U5zPm2i32aGe9ZKl1hSjhT7fY/w6/2CJFquUWpUvbMVOYN
 uCpDDEfVT3jQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 00:47:03 -0700
IronPort-SDR: NHaDS5kwOgpn2UXqAATGI0FB+kkIK0rivSsuwBzCAaIv1gOnArckVCyIlC3hO8hkeIH4KzNgx7
 1kP6WktN7tTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,330,1580803200"; 
   d="scan'208";a="242153558"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga008.fm.intel.com with ESMTP; 01 Apr 2020 00:47:02 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 00:47:02 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 1 Apr 2020 00:47:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 15:46:38 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Thread-Index: AQHWAEUdmZ6qeWVhq0GPreoHiPHgtahgaLaAgAOJ0aA=
Date:   Wed, 1 Apr 2020 07:46:37 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21D686@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-4-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF4FF@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF4FF@SHSMSX104.ccr.corp.intel.com>
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Monday, March 30, 2020 5:44 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> Subject: RE: [PATCH v1 3/8] vfio/type1: Report PASID alloc/free support to
> userspace
> 
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Sunday, March 22, 2020 8:32 PM
> >
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
> > vfio_iommu *iommu,
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
> > +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING,
> > 1);
> > +	if (IS_ERR(header))
> > +		return PTR_ERR(header);
> > +
> > +	nesting_cap = container_of(header,
> > +				struct vfio_iommu_type1_info_cap_nesting,
> > +				header);
> > +
> > +	nesting_cap->nesting_capabilities = 0;
> > +	if (iommu->nesting) {
> 
> Is it good to report a nesting cap when iommu->nesting is disabled? I suppose the
> check should move before vfio_info_cap_add...

oops, yes it.

> 
> > +		/* nesting iommu type supports PASID requests (alloc/free)
> > */
> > +		nesting_cap->nesting_capabilities |=
> > VFIO_IOMMU_PASID_REQS;
> 
> VFIO_IOMMU_CAP_PASID_REQ? to avoid confusion with ioctl cmd
> VFIO_IOMMU_PASID_REQUEST...

got it.

Thanks,
Yi Liu

