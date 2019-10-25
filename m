Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20B7E49AC
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439207AbfJYLQq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 25 Oct 2019 07:16:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:47728 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbfJYLQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:16:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 04:16:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="210693430"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga002.jf.intel.com with ESMTP; 25 Oct 2019 04:16:45 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 04:16:45 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 04:16:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.176]) with mapi id 14.03.0439.000;
 Fri, 25 Oct 2019 19:16:43 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHVimn7Rf6XEKLwVUSEQeOMJH4V9adqnLmAgACUdcA=
Date:   Fri, 25 Oct 2019 11:16:42 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0D7BD8@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
 <1571919983-3231-3-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D05D5@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5D05D5@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2U1MGIzZmQtNTFmNy00YWY0LThlZGQtZjcxNzFhYWRkMzNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVHFmdkM4Q1ZsaWRGbG1kQWlTd1c3eTU1ZzRcLzhCcFZJZjBhMVg4c09DWFV2eWtcL3VTNjJWbGtRQ2xyRTNlb1dFIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

> From: Tian, Kevin
> Sent: Friday, October 25, 2019 6:06 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
> Subject: RE: [RFC v2 2/3] vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> > From: Liu Yi L
> > Sent: Thursday, October 24, 2019 8:26 PM
> >
> > This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to passdown
> > PASID allocation/free request from the virtual iommu. This is required
> > to get PASID managed in system-wide.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 114
> > ++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  25 +++++++++
> >  2 files changed, 139 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index cd8d3a5..3d73a7d 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2248,6 +2248,83 @@ static int vfio_cache_inv_fn(struct device
> > *dev, void *data)
> >  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);  }
> >
> > +static int vfio_iommu_type1_pasid_alloc(struct vfio_iommu *iommu,
> > +					 int min_pasid,
> > +					 int max_pasid)
> > +{
> > +	int ret;
> > +	ioasid_t pasid;
> > +	struct mm_struct *mm = NULL;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +	mm = get_task_mm(current);
> > +	/* Track ioasid allocation owner by mm */
> below is purely allocation. Where does 'track' come to play?

ioasid_set is kind of owner track. As allocation is separate with
bind, here set the "owner" could be used to do sanity check when
a pasid bind comes.

> > +	pasid = ioasid_alloc((struct ioasid_set *)mm, min_pasid,
> > +				max_pasid, NULL);
> > +	if (pasid == INVALID_IOASID) {
> > +		ret = -ENOSPC;
> > +		goto out_unlock;
> > +	}
> > +	ret = pasid;
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	if (mm)
> > +		mmput(mm);
> > +	return ret;
> > +}
> > +
> > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> > +				       unsigned int pasid)
> > +{
> > +	struct mm_struct *mm = NULL;
> > +	void *pdata;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/**
> > +	 * REVISIT:
> > +	 * There are two cases free could fail:
> > +	 * 1. free pasid by non-owner, we use ioasid_set to track mm, if
> > +	 * the set does not match, caller is not permitted to free.
> > +	 * 2. free before unbind all devices, we can check if ioasid private
> > +	 * data, if data != NULL, then fail to free.
> > +	 */
> 
> Does REVISIT mean that above comment is the right way but the code doesn't follow
> yet, or the comment itself should be revisited?

Sorry, it's a mistake... should be removed. It's added in the development phase
for remind. Will remove it.

> 
> should we have some notification mechanism, so the guy who holds the reference to
> the pasid can be notified to release its usage?

Do you mean the ioasid itself to provide such a notification mechanism?

Currently, we prevent pasid free before all user (iommu driver, guest) released
their usage. This is achieved by checking the private data, in which there is
a user_cnt of a pasid. e.g. struct intel_svm. A fresh guest pasid bind will allocate
the private data. A second guest pasid bind will increase the user_cnt. guest pasid
unbind decreases the user_cnt. The private data will be freed by the last guest
pasid unbind. Do you think it is sufficient? or we may want to have a notification
mechanism to allow such pasid free and keep the user updated?

Thanks,
Yi Liu
